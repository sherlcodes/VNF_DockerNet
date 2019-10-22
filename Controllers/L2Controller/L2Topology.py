__author__ = 'Subhrendu Chattopadhyay'
import networkx as nx
import json
from networkx.readwrite import json_graph
'''
{"params": [{"ports": 
    [{"hw_addr": "56:c7:08:12:bb:36", "name": "s1-eth1", "port_no": "00000001", "dpid": "0000000000000001"},
     {"hw_addr": "de:b9:49:24:74:3f", "name": "s1-eth2", "port_no": "00000002", "dpid": "0000000000000001"}], "dpid": "0000000000000001"}]
, "jsonrpc": "2.0", "method": "event_switch_enter", "id": 1}
{"id": 1, "jsonrpc": "2.0", "result": ""}
{"params": [{"ports": [{"hw_addr": "56:c7:08:12:bb:36", "name": "s1-eth1", "port_no": "00000001", "dpid": "0000000000000001"}, {"hw_addr": "de:b9:49:24:74:3f", "name": "s1-eth2", "port_no": "00000002", "dpid": "0000000000000001"}], "dpid": "0000000000000001"}], "jsonrpc": "2.0", "method": "event_switch_leave", "id": 2}
{"id": 2, "jsonrpc": "2.0", "result": ""}
'''
######################
class L2Topology(object):
    def __init__(self, *args, **kwargs):
        self.net=nx.DiGraph()
        self.mac_to_port={}
        #nx.set_node_attributes(self.net, {"name":None,"port":None,"mac":None,"type":None,"dpid":None})
        #nx.set_edge_attributes(self.net, {"src":{"iface":None,"dpid":None,"mac":None,"port":None},"dst":{"iface":None,"dpid":None,"mac":None,"port":None}})
        #return(self)
    ##################################################
    def removeNode(self,dpid=None,host=False):
        hw_addrs=[hw for hw in self.mac_to_port.keys() if(self.mac_to_port[hw]["dpid"] == dpid)]
        ## Remove hosts

        ## Remove from hw_addr from mac_to_port
        for mac in hw_addrs:
            try:
                del self.mac_to_port[mac]
                self.net.remove_node(dpid)
            except:
                pass
        self.updateGraph({"dpid":dpid,"host":host})
    ##################################################
    def addPort(self,dpid=None,port=None):
        self.mac_to_port[port['hw_addr']]=port
        self.net.node[dpid]["ports"]
        ''' add ports here '''
        self.updateGraph({"dpid":dpid,"ports":json.dumps(self.net.node[dpid]["ports"])})
    ##################################################
    def addSwitches(self,items,node_type="switch"):
        ''' node.name,node.port,node.mac,node.type,node.dpid'''
        #print(json.dumps(self.getNodes(node_type=["switch","wswitch"])))
        if(len(items)>0):
            msg=[]
            for s in items:
                ports=[port for port in s.to_dict()["ports"]]
                for port in ports:
                    self.mac_to_port[port['hw_addr']]=port
                port_list=[port['port_no'] for port in ports]
                self.net.add_node(s.to_dict()['dpid'],type=node_type,ports=port_list)
                if(s.to_dict()['dpid']=="0000000000000003"):# for testing remove later
                    self.addPort(dpid="0000000000000003")
                msg.append([s.to_dict()['dpid'],port_list])
            self.updateGraph({"items":msg,"node_type":node_type})
    ##################################################
    def addWindowSwitches(self,items):
        self.addSwitches(items,node_type="wswitch")
    ##################################################
    def addHost(self,name=None,dt=None):
        if(name==None):
            name=dt['mac']
        # If mac is already in a switch then it is not a host
        if(name in self.mac_to_port.keys()):
            label={name:self.mac_to_port[name]["port_no"],dt["port"]["dpid"]:dt["port"]["port_no"]}
            self.mac_to_port[dt["port"]['hw_addr']]=dt["port"]
            self.net.add_edge(name,dt["port"]["dpid"],info=label)
        else:
            self.mac_to_port[name]=dt["port"]
            #if dt["ipv4": ["0.0.0.0"], "ipv6": []] has IP or IPv6 or "0.0.0.0" then it is added, else its a switch
            self.net.add_node(name,type="host",**dt)
            # Connect host to dpid
            dpid=dt["port"]["dpid"]
            self.net.add_edge(name,dpid,info={dpid:dt["port"]["port_no"]})
        self.updateGraph({"AddHost name":name,"dt":dt})
    ##################################################
    def addHosts(self,items):
        if(len(items)>0):
            msg=[]
            for h in items:
                self.addHost(h['mac'],h)
    ##################################################
    def addLinks(self,items):
        if(len(items)>0):
            msg=[]
            for l in items:
                src=l["src"]["dpid"]
                dst=l["dst"]["dpid"]
                self.net.add_edge(src,dst,info={src:l['src']["port_no"],dst:l['dst']["port_no"]})
                msg.append([src,dst,{src:l['src']["port_no"],dst:l['dst']["port_no"]}])
            #self.updateGraph({"Addlinks":msg})
    ##################################################
    def updateGraph(self,msg=None):
        #nx.write_yaml(self.net,"/tmp/test.yaml")
        #print(json.dumps(json_graph.node_link_data(self.net)))
        #self.simpleGraph.add_nodes_from(self.net.nodes())
        adjlist=[line for line in nx.generate_adjlist(self.net," ")]
        links=[json.dumps(l) for l in self.net.edges(data=True)]
        print("******************************")
        if(msg):
            print("MSG->%s"%(json.dumps(msg)))
        print("Network now:\nAdjlist:\n%s\n"%("\n".join(adjlist)))
        print("Links:\n %s"%("\n".join(links)))
        print("Mac Table:\n %s"%(json.dumps(self.mac_to_port)))
        #print(nx.shortest_path(self.net,source='0000000000000008'))
        #hosts=self.getNodes()
        #print("\n***********************\n",
        #    json.dumps(self.mac_to_port),
        #    "\n***********************\n",
        #    json.dumps(hosts))
        pass
    ##################################################
    def getNodes(self,node_type=[]):
        nodes=self.net.nodes(data=True)
        #print(json.dumps(nodes))
        if(len(node_type)>0):
            req_nodes=[n for n in nodes if(n[1]["type"] in node_type)]
        else:
            req_nodes=nodes
        return(req_nodes)
    ##################################################
    def findShortestPath(self,src,dst):
        ''' return (datapath)'''
        return()
