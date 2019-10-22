#!/usr/bin/python
from subprocess import Popen, PIPE, call
import sys
import psutil
def getIpIfconfig(output):
	output_split=output.decode('UTF-8').split("\n")
	listofMac=[j.split()[4] for i,j in enumerate(output_split) if "HWaddr" in j]
	listofIP=[removeValueFromList(j.replace(":"," ").split(" "),"")[2] for i,j in enumerate(output_split) if (("inet addr:" in j) and("inet addr:127.0.0.1" not in j)) ]
	return((listofMac,listofIP))
#############################################################
def removeValueFromList(l,val):
	while val in l:
		l.remove(val)
	return(l)
#############################################################
def hostCMDPrint(pid,cmd,prefix=None,debug=False):
	if psutil.pid_exists(int(pid)):
		if(prefix):
			CMD="%s;sudo mnexec -a %s %s"%(prefix,pid,cmd)
		else:
			CMD="sudo mnexec -a %s %s"%(pid,cmd)
		if(debug):
			print(CMD)
		p = Popen(CMD.split(" "),stdout=PIPE,stderr=PIPE)
		out, err = p.communicate()
		return((out,err))
	else:
		print("ERROR!! Check if mininet is running or \nRun \"ps -ef|grep mininet:h > host_pid.list\"")
		sys.exit(1)
#############################################################################
def insertSeperator(filehandle=None):
	if(filehandle):
		filehandle.write("#######################################################\n")
	else:
		print("#######################################################")
	return
#############################################################