# Flow analysis through terminal
## Print all flows of a switch
`br_name=$(sudo ovs-vsctl show |grep Bridge| awk -F ' '  '{print $2}'|sed 's/"//g'); ovs-ofctl dump-flows $br_name`
`ovs-vsctl show |grep Bridge| tr -d \" |awk -v FS=Bridge '{print $2}' | xargs ovs-ofctl dump-flows $1`
## Execute CMD in dockers
`cd $NFVCONTAINERNET/mininet_script/DockerTopo; source lib.sh`
### All nodes
`exec_all "ifconfig eth0"`
### All hosts
`exec_hosts "ifconfig eth0"`
### All switches
`exec_switches "ifconfig eth0"`
### All vnfs
`exec_vnfs "ifconfig eth0"`
### All ctlrs
`exec_ctlrs "ifconfig eth0"`

# REST requests
## GET Requests
### Switches
`http://172.16.117.50:9110/stats/switches`
### Description of switches
`http://172.16.117.50:9110/stats/desc/1`
### Flow entries of switches
`http://172.16.117.50:9110/stats/flow/1`
### Mactable of Switches
`http://172.16.117.50:9110/simpleswitch/mactable/0000000000000001`

## POST Requests
### View flow with filter
`curl -d '{"out_port":2}' -X POST http://172.16.117.50:9110/stats/flow/1`
### Add new flow
`curl -d '{"dpid": 1,"cookie": 42,"priority": 45000,"match": {"in_port": 3},"actions": []}' -X POST http://172.16.117.50:9110/stats/flowentry/add`
### Delete new flow
`curl -d '{"dpid": 1,"cookie": 42,"priority": 45000,"match": {"in_port": 3},"actions": []}' -X POST http://172.16.117.50:9110/stats/flowentry/delete_strict`



# Dev Notes
* RYU command 
	`python ryu/bin/ryu-manager --verbose --observe-links --ofp-tcp-listen-port 6600 --wsapi-port 9100 ryu.app.myapp.l3_switch_13`
	`sudo mn --topo linear,10 --mac --controller=remote,ip=10.0.2.15,port=6600 --switch ovs,protocols=OpenFlow13`
* WGET path checker
	`http://172.16.117.50:9110/l3switch/findpath/11.1.0.1/11.2.0.1`
* Tcpdump in node
	`tcpdump -i any -e icmp[icmptype] == 8 or icmp[icmptype] == 0`