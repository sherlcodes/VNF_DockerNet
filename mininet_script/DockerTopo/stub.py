config_file = "~/.SDN/switch_controller_config.json"

from mininet.topo import Topo
from mininet.net import Mininet
from os import environ,system,path
import json, itertools, thread,logging,sys
#from CustomCtlr import *
from ClosTree import *

config_file = path.expanduser(config_file)
protocols="OpenFlow10,OpenFlow11,OpenFlow12,OpenFlow13"
from mininet.topo import Topo
from mininet.net import Containernet
from mininet_rest import MininetRest
from mininet.log import setLogLevel, info
from mininet.node import Controller, OVSSwitch, RemoteController, OVSKernelSwitch, UserSwitch, Ryu
from mininet.cli import CLI
from mininet.link import TCLink
from CustomCtlr import *
from os import environ,system
import json, itertools, thread,logging,sys
##########################################################################################
net = Containernet(ipBase='11.0.0.1/24')
info("*** CONTROL PLANE STARTS\n")
info("*** Add Central Controller for debugging\n")
#H1=net.addDocker( name="h1", dimage="ryu-docker", volumes=["/home/mininet/ScalableSDN/Shared:/mnt/ryu:rw"])
port_bindings={6600:6600,9100:9100}
c0=net.addController(name="c0",controller=DockerRyu,ofpport=getVal(port_bindings,6600),wsport=getVal(port_bindings,9100))
#std_ctlr=net.addController(name="c_test")
#f = os.popen('ifconfig docker0 | grep "inet\ addr" | cut -d: -f2 | cut -d" " -f1')
#exposedIP=f.read().strip()
info("*** DATA PLANE STARTS\n")
s1= net.addSwitch("s1", cls=OVSDocker,protocols=protocols)
#s1 = net.addSwitch("s1", protocols=protocols)
info("*** HOST STARTS\n")
h1=net.addDocker("h1", dimage="ubuntu:trusty")
h2=net.addDocker("h2", dimage="ubuntu:trusty")

net.addLink(s1,h1,cls=TCLink)
net.addLink(s1,h2,cls=TCLink)

net.build()
c0.start()
#for c in net.controllers:
#    c.start()
s1.start([c0])
    
