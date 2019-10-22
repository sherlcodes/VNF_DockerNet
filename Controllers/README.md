# PARC
A hierarchical control plane for SDN (Software-Defined Networking) with a central controller and several local controllers.  
PARC is the highlights of this system, which means a Control plane with features like Partition, Abstract and Recursion.  
The local agent is run on ryu, and the topology can be based on mininet.  
# Steps
0. The package tflc is the code of central controller and package cc_client is the code of the local controller, which runs on ryu.
1. Design a LOCAL CONTROLLER topology with their links and ports represented, then update lc_level_topo.py in tflc and cfg.py in cc_client according to the LOCAL CONTROLLER topology.
2. On the central controller, run tflc.py to start the central controller. You can also use REST debug tools like POSTMAN to check the status and parameter, reference: `tflc/app_manager.py line 287`. 
3. On local controllers, run the local client using `ryu-manager --observe-links layer_2_switch.py`. `--observe-links` is used to discover the switch topology in the controller's control domain.

### Run central controller
```sudo python tflc.py```

### Run local remote controllers on port 6633 and rest server for traffic characteristics at 9000.  
```ryu/bin/ryu-manager --observe-links --ofp-tcp-listen-port 6633 --wsapi-port 9000 ryu.app.ofctl_rest ScalableSDN/Suraj_ScalableSDN/PARC-master/cc_client/layer_2_switch.py```

### Run the full test using clos topology
```cd /home/mininet/ScalableSDN/Suraj_ScalableSDN/PARC-master/mininet_script/topology;sudo python topo-clos-like.py```

### Delete flow entries at switch s1
```sudo ovs-ofctl --protocols=OpenFlow13 del-flows s1```

How to identify if the flow is inter-domain or intra-domain
from listed switches in flow_stats field which shows from which switches this flow has went through, but it does not say in which order. It is just a set of switches through which the flow has gone.

FLow is being setup now according to ip and port. If ip is not applicable it is not being used. A sample tcp flow_stats JSON is here:
```
[{"switches": [1, 2, 3], "byte_count": 41914848, "controllers": ["c1"], "duration_sec": 25, "throughput": 1676593, "match": {"dl_dst": "00:00:00:00:00:05"}}, {"switches": [1, 2, 3], "byte_count": 1719356460, "controllers": ["c1"], "duration_sec": 25, "throughput": 68774258, "match": {"dl_type": 2048, "nw_dst": "10.0.0.1", "nw_proto": 6, "tp_dst": 20000, "tp_src": 36823, "nw_src": "10.0.0.5"}}, {"switches": [4, 5, 6], "byte_count": 2707821226, "controllers": ["c2"], "duration_sec": 24, "throughput": 112825884, "match": {"dl_dst": "00:00:00:00:00:01"}}, {"switches": [4, 5, 6, 1, 2, 3], "byte_count": 26622660, "controllers": ["c2", "c1"], "duration_sec": 24, "throughput": 1109277, "match": {"dl_dst": "00:00:00:00:00:0b"}}, {"switches": [1, 2, 3], "byte_count": 2707821320, "controllers": ["c1"], "duration_sec": 24, "throughput": 112825888, "match": {"dl_type": 2048, "nw_dst": "10.0.0.1", "nw_proto": 6, "tp_dst": 20000, "tp_src": 48313, "nw_src": "10.0.0.11"}}]
```
It would be good to clear all switches' old stats before doing experiment. So that only relevant stats get gathered.

How to change switch controller mapping?
1. In layer_2_switch there is a local stub which periodically checks for all switches whether it is the controller or not by referencing to the switch_controller_config.json file
2. When a change is detected the script requests for a change on http://localhost:4000/jsonrpc by Remote procedure call. 
3. For that call to get exceuted the rpc server should run. Which is there in the /home/mininet/ScalableSDN/Suraj_ScalableSDN/PARC-master/rpcClientServer/rpcServer.py
4. So run rpcServer.py first then go on change the configuration.

## Useful commands
### Kill all ryu instances
```kill -9 $(ps -ef|grep "python /home/mininet/ryu/bin/ryu-manager"|awk -F ' ' '{print $2}')```

## usage of L2Controller
```ryu-manager --observe-links --ofp-tcp-listen-port 6600 --wsapi-port 9100 ryu.app.ofctl_rest /home/mininet/ScalableSDN/mininet_script/TestTopo/../../Controllers/L2Controller/topo_learner_13.py ```
## Tracker
### Flow table visualization 
