#!/bin/bash
bridges=( $(sudo ovs-vsctl show |grep Bridge|grep -o '".*"' | sed 's/"//g') )

for i in "${bridges[@]}"
do
   : 
   sudo ovs-vsctl set bridge $i protocols=OpenFlow10,OpenFlow11,OpenFlow12,OpenFlow13
   echo $i
done

