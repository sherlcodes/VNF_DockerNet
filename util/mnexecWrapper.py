#!/usr/bin/python
import argparse, os, subprocess, psutil, json
from helper_function import *
from termcolor import colored, cprint 

parser = argparse.ArgumentParser()
parser.add_argument('-n', '--name', help="node name", dest="node_name", default=None)
parser.add_argument('-p', '--pid', help="return pid", dest="pid", default=None)
parser.add_argument('-l', '--list', help="list of all mininet processes", dest="l", default=False, action='store_true')
parser.add_argument('-cmd','--cmd', nargs='+', help='Command to be executed', dest="cmd", default=["echo","'noargs'"])
#parser.add_argument('-f', dest="files", nargs='+', required=True)

args = parser.parse_args()
##############################################################################################
def get_list():
    netdict={}
    for proc in psutil.process_iter():
        check=[True for pargs in proc.cmdline if("mininet:" in pargs)]
        if any(check):
            netdict[proc.cmdline[-1].split(":")[-1]]=proc.pid
    return(netdict)
##############################################################################################
#c0:6633,c<port-6633>
def main():
    netdict=get_list()
    if(args.node_name):
        if(args.node_name in netdict.keys()):
            CMD="sudo mnexec -a %d %s"%(netdict[args.node_name]," ".join(args.cmd))
            cprint("%s %s<%s>"%(args.node_name, " ".join(args.cmd),CMD) ,'green')
            op=execRes(CMD)
            print(op)
        else:
            args.l=True
            cprint("*** Node name not found ***",'red', 'on_green')
            return(1)   
    if(args.l):
        if(len(netdict.keys())==0):
            cprint("*** Mininet is not running ***",'red')
            return(1)
        cprint("*** Running Mininet Nodes ***",'red')
        print(netdict.keys())
    if(args.pid):
        cprint("*** Node pid ***",'red')
        print(netdict[args.pid])
    return(0)
##############################################################################################
if __name__ == '__main__':
    main()
