#!/usr/bin/python

import os, sys
import subprocess
#from helper import *
from collections import defaultdict
import argparse
import matplotlib.pyplot as plt
import pickle

parser = argparse.ArgumentParser()
#parser.add_argument('--files', dest="files", nargs='+', required=True,help="input .pcap files")
parser.add_argument('--files', dest="files", nargs='+', help="input .pcap files")
parser.add_argument('--out', dest="out", default=None,help="output figure")
parser.add_argument('--miny',default=None,dest="miny",help="Min rtt on y-axis..")
parser.add_argument('--maxy',default=None,dest="maxy",help="Max rtt on y-axis..")
parser.add_argument('--subplot',default=None,dest="subplot",help="1 for subplot")
parser.add_argument('--sample',default=None,dest="sample",help="1 for subplot")
args = parser.parse_args()

debug=False
x = [0,2,4,6,8,10]
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
miny=100000000
maxy=0

#tshark -r results/h1-eth1.pcap -e frame.number -t e -o 'column.format:"Time", "%t", "XXXXXX", "%Cus:XXXXXX"' -e tcp.analysis.ack_rtt -E header=y -T fields 
cmd = "tshark -r %s -e frame.time -e frame.number -e tcp.analysis.ack_rtt -E header=y -T fields"

interface_plots={}

for f in args.files:
   print "Start parsing %s..." %(f)
   proc = subprocess.Popen(cmd%(f),shell=True, stdout=subprocess.PIPE)
   counter=0
   plot_data={}
   #line =iter(proc.stdout.readline, "")
   #vals=line.strip().split()
   for line in iter(proc.stdout.readline, ""):
   	vals=line.strip().split()
   	#print vals
   	if counter ==0:
   		xheader=vals[0]
		yheader=vals[2]
		counter=counter+1
		#break# For debuging
	else:
		counter=counter+1
		if counter == 100 and debug:
			print "Only first 100 values for dubuging"
			break
		if counter%50000 ==0:
			print counter # check execution status
   		if(vals[4]=='IST'):#for tshark version 2.1
	   		if (len(vals)==7):
	   			time=get_sec(vals[3])
				frameno=float(vals[5])
				rtt=float(vals[6])
	   			key=(time*pow(10,20))+(frameno)
	   			plot_data[time]=rtt
   		else:
	   		if (len(vals)==6):
	   			time=get_sec(vals[3])
				frameno=float(vals[4])
				rtt=float(vals[5])
	   			key=(time*pow(10,20))+(frameno)
	   			plot_data[time]=rtt
   print "Start plotting %s..." %(f)
   plt.ylim((int(miny), int(maxy)))
   #plt.legend(loc='upper left')
   interface_plots[f]=plot_data
filename="%s_rtt_dict.pkl"%(f)
if args.subplot:
   f, axarr = plt.subplots(len(interface_plots), sharex=True)
#interface_plots=pickle.load(open( filename))
# interface_plots=pickle.load(open("results/h2-eth1.pcap_rtt_dict.pkl"))
for i,iface in enumerate(interface_plots.keys()):
   plot_data=interface_plots[iface]
   x=[]
   y=[]
   sorted_list=[[i,plot_data[i]] for i in sorted(plot_data.keys())]
   x=[i[0] for i in sorted_list]
   y=[i[1] for i in sorted_list]
   #sampled_dict=sample(x,y,10000)
   if args.subplot:
   	axarr[i].scatter(x,y,label=iface, marker=".")
   else:
   	plt.plot(x,y,label=iface,marker=".", linewidth=.2)
   miny=min(miny,min(y))
   maxy=max(maxy,max(y))
   interface_plots[iface]=sorted_list
pickle.dump(interface_plots,open( filename, "wb" ) )
if args.miny:
   miny=args.miny
if args.maxy:
   maxy=args.maxy
plt.xlabel(xheader)#time
plt.ylabel(yheader)#rtt
plt.grid()
plt.legend()
delta=0.2
plt.ylim((float(miny)-delta, float(maxy)+delta))
if args.out:
    print 'saving to', args.out
    plt.savefig(args.out)
else:
    plt.show()
