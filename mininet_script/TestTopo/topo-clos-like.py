"""ClosTree topology by Howar31
http://www.hoggnet.com/NWWPics/CLOS%20Network.jpg

sudo mn --custom ~/mininet/custom/topo-clos-like.py --topo clostree --switch ovs-stp --controller=remote,ip=127.0.0.1,port=6633
sudo mn --custom ~/mininet/custom/topo-clos-like.py --topo clostree --switch ovs --controller=ref
mininet> sh time bash -c 'while ! ovs-ofctl show es_0_0 | grep FORWARD; do sleep 1; done'

Pass '--topo=fattree' from the command line
"""
config_file = "../../Controllers/cc_client/switch_controller_config.json"

from mininet.topo import Topo
from mininet.net import Mininet
from mininet_rest import MininetRest
from mininet.log import setLogLevel, info
from mininet.node import Controller, OVSSwitch, RemoteController, OVSKernelSwitch, UserSwitch, Ryu
from mininet.cli import CLI
from mininet.link import TCLink
from CustomCtlr import *
from mininet_rest import MininetRest
from os import environ,system
import json, itertools, thread,logging,sys
##########################################################################################
class StreamToLogger(object):
    '''Fake file-like stream object that redirects writes to a logger instance'''
    def __init__(self, logger, log_level=logging.INFO):
        self.logger = logger
        self.log_level = log_level
        self.linebuf = ''
    ################################################################
    def write(self, buf):
        for line in buf.rstrip().splitlines():
            self.logger.log(self.log_level, line.rstrip())
##########################################################################################
''' Parameters'''
protocols="OpenFlow13"
#switch=OVSBridgeSTP
switch=OVSKernelSwitch
##########################################################################################
class ClosTree( Topo ):
    def __init__( self,racks=6,hostsPerRack=20,ctlrNo = 3):
        # Initialize topology
        Topo.__init__( self)
        # Topology settings
        #(racks,hostsPerRack,ctlrNo)=(6,20,3)
        IPbase="11.0"
        mask=16
        hostNum = (racks*hostsPerRack)   # Hosts in ClosTree
        rackSwitchNum = racks            # Core switches 
        spineSwitchNum = (racks/2)       # Edge switches
        # Device Lists
        rackSwitches = []
        spineSwitches = []
        hosts=[]
        hostLinks=[]

        net = Mininet(controller=RemoteController, switch=switch, autoSetMacs=True)
        info("*** CONTROL PLANE STARTS\n")
        info("*** Add Ryu Controller for debugging\n")
        #RYU=net.addController('c100',controller=OriginalRYU, ip='127.0.0.1',port=6600, wsport=9100)
        RYU=net.addController('c100', controller=CustomL1,ip='127.0.0.1', port=6600, wsport=9100)
        '''
        ryu=Ryu('c100',cargs=['--observe-links '
            '--ofp-tcp-listen-port 6600 '
            '--wsapi-port 9100 '
            'ryu.app.ofctl_rest'])'''
        
        #net = Mininet(controller=RemoteController, switch=OVSKernelSwitch, autoSetMacs=True)
        info("*** Add L2 Controller (TFLC)\n")
        c0 = net.addController( 'c0',controller=CustomL2)
        
        info("*** Add L1 controllers (Ryu CC_Client)\n")
        controllers = [ net.addController('c%d' % (i+1), controller=CustomL1,ip='127.0.0.1', port=6633+i, wsport=9000+i) for i in xrange(ctlrNo) ]
        #controllers = []
        #for i in xrange(ctlrNo):
            #c = net.addController('c%d' % (i+1), controller=CustomL1,ip='127.0.0.1', port=6633+i, wsport=9000)
            #controllers.append(c)
        info("*** DATA PLANE STARTS\n")
        info("*** Add spine switches\n")
        for spine in xrange(1, (spineSwitchNum+1)):
            s = net.addSwitch("s"+str(spine), protocols=protocols)
            #s = net.addSwitch("s"+str(spine))
            spineSwitches.append(s)

        info("*** Add leaf/rack switches\n")
        for rack in xrange(1, (rackSwitchNum+1)):
            s = net.addSwitch("s"+str(rack+spineSwitchNum), protocols=protocols)
            #s = net.addSwitch("s"+str(rack+spineSwitchNum))
            rackSwitches.append(s)

        info("*** Add inter-switch links\n")
        for h_num,spine in enumerate(spineSwitches):
            rackLinks=[net.addLink(spine, rack) for rack in rackSwitches]
            # h=net.addHost("D"+str(h_num)) # Remove Later
            # hostLinks.append(net.addLink(spine,h,cls=TCLink)) # Remove Later
        # Edges and hosts
        rack_id = 0
        multiplier=pow(10,len(str(hostsPerRack)))

        info("*** Create hosts and links between host and switchs\n")
        for rack in rackSwitches:
                # rack_id=rack.name.split("_")[1]
                for x in xrange(1,(hostsPerRack+1)):
                    h_num = (rack_id * hostsPerRack)+ x
                    hopts={"ip":"%s.%s.%d/%d"%(IPbase,rack_id,x,mask)}
                    h=net.addHost("h"+str(h_num))
                    hosts.append(h)
                    hostLinks.append(net.addLink(rack,h,cls=TCLink))
                rack_id += 1
        info("*** All devices are deployed\n")
        self.RYU=RYU
        self.net=net
        self.rackSwitches =rackSwitches # Core switches in ClosTree
        self.spineSwitches = spineSwitches # Edge switches in ClosTree
        self.hosts=hosts # Hosts in ClosTree
        self.hostLinks=hostLinks # Links in ClosTree
        self.c0=c0 # L2 Controller in ClosTree
        self.controllers=controllers # L1 Controller in ClosTree
        return
    ################################################################
    def startNetwork(self,SwitchMappingDict=None):
        net=self.net
        net.build()
        self.c0.start()
        for c in self.controllers:
            c.start()
        if(SwitchMappingDict==None):
            info("*** Add all switches to a common controller\n")
            #self.RYU.start()
            for sw in net.switches:
                sw.start([self.RYU])
        else:
            info("*** Use switch to controller mapping from %s\n"%(config_file))
            for sw in SwitchMappingDict.keys():
                net.getNodeByName(sw).start([net.getNodeByName(SwitchMappingDict[sw])])
        info("*** Set arp table\n")
        for host in self.hosts:
            for host1 in self.hosts:
                if host.name != host1.name:
                    host.setARP(host1.IP(), host1.MAC())
                    #host.cmd("arp -s " + host1.IP() +" "+ host1.MAC())
        info("*** Create shell variable\n")
        resTemp=[n.cmd('name=\"%s\"'%(n.name)) for n in net.hosts]
        resTemp=[n.cmd('name=\"%s\"'%(n.name)) for n in net.switches]
        resTemp=[n.cmd('name=\"%s\";connect=\"%s:%s:%s\"'%(n.name,n.protocol,n.ip,n.port)) for n in net.controllers]
        info("*** Super controller WSGI help http://0.0.0.0:8080/index\n")
        self.monitor=thread.start_new_thread(self.startMininetRest,())
        #mininet_rest.run(host="0.0.0.0",port=8081)
        # net.getNodeByName("h1").cmdPrint("")
        ''' Invoke rpcServer in each switches also '''
        return(net)
    ################################################################
    def startMininetRest(self):
        logging.basicConfig(level=logging.DEBUG,
            format='%(asctime)s:%(levelname)s:%(name)s:%(message)s',
            filename="/tmp/monitor.log",filemode='a')
        stderr_logger = logging.getLogger('STDERR')
        sl = StreamToLogger(stderr_logger, logging.INFO)
        sys.stderr = sl
        info("*** Start Mininet Rest\n")
        mininet_rest = MininetRest(self.net)
        mininet_rest.run(host="0.0.0.0",port=8081, quite=True)
    ################################################################
    def stop(self):
        info("*** Stop Mininet Rest\n")
        info("*** Stopping network\n")
        self.net.stop()
        system("mn -c")
##########################################################################################
if __name__ == '__main__':
    setLogLevel( 'info' )  # for CLI output
    # controllers={ 'pox': POX }
    # topos = { 'clostree': ( lambda: ClosTree(racks=6,hostsPerRack=20) ) }
    # switches = { 'ovs-stp': OVSBridgeSTP }
    # Read Mapping file SwitchMappingDict.JSON
    with open(config_file, 'r') as f:
        SwitchMappingDict = json.load(f)
    clos=ClosTree(racks=6,hostsPerRack=2)
    #net=clos.startNetwork(SwitchMappingDict=SwitchMappingDict)
    net=clos.startNetwork()

    # Can be dropped later
    H={n.name:{"pid":n.pid} for n in net.hosts}
    S={n.name:{"pid":n.pid} for n in net.switches}
    C={n.name:{"pid":n.pid,"connect":"%s:%s:%s"%(n.protocol,n.ip,n.port)} for n in net.controllers}
    netDict=H.copy()
    netDict.update(S)
    netDict.update(C)
    with open('mnexecData.json', 'w') as fp:
        json.dump(netDict, fp)
        fp.close()
    dataPlane={i: [l.intf1.node.name,l.intf2.node.name] for i,l in enumerate(net.links) if not("Host" in "%s-%s"%(str(type(l.intf1.node)),str(type(l.intf2.node))))}
    with open('dataPlane.json', 'w') as fp:
        json.dump(dataPlane, fp)
        fp.close()
    ###############################################################
    info("*** Running CLI\n")
    # net.getNodeByName("h1").cmdPrint("")
    CLI(net)
    clos.stop()
    with open('mnexecData.json', 'w') as fp:
        json.dump({"EMPTY":True}, fp)
        fp.close()
    info("*** mnexecData.json Cleared\n")


