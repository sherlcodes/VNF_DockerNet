### Example
### sudo watch bash watchFlowTables.sh "mininet:h1"
function comment(){
PIDs=$(ps -ef|grep $1|awk -F ' ' '{print $2}'|sort -z)
echo $PIDs
for pid in $PIDs; do
	filter="dl_dst="$(sudo mnexec -a $pid ifconfig |grep HWaddr |cut -f 8  -d " ")
	echo $pid
	echo $filter
	sudo mnexec -a $pid ifconfig |grep HWaddr |cut -f 8  -d " "
	if [ $? != 0 ]; then
   		break
	fi
done
}
filter=$1
brigdes=$(sudo ovs-vsctl list-br)
echo $bridges
for i in $brigdes; do
	echo $i
	sudo ovs-ofctl --protocols=OpenFlow13 dump-flows $i $filter | cut -f 1,2,3 -d ' ' --complement
	echo "---------------------------------------------"
done

