#!/bin/bash
declare -a nodes
declare -a hosts
declare -a vnfs
declare -a ctlrs
declare -a switches
nodes=( $(sudo docker ps -a |grep mn.* | awk -F ' ' '{print $NF}') )
hosts=( $(sudo docker ps -a |grep -e 'mn.h' | awk -F ' ' '{print $NF}') )
vnfs=( $(sudo docker ps -a |grep -e 'mn.v' | awk -F ' ' '{print $NF}') )
ctlrs=( $(sudo docker ps -a |grep -e 'mn.c' | awk -F ' ' '{print $NF}') )
switches=( $(sudo docker ps -a |grep -e 'mn.s' | awk -F ' ' '{print $NF}') )
################################################################
exec_in(){
   	sudo docker exec $1 bash -c "$2"
}
################################################################
exec_all(){
	for i in "${nodes[@]}"
	do
   	: 
   	echo "*** $i"
   	sudo docker exec $i bash -c "$1"
done
}
################################################################
exec_hosts(){
	for i in "${hosts[@]}"
	do
   	: 
   	echo "*** $i"
   	sudo docker exec $i bash -c "$1"
done
}
################################################################
exec_vnfs(){
	for i in "${vnfs[@]}"
	do
   	: 
   	echo "*** $i"
   	sudo docker exec $i bash -c "$1"
done
}
################################################################
exec_switches(){
	for i in "${switches[@]}"
	do
   	: 
   	echo "*** $i"
   	sudo docker exec $i /bin/sh -c "$1"
done
}
################################################################
exec_ctlrs(){
	for i in "${ctlrs[@]}"
	do
   	: 
   	echo "*** $i"
   	sudo docker exec $i /bin/sh -c "$1"
done
}