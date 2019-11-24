"""
http://www.hoggnet.com/NWWPics/CLOS%20Network.jpg

sudo mn --custom ~/mininet/custom/topo-clos-like.py --topo clostree --switch ovs-stp --controller=remote,ip=127.0.0.1,port=6633
sudo mn --custom ~/mininet/custom/topo-clos-like.py --topo clostree --switch ovs --controller=ref
mininet> sh time bash -c 'while ! ovs-ofctl show es_0_0 | grep FORWARD; do sleep 1; done'

Pass '--topo=fattree' from the command line
"""
config_file = "~/.SDN/switch_controller_config.json"

from mininet.topo import Topo
from mininet.net import Mininet
from mininet_rest import MininetRest
from mininet.log import setLogLevel, info
from mininet.node import Controller, OVSSwitch, RemoteController, OVSKernelSwitch, UserSwitch, Ryu
from mininet.cli import CLI
from mininet.link import TCLink
from mininet_rest import MininetRest
from os import environ,system,path
import json, itertools, thread,logging,sys
#from CustomCtlr import *
from ClosTree import *
##########################################################################################
config_file = path.expanduser(config_file)
protocols="OpenFlow10,OpenFlow11,OpenFlow12,OpenFlow13"
#switch=OVSBridgeSTP
#switch=OVSKernelSwitch
##########################################################################################
if __name__ == '__main__':
    #setLogLevel( 'debug' )  # for CLI output
    setLogLevel( 'info' )  # for CLI output
    # controllers={ 'pox': POX }
    # topos = { 'clostree': ( lambda: ClosTree(racks=6,hostsPerRack=20) ) }
    # switches = { 'ovs-stp': OVSBridgeSTP }
    # Read Mapping file SwitchMappingDict.JSON
    if os.path.isfile(config_file):
        with open(config_file, 'r') as f:
            SwitchMappingDict = json.load(f)
    else:
        SwitchMappingDict=None
    clos=ClosTree(racks=2,hostsPerRack=2,ctlrNo=0)
    #clos.addVNF(name="Blank",parentNode=clos.net.getNodeByName("spine1"),dimage="ubuntu:trusty")
    #net=clos.startNetwork(SwitchMappingDict=SwitchMappingDict)
    net=clos.startNetwork(REST=True)

    # Can be dropped later
    H={n.name:{"pid":n.pid} for n in net.hosts}
    S={n.name:{"pid":n.pid} for n in net.switches}
    C={n.name:{"pid":n.pid,"connect":"%s:%s:%s"%(n.protocol,n.ip,n.port)} for n in net.controllers}
    netDict=H.copy()
    netDict.update(S)
    netDict.update(C)
    ###############################################################
    '''
    with open('mnexecData.json', 'w') as fp:
        json.dump(netDict, fp)
        fp.close()
    dataPlane={i: [l.intf1.node.name,l.intf2.node.name] for i,l in enumerate(net.links) if not("Host" in "%s-%s"%(str(type(l.intf1.node)),str(type(l.intf2.node))))}
    with open('dataPlane.json', 'w') as fp:
        json.dump(dataPlane, fp)
        fp.close()
    '''
    ###############################################################
    repeat=True
    while(repeat):
        info("*** Running Ipython\n")
        import IPython
        IPython.embed()
        ###############################################################
        info("*** Running CLI\n")
        # net.getNodeByName("h1").cmdPrint("")
        # clos.pingAllIntfs()
        CLI(net)
        try:
            choice=str(raw_input("Want to repeat? (N|y)\t:"))
        except SyntaxError:
            choice= None
        #print(choice)
        repeat= True if(choice=="y") else False
    clos.stop()
    ###############################################################
    with open('mnexecData.json', 'w') as fp:
        json.dump({"EMPTY":True}, fp)
        fp.close()
    info("*** mnexecData.json Cleared\n")


