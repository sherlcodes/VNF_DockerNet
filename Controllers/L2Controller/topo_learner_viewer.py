__author__ = 'Subhrendu Chattopadhyay'

import os
from bottle import route, run, template
import time, subprocess, json
from bottledaemon import daemon_run
import networkx as nx
from networkx.readwrite import json_graph

PATH = os.path.dirname(__file__)
parser = argparse.ArgumentParser()
parser.add_argument('-p', '--port', help="View Topology Server works in this port.", dest="port", default=9101)

args = parser.parse_args()
###########################################
def filename_to_graph(filename):
    ''' Filename to networkx graph'''
    with open(filename) as json_data:
        data = json.load(json_data)
        G=json_graph.node_link_graph(data)
    retun({"graph":G,"json":data})
###########################################
def getFiles():
    nx_files=os.listdir("%s/nx_files"%(PATH))
    data={f:filename_to_graph(f)["json"] for f in nx_files}
    return(data)
###########################################
@route('topology')
def index(self):
    data=getFiles()
    return({i:"http://172.16.117.50:%d/%s"%(args.port,f) for i,f in enumerate(data.keys())})
###########################################
@route('/topology/<filename>')
def showJson(fielname):
###########################################
if __name__ == "__main__":
  daemon_run()
###########################################