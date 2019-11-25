#!/usr/bin/python
from bottle import Bottle, request
import time, subprocess, json
from bottledaemon import daemon_run
from mininet.node import Docker
from mininet.link import TCLink
from paste.util.multidict import MultiDict
from DockerNodes import VNF
"""
MininetRest adds a REST API to mininet.
"""
protocols='OpenFlow13'
IP="10.0.2.15"
PORT="8081"
##########################################################################################
class MininetRest(Bottle):
    ############################################################
    def run(self,**kwargs):
        #daemon_run(**kwargs)
        super(MininetRest, self).run(**kwargs)
        #print("Run Called")
        #This can not be used as mininet is already running in main thread
        #super(MininetRest, self).run(reloader=True,**kwargs) 
    ############################################################
    def __init__(self, net):
        super(MininetRest, self).__init__()
        self.net = net
	self.route('/migrate/<src_OVS>/<tar_OVS>/<VNF>', method='GET', callback=self.migrate_VNF)
        self.route('/index', callback=self.show_index)
        self.route('/nodes', callback=self.get_nodes)
        self.route('/nodes/<node_name>', callback=self.get_node)
        self.route('/nodes/post/<node_name>/<params>', method='GET', callback=self.post_node)
        self.route('/nodes/cmd/<cmd_name>', method='GET', callback=self.do_cmd)
        self.route('/nodes/<node_name>/mnexec/<cmd>', method='GET', callback=self.mnexec)
        self.route('/nodes/<node_name>/cmdPrint/<cmd>', method='GET', callback=self.cmdPrint)
        self.route('/switches/rules/<switch_name>', method='GET', callback=self.ovsrules)
        self.route('/nodes/<node_name>/<intf_name>', callback=self.get_intf)
        self.route('/nodes/post/<node_name>/<intf_name>/<params>', method='GET', callback=self.post_intf)
        self.route('/hosts', method='GET', callback=self.get_hosts)
        self.route('/hosts/post/<host_name>', method='GET', callback=self.get_host_info)
        self.route('/switches', method='GET', callback=self.get_switches)
        self.route('/links', method='GET', callback=self.get_links)
        self.route('/controllers', method='GET', callback=self.get_ctlrs)
        self.route('/ctlrport', method='GET', callback=self.get_ctlrs_wsport)
        self.route('/neighbor', method='GET', callback=self.get_neighbors)
        self.route('/interfaces', method='GET', callback=self.get_intfs)
    ############################################################
    def show_index(self):
        return({'MSG':"Mininet is Running with REST API",
            'List of Nodes':"http://"+IP+":"+PORT+"/nodes",
            'Interfaces <node>':"http://"+IP+":"+PORT+"/nodes/<node>",
            'Configure <node>':["http://"+IP+":"+PORT+"/nodes/post/<node>/<params_json>","e.g.http://"+IP+":"+PORT+"/nodes/post/s1/{'name':'s2'}"],
            'Exec <cmd> in shell':"http://"+IP+":"+PORT+"/nodes/cmd/<cmd>",
            'Exec <cmd> in <node>':"http://"+IP+":"+PORT+"/nodes/<node>/mnexec/<cmd>",
            'Exec <cmd> in <node>':"http://"+IP+":"+PORT+"/nodes/<node>/cmdPrint/<cmd>",
            'rules of <switch>':"http://"+IP+":"+PORT+"/switches/rules/<switch>",
            'Interfaces':"http://"+IP+":"+PORT+"/interfaces",
            'See <intf> of <switch>':"http://"+IP+":"+PORT+"/nodes/<switch>/<intf>",
            'Configure <intf> of <node>':["http://"+IP+":"+PORT+"/nodes/post/<node>/<intf>/<params_json>",
            "e.g.http://"+IP+":"+PORT+"/nodes/post/s1/s1-eth1/{'name':'s2'}"],
            'List of hosts':"http://"+IP+":"+PORT+"/hosts",
            'List of hosts':"http://"+IP+":"+PORT+"/hosts/post/<host_name>",
            'List of switches':"http://"+IP+":"+PORT+"/switches",
            'List of links':"http://"+IP+":"+PORT+"/links",
            'List of controllers':"http://"+IP+":"+PORT+"/controllers",
            'Controller ports':"http://"+IP+":"+PORT+"/ctlrport",
            'Neighbor map':"http://"+IP+":"+PORT+"/neighbor"
            })
    ############################################################
    def get_intfs(self):
        '''http://10.0.2.15:8081/interfaces'''
        return({'nodes': [self.get_node(n) for n in self.net]})
    ############################################################
    def get_nodes(self):
        '''http://10.0.2.15:8081/nodes'''
        return({'nodes': [n for n in self.net]})
    ############################################################
    def get_node(self, node_name):
        '''http://10.0.2.15:8081/nodes/h1'''
        node = self.net[node_name]
        return({'name':node.name,'dpid': node.dpid if("Switch" in str(type(node))) else False,'pid':node.pid,'intfs': [[i.name,i.mac] for i in node.intfList()], 'params': node.params})
    ############################################################
    def post_node(self, node_name, params):
        node = self.net[node_name]
        print(params,type(params))
        params=json.loads(params.replace("'","\""))
        node.params.update(params)
        return(node.params)
    ############################################################
    def cmdPrint(self, node_name, cmd):
        '''http://10.0.2.15:8081/nodes/h1/cmdPrint/name="h1"'''
        node = self.net[node_name]
        out=node.cmdPrint(cmd)
        return({'cmd': cmd,'output': out})
    ############################################################
    def mnexec(self, node_name, cmd):
        '''http://10.0.2.15:8081/nodes/s1/mnexec/ifconfig s1-eth0'''
        node = self.net[node_name]
        CMD=cmd.split(" ")
        out, err, exitcode=node.pexec(cmd)
        return({'cmd':' '.join(CMD),'output': out,'stderr':err,'exitcode':exitcode})
    ############################################################
    def get_intf(self, node_name, intf_name):
        '''http://10.0.2.15:8081/nodes/s1'''
        node = self.net[node_name]
        intf = node.nameToIntf[intf_name]
        return({'name': intf.name, 'status': 'up' if intf.name in intf.cmd('ifconfig') else 'down',
                "params": intf.params})
    ############################################################
    def post_intf(self, node_name, intf_name, params):
        '''http://10.0.2.15:8081/nodes/s1/s1-eth1'''
        node = self.net[node_name]
        intf = node.nameToIntf[intf_name]
        if(len(params)>1):
            params_dict=json.loads(params)
            if 'status' in params_dict.keys():
                intf.ifconfig(params_dict['status'])
            if 'params' in params_dict.keys():
                intf_params = params_dict['params']
                intf.config(**intf_params)
                intf.params.update(intf_params)
        else:
            pass
        return({'name': intf.name, 'status': 'up' if intf.name in intf.cmd('ifconfig') else 'down',
                "params": intf.params})
    ############################################################
    def get_hosts(self):
        '''http://10.0.2.15:8081/hosts'''
        return({'hosts': [h.name for h in self.net.hosts]})
    ############################################################
    def get_host_info(self,host_name):
        '''http://10.0.2.15:8081/hosts/h1'''
        node=self.net[host_name]
        return({'name':node.name,'intfs': {i.name:i.mac for i in node.intfList()}})
    ############################################################
    def get_ctlrs(self):
        '''http://10.0.2.15:8081/controllers'''
        return({'controllers': [ctlr.name for ctlr in self.net.controllers]})
    ############################################################
    def get_switches(self):
        '''http://10.0.2.15:8081/switches'''
        return({'switches': {sw.name:{"ctlr":sw.vsctl("get-controller %s"%(sw.name)),'connected':sw.vsctl("get-controller %s"%(sw.name))} for sw in self.net.switches}})
    ############################################################
    def get_links(self):
        '''http://10.0.2.15:8081/links'''
        return({'links': [dict(name=l.intf1.node.name + '-' + l.intf2.node.name,
                               node1=l.intf1.node.name, node2=l.intf2.node.name,
                               intf1=l.intf1.name, intf2=l.intf2.name) for l in self.net.links]})
    ############################################################
    def get_ctlrs_wsport(self):
        ''' get json ws port from net object'''
        '''http://10.0.2.15:8081/ctlrport'''
        return({c.name:c.wsport for c in self.net.controllers if "CustomL1" in str(type(c))})
    ############################################################
    def ovsrules(self, switch_name):
        '''http://10.0.2.15:8081/switches/s1/rules'''
        if(switch_name in [s.name for s in self.net.switches]):
            pass
        else:
            return("Switch not found")
        node = self.net[switch_name]
        cmd="ovs-ofctl dump-flows "+switch_name+" --protocols="+protocols
        #print("CMD="+cmd)
        out = subprocess.Popen(['ovs-ofctl', 'dump-flows',switch_name,"--protocols="+protocols],
            stdout=subprocess.PIPE, 
            stderr=subprocess.STDOUT)
        result,stderr = out.communicate()
        rules=[l[1:] if(l[0]==" ") else l for l in result.replace(" ",",").split("\n")[1:] if(len(l)>0)]
        rulesdict=[[l for l in r.split(",") if(len(l)>0)]for r in rules]
        return({'ovsrules': rulesdict})
    ############################################################
    def do_cmd(self, cmd_name):
        '''http://10.0.2.15:8081/cmd/ifconfig'''
        CMD=cmd_name.split(" ")
        out = subprocess.Popen(CMD,
            stdout=subprocess.PIPE, 
            stderr=subprocess.STDOUT)
        result,stderr = out.communicate()
        return({'cmd':cmd_name,'output': result,'stderr':stderr})
    ############################################################
        '''args = request.body.read()
        node = self.net[node_name]
        rest = args.split(' ')
        # Substitute IP addresses for node names in command
        # If updateIP() returns None, then use node name
        rest = [self.net[arg].defaultIntf().updateIP() or arg
                if arg in self.net else arg
                for arg in rest]
        rest = ' '.join(rest)
        print("CMD="+rest)
        # Run cmd on node:
        node.sendCmd(rest)
        output = ''
        init_time = time.time()
        while node.waiting:
            exec_time = time.time() - init_time
            #timeout of 5 seconds
            if exec_time > 5:
                break
            data = node.monitor(timeoutms=1000)
            output += data
        # Force process to stop if not stopped in timeout
        if node.waiting:
            node.sendInt()
            time.sleep(0.5)
            data = node.monitor(timeoutms=1000)
            output += data
            node.waiting = False
        return(output)'''
    ############################################################
    def get_neighbors(self):
        '''http://10.0.2.15:8081/neighbor'''
        dataPlaneLinks=[l for i,l in enumerate(self.net.links) if not("Host" in "%s-%s"%(str(type(l.intf1.node)),str(type(l.intf2.node))))]
        dataPlane={i:[l.intf1.node.name,l.intf2.node.name] for i,l in enumerate(dataPlaneLinks) if(l.intf1.isUp() and l.intf2.isUp())}
        return(dataPlane)
    ############################################################
    def migrate_VNF(self,src_OVS,tar_OVS,VNF):
	switch1 = self.net[src_OVS]
	switch2 = self.net[tar_OVS]
	node = self.net[VNF]
	switch1_name="mn."+switch1.name
	switch2_name="mn."+switch2.name
	node_name="mn."+node.name
	vnfImage=node_name+":latest"	
	result=subprocess.call(["./mn.sh",switch1_name,switch2_name,node_name])
	net=self.net
        v=self.net.addDocker( node.name,dimage=vnfImage)
        l1=net.addLink(switch2.name,v,cls=TCLink)
        l2=net.addLink(switch2.name,v,cls=TCLink)
	self.VNFs=MultiDict()	
	self.VNFs.add(switch2.name,v)
	'''
	v=VNF.__init__(node.name,dimage=vnfImage)
	v.addParent(swtich2.name)'''	
	self.net[VNF]=v
	return({'output':result}) 
##########################################################################################
