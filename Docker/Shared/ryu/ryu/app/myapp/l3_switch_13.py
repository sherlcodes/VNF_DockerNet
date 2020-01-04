# Copyright (C) 2011 Nippon Telegraph and Telephone Corporation.
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

from ryu.app import simple_switch_13
#from ryu.app.myapp import topology
#from ryu.base import app_manager
from ryu.controller import dpset
from ryu.topology import event, switches as sw, api

from ryu.app.wsgi import WSGIApplication
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.lib.packet import *
from ryu.lib.dpid import dpid_to_str, str_to_dpid
from ryu.lib.port_no import port_no_to_str

import json
from networkx.readwrite import json_graph
import networkx as nx
import traceback, itertools
############################################################################
def getDataFrom(filename):
    file_handler=open(filename,"r")
    variable=[l.strip() for l in file_handler]
    file_handler.close()
    return(variable)
############################################################################
def getDictFrom(filename):
    file_handler=open(filename,"r")
    variable=json.load(file_handler)
    file_handler.close()
    return(variable)
############################################################################
class L3Switch13(simple_switch_13.SimpleSwitch13):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]
    _CONTEXTS = {
        'switches': sw.Switches,
	'wsgi': WSGIApplication
    }
    
    _CONTEXTS = {
        #'topology': topology.TopologyController
        'dpset': dpset.DPSet
        #'topo': WSGIApplication
    }
 
    #########################################
    def __init__(self, *args, **kwargs):
        self.net=ryuNet()
        super(L3Switch13, self).__init__(*args, **kwargs)
        self.dpset = kwargs['dpset']
        #print(self.dpset)
        #topo = kwargs['topo']
        #topo.register(topology.TopologyController, {'topology_api_app': self})
        self.ip_to_port = {}
    #########################################
    ### Handler for all topology change events    
    @set_ev_cls(event.EventSwitchEnter)
    @set_ev_cls(event.EventSwitchLeave)
    @set_ev_cls(event.EventSwitchReconnected)
    @set_ev_cls(event.EventPortAdd)
    @set_ev_cls(event.EventPortDelete)
    @set_ev_cls(event.EventPortModify)
    @set_ev_cls(event.EventSwitchRequest)
    @set_ev_cls(event.EventSwitchReply)
    @set_ev_cls(event.EventLinkAdd)
    @set_ev_cls(event.EventLinkDelete)
    #@set_ev_cls(event.EventLinkRequest)
    #@set_ev_cls(event.EventLinkReply)
    #@set_ev_cls(event.EventHostRequest)
    #@set_ev_cls(event.EventHostReply)
    @set_ev_cls(event.EventHostAdd)
    @set_ev_cls(event.EventHostDelete)
    @set_ev_cls(event.EventHostMove)
    def _topo_update(self,ev):
        #self.logger.info("*** Topology change event",ev.__class__.__name__)
        print("---","Topology change event:",ev.__str__())
        #if(isinstance(ev,event.EventLinkAdd)):
            #print("*** Link change event:",ev,"links:",api.get_all_link(self))
        #self.net.update(switches=api.get_all_switch(self),links=api.get_all_link(self),hosts=api.get_all_host(self))
        #del(self.net)
	if isinstance(ev,event.EventPortModify):
                port = ev.port
                if port.is_down():
			self.del_flow(self.switches.dps[port.dpid],port.port_no)
                        self.logger.info("Delete the flow entries when the port %d is down"%(port.port_no))
        self.net= ryuNet(switches=api.get_all_switch(self),links=api.get_all_link(self),hosts=api.get_all_host(self))
    #########################################
    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def _packet_in_handler(self, ev):
        
        #print("+++ ",net.to_dict())

        # If you hit this you might want to increase
        # the "miss_send_length" of your switch
        if ev.msg.msg_len < ev.msg.total_len:
            self.logger.debug("packet truncated: only %s of %s bytes",
                              ev.msg.msg_len, ev.msg.total_len)
        msg = ev.msg
        datapath = msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
        in_port = msg.match['in_port']

        pkt = packet.Packet(msg.data)
        ip= pkt.get_protocols(ipv4.ipv4)[0] if(len(pkt.get_protocols(ipv4.ipv4))) else None
        if(not ip):
            super(L3Switch13, self)._packet_in_handler(ev)
            return
        dpid = datapath.id

        ###  remove block once running  ##########
        '''
        self.ip_to_port.setdefault(dpid, {})
        self.ip_to_port[dpid][ip.src] = in_port 
        if ip.dst in self.ip_to_port[dpid]:
            ip_out_port = self.ip_to_port[dpid][ip.dst]
        else:
            ip_out_port = ofproto.OFPP_FLOOD
        # learn a IP address to avoid FLOOD next time.
        self.ip_to_port[dpid][ip.src] = in_port
        '''
        ###########################################
        actions=self.net.find_path(dpid,ip.dst,via=["11.1.0.1"])
        pathLog=[]
        if(actions and len(actions)>0):
            pathLog=["+++ Flow Installed:[Match= src:%s dst:%s][Actions:"%(ip.dst,ip.src)]
            #print("*** Flow path size:[Match= src:%s dst:%s][Actions =%d]"%(ip.dst,ip.src,len(actions)))
            for p in actions:
                self.send_flow(ipv4_dst=ip.dst,ipv4_src=ip.src,datapath=p["datapath"],msg=msg,out_ports=p["out_port"],in_port=None)
                pathLog.append("(%d).%s -> "%(p["datapath"].id,"".join(map(str, p["out_port"]))))
            print(pathLog)
        else:
            print("(Use L2-switch) No (L3) path:",dpid,ip.dst)
            super(L3Switch13, self)._packet_in_handler(ev)
        #print("+++ ",actions)
        #self.send_flow(ip.dst,ip.src,datapath,msg,[ip_out_port],in_port)
    #########################################
    def send_flow(self,ipv4_dst,ipv4_src,datapath,msg,out_ports,in_port=None):
        # install a flow to avoid packet_in next time
        try:
            #print("+++",locals(),{"dpid":datapath.id})
            parser = datapath.ofproto_parser
            ofproto = datapath.ofproto
            actions = [parser.OFPActionOutput(p) for p in out_ports]
            if out_ports[0] != ofproto.OFPP_FLOOD:
                match = parser.OFPMatch(eth_type=0x800, ipv4_dst=ipv4_dst, ipv4_src=ipv4_src)
                self.add_flow(datapath, 1, match, actions,idle_timeout=20)
                # verify if we have a valid buffer_id, if yes avoid to send both
                # flow_mod & packet_out
                #if msg.buffer_id != ofproto.OFP_NO_BUFFER:
                    #self.add_flow(datapath, 1, match, actions, msg.buffer_id)
                #else:
                    #self.add_flow(datapath, 1, match, actions)
            data = None
            if msg.buffer_id == ofproto.OFP_NO_BUFFER:
                data = msg.data
            if(not in_port):
                in_port=ofproto.OFPP_CONTROLLER
            ip_out=parser.OFPPacketOut(datapath=datapath, buffer_id=msg.buffer_id,
                                      in_port=in_port,actions=actions, data=data)
            #flow_property={"MSG":"IP_Property","dpid":dpid,"ip":ip,'actions':ip_actions}
            #self.logger.info(ip_out.to_jsondict())
            datapath.send_msg(ip_out)
        except:
            print(traceback.format_exc())
            #import IPython
            #IPython.embed()
    #########################################
    '''
    def getDatapath(self,dpid):
        G=self.net.topo
        switches=[s for s in G.nodes() if(isinstance(s,sw.Switch))]
        ret=[s.dp for n in  if (s.dp.id==dpid)]
        if(len(ret)>0)
        return(ret[0])
    '''
    #########################################
############################################################################
class ryuNet(object):
    """docstring for ryuNet"""
    def __init__(self,switches=[],links=[],hosts=[]):
        super(ryuNet, self).__init__()
        self.S=switches
        self.L=links
        self.H=hosts
        self.V=[]
        self.topo = nx.MultiGraph()
        
        import threading
        self.observer = threading.Timer(5.0, self.to_dict) 
        self.observer.start()
        
        self.update(switches=switches,links=links,hosts=hosts)
    #########################################
    def to_dict(self):
        S=[n.to_dict() for n in self.topo.nodes()]
        #print("*** CurrentTopology",json_graph.node_link_data(self.topo))
        return({"switches":S,"links":self.topo.edges()})
    #########################################
    def port_to_node(self,port):
        n,isMatch=self.keys_to_node(keys={"port":port}) # get host
        if(n):
            return(n)
        else:
            n,isMatch=self.keys_to_node(keys={"ports":port}) # get switch
            if(n):
                return(n)
        print("port:(",port.to_dict(),") Not found")
        return(None)
    #########################################
    def getSwitch(self,dpid):
        if(isinstance(dpid,int)):
            dpid=dpid_to_str(dpid)
        for n in self.topo.nodes():
            if(not isinstance(n,sw.Switch)):
                continue
            val=dpid_to_str(self.obj_to_val(["dp","id"],n))
            if(val==dpid):
                return(n)
        print("No such dpid:",dpid)
        return(None)
    #########################################
    def obj_to_val(self,keys=[],obj=None):
        if(obj):
            try:
                temp=obj
                for k in keys:
                    temp=vars(temp)[k]
                return(temp)
            except:
                return(None)
        return(None)
    #########################################
    def keys_to_node(self,keys={},cls=None):
        for h in self.topo.nodes():
            if(cls):
                if(isinstance(h,cls)):
                    continue
            try:
                match=[]
                for k in keys.keys():
                    if(isinstance(vars(h)[k],list) and (keys[k] in vars(h)[k])):
                        match.append(2) # Partial match
                    elif(not isinstance(vars(h)[k],list) and (vars(h)[k]== keys[k])):
                        match.append(1)
                    else:
                        match.append(0)
            except KeyError:
                pass
            except Exception:
                print(traceback.format_exc())
                import IPython
                IPython.embed()
                #print("no object attribute found:(",key,")")
                return(None,None)
            if((len(match) >0 ) and (not 0 in match) and (not 2 in match)):
                return(h,None)
            elif((len(match) >0 ) and (not 0 in match) and (2 in match)):
                return(h,True) # second return is for part matching
        #print("no object found with this filter:(",keys,")")
        return(None,None)
    #########################################
    def update(self,switches=[],links=[],hosts=[]):
        #print("ryuNet.update",locals())
        ###########################
        #import IPython
        #IPython.embed()
        import threading
        self.observer.cancel()
        ###########################
        ADD,DEL=Diff(old=self.topo.nodes(),new= switches+hosts)
        for n in DEL:
            self.topo.remove_node(n)
        for n in ADD:
            self.topo.add_node(n)
        ###########################
        for h in hosts:
            n=self.getSwitch(dpid_to_str(h.port.dpid))
            self.topo.add_edge(h,n)
            l=sw.Link(h.port,h.port)
            self.topo[h][n][0].update(l.to_dict())
        ###########################
        self.L=links
        #print("AddLinks",ADD)
        for l in links:
            src= self.port_to_node(l.src)
            dst= self.port_to_node(l.dst)
            if(src and dst):
                self.topo.add_edge(src,dst)
                if(l.to_dict() != self.topo[src][dst][0]):
                    self.topo[src][dst][0].update(l.to_dict())
            else:
                print("ADD: Edge not Found !!!",l.src,l.dst)
        #print("+++ LinkUpdate:",len(ADD),len(DEL))
        self.observer = threading.Timer(5.0, self.to_dict) 
        self.observer.start()
    #########################################
    def find_path(self,src=None,dst=None,via=[]):
        #print(locals())
        if(len(via)>0):
            tot=[src]+via+[dst]
            A=[]
            for idx,medium in enumerate(tot[1:]):
                A.append(self.find_path(src=tot[idx-1],dst=medium,via=[]))
                if(A[len(A)-1] == None):
                    print("Path does not exist between ",tot[idx-1],medium)
                    return(None)
            from itertools import chain
            flatA = list(chain.from_iterable(A))
            return(flatA)
        else:
            if(src and dst):
                h=m=None
                from IPy import IP
                try:
                    if((not isinstance(src,(str,unicode))) and (IP(src)!=str(src))):
                        raise Exception('spam')
                    print("SRC is not DPID")
                    keys={"ipv4":src}
                    m, isMatchn=self.keys_to_node(keys=keys)
                    if(not m):
                        print("SRC: Host with",keys, "not found")
                        return(None)
                except Exception as inst:
                    print("SRC is not IP:",src)
                    src_id=dpid_to_str(src)
                    m=self.getSwitch(src_id)
            ########################################################
                if(not m):
                    print("NotFound: Node.dpid=",src_id)
                    import IPython
                    IPython.embed()
                    return(None)
                dst_id=None
                keys={"ipv4":dst}
                h, isMatchn=self.keys_to_node(keys=keys)
                if(not h):
                    print("Host with",keys, "not found")
                    return(None)
                elif(isMatchn):
                    pass
                    #print("@@@ part match (keys: ",keys,"target_obj: ",vars(n)["ipv4"],")")
                try:
                    path=nx.shortest_path(self.topo,source=m,target=h)
                except nx.NetworkXNoPath:
                    print(traceback.format_exc())
                    path=nx.single_source_shortest_path(self.topo, m)
                    #print(dict(path))
                    return(None)
                except nx.NodeNotFound:
                    print(traceback.format_exc(),m,n)
                    return(None)
                except:
                    print(traceback.format_exc())
                    return(None)
                if(isinstance(path[0],sw.Host)):
                    path=path[1:]
                path_edge_list=[(path[i],self.topo[path[i]][n][0]) for i,n in enumerate(path[1:])]
                actions_str=[{"Switch":e[0],
                "out_port": e[1]["src"]["port_no"] if(e[1]["src"]["dpid"]==e[0].dp.id) else e[1]["dst"]["port_no"]} 
                for e in path_edge_list ]
                try:
                    actions=[{"datapath":e["Switch"].dp,
                    "out_port":[int(e["out_port"])]} 
                    for e in actions_str ]
                except:
                    print(traceback.format_exc())
                    #print("---",actions_str)
                    return(None)          
                return(actions)
            #print(self.to_dict(),self.topo)
        return(None)
############################################################################
def Diff(old, new): 
    #all_elements=list(itertools.chain(old,new))
    DEL= [i for i in old if(i not in new)]
    ADD= [i for i in new if(i not in old)]
    return (ADD,DEL)
############################################################################
'''
try:

except:
    print(traceback.format_exc())
    import IPython
    IPython.embed()
'''
