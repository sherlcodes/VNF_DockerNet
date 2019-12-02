from mininet.node import *
from mininet.examples.mobility import *
from mininet.link import TCLink
from os import environ
from mininet.log import setLogLevel, info
import os
PWD= os.getcwd()
import os

#RYUDIR = environ[ 'HOME' ] + '/ryu'
#L2CTLR= PWD + '/../../Controllers/cc_client/layer_2_switch.py'
#L2CTLR= PWD + '/../../Controllers/L2Controller/topo_learner.py'
#TFLCDIR= PWD + '/../../Controllers/tflc'
setLogLevel( 'info' )
###########################################################################################################
class OriginalRYU( Controller ):
    def __init__( self, name,cdir="",
                  command='ryu-manager',
                  cargs=( '--observe-links '
                          '--ofp-tcp-listen-port %s '
                          '--wsapi-port %s '
                          'ryu.app.ofctl_rest '
                          'ryu.app.simple_switch_13'),
                  wsport=9100,
                  **kwargs ):
        print("Original RYU L0 in the host system")
        self.wsport = wsport
        Controller.__init__( self, name,
                             command=command,
                             cargs=cargs, **kwargs )
    ####################################
    def start( self ):
        """Start <controller> <args> on controller.
           Log to /tmp/cN.log"""
        pathCheck( self.command )
        cout = '/tmp/' + self.name + '.log'
        if self.cdir is not None:
            self.cmd( 'cd ' + self.cdir )
        self.cmd( self.command + ' ' + self.cargs % (self.port,self.wsport )+
                  ' 1>' + cout + ' 2>' + cout + ' &' )
        self.execed = False
###########################################################################################################
#sudo docker run --name=mn.test -d -v $NFVCONTAINERNET/Shared:~/Shared -p 5000:80 ryu-docker

class DockerRyu( Docker, RemoteController ):
    def __init__( self, name,dimage="ryu-docker",ofpport=6600,wsport=9100,**kwargs ):
        f = os.popen('ifconfig docker0 | grep "inet\ addr" | cut -d: -f2 | cut -d" " -f1')
        self.exposedIP=f.read().strip()
        self.ofpport=6600
        self.wsport=9100
        Docker.__init__( self, name, dimage, port_bindings={self.ofpport:ofpport,self.wsport:wsport},volumes=["%s/Docker/Shared:/Shared:rw"%(os.environ['NFVCONTAINERNET']), "/dev:/dev:rw", "/lib/modules:/lib/modules:rw"],**kwargs)
    ####################################
    def start( self,appNo="l2" ):
        pids=Docker.cmd(self,"ps -ef|grep 'ryu-manager'|awk '{print $2}'|xargs kill -9")
        #Docker.start(self)
        #cd /Shared; python ryu/bin/ryu-manager --observe-links --ofp-tcp-listen-port 6600 --wsapi-port 9100 ryu/ryu/app/ofctl_rest.py ryu/ryu/app/simple_switch_rest_13.py
        CMDdict={"l2":"python ryu/bin/ryu-manager --verbose --observe-links --ofp-tcp-listen-port %d --wsapi-port %d ryu.app.ofctl_rest ryu.app.simple_switch_rest_13",
        "l2_gui":"python ryu/bin/ryu-manager --verbose --observe-links --ofp-tcp-listen-port %d --wsapi-port %d ryu.app.ofctl_rest ryu.app.simple_switch_13 ryu.app.gui_topology.gui_topology",
        "l3":"python ryu/bin/ryu-manager --verbose --observe-links --ofp-tcp-listen-port %d --wsapi-port %d ryu.app.myapp.l3_switch_13",
        "l3_host":"python ryu/bin/ryu-manager --verbose --observe-links --ofp-tcp-listen-port %d --wsapi-port %d ryu.app.myapp.l3_switch_13 ryu.app.rest_topology"
        }
        RyuCommand=CMDdict[appNo]%(self.ofpport,self.wsport)
        info("*** RYU-App:"+appNo+"\n")
        Docker.cmd(self,"cd /Shared; nohup %s &"%(RyuCommand))
        RemoteController.__init__(self,self.name,port=self.ofpport,ip=self.exposedIP)
        RemoteController.start(self)
    ####################################
    def stop( self ):
        pids=Docker.cmd(self,"ps -ef|grep 'ryu-manager'|awk '{print $2}'|xargs kill -9")
        Docker.stop(self)
        RemoteController.stop(self)
###########################################################################################################
class OVSDocker( Docker, MobilitySwitch ):
    """Open vSwitch Ethernet bridge with Spanning Tree Protocol
       rooted at the first bridge that is created"""
    def __init__(self,name,dimage="switch-docker",**kwargs):
      Docker.__init__( self, name, dimage=dimage, volumes=["%s/Docker/Shared:/Shared:rw"%(os.environ['NFVCONTAINERNET']),"/var/run/docker.sock:/var/run/docker.sock:rw", "/dev:/dev:rw", "/lib/modules:/lib/modules:rw"],**kwargs)
      OVSSwitch.__init__( self, name,failMode='secure',**kwargs )
      #OVSSwitch.__init__( self, name,stp=True,failMode='secure',datapath='kernel',**kwargs )
    ####################################
    def start(self,controllers ):
      OVSSwitch.sendCmd(self,'service', 'openvswitch-switch', 'start')
      ''' Do we need it?
      ovs-vsctl set-manager ptcp:6640
      bash
      service openvswitch-switch stop
      '''
      OVSSwitch.sendCmd(self,'service', 'ssh', 'start')
      OVSSwitch.start(self,[])
      self.controllers=controllers
      connections=["tcp:%s:%d"%(c.exposedIP,c.port_bindings[c.port]) if(isinstance(c,DockerRyu)) else "tcp:%s:%d"%(c.ip,c.port) for c in controllers ]
      print(connections)
      OVSSwitch.vsctl(self,"set-controller %s %s"%(self.name," ".join(connections)))
    ####################################
    def addNFV(self,dimage=None):
      if(not None):
        self.sendCmd(self,name, dimage=dimage, volumes=["%s/Docker/Shared:/Shared:rw"%(os.environ['NFVCONTAINERNET']),"/var/run/docker.sock:/var/run/docker.sock:rw"],**kwargs)
    ####################################
    def cleanFlows(self):
      flows=OVSSwitch.cmd(self,"ovs-ofctl dump-flows s1").split("\n")
      flow_tab=[re.split(' |,', f.strip())  for f in  flows if len(f)>0]
      tab_set= set([cell.replace("table=","") for row in flow_tab for cell in row if ("table=" in cell) ])
      connections=["tcp:%s:%d"%(c.exposedIP,c.port_bindings[c.port]) for c in self.controllers ]
      OVSSwitch.vsctl(self,"del-controller %s"%(self.name))
      for tab in tab_set:
        OVSSwitch.cmd(self,"ovs-ofctl del-flows %s 'table=%s'"%(self.name,tab))
      OVSSwitch.vsctl(self,"set-controller %s %s"%(self.name," ".join(connections)))
###########################################################################################################
class VNF( Docker, Host ):
    """VNF as a host"""
    def __init__(self,name,dimage="vnf:latest",**kwargs):
      Docker.__init__(self, name, dimage=dimage, volumes=["%s/Docker/Shared:/Shared:rw"%(os.environ['NFVCONTAINERNET']),"/var/run/docker.sock:/var/run/docker.sock:rw", "/dev:/dev:rw", "/lib/modules:/lib/modules:rw"],**kwargs)
      Host.__init__(name)
      self.parentNode=None      
    ####################################
    def addParent(self,parentNode=None):
      self.parentNode=parentNode
    ####################################

###########################################################################################################



#controllers={ 'CustomL1': CustomL1,'CustomL2': CustomL2,"OriginalRYU":OriginalRYU}
controllers={ 'DockerRyu': DockerRyu,"OriginalRYU":OriginalRYU}
switches={ "OVSDocker":OVSDocker}
nfvs={ "VNF":VNF}
