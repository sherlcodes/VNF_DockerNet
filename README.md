## Folder Structure
RawTopology		--> Topology Store for experiments
Controllers		--> L1 and L2 Wrappers to be used for mininet automated controller setup
mininet_script	--> Mininet driver scripts for experimentation
scikit-optimize	--> Python library used for BO
ryu + ryu.diff	--> L2 controller implementation
BaysianOptimization	--> BO finds the optimum switch controller assignment
results			--> 
util			--> Plots generation from results
Documents		--> Reports and posters
## Setup instructions
### Required python packages
`sudo -E pip install bottle, bottledaemon numpy psutil matplotlib scipy termcolor`
### Git Repo
`mkdir -f /home/mininet/GIT`
`git clone https://github.com/subhrendu1987/NFV_Containernet.git`
### PATH variable
`sudo echo 'export NFVCONTAINERNET="/home/mininet/GIT/NFV_Containernet"' >> /etc/environment`
## Build Required containers
### Create Controller docker
`sudo docker build $NFVCONTAINERNET/Docker/ryu-docker -t ryu-docker`
### Create OVS docker
`sudo docker build $NFVCONTAINERNET/Docker/ovs-docker -t ovs-docker`
## Execute Experiments
### Invoke data center clos tree topology in mininet
`cd $NFVCONTAINERNET/mininet_script/DockerTopo;sudo python topo-clos-like.py`
### Check mininet stat using REST
`http://172.16.117.50:8081/switches`

## Execute command in a node
### Dockernet
`sudo docker exec -it <node_name> <cmd>`
### Standard mininet
`cd $NFVCONTAINERNET/util;sudo python mnexecWrapper.py -h`
`cd $NFVCONTAINERNET/util;sudo python mnexecWrapper.py -l`
`cd $NFVCONTAINERNET/util;sudo python mnexecWrapper.py -n <node_name> -cmd <cmd>`

## Enforce switch-controller assignment based on /home/mininet/GIT/NFV_Containernet/Controllers/cc_client/switch_controller_config.json
`cd $NFVCONTAINERNET/BaysianOptimization; sudo python mininetChangeAssignment.py`
### View log of c0
`sudo docker run --name mn.c0 -it ryu-docker /bin/bash`
`sudo docker logs --follow $(sudo docker inspect --format="{{.Id}}" mn.c0)`
