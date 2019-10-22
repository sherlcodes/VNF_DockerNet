## Create Docker Images
### Create Controller docker
`sudo docker build $NFVCONTAINERNET/Docker/ryu-docker -t ryu-docker`
### Create OVS docker
`sudo docker build $NFVCONTAINERNET/Docker/ovs-docker -t ovs-docker`
### Create switch docker
`sudo docker build $NFVCONTAINERNET/Docker/switch-docker -t switch-docker`
### View log of c0
`sudo docker run --name mn.c0 -it ryu-docker /bin/bash`
`sudo docker logs --follow $(sudo docker inspect --format="{{.Id}}" mn.c0)`
