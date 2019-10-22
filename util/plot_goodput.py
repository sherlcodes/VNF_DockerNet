#!/usr/bin/python
import os, sys
import subprocess
#from helper import *
from collections import defaultdict
import argparse
import matplotlib.pyplot as plt
import re

parser = argparse.ArgumentParser()
parser.add_argument('--files', '-f',
                    help="Rate timeseries output to one plot",
                    #required=True,
                    action="store",
                    nargs='+',
                    dest="files")

parser.add_argument('--legend', '-l',
                    help="Legend to use if there are multiple plots.  File names used as default.",
                    action="store",
                    nargs="+",
                    default=None,
                    dest="legend")

parser.add_argument('--out', '-o',
                    help="Output png file for the plot.",
                    default=None, # Will show the plot
                    dest="out")

parser.add_argument('-s', '--summarise',
                    help="Summarise the time series plot (boxplot).  First 10 and last 10 values are ignored.",
                    default=False,
                    dest="summarise",
                    action="store_true")

parser.add_argument('--labels',
                    help="Labels for x-axis if summarising; defaults to file names",
                    required=False,
                    default=[],
                    nargs="+",
                    dest="labels")

parser.add_argument('--xlabel',
                    help="Custom label for x-axis",
                    required=False,
                    default=None,
                    dest="xlabel")

parser.add_argument('--ylabel',
                    help="Custom label for y-axis",
                    required=False,
                    default=None,
                    dest="ylabel")

parser.add_argument('-i',
                    help="Interfaces to plot (regex)",
                    default=".*",
                    dest="pat_iface")

parser.add_argument('--rx',
                    help="Plot receive rates on the interfaces.",
                    default=False,
                    action="store_true",
                    dest="rx")

parser.add_argument('--maxy',
                    help="Max mbps on y-axis..",
                    default=100,
                    action="store",
                    dest="maxy")

parser.add_argument('--miny',
                    help="Min mbps on y-axis..",
                    default=0,
                    action="store",
                    dest="miny")

parser.add_argument('--normalize',
                    help="normalise y-axis",
                    default=False,
                    action="store_true",
                    dest="normalise")

args = parser.parse_args()
if args.labels is None:
    args.labels = args.files

to_plot=[]
"""Output of iperf csv has the following columns:
[  3]  0.0- 2.0 sec  17.1 MBytes  71.8 Mbits/sec
"""

bw = map(lambda e: int(e.replace('M','')), args.labels)
idx = 0
for f in args.files:
	print "Input file %s"%(f)
	data = [line.strip().split() for line in open(f, 'r')]
	rate = {}
	column = 2
	if args.rx:
	    column = 3
	start=6
	end=len(data) -2
	for row in data[start:end]:
		if len(row)==9:
			time=float(row[3])
			goodput=float(row[7])
		if len(row)==8:
			time=float(row[2].split('-')[1])
			goodput=float(row[6])
		rate[time]=goodput
	plt.plot(rate.keys(),rate.values())

plt.title("Goodput")
if args.rx:
    plt.title("RX rates")

if args.ylabel:
    plt.ylabel(args.ylabel)
elif args.normalise:
    plt.ylabel("Normalized BW")
else:
    plt.ylabel("%s"%(row[len(row)-1]))

plt.grid()
plt.legend()
plt.ylim((int(args.miny), int(args.maxy)))

if args.summarise:
    plt.boxplot(to_plot)
    plt.xticks(range(1, 1+len(args.files)), args.labels)

if not args.summarise:
    if args.xlabel:
        plt.xlabel(args.xlabel)
    else:
        plt.xlabel("Time")
    if args.legend:
        plt.legend(args.legend)

if args.out:
    plt.savefig(args.out)
else:
    plt.show()

