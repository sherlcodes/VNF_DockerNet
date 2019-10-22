#!/bin/bash
### MANUAL http://manpages.ubuntu.com/manpages/trusty/man8/ip-l2tp.8.html
#source common/ssh_config.sh
if [ $# -lt 3 ]; then
    echo "bash CreateEdge.sh <EdgeNo> <SiteAname> <SiteBname> {delay_in_ms} {bandwidth_in_Mbps}";
    exit 1;
fi
echo "bash CreateEdge.sh "${1}" "${2}" "${3};
Delay="";
BW="";
if [[ $# -eq 5 ]]; then
	BW=${5}				#BW="1Mbit"
	if [[ $# -eq 4 ]]; then
		Delay=${4}		#Delay="5ms"
	fi
fi
EdgeNo=${1}		#EdgeNo="1"
SiteAname=${2}	#SiteAname="mn.h1"
SiteBname=${3}	#SiteBname="mn.rack2"

### Check if Sites are accessible
ping -c1 -W1 $SiteAname && echo 'server is up' || debug1=`echo "${SiteAname} Unreachable"`
ping -c1 -W1 $SiteBname && echo 'server is up' || debug2=`echo "${SiteBname} Unreachable"`
if [[ $debug1 = *"Unreachable"* ]]; then
	echo "EXITING! ${debug1}"
fi
if [[ $debug2 = *"Unreachable"* ]]; then
	echo "EXITING! ${debug2}"
fi
##############################################
SiteA=$(${SSHCOMMAND} ${USERNAME}@$SiteAname "ifconfig eth0"|grep "inet addr"|awk -F ":" '{print $2}'|awk -F " " '{print $1}');
SiteB=$(${SSHCOMMAND} ${USERNAME}@$SiteBname "ifconfig eth0"|grep "inet addr"|awk -F ":" '{print $2}'|awk -F " " '{print $1}');
SiteAprivate="10.42.1."`expr 0 + $EdgeNo`;
SiteBprivate="10.42.2."`expr 0 + $EdgeNo`;
SiteAPort=`expr 5000 + $EdgeNo`;
SiteBPort=`expr 6000 + $EdgeNo`;
##############################################
SiteATunID=`expr 1000 + $EdgeNo`;
SiteBTunID=`expr 2000 + $EdgeNo`;
SiteASessID=`expr 3000 + $EdgeNo`;
SiteBSessID=`expr 4000 + $EdgeNo`;
SiteAif="l2tpeth$(${SSHCOMMAND} ${USERNAME}@$SiteAname "sudo ip link show" |grep l2tpeth| wc -l)";
SiteBif="l2tpeth$(${SSHCOMMAND} ${USERNAME}@$SiteBname "sudo ip link show" |grep l2tpeth| wc -l)";
SiteAif="${SiteAif// /}"
SiteBif="${SiteBif// /}"
#############################################################################################################################
### Check existence of the edge
pairA=( $(${SSHCOMMAND} ${USERNAME}@$SiteAname "sudo ip l2tp show tunnel"|grep "From"|awk -F " " '{print $4}') );
pairB=( $(${SSHCOMMAND} ${USERNAME}@$SiteBname "sudo ip l2tp show tunnel"|grep "From"|awk -F " " '{print $4}') );
case "${pairA[@]}" in  *"${SiteB}"*) echo "This Link Already Exists!"; exit 1 ;; esac
case "${pairB[@]}" in  *"${SiteA}"*) echo "One End of This Link Already Exists! Remove from ${SiteBname}"; exit 1 ;; esac
#############################################################################################################################
echo $SiteA"("$SiteAprivate")"$SiteAPort"--------->"$SiteB"("$SiteBprivate")"$SiteBPort;
echo $SiteATunID"("$SiteASessID")"$SiteAif"--------->"$SiteBTunID"("$SiteBSessID")"$SiteBif
#############################################################################################################################
#Site A:
${SSHCOMMAND} ${USERNAME}@$SiteAname "sudo  modprobe l2tp_eth; sudo ip l2tp add tunnel tunnel_id $SiteATunID peer_tunnel_id $SiteBTunID encap udp local $SiteA remote $SiteB udp_sport $SiteAPort udp_dport $SiteBPort";
${SSHCOMMAND} ${USERNAME}@$SiteAname "sudo ip l2tp add session tunnel_id $SiteATunID session_id $SiteASessID peer_session_id $SiteBSessID";
#Site B:
${SSHCOMMAND} ${USERNAME}@$SiteBname "sudo  modprobe l2tp_eth; sudo ip l2tp add tunnel tunnel_id $SiteBTunID peer_tunnel_id $SiteATunID encap udp local $SiteB remote $SiteA udp_sport $SiteBPort udp_dport $SiteAPort";
${SSHCOMMAND} ${USERNAME}@$SiteBname "sudo ip l2tp add session tunnel_id $SiteBTunID session_id $SiteBSessID peer_session_id $SiteASessID";
#Both:
${SSHCOMMAND} ${USERNAME}@$SiteAname "sudo ip link set $SiteAif up mtu 1488; sudo ip addr add $SiteAprivate peer $SiteBprivate dev $SiteAif";
${SSHCOMMAND} ${USERNAME}@$SiteBname "sudo ip link set $SiteBif up mtu 1488; sudo ip addr add $SiteBprivate peer $SiteAprivate dev $SiteBif";
#############################################################################################################################
# Add delay and Bandwidth capacity
if [[ ! -z "$Delay" ]]; then
	${SSHCOMMAND} ${USERNAME}@$SiteAname "tc q";
	${SSHCOMMAND} ${USERNAME}@$SiteAname "sudo tc qdisc add dev "$SiteAif" root handle 1: tbf rate "$BW" buffer 1600 limit 3000; sudo tc qdisc add dev "$SiteAif" parent 1:1 handle 10: netem delay "$Delay";";
	${SSHCOMMAND} ${USERNAME}@$SiteBname "sudo tc qdisc add dev "$SiteBif" root handle 1: tbf rate "$BW" buffer 1600 limit 3000; sudo tc qdisc add dev "$SiteBif" parent 1:1 handle 10: netem delay "$Delay";";
fi
#############################################################################################################################
# Do PING test for verification.
${SSHCOMMAND} ${USERNAME}@$SiteAname "ping -c 3 $SiteBprivate";
${SSHCOMMAND} ${USERNAME}@$SiteBname "ping -c 3 $SiteAprivate";
# Do LLDP test for verification.
${SSHCOMMAND} ${USERNAME}@$SiteAname "sudo lldpcli show neighbor|grep MgmtIP|grep $SiteB";
${SSHCOMMAND} ${USERNAME}@$SiteBname "sudo lldpcli show neighbor|grep MgmtIP|grep $SiteA";
# Clean IP
${SSHCOMMAND} ${USERNAME}@$SiteAname "sudo ip addr flush dev $SiteAif"
${SSHCOMMAND} ${USERNAME}@$SiteBname "sudo ip addr flush dev $SiteBif"
#############################################################################################################################
: '
# Show tunnel list
#sudo ip l2tp show tunnel
# Delete tunnel
#sudo ip l2tp del tunnel tunnel_id 3000
# Delete All tunnels
function deleteTunneles{
IDLines=$(${SSHCOMMAND} ${USERNAME}@$SiteAname "sudo ip l2tp show tunnel"|grep "Tunnel")
for (TID in $(sudo ip l2tp show tunnel|grep "Tunnel"|awk -F " " "{print $2}"))
	do
	sudo ip l2tp del tunnel tunnel_id $TID
	end
}
#############################################################################################################################
function comment(){
#Site A:
sudo ip addr add $SiteAprivate peer $SiteBprivate dev l2tpeth0
sudo ip link set l2tpeth0 up mtu 1446
sudo ip link add br0 type bridge
sudo ip link set l2tpeth0 master br0
sudo ip link set eth0 master br0
sudo ip link set br0 up
#Site B:
sudo ip addr add $SiteBprivate peer $SiteAprivate dev l2tpeth0
}
'
