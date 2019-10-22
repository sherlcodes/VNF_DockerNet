# Copyright (C) 2016 Nippon Telegraph and Telephone Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import json

#from ryu.app import simple_switch_13
from ryu.app.myapp import l3_switch_13
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.app.wsgi import ControllerBase
from ryu.app.wsgi import Response
from ryu.app.wsgi import route
from ryu.app.wsgi import WSGIApplication
from ryu.lib import dpid as dpid_lib
from ryu.topology import event, switches, api


from networkx.readwrite import json_graph
import networkx as nx
import traceback, itertools
import os

PATH = os.path.dirname(__file__)

simple_switch_instance_name = 'simple_switch_api_app'
url = '/l3switch/{dpid}'

############################################################################
class SimpleSwitchRest13(l3_switch_13.L3Switch13):
    _CONTEXTS = {'wsgi': WSGIApplication}
    #########################################
    def __init__(self, *args, **kwargs):
        super(SimpleSwitchRest13, self).__init__(*args, **kwargs)
        self.switches = {}
        wsgi = kwargs['wsgi']
        wsgi.register(SimpleSwitchController,
                      {simple_switch_instance_name: self})
############################################################################
class SimpleSwitchController(ControllerBase):
    #########################################
    def __init__(self, req, link, data, **config):
        super(SimpleSwitchController, self).__init__(req, link, data, **config)
        self.simple_switch_app = data[simple_switch_instance_name]
    #########################################
    def topo_to_simple_graph(self):
        simple_switch = self.simple_switch_app
        nx_graph=simple_switch.net.topo
        nodes=[n.__str__() for n in nx_graph.nodes()]
        edges=[(e[0].__str__(),e[1].__str__(),e[2]) for e in nx_graph.edges(data=True)]
        G=nx.MultiGraph()
        G.add_nodes_from(nodes)
        for e in edges:
            G.add_edge(e[0],e[1])
            G[e[0]][e[1]][0].update(e[2])
        return(G)
    #########################################
    @route('viewtopo', "/l3switch/viewtopo", methods=['GET'])
    def viewTopo(self, req, **kwargs):
        G=self.topo_to_simple_graph()
        body = json.dumps({"Nodes":list(G.nodes()),"Edges":list(G.edges(data=True))})
        return Response(content_type='application/json', body=body)
    #########################################
    @route('paths', "/l3switch/paths", methods=['GET'])
    def all_shortest_path(self, req, **kwargs):
        G=self.topo_to_simple_graph()
        paths=dict(nx.all_pairs_shortest_path(G, cutoff=10))
        hosts=[h for h in G.nodes() if("Host" in h)]
        switches=[s for s in G.nodes() if("Switch" in s)]
        h_pair=[i for i in itertools.product(hosts,hosts) if(i[0]!=i[1])]
        path_pair={}
        for n1,n2 in h_pair:
            if(paths[n1][n2]):
                if(n1 not in path_pair.keys()):
                    path_pair[n1]=[n2]
                else:
                    path_pair[n1].append(n2)
        last_mile=[G[h].keys() for h in hosts]
        if(len(hosts)>0):
            print(req)
            body = json.dumps({"hosts":hosts,"last_mile":last_mile,"reach":path_pair}) #paths
        else:
            body=[]
        return Response(content_type='application/json', body=body)
    #########################################
    @route('path', "/l3switch/findpath/{src}/{dst}", methods=['GET'])
    def path(self, req,**kwargs):
        src=kwargs["src"]
        dst=kwargs["dst"]
        actions=self.simple_switch_app.net.find_path(src=src,dst=dst,require_service=False,via=[])
        path=[{"dpid":p["datapath"].id,"out_ports":p["out_port"]} for p in actions]
        body =json.dumps({"src":src,"dst":dst,"path":path}) #paths
        return Response(content_type='application/json', body=body)

