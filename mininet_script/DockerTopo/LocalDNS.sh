#!/bin/bash
source lib.sh
for i in "${nodes[@]}"
do
   : 
   IP=$(sudo docker exec $i ifconfig eth0| awk -F ' *|:' '/inet addr/{print $4}')
   if [ ${#IP} -le 0 ]; then
   	IP=$(sudo docker exec $i ifconfig eth0| awk -F ' ' '/inet/{print $2}')
   fi
   sed -i '/'$i'/d' hosts
   echo $IP"	"$i >> hosts
done

for i in "${nodes[@]}"
do
   : 
   sudo docker cp hosts $i:/foo.txt
done
exec_all "cat /etc/hosts /foo.txt > /etc/hosts"
exec_all "cat /etc/hosts"