from mininet.net import Mininet
from mininet.node import RemoteController, OVSSwitch
from mininet.cli import CLI
from mininet.log import setLogLevel
from mininet.link import TCLink, Intf
from threading import Timer
import time, threading
import networkx as nx
import pickle

class OVSBridgeSTP( OVSSwitch ):
    """Open vSwitch Ethernet bridge with Spanning Tree Protocol
       rooted at the first bridge that is created"""
    prio = 1000
    def start( self, *args, **kwargs ):
        OVSSwitch.start( self, *args, **kwargs )
        OVSBridgeSTP.prio += 1
        # self.cmd( 'ovs-vsctl set-fail-mode', self, 'standalone' )
        # self.cmd( 'ovs-vsctl set-controller', self )
        # self.cmd( 'ovs-vsctl set Bridge', self,
        #          'stp_enable=true',
        #          'other_config:stp-priority=%d' % OVSBridgeSTP.prio )


def closTree(racks=4,hostsPerRack=20):
    hostNum = (racks*hostsPerRack)
    rackSwitchNum = racks
    spineSwitchNum = (racks/2)
    net = Mininet(controller=RemoteController, switch=OVSSwitch, autoSetMacs=True)

    print "creating controllers"
    controllers = []
    c1 = net.addController('c1', ip='127.0.0.1', port=6633)
    # c2 = net.addController('c2', ip='127.0.0.1', port=6634)
    # c3 = net.addController('c3', ip='127.0.0.1', port=6635)
    # c4 = net.addController('c4', ip='127.0.0.1', port=6636)
    # c5 = net.addController('c5', ip='127.0.0.1', port=6637)

    controllers.append(c1)
    # controllers.append(c2)
    # controllers.append(c3)
    # controllers.append(c4)
    # controllers.append(c5)

    spineSwitches = []
    rackSwitches = []
    switch_count = 1
    for i in xrange(rackSwitchNum):
        s = net.addSwitch("s"+str(switch_count), protocols='OpenFlow13')
        switch_count += 1
        rackSwitches.append(s)

    for i in xrange(spineSwitchNum):
        s = net.addSwitch("s"+str(switch_count), protocols='OpenFlow13')
        switch_count += 1
        spineSwitches.append(s)

    for spine in spineSwitches:
        rackLinks=[net.addLink(spine, rack) for rack in rackSwitches]

    # net.addLink(spineSwitches[0],rackSwitches[0])
    # net.addLink(spineSwitches[0],rackSwitches[1])
    # net.addLink(spineSwitches[1],rackSwitches[2])
    # net.addLink(spineSwitches[1],rackSwitches[3])

    # connect two spine switches
    # net.addLink(spineSwitches[0],spineSwitches[1])    

    rack_id = 0
    host_count = 0
    hosts = []
    hostLinks = []
    for rack in rackSwitches:
        rack_id += 1
        for x in xrange(1,(hostsPerRack+1)):
            host_count += 1
            # hopts={"ip":"%s.%s.%d/%d"%(IPbase,rack_id,x,mask)}
            h=net.addHost("h"+str(host_count))
            hosts.append(h)
            hostLinks.append(net.addLink(rack,h,cls=TCLink))

    net.build()
    for c in controllers:
        c.start()

    rackSwitches[0].start([controllers[0]])
    rackSwitches[1].start([controllers[0]])
    rackSwitches[2].start([controllers[0]])
    rackSwitches[3].start([controllers[0]])
    spineSwitches[0].start([controllers[0]])
    spineSwitches[1].start([controllers[0]])

    # for i in xrange(len(rackSwitches)):
    #     rackSwitches[i].start([controllers[i]])

    # for i in xrange(len(spineSwitches)):
    #     spineSwitches[i].start([controllers[-1]])

    print "*** Running CLI"
    CLI(net)

    print "*** Stopping network"
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )  # for CLI output
    # controllers={ 'pox': POX }
    # topos = { 'clostree': ( lambda: ClosTree(racks=6,hostsPerRack=20) ) }
    # switches = { 'ovs-stp': OVSBridgeSTP }
    closTree(racks=4,hostsPerRack=3)
