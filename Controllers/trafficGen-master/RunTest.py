#!/usr/bin/python
from subprocess import Popen, PIPE, call
import psutil
import sys
from mylibrary import *
###INPUTS
PREFIX="/home/mininet/ScalableSDN/BaysianOptimization/traffic_generator/"
CONFIGURE_FILENAME="host_pid.list"
INPUT_FILENAME="test_flow.csv"
OUTPUT_FILE_PREFIX="Results/"
DELTA_TIME=5
#############################################################
def hostExec(pid,cmd,prefix=None,filehandle=None):
	if(prefix):
		CMD="%s && sudo mnexec -a %s %s"%(prefix,pid,cmd)
	else:
		CMD="sudo mnexec -a %s %s"%(pid,cmd)
	if(filehandle):
		filehandle.write(CMD+"\n")
	else:
		print(CMD)
	return

def setup():
	#############################################################
	''' Read PID and Host mapping '''
	lines = open(CONFIGURE_FILENAME).read().split("\n")
	lines2=[removeValueFromList(line.split(" "),"") for line in lines if(len(line) > 1 and ("bash" in line))]
	## FORMAT:root     15085 15074  0 15:50 pts/22   00:00:00 bash --norc -is mininet:h_1_1
	hostPidList={line[len(line)-1].replace("mininet:h",""):line[1] for line in lines2}
	#############################################################
	#ipList={node:getIpIfconfig(hostCMDPrint(hostPidList[node],"ifconfig",debug=True)[0])[1][0] for node in hostPidList.keys()}
	ipList={node:getIpIfconfig(hostCMDPrint(hostPidList[node],"ifconfig")[0])[1][0] for node in hostPidList.keys()}
	#############################################################
	''' Read Flow events file '''
	lines = open(INPUT_FILENAME).read().split("\n")
	lines2=[map(str,map(int, line.split(",")[0:2]))+map(float,line.split(",")[2:]) for line in lines if (len(line) > 1) ]
	IperfServers=set([int(item[1]) for item in lines2])
	print lines2
	print ipList
	events = []
	for item in lines2:
		# if this flow is fesible, that is src and dst is in network
		if item[0] in hostPidList and item[1] in ipList:	
			src_pid = hostPidList[item[0]]
			dst_ip = ipList[item[1]]

			events.append([src_pid,dst_ip]+item[2:]) #### Change hostPidList[item[1]] with IpDestination list

	return hostPidList, ipList, IperfServers, events

### Assuming each host has only one interface
#############################################################
def schedule(eventDes,outputfile=None,filehandle=None):
	''' [PID, DestIP, StartsAt, Duration] '''
	if(filehandle):
		filehandle.write("# "+' '.join(map(str,eventDes))+"\n")
	else:
		print("# "+' '.join(map(str,eventDes))+"\n")
	if(psutil.pid_exists(int(eventDes[0]))):
		if(outputfile):
			CMD="iperf -c %s -t 1 > %s &"%(eventDes[1],outputfile)
		else:
			CMD="iperf -c %s -t 1"%(eventDes[1])
		pid=hostExec(eventDes[0],CMD,prefix="sleep %f && printMsg $START \"%s\""%(eventDes[2],outputfile),filehandle=filehandle)
		return(pid)
	else:
		print("PID[%d] Not exists"%(eventDes[0]))
		return(-1)

#############################################################################
def shellHeader(filehandle=None):
	if(filehandle):
		filehandle.write("#!/bin/bash\nSTART=$(date +%s%N)\nprintMsg() {\n    tt=$((($(date +%s%N) - $1)/1000000))\n    echo \"$2 -> Start time: $tt milliseconds\"\n}\n")
		filehandle.write("rm -f Results/*\n")
		for i in xrange(1,10):
			filehandle.write("ovs-ofctl --protocols=OpenFlow13 del-flows s"+str(i)+"\n")
		for i in xrange(1,10):	
			filehandle.write("ovs-ofctl --protocols=OpenFlow13 add-flow s"+str(i)+" dl_type=0x0806,actions=drop"+"\n")
		insertSeperator(filehandle=filehandle)
		filehandle.write("timeTracker(){\n\tmax=$1\n\techo -n \"Timer Started\"\n\tfor ((curr=1;curr<=max;curr=curr+5));\n\t\tdo\n\t\tsleep 5\n\t\techo -en \"\\e[0K\\r [\"$curr\"]\"\n\tdone\n}\n")
		insertSeperator(filehandle=filehandle)
	else:
		print("#!/bin/bash\nSTART=$(date +%s%N)\nprintMsg() {\n    tt=$((($(date +%s%N) - $1)/1000000))\n    echo \"$2 -> Start time: $tt milliseconds\"\n}\n")
		insertSeperator()
		print("timeTracker(){\n\tmax=$1\n\tcurr=0\n\techo -n \"Timer Started\"\n\tfor ((curr=1;curr<=max;curr=curr+5));\n\t\tdo\n\t\tsleep 5\n\t\techo -en \"\e[0K\r [\"$curr\"]\"\n\tdone\n}\n")
		insertSeperator()
	return
#############################################################################

def create_scripts():
	hostPidList, ipList, IperfServers, events = setup()
	files=[]
	if(len(sys.argv) > 1):
		files=sys.argv[1:]
		f= open(files[0],"w")
	else:
		f=None
		print("##### BEGIN START SCRIPT")
	#shellHeader(f)
	for s in IperfServers:
		# if server in hostPidList
		if str(s) in hostPidList:
			sPID=hostPidList[str(s)]
			hostExec(sPID,"iperf -s > /dev/null &",filehandle=f)
	if(len(sys.argv) > 1):
		f.close()
	else:
		print("##### END START SCRIPT")
	###########################################################################
	timeFromEpoch=[]
	if(len(sys.argv) > 2):
		f= open(files[1],"w")
	else:
		f=None
		print("##### BEGIN EXECUTION SCRIPT")
	shellHeader(filehandle=f)
	for i,e in enumerate(events):
		schedule(e, outputfile=OUTPUT_FILE_PREFIX+"%d.log"%(i),filehandle=f)
		e[3] = 40   # for current, all traffic would be 40 seconds longer 
		timeFromEpoch.append(e[2]+e[3])

	timeFromEpoch.append(420) # max time 
	lines="MAXTIME=%d\ntimeTracker $MAXTIME & \nwait\n"%(int(max(timeFromEpoch))+DELTA_TIME)
	if(len(sys.argv) > 2):
		f.write(lines)
		f.close()
	else:
		print(lines)
		print("##### END EXECUTION SCRIPT")
	###########################################################################
	'''
	f= open(files[2],"w")
	shellHeader(f)
	for i,e in enumerate(events):
		schedule(e, outputfile=OUTPUT_FILE_PREFIX+"%d.log"%(i),filehandle=f)
	f.write("wait")
	f.close()
	'''
	print("##### All shell scripts are created")

if __name__ == '__main__':
	create_scripts()