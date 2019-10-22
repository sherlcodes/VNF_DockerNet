# currently the problem i am facing is when ever i am running c1 or c2 the hosts h3 and h4
# gets connected that is s1 switch gets controlled but then even after running c2 h5 and h6
# does not get connected. I am running simple_switch.py program from ryu example.
# I am now quite sure that i am not understanding mininet and ryu on the level that 
# i could write any code. I need to spend some more time on mininet. Go through each
# example and then figure out what each term precisely mean

from mininet.net import Mininet
from mininet.node import Controller, OVSSwitch, RemoteController, OVSKernelSwitch, UserSwitch
from mininet.cli import CLI
from mininet.log import setLogLevel
from CustomCtlr import CustomL1,CustomL2

def multiControllerNet():
    "Create a network from semi-scratch with multiple controllers."
    ### Require of version 1.3
    net = Mininet( controller=CustomL1, switch=OVSKernelSwitch )

    print "*** Creating (reference) controllers"
    c0 = net.addController( 'c0',controller=CustomL2)
    c1 = net.addController( 'c1',controller=CustomL1, port=6633, wsport=9000 )
    c2 = net.addController( 'c2',controller=CustomL1, port=6634, wsport=9000 )

    print "*** Creating switches"
    s1 = net.addSwitch( 's1',protocols=["OpenFlow13"] )
    s2 = net.addSwitch( 's2',protocols=["OpenFlow13"] )

    print "*** Creating hosts"
    hosts1 = [ net.addHost( 'h%d' % n ) for n in 3, 4 ]
    hosts2 = [ net.addHost( 'h%d' % n ) for n in 5, 6 ]

    print "*** Creating links"
    for h in hosts1:
        net.addLink( s1, h )
    for h in hosts2:
        net.addLink( s2, h )
    net.addLink( s1, s2 )

    print "*** Starting network"
    net.build()
    c0.start()
    c1.start()
    c2.start()
    s1.start( [ c1 ] )
    s2.start( [ c2 ] )

    print "*** Testing network"
    # net.pingAll()

    print "*** Running CLI"
    CLI( net )

    print "*** Stopping network"
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )  # for CLI output
    multiControllerNet()
