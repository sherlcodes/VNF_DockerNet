from mininet.node import *
from os import environ
import os
PWD= os.getcwd()
RYUDIR = environ[ 'HOME' ] + '/ryu'
L2CTLR= PWD + '/../../Controllers/cc_client/layer_2_switch.py'
#L2CTLR= PWD + '/../../Controllers/L2Controller/topo_learner.py'
TFLCDIR= PWD + '/../../Controllers/tflc'

###########################################################################################################
class OriginalRYU( Controller ):
    def __init__( self, name,cdir=RYUDIR,
                  command='ryu-manager',
                  cargs=( '--observe-links '
                          '--ofp-tcp-listen-port %s '
                          '--wsapi-port %s '
                          'ryu.app.ofctl_rest '
                          'ryu.app.simple_switch_13'),
                  wsport=9100,
                  **kwargs ):
        print("Original RYU L0")
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

###########################################################################################################
class CustomL1( Controller ):
    def __init__( self, name,cdir=RYUDIR,
                  command='ryu-manager',
                  cargs=( '--observe-links '
                          '--ofp-tcp-listen-port %s '
                          '--wsapi-port %s '
                          'ryu.app.ofctl_rest '+L2CTLR),
                  wsport=9000,
                  **kwargs ):
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
class CustomL2( Controller ):
    def __init__( self, name,cdir=TFLCDIR,
                  command='python tflc.py', **kwargs ):
        print("L2 init")
        Controller.__init__( self, name,cdir=cdir,
                             command=command,**kwargs )
###########################################################################################################
class OVSBridgeSTP( OVSSwitch ):
    """Open vSwitch Ethernet bridge with Spanning Tree Protocol
       rooted at the first bridge that is created"""
    def __init__(self,name,**kwargs):
      OVSSwitch.__init__( self, name,**kwargs )
      #OVSSwitch.__init__( self, name,stp=True,failMode='open',datapath='kernel',**kwargs )
    ####################################
    prio = 1000
    def start( self, *args, **kwargs ):
        OVSSwitch.start( self, *args, **kwargs )
        OVSBridgeSTP.prio += 1
        #self.cmd( 'ovs-vsctl set-fail-mode', self, 'standalone' )
        #self.cmd( 'ovs-vsctl set-controller', self )
        self.cmd( 'ovs-vsctl set Bridge', self,
                  'stp_enable=true',
                  'other_config:stp-priority=%d' % OVSBridgeSTP.prio )
##########################################################################################

###########################################################################################################
controllers={ 'CustomL1': CustomL1,'CustomL2': CustomL2,"OriginalRYU":OriginalRYU}
switches={ 'OVSBridgeSTP': OVSBridgeSTP}
