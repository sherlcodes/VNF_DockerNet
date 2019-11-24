"""ClosTree topology by Subhrendu
http://www.hoggnet.com/NWWPics/CLOS%20Network.jpg

sudo mn --custom ~/mininet/custom/topo-clos-like.py --topo clostree --switch ovs-stp --controller=remote,ip=127.0.0.1,port=6633
sudo mn --custom ~/mininet/custom/topo-clos-like.py --topo clostree --switch ovs --controller=ref
mininet> sh time bash -c 'while ! ovs-ofctl show es_0_0 | grep FORWARD; do sleep 1; done'

Pass '--topo=fattree' from the command line
"""
#from mininet.net import mininet
from mininet.topo import Topo
from mininet.net import Containernet
from mininet_rest import MininetRest
from mininet.log import setLogLevel, info, output, error
#from mininet.node import Controller, OVSSwitch, RemoteController, OVSKernelSwitch, UserSwitch, Ryu
from mininet.cli import CLI
from mininet.link import TCLink
from netaddr import IPNetwork
from mininet.util import ( quietRun, fixLimits, numCores, ensureRoot,
                           macColonHex, ipStr, ipParse, netParse, ipAdd,
                           waitListening )

from DockerNodes import *
from os import environ,system
from paste.util.multidict import MultiDict
import json, itertools, thread,logging,sys

protocols="OpenFlow10,OpenFlow11,OpenFlow12,OpenFlow13"
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
def getVal(d,key):
    return(d[key] if key in d.keys() else None)
##########################################################################################
class ClosTree( Topo ):
    def __init__( self,racks=6,hostsPerRack=20,ctlrNo = 1,ipBase='11.0.0.1/24',vnfIpBase='11.1.0.0/24'):
        # Initialize topology
        self.vnfIpBase=vnfIpBase
        self.vnfNextIP=1

        Topo.__init__( self)
        # Topology settings
        #(racks,hostsPerRack,ctlrNo)=(6,20,3)
        hostNum = (racks*hostsPerRack)   # Hosts in ClosTree
        rackSwitchNum = racks            # Core switches 
        spineSwitchNum = (racks/2)       # Edge switches
        # Device Lists
        rackSwitches = []
        spineSwitches = []
        hosts=[]
        hostLinks=[]

        #net = Containernet(controller=Controller)
        net = Containernet(ipBase=ipBase,autoStaticArp=True)
        info("*** CONTROL PLANE STARTS\n")
        
        port_bindings={6600:6600,9100:9100}
        if(ctlrNo):
            info("*** Add Central Controller for debugging\n")
            c0=net.addController(name="c0",controller=DockerRyu,ofpport=getVal(port_bindings,6600),wsport=getVal(port_bindings,9100))
        else:
            info("*** Add Remote Controller for debugging\n")
            c0=net.addController(name="c0",controller=RemoteController,ip="172.17.0.1",port=6600)
        info("*** DATA PLANE STARTS\n")
        info("*** Add spine switches\n")
        for spine in xrange(1, (spineSwitchNum+1)):
            s = net.addSwitch("s.spine"+str(spine), cls=OVSDocker,protocols=protocols)
            spineSwitches.append(s)

        info("*** Add leaf/rack switches\n")
        for rack in xrange(1, (rackSwitchNum+1)):
            s = net.addSwitch("s.rack"+str(rack+spineSwitchNum),cls=OVSDocker, protocols=protocols)
            rackSwitches.append(s)

        info("*** Add inter-switch links\n")
        for h_num,spine in enumerate(spineSwitches):
            rackLinks=[net.addLink(spine, rack) for rack in rackSwitches]
        # Edges and hosts
        rack_id = 0
        multiplier=pow(10,len(str(hostsPerRack)))

        info("*** Create hosts and links between host and switchs\n")
        for rack in rackSwitches:
            for x in xrange(1,(hostsPerRack+1)):
                h_num = (rack_id * hostsPerRack)+ x
                #hopts={"ip":"%s.%s.%d/%d"%(IPbase,rack_id,x,mask)}
                h=net.addDocker("h"+str(h_num), dimage="ubuntu:trusty")
                hosts.append(h)
                hostLinks.append(net.addLink(rack,h,cls=TCLink))
            rack_id += 1
        info("*** All devices are deployed\n")
        self.net=net
        self.rackSwitches =rackSwitches # Core switches in ClosTree
        self.spineSwitches = spineSwitches # Edge switches in ClosTree
        self.hosts=hosts # Hosts in ClosTree
        self.hostLinks=hostLinks # Links in ClosTree
        self.c0=c0
        self.controllers=net.controllers
        self.VNFs=MultiDict()
        ''' ADD VNFs'''
        ''' Ping Problem due to different network '''
        vnfImage="vnf:latest"
        #vnfImage="tcpdump:latest"
        #vnfImage="ubuntu:trusty"
        #v=self.net.addDocker("v5",cls=VNF,dimage=vnfImage)
        #v.addParent(parentNode=rackSwitches[0])
        #self.VNFs.add(parentNode,v)
        self.addVNF("v1",parentNode=rackSwitches[0], dimage=vnfImage)
        self.addVNF("v2",parentNode=rackSwitches[0], dimage=vnfImage)
        self.addVNF("v3",parentNode=rackSwitches[1], dimage=vnfImage)
        self.addVNF("v4",parentNode=rackSwitches[1], dimage=vnfImage)
        return
    ################################################################
    def getCurrVnfIp( self ):
        ipBaseNum, prefixLen = netParse( self.vnfIpBase )
        ip = ipAdd( self.vnfNextIP,
                    ipBaseNum=ipBaseNum,
                    prefixLen=prefixLen ) + '/%s' % prefixLen
        return ip
    ################################################################
    def getNextVnfIp( self ):
        ipBaseNum, prefixLen = netParse( self.vnfIpBase )
        ip = ipAdd( self.vnfNextIP,
                    ipBaseNum=ipBaseNum,
                    prefixLen=prefixLen ) + '/%s' % prefixLen
        self.vnfNextIP += 1
        return ip
    ################################################################
    def startNetwork(self,SwitchMappingDict=None,REST=True):
        net=self.net
        net.build()
        #if self.c0 is not None:
        #    self.c0.start()
        for c in net.controllers:
            c.start(appNo="l2_host") if(isinstance(c,DockerRyu)) else c.start()
            #c.start(appNo=["l2"|"l2_gui"|"l3"|"l2_host"])
        if(SwitchMappingDict==None):
            info("*** Add all switches to first available controller\n")
            for sw in net.switches:
                sw.start([self.c0]) if(self.c0) else sw.start()
        else:
            info("*** Use switch to controller mapping from %s\n"%(config_file))
            for sw in SwitchMappingDict.keys():
                net.getNodeByName(sw).start([net.getNodeByName(SwitchMappingDict[sw])])
        info("*** Create shell variable\n")
        resTemp=[n.cmd('name=\"%s\"'%(n.name)) for n in net.hosts]
        resTemp=[n.cmd('name=\"%s\"'%(n.name)) for n in net.switches]
        resTemp=[n.cmd('name=\"%s\";connect=\"%s:%s:%s\"'%(n.name,n.protocol,n.ip,n.port)) for n in net.controllers]
        #####################################################################
        # VNF network configuration
        for v in self.VNFs.values():
            node_ip=self.getNextVnfIp()
            for i,i_no in enumerate(v.intfs.keys()):
                #Assign IP to outgoing intfs and in coming intfs
                intf_ip=".".join([node_ip.split(".")[0]]+[str(int(node_ip.split(".")[1])+i)]+node_ip.split(".")[2:])
                v.setIP(intf_ip,intf=v.intfs[i_no])
                #info(v.intfs[i_no],self.getCurrVnfIp())
        #####################################
        ipBase=str(IPNetwork(self.vnfIpBase).network)
        subNetMask=str(IPNetwork(self.vnfIpBase).netmask)
        ipBase2=".".join([ipBase.split(".")[0]]+[str(int(ipBase.split(".")[1])+1)]+ipBase.split(".")[2:])
        info("*** Set VNFs routes in all hosts\n")
        info("*** %s and %s \n"%(ipBase,ipBase2))
        for h in self.hosts:
            h.cmd("route add -net %s netmask %s dev %s"%(ipBase,subNetMask,h.intfs[0].name))
            h.cmd("route add -net %s netmask %s dev %s"%(ipBase2,subNetMask,h.intfs[0].name))
        #####################################    
        ipBase=str(IPNetwork(self.net.ipBase).network)
        subNetMask=str(IPNetwork(self.net.ipBase).netmask)
        info("*** Set hosts routes in all VNFs\n")
        for v in self.VNFs.values():
            v.cmd("route add -net %s netmask %s dev %s"%(ipBase,subNetMask,v.intfs[0].name))
        #####################################################################
        info("*** Set arp table\n")
        for host in self.net.hosts:
            for dest in self.net.hosts:
                if host.name != dest.name:
                    for dst_intf in dest.intfs.values():
                        host.setARP(dest.IP(intf=dst_intf), dest.MAC(intf=dst_intf))
        if(REST):
            info("*** Super controller WSGI help http://0.0.0.0:8081/index\n")
            self.monitor=thread.start_new_thread(self.startMininetRest,())
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
    def addVNF( self, name, parentNode=None,net=None,dimage="vnf:latest",**params ):
        if(not net):
            net=self.net
        v=self.net.addDocker( name,dimage=dimage, **params)
        if(parentNode):
            l1=net.addLink(parentNode,v,cls=TCLink)
            l2=net.addLink(parentNode,v,cls=TCLink)
            self.VNFs.add(parentNode,v)
            #print(self.VNFs)
            return v
##########################################################################################
    def pingAllIntfs( self, net=None):
        """Ping between all specified hosts.
           hosts: list of hosts
           timeout: time to wait for a response, as string
           manualdestip: sends pings from each h in hosts to manualdestip
           returns: ploss packet loss percentage"""
        # should we check if running?
        packets = 0
        lost = 0
        ploss = None
        net= net if(net) else self.net
        hosts = net.hosts
        output( '*** Ping: testing ping reachability for each interface\n' )
        for node in hosts:
            output( '%s -> ' % node.name )
            for dest in hosts:
                if node != dest:
                    for intf in dest.intfs.values():
                        result = node.cmd( 'ping -c1 %s' %
                                           (dest.IP(intf=intf)) )
                        sent, received = net._parsePing( result )
                        packets += sent
                        if received > sent:
                            error( '*** Error: received too many packets' )
                            error( '%s' % result )
                            node.cmdPrint( 'route' )
                            exit( 1 )
                        lost += sent - received
                        output( ( '%s ' % intf.name ) if received else 'X ' )
            output( '\n' )
        if packets > 0:
            ploss = 100.0 * lost / packets
            received = packets - lost
            output( "*** Results: %i%% dropped (%d/%d received)\n" %
                    ( ploss, received, packets ) )
        else:
            ploss = 0
            output( "*** Warning: No packets sent\n" )
        return ploss
##########################################################################################
