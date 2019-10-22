#!/usr/bin/python

import os, sys
import subprocess
#from helper import *
from collections import defaultdict
import argparse
import matplotlib.pyplot as plt
import pickle
import numpy
import socket

parser = argparse.ArgumentParser()
#parser.add_argument('--files', dest="files", nargs='+', required=True,help="input .pcap files")
parser.add_argument('--files', dest="files", nargs='+', help="input .pcap files")
parser.add_argument('--out', dest="out", default=None,help="output figure")
parser.add_argument('--miny',default=None,dest="miny",help="Min rtt on y-axis..")
parser.add_argument('--maxy',default=None,dest="maxy",help="Max rtt on y-axis..")
parser.add_argument('--subplot',default=None,dest="subplot",help="1 for subplot")
parser.add_argument('--sample',default=None,dest="sample",help="1 for subplot")
parser.add_argument('--i', dest="interface", default=None,help="select interface")
parser.add_argument('--lost', dest="lost", default=False,help="if want to plot lost segment")
parser.add_argument('--oop', dest="oop", default=False,help="if want to plot out of order packet")
parser.add_argument('--all', dest="all", default=False,help="plot all destination")
parser.add_argument('--eps', dest="eps", default=False,help="if want to plot eps file")
args = parser.parse_args()

debug=False
x = [0,2,4,6,8,10]
tot_mptcp_pkts={}
######################################################################
def sample(x,y,size):
    bucket=len(x)/size
    sampled_x=[]
    sampled_y=[]
    for i in xrange(0,len(sorted_dict),bucket):
    	data_chunk=y[i:(i+bucket-1)]
    	sampled_x=sampled_x.append(x[i])
    	sampled_y=sampled_y.append(float(sum(data_chunk))/len(data_chunk))
    sampled_dict=(sampled_x,sampled_y)
    return(sampled_dict)
######################################################################
def get_sec(s):
    l = s.split(':')
    return float(l[0]) * 3600 + float(l[1]) * 60 + float(l[2])
######################################################################
def plot_bytes_inflight(proc):
    stats=[line.strip() for line in iter(proc.stdout.readline, "") if line.strip()!= []]
    bw_lines=stats[12:len(stats)-1]
    x=[float(line.split()[1]) for line in bw_lines]
    y=[(float(line.split()[7])/(1024*128)) for line in bw_lines if len(line.split())==9 ]
    if len(x) > len(y):
    	y=y+([0]*(len(x)-len(y)))
    return (x,y)
######################################################################
####tshark -r m.1/h1.pcap -e ip.src -e mptcp.analysis -e icmp -E header=y -E separator=, -T fields|sort |uniq
def get_ips(args):
    cmd="tshark -r %s -e ip.src -e mptcp.analysis -e icmp -E header=y -E separator=, -T fields" %(args.files[0])
    proc = subprocess.Popen(cmd,shell=True, stdout=subprocess.PIPE)
    ips=[line.strip().split(",") for line in iter(proc.stdout.readline, "") if line.strip()!= []]
    ips_temp=[ i[0] for i in ips if(len(i)==3)]
    iplist=list(set(ips_temp))
    remove_item=[ i for i in iplist if("," in i)]
    for i in remove_item:
    	iplist.remove(i)
    return (iplist)
######################################################################
def plot_bw(cmd,cols):
    proc = subprocess.Popen(cmd,shell=True, stdout=subprocess.PIPE)
    stats=[line.strip() for line in iter(proc.stdout.readline, "") if line.strip()!= []]
    col_list=stats[7:len(cols)+8]
    headers=[ i.strip().split() for i in col_list]
    headers=[l[len(l)-2] for l in headers] 
    bw_lines=stats[len(cols)+12:len(stats)-1]# remove Header
    data={}
    for index,heading in enumerate(headers):
	col_no=7+(index*4)
	x=[float(line.split()[1]) for line in bw_lines]
	y=[(float(line.split()[col_no])/(1024*128)) for line in bw_lines if len(line.split())==(4*len(headers)+5) ]
	if len(x) > len(y):
		y=y+([0]*(len(x)-len(y)))
	elif len(x) !=0:
		data[heading]=(x,y)
    return (data)
######################################################################
def plot_lost_segment(proc2,filename):
    plot_data={}
    #frame.time,tcp.analysis.retransmission,mptcp.analysis
    LostPackets=[line.strip().split(",") for line in iter(proc2.stdout.readline, "") if line.strip()!= []]
    LostPackets.pop(0)
    mptcp_pkts=[pkts for pkts in LostPackets if pkts[2]!=""]
    tot_mptcp_pkts[filename]=len(mptcp_pkts)
    for line in LostPackets:
	if(line[1]!="" and line[2]!=""):
	    #print line
	    time=float(line[0])
	    #print timestamp
	    if(plot_data.has_key(time)):
	    	plot_data[time]=plot_data[time]+1
	    else:
	    	plot_data[time]=1
    sorted_list=[[i,plot_data[i]] for i in sorted(plot_data.keys())]
    x=[i[0] for i in sorted_list]
    if(len(x)!=0):
   	offset=min(x)
    	x_offset=[(i-offset) for i in x]
    	y=[i[1] for i in sorted_list]
    	return(x_offset,y)
    else:
    	return([0],[0])
######################################################################
def OutOfOrder(tmpfile):
   cmd = "tshark -r %s -e frame.time_relative -e mptcp.analysis -e ip.src -e ip.dst -e tcp.seq -e mptcp.dss.dsn -e frame.number -e mptcp.stream -e mptcp.analysis.subflows -e tcp.analysis.out_of_order -E header=y -E separator=, -T fields" %(tmpfile)
   proc = subprocess.Popen(cmd,shell=True, stdout=subprocess.PIPE)
   pkts=[line.strip().split(",") for line in iter(proc.stdout.readline, "") if line.strip()!= []]
   headers=pkts.pop(0)
   mppkts=[mppkt for mppkt in pkts if (mppkt[1]!="" and mppkt[4]!="")]
   #	0		     1		 2	3	4	 5		6	    7
   #frame.time_relative,mptcp.analysis,ip.src,ip.dst,tcp.seq,mptcp.dss.dsn,frame.number,tcp.stream
   pkts=[ pkt for pkt in mppkts if((pkt[3]!="")and(pkt[4]!=""))]
   total=len(pkts)
   time_list=[ (dt[2],dt[3],dt[0]) for dt in pkts]
   seq_list =[ (dt[2],dt[3],dt[4]) for dt in pkts]
   dssn_list=[ (dt[2],dt[3],dt[5]) for dt in pkts]
   blank_dssn=[ (i,dt[4],dt[5]) for i,dt in enumerate(pkts) if(dt[5]=="")]
   dssn_list_oop_temp=[(i,dssn_list[i-1],j) for i,j in enumerate(dssn_list) if(dssn_list[i-1][2]!="" and j[2]!="" and dssn_list[i-1][0] != dssn_list[i-1][1]  and j[0] != j[1])]
   dssn_list_oop=[(i,j,k) for i,j,k in dssn_list_oop_temp if(float(j[2])>float(k[2]))]
   seq_list_oop=[]
   #seq_list_oop=[(i,seq_list[i-1],j) for i,j in enumerate(seq_list) if(float(seq_list[i-1][2]) > float(j[2]) and seq_list[i-1][2]!="" and j[2]!="" and seq_list[i-1][0] != seq_list[i-1][1]  and j[0] != j[1])]
   ret=(time_list,dssn_list_oop,seq_list_oop,total)
   return ret
######################################################################
def remove_zeros(plots):
    for k in plots.keys():
    	print k
    	x=plots[k][0]
    	y=plots[k][1]
    	z_indexes=[i for i,j in enumerate(y) if(j==0)]
    	z_indexes.reverse()
    	for i in z_indexes:
	    #print i,x[i],y[i]
	    x.pop(i)
	    y.pop(i)
	plots[k]=(x,y)
    return(plots)
######################################################################
def save_data_to_file(IP_plots,args):
    for k in IP_plots.keys():
        x=IP_plots[k][0]
        y=IP_plots[k][1]
        z=zip(x,y)
        txt= ["\t".join(map(str, a)) for a in z]
        outputfile = open('test_%s.txt'%(k), 'w')
        for t in txt:
            print >> outputfile,t
        outputfile.close()
    return
######################################################################
def plot_OOP(proc1,filename):
    plot_data={}
    #frame.time_relative,tcp.analysis.out_of_order,mptcp.analysis
    pkts=[line.strip().split(",") for line in iter(proc1.stdout.readline, "") if line.strip()!= []]
    mptcp_pkts=[mpkts for mpkts in pkts if mpkts[2]!=""]
    tot_mptcp_pkts[filename]=len(mptcp_pkts)
    OooPackets=[pkt for pkt in pkts if(pkt[2]!="" and pkt[1]!="")]
    OooPackets.pop(0)
    for line in OooPackets:
	#print line
	time=float(line[0])
	if(plot_data.has_key(time)):
	    plot_data[time]=plot_data[time]+1
	else:
	    plot_data[time]=1
    sorted_list=[[i,plot_data[i]] for i in sorted(plot_data.keys())]
    x=[i[0] for i in sorted_list]
    if(len(x)!=0):
    	offset=min(x)
    	x_offset=[(i-offset) for i in x]
    	y=[i[1] for i in sorted_list]
    	return(x_offset,y)
    else:
    	return([0],[0])
######################################################################
miny=100000000
maxy=0
f=args.files[0]
#tshark -r results/h1-eth1.pcap -e frame.number -t e -o 'column.format:"Time", "%t", "XXXXXX", "%Cus:XXXXXX"' -e tcp.analysis.ack_rtt -E header=y -T fields 
if(args.interface):
   iplist=get_ips(args)
   filter_string=["ip.dst=="+i for i in iplist if (i !="" and i!="0.0.0.0")]
   if(filter_string==""):
   	print "Error! No IPs found"
   	sys.exit()
   add_filter=",".join(filter_string)
   cmd = "tshark -q -z 'io,stat,1,mptcp.analysis,%s' -i %s -r %s" %(add_filter,args.interface,f)# Bandwidth
   #cmd = "tshark -q -z 'io,stat,1,mptcp.analysis,ip.addr==10.0.0.1,ip.addr==10.0.1.1' -r %s -i %s"# Bandwidth
   #cmd1 = "tshark -r %s -i %s -e frame.time_relative -e tcp.analysis.out_of_order -e mptcp.analysis -E header=y -E separator=, -T fields"
   #cmd2 = "tshark -r %s -i %s -e frame.time_relative -e tcp.analysis.lost_segment -e mptcp.analysis -E header=y -E separator=, -T fields"
   #cmd3 = "tshark -r %s -i %s -e frame.time_relative -e tcp.analysis.bytes_in_flight -e mptcp.analysis -E header=y -E separator=, -T fields"
else:
   ip_list_cmd="tshark -T fields -e ip.src -e mptcp.analysis -r %s" %(f)
   #iplist=get_ips(ip_list_cmd)
   iplist=get_ips(args)
   filter_string=["ip.dst=="+i for i in iplist if (i !="" and i!="0.0.0.0")]
   if(filter_string==""):
   	print "Error! No IPs found"
   	sys.exit()
   add_filter=",".join(filter_string)
   cmd = "tshark -q -z 'io,stat,1,mptcp.analysis,%s' -r %s" %(add_filter,f)# Bandwidth
   #cmd1 = "tshark -r %s -e frame.time_relative -e tcp.analysis.out_of_order -e mptcp.analysis -E header=y -E separator=, -T fields"
   #cmd2 = "tshark -r %s -e frame.time -e tcp.analysis.lost_segment -e mptcp.analysis -E header=y -E separator=, -T fields"
   #cmd2 = "tshark -r %s -e frame.time_relative -e tcp.analysis.retransmission -e mptcp.analysis -E header=y -E separator=, -T fields"
   #cmd3 = "tshark -r %s -e frame.time_relative -e tcp.analysis.bytes_in_flight -e mptcp.analysis -E header=y -E separator=, -T fields"
interface_plots={}
OP={}
LS={}
f=args.files
print "Start parsing %s..." %(f)

#proc1 = subprocess.Popen(cmd1%(f), shell=True, stdout=subprocess.PIPE)
#proc2 = subprocess.Popen(cmd2%(f), shell=True, stdout=subprocess.PIPE)
counter=0
IP_plots=plot_bw(cmd,filter_string)
IP_plots=remove_zeros(IP_plots)
save_data_to_file(IP_plots,args)
#OP[f]=plot_OOP(proc1,f)
if(args.lost):
   #LS[f]=plot_lost_segment(proc2,f)
   print "Later"
print "Start plotting %s..." %(f)
plt.ylim((int(miny), int(maxy)))
#filename="%s_rtt_dict.pkl"%(f)
if args.subplot:
   f, axarr = plt.subplots(len(interface_plots), sharex=True)
print tot_mptcp_pkts
for i,iface in enumerate(sorted(IP_plots.keys())):
   x,y=IP_plots[iface]
   if(args.oop):
   	OPx,OPy=OP[iface]
   	OPy=[k+i for k in OPy]
   if(args.lost):
   	LSx,LSy=LS[iface]
   	LSy=[j+i for j in LSy]
   if args.subplot:
   	#axarr[i].scatter(x,y,label=iface+"[OutOfOrder=%d]"%(OP[iface]), marker=".")
   	print "Not implemented"
   else:
	Path="Undefined"
	temp_split=iface.split("==")
	try:
    		k=temp_split[len(temp_split)-1]
    		socket.inet_aton(k)
    		pathip=k.split(".")
    		if(int(pathip[3])!=1):
    			print(pathip)
    			continue
    		pathid="%d"%(int(pathip[2])+1)
    		Path="S"+pathid
	except socket.error:
		if("mptcp" in iface):
			Path="Total"
		else:
			continue
   	avgy=numpy.mean(y)
   	sdy=numpy.std(y)
   	avgy=[avgy,avgy]
   	avgx=[x[0],x[len(x)-1]]
   	#oop_percentage=len(OP[iface][0]) *100 /float(tot_mptcp_pkts[iface] )
   	#print "oop",iface,len(OP[iface][0]),oop_percentage
   	#plt.plot(x,y,label=Path+"[OutOfOrder=%f/%f]" %(len(OP[iface][0]), oop_percentage), marker=".", linewidth=.2)
   	#leny=len(y)
   	if(Path!="Undefined"):
	   	plt.plot(x,y,label=Path, marker=".", linewidth=.2)
	   	plt.plot(avgx,avgy,label=Path+"[avg=%f+/-%f]"%(avgy[0],sdy),color="r",marker="+", linewidth=.3)
	elif(args.all):
		plt.plot(x,y,label="%s[avg=%f+/-%f]"%(iface,avgy[0],sdy), marker=".", linewidth=.2)
   	if(args.oop):
   		#print OPx
   		plt.plot(OPx,OPy,label=Path+" OutOfOrderPackets",marker=".", linewidth=.5)
        if(args.lost):
        	los_percentage=len(LSy) *100 / float(tot_mptcp_pkts[iface] )
        	print "loss",iface,len(LSy),los_percentage
   		plt.plot(LSx,LSy,label=Path+" Lost segments=%f/%f"%(len(LSy),los_percentage),marker="^", linewidth=2)
   		#print LSx
   try:
	miny=min(miny,min(y))
   	maxy=max(maxy,max(y))
   except ValueError:
        print miny,maxy
   ###interface_plots[iface]=sorted_list
#pickle.dump(interface_plots,open( filename, "wb" ) )
if args.miny:
   miny=args.miny
if args.maxy:
   maxy=args.maxy
#############################################################################
T_D_S=OutOfOrder(args.files[0])
time_list,dssn_list_oop,seq_list_oop,total=T_D_S
dssn_index=[ i[0] for i in dssn_list_oop]
oop_dssn_time=[time_list[i][2] for i in dssn_index]
oop_dssn_list=[ i[2][2] for i in dssn_list_oop]
Px=oop_dssn_time
Py=oop_dssn_list
#############################################################################
plt.xlabel("Time in sec")#time
plt.ylabel("Bandwidth in Mbps \n[Out Of Order DSSN=%d/%d(%.2f percent)]"%(len(Px),total,len(Px)*100/float(total)))#rtt
plt.grid()
plt.legend()
plt.ylim((float(miny), float(maxy)*2.4))
if(args.oop or args.lost):
    plt.ylim((float(miny), float(maxy)*2))
if(args.oop and args.lost):
    plt.ylim((float(miny), float(maxy)*2.2))
if args.out:
    if args.eps:
    	plt.savefig(args.out[:-3]+"eps",format="eps",dpi=1000)
    	print "Saving to %s"%(args.out[:-3]+"eps")
    else:
    	plt.savefig(args.out,format="png",dpi=1000)
    	print "Saving to %s"%(args.out)

