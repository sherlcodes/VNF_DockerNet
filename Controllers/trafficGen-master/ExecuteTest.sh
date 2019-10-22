#!/bin/bash
START=$(date +%s%N)
printMsg() {
    tt=$((($(date +%s%N) - $1)/1000000))
    echo "$2 -> Start time: $tt milliseconds"
}
rm -f Results/*
ovs-ofctl --protocols=OpenFlow13 del-flows s1
ovs-ofctl --protocols=OpenFlow13 del-flows s2
ovs-ofctl --protocols=OpenFlow13 del-flows s3
ovs-ofctl --protocols=OpenFlow13 del-flows s4
ovs-ofctl --protocols=OpenFlow13 del-flows s5
ovs-ofctl --protocols=OpenFlow13 del-flows s6
ovs-ofctl --protocols=OpenFlow13 del-flows s7
ovs-ofctl --protocols=OpenFlow13 del-flows s8
ovs-ofctl --protocols=OpenFlow13 del-flows s9
ovs-ofctl --protocols=OpenFlow13 add-flow s1 dl_type=0x0806,actions=drop
ovs-ofctl --protocols=OpenFlow13 add-flow s2 dl_type=0x0806,actions=drop
ovs-ofctl --protocols=OpenFlow13 add-flow s3 dl_type=0x0806,actions=drop
ovs-ofctl --protocols=OpenFlow13 add-flow s4 dl_type=0x0806,actions=drop
ovs-ofctl --protocols=OpenFlow13 add-flow s5 dl_type=0x0806,actions=drop
ovs-ofctl --protocols=OpenFlow13 add-flow s6 dl_type=0x0806,actions=drop
ovs-ofctl --protocols=OpenFlow13 add-flow s7 dl_type=0x0806,actions=drop
ovs-ofctl --protocols=OpenFlow13 add-flow s8 dl_type=0x0806,actions=drop
ovs-ofctl --protocols=OpenFlow13 add-flow s9 dl_type=0x0806,actions=drop
#######################################################
timeTracker(){
	max=$1
	echo -n "Timer Started"
	for ((curr=1;curr<=max;curr=curr+5));
		do
		sleep 5
		echo -en "\e[0K\r ["$curr"]"
	done
}
#######################################################
# 6686 10.0.0.6 26.26408 274.2176
sleep 26.264080 && printMsg $START "Results/0.log" && sudo mnexec -a 6686 iperf -c 10.0.0.6 -t 1 > Results/0.log &
# 6686 10.0.0.6 24.30032 173.7801
sleep 24.300320 && printMsg $START "Results/1.log" && sudo mnexec -a 6686 iperf -c 10.0.0.6 -t 1 > Results/1.log &
# 6709 10.0.0.2 46.21139 156.4176
sleep 46.211390 && printMsg $START "Results/2.log" && sudo mnexec -a 6709 iperf -c 10.0.0.2 -t 1 > Results/2.log &
# 6709 10.0.0.4 35.43715 3197.142
sleep 35.437150 && printMsg $START "Results/3.log" && sudo mnexec -a 6709 iperf -c 10.0.0.4 -t 1 > Results/3.log &
# 6709 10.0.0.4 31.70664 2002.568
sleep 31.706640 && printMsg $START "Results/4.log" && sudo mnexec -a 6709 iperf -c 10.0.0.4 -t 1 > Results/4.log &
# 6709 10.0.0.4 36.03925 3552.025
sleep 36.039250 && printMsg $START "Results/5.log" && sudo mnexec -a 6709 iperf -c 10.0.0.4 -t 1 > Results/5.log &
# 6709 10.0.0.4 37.34618 17428.9
sleep 37.346180 && printMsg $START "Results/6.log" && sudo mnexec -a 6709 iperf -c 10.0.0.4 -t 1 > Results/6.log &
# 6709 10.0.0.4 33.2653 212.0065
sleep 33.265300 && printMsg $START "Results/7.log" && sudo mnexec -a 6709 iperf -c 10.0.0.4 -t 1 > Results/7.log &
# 6709 10.0.0.4 35.62314 14120.21
sleep 35.623140 && printMsg $START "Results/8.log" && sudo mnexec -a 6709 iperf -c 10.0.0.4 -t 1 > Results/8.log &
# 6709 10.0.0.4 34.12698 17841.39
sleep 34.126980 && printMsg $START "Results/9.log" && sudo mnexec -a 6709 iperf -c 10.0.0.4 -t 1 > Results/9.log &
# 6709 10.0.0.4 39.72161 80.30857
sleep 39.721610 && printMsg $START "Results/10.log" && sudo mnexec -a 6709 iperf -c 10.0.0.4 -t 1 > Results/10.log &
# 6709 10.0.0.4 30.95226 52943.14
sleep 30.952260 && printMsg $START "Results/11.log" && sudo mnexec -a 6709 iperf -c 10.0.0.4 -t 1 > Results/11.log &
# 6709 10.0.0.5 40.86223 422.6994
sleep 40.862230 && printMsg $START "Results/12.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/12.log &
# 6709 10.0.0.5 47.82816 33946.4
sleep 47.828160 && printMsg $START "Results/13.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/13.log &
# 6709 10.0.0.5 44.56789 3051.015
sleep 44.567890 && printMsg $START "Results/14.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/14.log &
# 6709 10.0.0.5 45.66189 17428.9
sleep 45.661890 && printMsg $START "Results/15.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/15.log &
# 6709 10.0.0.5 49.14493 26553.83
sleep 49.144930 && printMsg $START "Results/16.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/16.log &
# 6709 10.0.0.5 47.78493 8149.128
sleep 47.784930 && printMsg $START "Results/17.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/17.log &
# 6709 10.0.0.5 48.80229 914.6814
sleep 48.802290 && printMsg $START "Results/18.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/18.log &
# 6709 10.0.0.5 40.2238 442.9444
sleep 40.223800 && printMsg $START "Results/19.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/19.log &
# 6709 10.0.0.5 47.47241 448.1552
sleep 47.472410 && printMsg $START "Results/20.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/20.log &
# 6709 10.0.0.5 44.64363 212.0065
sleep 44.643630 && printMsg $START "Results/21.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/21.log &
# 6709 10.0.0.5 48.34923 319.2471
sleep 48.349230 && printMsg $START "Results/22.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/22.log &
# 6709 10.0.0.5 50.43042 37714.47
sleep 50.430420 && printMsg $START "Results/23.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/23.log &
# 6709 10.0.0.5 56.98147 515.6807
sleep 56.981470 && printMsg $START "Results/24.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/24.log &
# 6709 10.0.0.5 58.13373 176597.3
sleep 58.133730 && printMsg $START "Results/25.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/25.log &
# 6709 10.0.0.5 54.76235 1660.8
sleep 54.762350 && printMsg $START "Results/26.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/26.log &
# 6709 10.0.0.5 50.03431 182903.6
sleep 50.034310 && printMsg $START "Results/27.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/27.log &
# 6709 10.0.0.5 51.64855 10664.4
sleep 51.648550 && printMsg $START "Results/28.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/28.log &
# 6709 10.0.0.5 55.55902 3311.311
sleep 55.559020 && printMsg $START "Results/29.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/29.log &
# 6709 10.0.0.5 56.16507 3086.909
sleep 56.165070 && printMsg $START "Results/30.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/30.log &
# 6709 10.0.0.5 50.60275 14017370.0
sleep 50.602750 && printMsg $START "Results/31.log" && sudo mnexec -a 6709 iperf -c 10.0.0.5 -t 1 > Results/31.log &
# 6709 10.0.0.7 40.86598 8149.128
sleep 40.865980 && printMsg $START "Results/32.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/32.log &
# 6709 10.0.0.7 44.48123 7334.943
sleep 44.481230 && printMsg $START "Results/33.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/33.log &
# 6709 10.0.0.7 49.70538 1566.464
sleep 49.705380 && printMsg $START "Results/34.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/34.log &
# 6709 10.0.0.7 45.88918 527.8854
sleep 45.889180 && printMsg $START "Results/35.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/35.log &
# 6709 10.0.0.7 49.1736 363.078
sleep 49.173600 && printMsg $START "Results/36.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/36.log &
# 6709 10.0.0.7 48.17602 1443.328
sleep 48.176020 && printMsg $START "Results/37.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/37.log &
# 6709 10.0.0.7 44.78777 143072.4
sleep 44.787770 && printMsg $START "Results/38.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/38.log &
# 6709 10.0.0.7 48.88 169.7623
sleep 48.880000 && printMsg $START "Results/39.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/39.log &
# 6709 10.0.0.7 46.73939 6449.467
sleep 46.739390 && printMsg $START "Results/40.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/40.log &
# 6709 10.0.0.7 47.48696 1911.04
sleep 47.486960 && printMsg $START "Results/41.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/41.log &
# 6709 10.0.0.7 42.44327 2651.502
sleep 42.443270 && printMsg $START "Results/42.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/42.log &
# 6709 10.0.0.7 49.45182 11848.16
sleep 49.451820 && printMsg $START "Results/43.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/43.log &
# 6709 10.0.0.7 48.40374 308.24
sleep 48.403740 && printMsg $START "Results/44.log" && sudo mnexec -a 6709 iperf -c 10.0.0.7 -t 1 > Results/44.log &
# 6709 10.0.0.8 40.89364 173.7801
sleep 40.893640 && printMsg $START "Results/45.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/45.log &
# 6709 10.0.0.8 44.48916 246.8203
sleep 44.489160 && printMsg $START "Results/46.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/46.log &
# 6709 10.0.0.8 49.74219 197.6391
sleep 49.742190 && printMsg $START "Results/47.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/47.log &
# 6709 10.0.0.8 40.2151 170508.6
sleep 40.215100 && printMsg $START "Results/48.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/48.log &
# 6709 10.0.0.8 45.89558 475.144
sleep 45.895580 && printMsg $START "Results/49.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/49.log &
# 6709 10.0.0.8 49.17642 723.9066
sleep 49.176420 && printMsg $START "Results/50.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/50.log &
# 6709 10.0.0.8 46.20274 1299.125
sleep 46.202740 && printMsg $START "Results/51.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/51.log &
# 6709 10.0.0.8 44.79275 5164.352
sleep 44.792750 && printMsg $START "Results/52.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/52.log &
# 6709 10.0.0.8 41.80546 940444.9
sleep 41.805460 && printMsg $START "Results/53.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/53.log &
# 6709 10.0.0.8 49.14218 10296.71
sleep 49.142180 && printMsg $START "Results/54.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/54.log &
# 6709 10.0.0.8 40.64202 48214.16
sleep 40.642020 && printMsg $START "Results/55.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/55.log &
# 6709 10.0.0.8 46.74087 527.8854
sleep 46.740870 && printMsg $START "Results/56.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/56.log &
# 6709 10.0.0.8 47.5101 2251.028
sleep 47.510100 && printMsg $START "Results/57.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/57.log &
# 6709 10.0.0.8 42.45681 403.38
sleep 42.456810 && printMsg $START "Results/58.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/58.log &
# 6709 10.0.0.8 41.02608 1460.308
sleep 41.026080 && printMsg $START "Results/59.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/59.log &
# 6709 10.0.0.8 48.46661 1460.308
sleep 48.466610 && printMsg $START "Results/60.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/60.log &
# 6709 10.0.0.8 40.96623 3015.54
sleep 40.966230 && printMsg $START "Results/61.log" && sudo mnexec -a 6709 iperf -c 10.0.0.8 -t 1 > Results/61.log &
# 6709 10.0.0.11 46.03849 171.7595
sleep 46.038490 && printMsg $START "Results/62.log" && sudo mnexec -a 6709 iperf -c 10.0.0.11 -t 1 > Results/62.log &
# 6727 10.0.0.2 14.3218 100.2928
sleep 14.321800 && printMsg $START "Results/63.log" && sudo mnexec -a 6727 iperf -c 10.0.0.2 -t 1 > Results/63.log &
# 6727 10.0.0.6 42.9472 1115.884
sleep 42.947200 && printMsg $START "Results/64.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/64.log &
# 6727 10.0.0.6 45.70363 5604.946
sleep 45.703630 && printMsg $START "Results/65.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/65.log &
# 6727 10.0.0.6 40.73333 872.8755
sleep 40.733330 && printMsg $START "Results/66.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/66.log &
# 6727 10.0.0.6 40.52459 16632.31
sleep 40.524590 && printMsg $START "Results/67.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/67.log &
# 6727 10.0.0.6 46.38397 11710.4
sleep 46.383970 && printMsg $START "Results/68.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/68.log &
# 6727 10.0.0.6 49.54014 698.9474
sleep 49.540140 && printMsg $START "Results/69.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/69.log &
# 6727 10.0.0.6 49.72189 2002.568
sleep 49.721890 && printMsg $START "Results/70.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/70.log &
# 6727 10.0.0.6 48.1461 509.6847
sleep 48.146100 && printMsg $START "Results/71.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/71.log &
# 6727 10.0.0.6 45.74259 842.7801
sleep 45.742590 && printMsg $START "Results/72.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/72.log &
# 6727 10.0.0.6 43.94524 893.534
sleep 43.945240 && printMsg $START "Results/73.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/73.log &
# 6727 10.0.0.6 46.24606 23900.82
sleep 46.246060 && printMsg $START "Results/74.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/74.log &
# 6727 10.0.0.6 40.21722 8639.885
sleep 40.217220 && printMsg $START "Results/75.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/75.log &
# 6727 10.0.0.6 42.12965 255.6342
sleep 42.129650 && printMsg $START "Results/76.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/76.log &
# 6727 10.0.0.6 40.8008 160.1196
sleep 40.800800 && printMsg $START "Results/77.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/77.log &
# 6727 10.0.0.6 47.43674 301.1135
sleep 47.436740 && printMsg $START "Results/78.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/78.log &
# 6727 10.0.0.6 41.74114 1254.333
sleep 41.741140 && printMsg $START "Results/79.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/79.log &
# 6727 10.0.0.6 44.03827 232.8006
sleep 44.038270 && printMsg $START "Results/80.log" && sudo mnexec -a 6727 iperf -c 10.0.0.6 -t 1 > Results/80.log &
# 6727 10.0.0.10 0.1795861 2714.256
sleep 0.179586 && printMsg $START "Results/81.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/81.log &
# 6727 10.0.0.10 7.451029 48781.36
sleep 7.451029 && printMsg $START "Results/82.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/82.log &
# 6727 10.0.0.10 2.893143 14454.39
sleep 2.893143 && printMsg $START "Results/83.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/83.log &
# 6727 10.0.0.10 2.444268 3636.092
sleep 2.444268 && printMsg $START "Results/84.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/84.log &
# 6727 10.0.0.10 1.673467 58135.89
sleep 1.673467 && printMsg $START "Results/85.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/85.log &
# 6727 10.0.0.10 0.8635343 6227.099
sleep 0.863534 && printMsg $START "Results/86.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/86.log &
# 6727 10.0.0.10 9.868326 10058.65
sleep 9.868326 && printMsg $START "Results/87.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/87.log &
# 6727 10.0.0.10 2.121513 3552.025
sleep 2.121513 && printMsg $START "Results/88.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/88.log &
# 6727 10.0.0.10 0.01354512 1225.333
sleep 0.013545 && printMsg $START "Results/89.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/89.log &
# 6727 10.0.0.10 4.693639 1169.328
sleep 4.693639 && printMsg $START "Results/90.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/90.log &
# 6727 10.0.0.10 43.28382 6012.398
sleep 43.283820 && printMsg $START "Results/91.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/91.log &
# 6727 10.0.0.10 46.49654 1866.857
sleep 46.496540 && printMsg $START "Results/92.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/92.log &
# 6727 10.0.0.10 47.24891 1622.403
sleep 47.248910 && printMsg $START "Results/93.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/93.log &
# 6727 10.0.0.10 40.70806 12128.56
sleep 40.708060 && printMsg $START "Results/94.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/94.log &
# 6727 10.0.0.10 46.39751 1115.884
sleep 46.397510 && printMsg $START "Results/95.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/95.log &
# 6727 10.0.0.10 49.76744 8440.131
sleep 49.767440 && printMsg $START "Results/96.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/96.log &
# 6727 10.0.0.10 49.07379 503.7582
sleep 49.073790 && printMsg $START "Results/97.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/97.log &
# 6727 10.0.0.10 45.85794 9267.958
sleep 45.857940 && printMsg $START "Results/98.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/98.log &
# 6727 10.0.0.10 43.95928 644.0045
sleep 43.959280 && printMsg $START "Results/99.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/99.log &
# 6727 10.0.0.10 46.28287 1090.085
sleep 46.282870 && printMsg $START "Results/100.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/100.log &
# 6727 10.0.0.10 45.50421 177.893
sleep 45.504210 && printMsg $START "Results/101.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/101.log &
# 6727 10.0.0.10 42.93611 156.4176
sleep 42.936110 && printMsg $START "Results/102.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/102.log &
# 6727 10.0.0.10 40.8973 1377.36
sleep 40.897300 && printMsg $START "Results/103.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/103.log &
# 6727 10.0.0.10 47.47919 380.4674
sleep 47.479190 && printMsg $START "Results/104.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/104.log &
# 6727 10.0.0.10 41.8163 10664.4
sleep 41.816300 && printMsg $START "Results/105.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/105.log &
# 6727 10.0.0.10 43.00057 6154.691
sleep 43.000570 && printMsg $START "Results/106.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/106.log &
# 6727 10.0.0.10 40.15613 166566.3
sleep 40.156130 && printMsg $START "Results/107.log" && sudo mnexec -a 6727 iperf -c 10.0.0.10 -t 1 > Results/107.log &
# 6727 10.0.0.11 10.86658 147.5329
sleep 10.866580 && printMsg $START "Results/108.log" && sudo mnexec -a 6727 iperf -c 10.0.0.11 -t 1 > Results/108.log &
# 6738 10.0.0.1 2.673651 3159.966
sleep 2.673651 && printMsg $START "Results/109.log" && sudo mnexec -a 6738 iperf -c 10.0.0.1 -t 1 > Results/109.log &
# 6738 10.0.0.1 7.980007 290.7315
sleep 7.980007 && printMsg $START "Results/110.log" && sudo mnexec -a 6738 iperf -c 10.0.0.1 -t 1 > Results/110.log &
# 6738 10.0.0.1 6.01267 2746.188
sleep 6.012670 && printMsg $START "Results/111.log" && sudo mnexec -a 6738 iperf -c 10.0.0.1 -t 1 > Results/111.log &
# 6738 10.0.0.1 2.779947 2811.181
sleep 2.779947 && printMsg $START "Results/112.log" && sudo mnexec -a 6738 iperf -c 10.0.0.1 -t 1 > Results/112.log &
# 6738 10.0.0.1 3.437727 212.0065
sleep 3.437727 && printMsg $START "Results/113.log" && sudo mnexec -a 6738 iperf -c 10.0.0.1 -t 1 > Results/113.log &
# 6738 10.0.0.1 1.200051 1211.085
sleep 1.200051 && printMsg $START "Results/114.log" && sudo mnexec -a 6738 iperf -c 10.0.0.1 -t 1 > Results/114.log &
# 6738 10.0.0.1 0.01729178 261.6844
sleep 0.017292 && printMsg $START "Results/115.log" && sudo mnexec -a 6738 iperf -c 10.0.0.1 -t 1 > Results/115.log &
# 6738 10.0.0.1 3.592039 217.0241
sleep 3.592039 && printMsg $START "Results/116.log" && sudo mnexec -a 6738 iperf -c 10.0.0.1 -t 1 > Results/116.log &
# 6738 10.0.0.1 0.0819164 16058.84
sleep 0.081916 && printMsg $START "Results/117.log" && sudo mnexec -a 6738 iperf -c 10.0.0.1 -t 1 > Results/117.log &
# 6738 10.0.0.2 2.748808 188.606
sleep 2.748808 && printMsg $START "Results/118.log" && sudo mnexec -a 6738 iperf -c 10.0.0.2 -t 1 > Results/118.log &
# 6738 10.0.0.2 8.008673 1345.516
sleep 8.008673 && printMsg $START "Results/119.log" && sudo mnexec -a 6738 iperf -c 10.0.0.2 -t 1 > Results/119.log &
# 6738 10.0.0.2 6.92729 1823.696
sleep 6.927290 && printMsg $START "Results/120.log" && sudo mnexec -a 6738 iperf -c 10.0.0.2 -t 1 > Results/120.log &
# 6738 10.0.0.2 5.012682 16632.31
sleep 5.012682 && printMsg $START "Results/121.log" && sudo mnexec -a 6738 iperf -c 10.0.0.2 -t 1 > Results/121.log &
# 6738 10.0.0.2 3.465387 1641.489
sleep 3.465387 && printMsg $START "Results/122.log" && sudo mnexec -a 6738 iperf -c 10.0.0.2 -t 1 > Results/122.log &
# 6738 10.0.0.2 5.711125 255.6342
sleep 5.711125 && printMsg $START "Results/123.log" && sudo mnexec -a 6738 iperf -c 10.0.0.2 -t 1 > Results/123.log &
# 6738 10.0.0.2 5.633814 1426.546
sleep 5.633814 && printMsg $START "Results/124.log" && sudo mnexec -a 6738 iperf -c 10.0.0.2 -t 1 > Results/124.log &
# 6738 10.0.0.2 0.1655692 1443.328
sleep 0.165569 && printMsg $START "Results/125.log" && sudo mnexec -a 6738 iperf -c 10.0.0.2 -t 1 > Results/125.log &
# 6738 10.0.0.2 47.29137 209.5414
sleep 47.291370 && printMsg $START "Results/126.log" && sudo mnexec -a 6738 iperf -c 10.0.0.2 -t 1 > Results/126.log &
# 6738 10.0.0.3 2.811679 145.8175
sleep 2.811679 && printMsg $START "Results/127.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/127.log &
# 6738 10.0.0.3 4.399576 1584.893
sleep 4.399576 && printMsg $START "Results/128.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/128.log &
# 6738 10.0.0.3 7.841909 80.30857
sleep 7.841909 && printMsg $START "Results/129.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/129.log &
# 6738 10.0.0.3 5.274865 3593.814
sleep 5.274865 && printMsg $START "Results/130.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/130.log &
# 6738 10.0.0.3 7.943861 2277.51
sleep 7.943861 && printMsg $START "Results/131.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/131.log &
# 6738 10.0.0.3 5.688319 301.1135
sleep 5.688319 && printMsg $START "Results/132.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/132.log &
# 6738 10.0.0.3 3.845939 80.30857
sleep 3.845939 && printMsg $START "Results/133.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/133.log &
# 6738 10.0.0.3 43.51117 10417.85
sleep 43.511170 && printMsg $START "Results/134.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/134.log &
# 6738 10.0.0.3 46.51968 290.7315
sleep 46.519680 && printMsg $START "Results/135.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/135.log &
# 6738 10.0.0.3 47.4562 593.3806
sleep 47.456200 && printMsg $START "Results/136.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/136.log &
# 6738 10.0.0.3 40.78421 3350.266
sleep 40.784210 && printMsg $START "Results/137.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/137.log &
# 6738 10.0.0.3 46.5259 1077.41
sleep 46.525900 && printMsg $START "Results/138.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/138.log &
# 6738 10.0.0.3 40.39922 2778.494
sleep 40.399220 && printMsg $START "Results/139.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/139.log &
# 6738 10.0.0.3 49.72687 343960.1
sleep 49.726870 && printMsg $START "Results/140.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/140.log &
# 6738 10.0.0.3 48.67186 20290.91
sleep 48.671860 && printMsg $START "Results/141.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/141.log &
# 6738 10.0.0.3 48.43339 241.1139
sleep 48.433390 && printMsg $START "Results/142.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/142.log &
# 6738 10.0.0.3 44.01576 1028.167
sleep 44.015760 && printMsg $START "Results/143.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/143.log &
# 6738 10.0.0.3 46.31153 246.8203
sleep 46.311530 && printMsg $START "Results/144.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/144.log &
# 6738 10.0.0.3 48.58294 261.6844
sleep 48.582940 && printMsg $START "Results/145.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/145.log &
# 6738 10.0.0.3 43.0326 464.159
sleep 43.032600 && printMsg $START "Results/146.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/146.log &
# 6738 10.0.0.3 41.37455 8576960.0
sleep 41.374550 && printMsg $START "Results/147.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/147.log &
# 6738 10.0.0.3 41.15948 149.2686
sleep 41.159480 && printMsg $START "Results/148.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/148.log &
# 6738 10.0.0.3 47.52319 2331.412
sleep 47.523190 && printMsg $START "Results/149.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/149.log &
# 6738 10.0.0.3 41.8222 12128.56
sleep 41.822200 && printMsg $START "Results/150.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/150.log &
# 6738 10.0.0.3 43.01511 629.1151
sleep 43.015110 && printMsg $START "Results/151.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/151.log &
# 6738 10.0.0.3 41.08478 5805.096
sleep 41.084780 && printMsg $START "Results/152.log" && sudo mnexec -a 6738 iperf -c 10.0.0.3 -t 1 > Results/152.log &
# 6738 10.0.0.6 3.604591 209.5414
sleep 3.604591 && printMsg $START "Results/153.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/153.log &
# 6738 10.0.0.6 8.493739 153472.9
sleep 8.493739 && printMsg $START "Results/154.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/154.log &
# 6738 10.0.0.6 8.046119 173.7801
sleep 8.046119 && printMsg $START "Results/155.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/155.log &
# 6738 10.0.0.6 5.303531 1028.167
sleep 5.303531 && printMsg $START "Results/156.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/156.log &
# 6738 10.0.0.6 8.63126 515.6807
sleep 8.631260 && printMsg $START "Results/157.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/157.log &
# 6738 10.0.0.6 5.77347 21262.73
sleep 5.773470 && printMsg $START "Results/158.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/158.log &
# 6738 10.0.0.6 5.527666 139764.4
sleep 5.527666 && printMsg $START "Results/159.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/159.log &
# 6738 10.0.0.6 2.232735 540.379
sleep 2.232735 && printMsg $START "Results/160.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/160.log &
# 6738 10.0.0.6 4.7063 176597.3
sleep 4.706300 && printMsg $START "Results/161.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/161.log &
# 6738 10.0.0.6 16.88801 148181.3
sleep 16.888010 && printMsg $START "Results/162.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/162.log &
# 6738 10.0.0.6 19.60832 343960.1
sleep 19.608320 && printMsg $START "Results/163.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/163.log &
# 6738 10.0.0.6 13.59992 258.6417
sleep 13.599920 && printMsg $START "Results/164.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/164.log &
# 6738 10.0.0.6 16.99645 503.7582
sleep 16.996450 && printMsg $START "Results/165.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/165.log &
# 6738 10.0.0.6 13.21709 207.105
sleep 13.217090 && printMsg $START "Results/166.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/166.log &
# 6738 10.0.0.6 14.00205 199.9643
sleep 14.002050 && printMsg $START "Results/167.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/167.log &
# 6738 10.0.0.6 19.30685 1956.269
sleep 19.306850 && printMsg $START "Results/168.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/168.log &
# 6738 10.0.0.6 15.37799 4594.33
sleep 15.377990 && printMsg $START "Results/169.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/169.log &
# 6738 10.0.0.6 19.61771 308.24
sleep 19.617710 && printMsg $START "Results/170.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/170.log &
# 6738 10.0.0.6 16.92343 15505.17
sleep 16.923430 && printMsg $START "Results/171.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/171.log &
# 6738 10.0.0.6 13.40199 3855.065
sleep 13.401990 && printMsg $START "Results/172.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/172.log &
# 6738 10.0.0.6 17.92071 1660.8
sleep 17.920710 && printMsg $START "Results/173.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/173.log &
# 6738 10.0.0.6 19.39503 243.9505
sleep 19.395030 && printMsg $START "Results/174.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/174.log &
# 6738 10.0.0.6 14.33366 1460.308
sleep 14.333660 && printMsg $START "Results/175.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/175.log &
# 6738 10.0.0.6 17.14125 1460.308
sleep 17.141250 && printMsg $START "Results/176.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/176.log &
# 6738 10.0.0.6 15.21048 442.9444
sleep 15.210480 && printMsg $START "Results/177.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/177.log &
# 6738 10.0.0.6 18.25519 173.7801
sleep 18.255190 && printMsg $START "Results/178.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/178.log &
# 6738 10.0.0.6 18.99184 3159.966
sleep 18.991840 && printMsg $START "Results/179.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/179.log &
# 6738 10.0.0.6 12.86034 186.413
sleep 12.860340 && printMsg $START "Results/180.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/180.log &
# 6738 10.0.0.6 17.68316 176597.3
sleep 17.683160 && printMsg $START "Results/181.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/181.log &
# 6738 10.0.0.6 13.26176 677814.7
sleep 13.261760 && printMsg $START "Results/182.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/182.log &
# 6738 10.0.0.6 16.81115 188.606
sleep 16.811150 && printMsg $START "Results/183.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/183.log &
# 6738 10.0.0.6 12.81925 212.0065
sleep 12.819250 && printMsg $START "Results/184.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/184.log &
# 6738 10.0.0.6 15.17893 90669.33
sleep 15.178930 && printMsg $START "Results/185.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/185.log &
# 6738 10.0.0.6 10.49129 448.1552
sleep 10.491290 && printMsg $START "Results/186.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/186.log &
# 6738 10.0.0.6 16.39564 1802.49
sleep 16.395640 && printMsg $START "Results/187.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/187.log &
# 6738 10.0.0.6 16.07513 40456.11
sleep 16.075130 && printMsg $START "Results/188.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/188.log &
# 6738 10.0.0.6 13.58532 51117.72
sleep 13.585320 && printMsg $START "Results/189.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/189.log &
# 6738 10.0.0.6 17.89895 6449.467
sleep 17.898950 && printMsg $START "Results/190.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/190.log &
# 6738 10.0.0.6 14.13234 1314.408
sleep 14.132340 && printMsg $START "Results/191.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/191.log &
# 6738 10.0.0.6 16.72221 207.105
sleep 16.722210 && printMsg $START "Results/192.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/192.log &
# 6738 10.0.0.6 17.03134 3946.303
sleep 17.031340 && printMsg $START "Results/193.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/193.log &
# 6738 10.0.0.6 15.39021 6227.099
sleep 15.390210 && printMsg $START "Results/194.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/194.log &
# 6738 10.0.0.6 10.4076 103117.7
sleep 10.407600 && printMsg $START "Results/195.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/195.log &
# 6738 10.0.0.6 13.1252 2471.814
sleep 13.125200 && printMsg $START "Results/196.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/196.log &
# 6738 10.0.0.6 14.45508 103117.7
sleep 14.455080 && printMsg $START "Results/197.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/197.log &
# 6738 10.0.0.6 14.50044 17226.23
sleep 14.500440 && printMsg $START "Results/198.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/198.log &
# 6738 10.0.0.6 19.48943 4135.309
sleep 19.489430 && printMsg $START "Results/199.log" && sudo mnexec -a 6738 iperf -c 10.0.0.6 -t 1 > Results/199.log &
# 6738 10.0.0.7 43.57869 723.9066
sleep 43.578690 && printMsg $START "Results/200.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/200.log &
# 6738 10.0.0.7 46.57617 7334.943
sleep 46.576170 && printMsg $START "Results/201.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/201.log &
# 6738 10.0.0.7 47.63968 30554.79
sleep 47.639680 && printMsg $START "Results/202.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/202.log &
# 6738 10.0.0.7 41.48023 492.1116
sleep 41.480230 && printMsg $START "Results/203.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/203.log &
# 6738 10.0.0.7 46.53994 1077.41
sleep 46.539940 && printMsg $START "Results/204.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/204.log &
# 6738 10.0.0.7 40.46674 1254.333
sleep 40.466740 && printMsg $START "Results/205.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/205.log &
# 6738 10.0.0.7 49.91034 190.8248
sleep 49.910340 && printMsg $START "Results/206.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/206.log &
# 6738 10.0.0.7 48.70745 252.6619
sleep 48.707450 && printMsg $START "Results/207.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/207.log &
# 6738 10.0.0.7 49.2263 207.105
sleep 49.226300 && printMsg $START "Results/208.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/208.log &
# 6738 10.0.0.7 44.35238 235.5393
sleep 44.352380 && printMsg $START "Results/209.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/209.log &
# 6738 10.0.0.7 46.36604 367.3495
sleep 46.366040 && printMsg $START "Results/210.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/210.log &
# 6738 10.0.0.7 48.69829 171.7595
sleep 48.698290 && printMsg $START "Results/211.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/211.log &
# 6738 10.0.0.7 44.43635 723.9066
sleep 44.436350 && printMsg $START "Results/212.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/212.log &
# 6738 10.0.0.7 42.99376 147.5329
sleep 42.993760 && printMsg $START "Results/213.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/213.log &
# 6738 10.0.0.7 41.26311 144.122
sleep 41.263110 && printMsg $START "Results/214.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/214.log &
# 6738 10.0.0.7 47.53722 61636.95
sleep 47.537220 && printMsg $START "Results/215.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/215.log &
# 6738 10.0.0.7 40.56197 8576960.0
sleep 40.561970 && printMsg $START "Results/216.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/216.log &
# 6738 10.0.0.7 42.00567 723.9066
sleep 42.005670 && printMsg $START "Results/217.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/217.log &
# 6738 10.0.0.7 49.5307 1477.487
sleep 49.530700 && printMsg $START "Results/218.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/218.log &
# 6738 10.0.0.7 41.08977 204.6969
sleep 41.089770 && printMsg $START "Results/219.log" && sudo mnexec -a 6738 iperf -c 10.0.0.7 -t 1 > Results/219.log &
# 6738 10.0.0.8 4.413614 940444.9
sleep 4.413614 && printMsg $START "Results/220.log" && sudo mnexec -a 6738 iperf -c 10.0.0.8 -t 1 > Results/220.log &
# 6738 10.0.0.8 8.534703 277.4435
sleep 8.534703 && printMsg $START "Results/221.log" && sudo mnexec -a 6738 iperf -c 10.0.0.8 -t 1 > Results/221.log &
# 6738 10.0.0.8 8.060667 3552.025
sleep 8.060667 && printMsg $START "Results/222.log" && sudo mnexec -a 6738 iperf -c 10.0.0.8 -t 1 > Results/222.log &
# 6738 10.0.0.8 5.387184 186.413
sleep 5.387184 && printMsg $START "Results/223.log" && sudo mnexec -a 6738 iperf -c 10.0.0.8 -t 1 > Results/223.log &
# 6738 10.0.0.8 8.636245 6154.691
sleep 8.636245 && printMsg $START "Results/224.log" && sudo mnexec -a 6738 iperf -c 10.0.0.8 -t 1 > Results/224.log &
# 6738 10.0.0.8 6.688089 208015.3
sleep 6.688089 && printMsg $START "Results/225.log" && sudo mnexec -a 6738 iperf -c 10.0.0.8 -t 1 > Results/225.log &
# 6738 10.0.0.8 5.643015 2173.416
sleep 5.643015 && printMsg $START "Results/226.log" && sudo mnexec -a 6738 iperf -c 10.0.0.8 -t 1 > Results/226.log &
# 6738 10.0.0.8 2.46003 4871.009
sleep 2.460030 && printMsg $START "Results/227.log" && sudo mnexec -a 6738 iperf -c 10.0.0.8 -t 1 > Results/227.log &
# 6738 10.0.0.8 4.720848 1393.564
sleep 4.720848 && printMsg $START "Results/228.log" && sudo mnexec -a 6738 iperf -c 10.0.0.8 -t 1 > Results/228.log &
# 6738 10.0.0.9 37.05636 21765.95
sleep 37.056360 && printMsg $START "Results/229.log" && sudo mnexec -a 6738 iperf -c 10.0.0.9 -t 1 > Results/229.log &
# 6738 10.0.0.9 37.15367 54196.13
sleep 37.153670 && printMsg $START "Results/230.log" && sudo mnexec -a 6738 iperf -c 10.0.0.9 -t 1 > Results/230.log &
# 6738 10.0.0.9 30.00862 6679.776
sleep 30.008620 && printMsg $START "Results/231.log" && sudo mnexec -a 6738 iperf -c 10.0.0.9 -t 1 > Results/231.log &
# 6738 10.0.0.9 33.34046 76079.9
sleep 33.340460 && printMsg $START "Results/232.log" && sudo mnexec -a 6738 iperf -c 10.0.0.9 -t 1 > Results/232.log &
# 6738 10.0.0.9 37.63307 5737.599
sleep 37.633070 && printMsg $START "Results/233.log" && sudo mnexec -a 6738 iperf -c 10.0.0.9 -t 1 > Results/233.log &
# 6738 10.0.0.9 36.3498 2414.666
sleep 36.349800 && printMsg $START "Results/234.log" && sudo mnexec -a 6738 iperf -c 10.0.0.9 -t 1 > Results/234.log &
# 6738 10.0.0.9 37.82966 287.351
sleep 37.829660 && printMsg $START "Results/235.log" && sudo mnexec -a 6738 iperf -c 10.0.0.9 -t 1 > Results/235.log &
# 6738 10.0.0.9 31.10296 14454.39
sleep 31.102960 && printMsg $START "Results/236.log" && sudo mnexec -a 6738 iperf -c 10.0.0.9 -t 1 > Results/236.log &
# 6738 10.0.0.10 40.41885 10058.65
sleep 40.418850 && printMsg $START "Results/237.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/237.log &
# 6738 10.0.0.10 46.57717 1102.909
sleep 46.577170 && printMsg $START "Results/238.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/238.log &
# 6738 10.0.0.10 47.75099 16247.76
sleep 47.750990 && printMsg $START "Results/239.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/239.log &
# 6738 10.0.0.10 41.48663 249.724
sleep 41.486630 && printMsg $START "Results/240.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/240.log &
# 6738 10.0.0.10 46.5676 2500.893
sleep 46.567600 && printMsg $START "Results/241.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/241.log &
# 6738 10.0.0.10 40.72892 2980.476
sleep 40.728920 && printMsg $START "Results/242.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/242.log &
# 6738 10.0.0.10 41.73927 1345.516
sleep 41.739270 && printMsg $START "Results/243.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/243.log &
# 6738 10.0.0.10 48.73511 509.6847
sleep 48.735110 && printMsg $START "Results/244.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/244.log &
# 6738 10.0.0.10 49.24944 469.6194
sleep 49.249440 && printMsg $START "Results/245.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/245.log &
# 6738 10.0.0.10 44.35269 3389.68
sleep 44.352690 && printMsg $START "Results/246.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/246.log &
# 6738 10.0.0.10 46.49443 1911.04
sleep 46.494430 && printMsg $START "Results/247.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/247.log &
# 6738 10.0.0.10 48.70469 667.0017
sleep 48.704690 && printMsg $START "Results/248.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/248.log &
# 6738 10.0.0.10 44.69853 1115.884
sleep 44.698530 && printMsg $START "Results/249.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/249.log &
# 6738 10.0.0.10 43.06891 3678.869
sleep 43.068910 && printMsg $START "Results/250.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/250.log &
# 6738 10.0.0.10 42.48006 7596.876
sleep 42.480060 && printMsg $START "Results/251.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/251.log &
# 6738 10.0.0.10 43.37714 3350.266
sleep 43.377140 && printMsg $START "Results/252.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/252.log &
# 6738 10.0.0.10 41.35496 175.8245
sleep 41.354960 && printMsg $START "Results/253.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/253.log &
# 6738 10.0.0.10 42.34228 1584.893
sleep 42.342280 && printMsg $START "Results/254.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/254.log &
# 6738 10.0.0.10 49.73491 274.2176
sleep 49.734910 && printMsg $START "Results/255.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/255.log &
# 6738 10.0.0.10 42.49351 1239.748
sleep 42.493510 && printMsg $START "Results/256.log" && sudo mnexec -a 6738 iperf -c 10.0.0.10 -t 1 > Results/256.log &
# 6738 10.0.0.12 4.488771 131.2487
sleep 4.488771 && printMsg $START "Results/257.log" && sudo mnexec -a 6738 iperf -c 10.0.0.12 -t 1 > Results/257.log &
# 6738 10.0.0.12 9.327614 26553.83
sleep 9.327614 && printMsg $START "Results/258.log" && sudo mnexec -a 6738 iperf -c 10.0.0.12 -t 1 > Results/258.log &
# 6738 10.0.0.12 8.074212 1169.328
sleep 8.074212 && printMsg $START "Results/259.log" && sudo mnexec -a 6738 iperf -c 10.0.0.12 -t 1 > Results/259.log &
# 6738 10.0.0.12 0.5353143 255.6342
sleep 0.535314 && printMsg $START "Results/260.log" && sudo mnexec -a 6738 iperf -c 10.0.0.12 -t 1 > Results/260.log &
# 6738 10.0.0.12 8.898428 219.5772
sleep 8.898428 && printMsg $START "Results/261.log" && sudo mnexec -a 6738 iperf -c 10.0.0.12 -t 1 > Results/261.log &
# 6738 10.0.0.12 6.689089 1530.249
sleep 6.689089 && printMsg $START "Results/262.log" && sudo mnexec -a 6738 iperf -c 10.0.0.12 -t 1 > Results/262.log &
# 6738 10.0.0.12 0.388282 842.7801
sleep 0.388282 && printMsg $START "Results/263.log" && sudo mnexec -a 6738 iperf -c 10.0.0.12 -t 1 > Results/263.log &
# 6738 10.0.0.12 2.462146 1603.538
sleep 2.462146 && printMsg $START "Results/264.log" && sudo mnexec -a 6738 iperf -c 10.0.0.12 -t 1 > Results/264.log &
# 6738 10.0.0.12 4.849236 184.2455
sleep 4.849236 && printMsg $START "Results/265.log" && sudo mnexec -a 6738 iperf -c 10.0.0.12 -t 1 > Results/265.log &
# 6748 10.0.0.1 57.14012 21262.73
sleep 57.140120 && printMsg $START "Results/266.log" && sudo mnexec -a 6748 iperf -c 10.0.0.1 -t 1 > Results/266.log &
# 6748 10.0.0.1 59.03448 417.7845
sleep 59.034480 && printMsg $START "Results/267.log" && sudo mnexec -a 6748 iperf -c 10.0.0.1 -t 1 > Results/267.log &
# 6748 10.0.0.1 59.85114 1115.884
sleep 59.851140 && printMsg $START "Results/268.log" && sudo mnexec -a 6748 iperf -c 10.0.0.1 -t 1 > Results/268.log &
# 6748 10.0.0.1 54.87335 3051.015
sleep 54.873350 && printMsg $START "Results/269.log" && sudo mnexec -a 6748 iperf -c 10.0.0.1 -t 1 > Results/269.log &
# 6748 10.0.0.1 57.87377 1299.125
sleep 57.873770 && printMsg $START "Results/270.log" && sudo mnexec -a 6748 iperf -c 10.0.0.1 -t 1 > Results/270.log &
# 6748 10.0.0.1 52.65444 343960.1
sleep 52.654440 && printMsg $START "Results/271.log" && sudo mnexec -a 6748 iperf -c 10.0.0.1 -t 1 > Results/271.log &
# 6748 10.0.0.1 51.07258 1211.085
sleep 51.072580 && printMsg $START "Results/272.log" && sudo mnexec -a 6748 iperf -c 10.0.0.1 -t 1 > Results/272.log &
# 6748 10.0.0.1 57.51431 12271.26
sleep 57.514310 && printMsg $START "Results/273.log" && sudo mnexec -a 6748 iperf -c 10.0.0.1 -t 1 > Results/273.log &
# 6748 10.0.0.1 55.07426 40456.11
sleep 55.074260 && printMsg $START "Results/274.log" && sudo mnexec -a 6748 iperf -c 10.0.0.1 -t 1 > Results/274.log &
# 6748 10.0.0.1 56.01249 8576960.0
sleep 56.012490 && printMsg $START "Results/275.log" && sudo mnexec -a 6748 iperf -c 10.0.0.1 -t 1 > Results/275.log &
# 6748 10.0.0.2 57.1535 7082.045
sleep 57.153500 && printMsg $START "Results/276.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/276.log &
# 6748 10.0.0.2 59.03823 1603.538
sleep 59.038230 && printMsg $START "Results/277.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/277.log &
# 6748 10.0.0.2 52.77035 2098.479
sleep 52.770350 && printMsg $START "Results/278.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/278.log &
# 6748 10.0.0.2 55.10064 2651.502
sleep 55.100640 && printMsg $START "Results/279.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/279.log &
# 6748 10.0.0.2 57.8817 1512.455
sleep 57.881700 && printMsg $START "Results/280.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/280.log &
# 6748 10.0.0.2 52.66798 2414.666
sleep 52.667980 && printMsg $START "Results/281.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/281.log &
# 6748 10.0.0.2 51.08613 3765.936
sleep 51.086130 && printMsg $START "Results/282.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/282.log &
# 6748 10.0.0.2 54.41999 8576960.0
sleep 54.419990 && printMsg $START "Results/283.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/283.log &
# 6748 10.0.0.2 59.13352 134945.7
sleep 59.133520 && printMsg $START "Results/284.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/284.log &
# 6748 10.0.0.2 55.23909 1866.857
sleep 55.239090 && printMsg $START "Results/285.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/285.log &
# 6748 10.0.0.2 56.12784 1477.487
sleep 56.127840 && printMsg $START "Results/286.log" && sudo mnexec -a 6748 iperf -c 10.0.0.2 -t 1 > Results/286.log &
# 6748 10.0.0.3 57.16804 44946.77
sleep 57.168040 && printMsg $START "Results/287.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/287.log &
# 6748 10.0.0.3 59.95285 232.8006
sleep 59.952850 && printMsg $START "Results/288.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/288.log &
# 6748 10.0.0.3 52.82486 4233.18
sleep 52.824860 && printMsg $START "Results/289.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/289.log &
# 6748 10.0.0.3 55.59915 1740.343
sleep 55.599150 && printMsg $START "Results/290.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/290.log &
# 6748 10.0.0.3 59.50302 9711.842
sleep 59.503020 && printMsg $START "Results/291.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/291.log &
# 6748 10.0.0.3 59.18357 7596.876
sleep 59.183570 && printMsg $START "Results/292.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/292.log &
# 6748 10.0.0.3 51.29034 469.6194
sleep 51.290340 && printMsg $START "Results/293.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/293.log &
# 6748 10.0.0.3 54.9185 169.7623
sleep 54.918500 && printMsg $START "Results/294.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/294.log &
# 6748 10.0.0.3 59.63203 1142.294
sleep 59.632030 && printMsg $START "Results/295.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/295.log &
# 6748 10.0.0.3 55.57571 274.2176
sleep 55.575710 && printMsg $START "Results/296.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/296.log &
# 6748 10.0.0.3 59.20657 10664.4
sleep 59.206570 && printMsg $START "Results/297.log" && sudo mnexec -a 6748 iperf -c 10.0.0.3 -t 1 > Results/297.log &
# 6748 10.0.0.4 57.35151 3272.809
sleep 57.351510 && printMsg $START "Results/298.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/298.log &
# 6748 10.0.0.4 59.96688 566.2598
sleep 59.966880 && printMsg $START "Results/299.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/299.log &
# 6748 10.0.0.4 52.86582 852.6951
sleep 52.865820 && printMsg $START "Results/300.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/300.log &
# 6748 10.0.0.4 51.81491 80.30857
sleep 51.814910 && printMsg $START "Results/301.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/301.log &
# 6748 10.0.0.4 59.51656 1660.8
sleep 59.516560 && printMsg $START "Results/302.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/302.log &
# 6748 10.0.0.4 59.24644 629.1151
sleep 59.246440 && printMsg $START "Results/303.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/303.log &
# 6748 10.0.0.4 51.31078 1566.464
sleep 51.310780 && printMsg $START "Results/304.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/304.log &
# 6748 10.0.0.4 54.97301 9053.687
sleep 54.973010 && printMsg $START "Results/305.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/305.log &
# 6748 10.0.0.4 59.85933 389.472
sleep 59.859330 && printMsg $START "Results/306.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/306.log &
# 6748 10.0.0.4 58.15116 981.1738
sleep 58.151160 && printMsg $START "Results/307.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/307.log &
# 6748 10.0.0.4 59.23524 682.7878
sleep 59.235240 && printMsg $START "Results/308.log" && sudo mnexec -a 6748 iperf -c 10.0.0.4 -t 1 > Results/308.log &
# 6748 10.0.0.5 41.18757 9941.693
sleep 41.187570 && printMsg $START "Results/309.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/309.log &
# 6748 10.0.0.5 42.06435 2778.494
sleep 42.064350 && printMsg $START "Results/310.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/310.log &
# 6748 10.0.0.5 40.90508 1142.294
sleep 40.905080 && printMsg $START "Results/311.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/311.log &
# 6748 10.0.0.5 49.50554 3234.754
sleep 49.505540 && printMsg $START "Results/312.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/312.log &
# 6748 10.0.0.5 43.77249 1225.333
sleep 43.772490 && printMsg $START "Results/313.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/313.log &
# 6748 10.0.0.5 40.05571 1142.294
sleep 40.055710 && printMsg $START "Results/314.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/314.log &
# 6748 10.0.0.5 47.12365 182.1032
sleep 47.123650 && printMsg $START "Results/315.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/315.log &
# 6748 10.0.0.5 44.49583 1409.959
sleep 44.495830 && printMsg $START "Results/316.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/316.log &
# 6748 10.0.0.5 41.65317 1115.884
sleep 41.653170 && printMsg $START "Results/317.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/317.log &
# 6748 10.0.0.5 45.63148 469.6194
sleep 45.631480 && printMsg $START "Results/318.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/318.log &
# 6748 10.0.0.5 47.61379 1169.328
sleep 47.613790 && printMsg $START "Results/319.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/319.log &
# 6748 10.0.0.5 42.14523 1426.546
sleep 42.145230 && printMsg $START "Results/320.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/320.log &
# 6748 10.0.0.5 43.7163 3510.725
sleep 43.716300 && printMsg $START "Results/321.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/321.log &
# 6748 10.0.0.5 47.15263 22281.1
sleep 47.152630 && printMsg $START "Results/322.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/322.log &
# 6748 10.0.0.5 40.25495 2778.494
sleep 40.254950 && printMsg $START "Results/323.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/323.log &
# 6748 10.0.0.5 45.00779 165.8374
sleep 45.007790 && printMsg $START "Results/324.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/324.log &
# 6748 10.0.0.5 46.26892 8576960.0
sleep 46.268920 && printMsg $START "Results/325.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/325.log &
# 6748 10.0.0.5 57.35526 1566.464
sleep 57.355260 && printMsg $START "Results/326.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/326.log &
# 6748 10.0.0.5 50.52553 80.30857
sleep 50.525530 && printMsg $START "Results/327.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/327.log &
# 6748 10.0.0.5 56.93448 2471.814
sleep 56.934480 && printMsg $START "Results/328.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/328.log &
# 6748 10.0.0.5 51.81551 280.7074
sleep 51.815510 && printMsg $START "Results/329.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/329.log &
# 6748 10.0.0.5 59.52449 1129.012
sleep 59.524490 && printMsg $START "Results/330.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/330.log &
# 6748 10.0.0.5 50.77316 422.6994
sleep 50.773160 && printMsg $START "Results/331.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/331.log &
# 6748 10.0.0.5 51.43916 2471.814
sleep 51.439160 && printMsg $START "Results/332.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/332.log &
# 6748 10.0.0.5 57.54846 10417.85
sleep 57.548460 && printMsg $START "Results/333.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/333.log &
# 6748 10.0.0.5 59.90178 29501.32
sleep 59.901780 && printMsg $START "Results/334.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/334.log &
# 6748 10.0.0.5 58.64967 1183.085
sleep 58.649670 && printMsg $START "Results/335.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/335.log &
# 6748 10.0.0.5 59.85081 48214.16
sleep 59.850810 && printMsg $START "Results/336.log" && sudo mnexec -a 6748 iperf -c 10.0.0.5 -t 1 > Results/336.log &
# 6748 10.0.0.7 57.35534 925.4418
sleep 57.355340 && printMsg $START "Results/337.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/337.log &
# 6748 10.0.0.7 51.58054 358.8564
sleep 51.580540 && printMsg $START "Results/338.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/338.log &
# 6748 10.0.0.7 56.93478 1090.085
sleep 56.934780 && printMsg $START "Results/339.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/339.log &
# 6748 10.0.0.7 51.89067 342.4547
sleep 51.890670 && printMsg $START "Results/340.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/340.log &
# 6748 10.0.0.7 59.52549 222.1604
sleep 59.525490 && printMsg $START "Results/341.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/341.log &
# 6748 10.0.0.7 51.46056 149.2686
sleep 51.460560 && printMsg $START "Results/342.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/342.log &
# 6748 10.0.0.7 52.84291 223136.9
sleep 52.842910 && printMsg $START "Results/343.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/343.log &
# 6748 10.0.0.7 57.88507 17841.39
sleep 57.885070 && printMsg $START "Results/344.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/344.log &
# 6748 10.0.0.7 55.81209 1979.283
sleep 55.812090 && printMsg $START "Results/345.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/345.log &
# 6748 10.0.0.7 51.65596 2651.502
sleep 51.655960 && printMsg $START "Results/346.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/346.log &
# 6748 10.0.0.7 55.82363 20529.61
sleep 55.823630 && printMsg $START "Results/347.log" && sudo mnexec -a 6748 iperf -c 10.0.0.7 -t 1 > Results/347.log &
# 6748 10.0.0.9 57.61752 947.3444
sleep 57.617520 && printMsg $START "Results/348.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/348.log &
# 6748 10.0.0.9 51.68417 21015.5
sleep 51.684170 && printMsg $START "Results/349.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/349.log &
# 6748 10.0.0.9 56.94933 503.7582
sleep 56.949330 && printMsg $START "Results/350.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/350.log &
# 6748 10.0.0.9 52.00602 1314.408
sleep 52.006020 && printMsg $START "Results/351.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/351.log &
# 6748 10.0.0.9 59.53342 255.6342
sleep 59.533420 && printMsg $START "Results/352.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/352.log &
# 6748 10.0.0.9 53.85814 1361.345
sleep 53.858140 && printMsg $START "Results/353.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/353.log &
# 6748 10.0.0.9 52.85645 13956.03
sleep 52.856450 && printMsg $START "Results/354.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/354.log &
# 6748 10.0.0.9 57.91273 182903.6
sleep 57.912730 && printMsg $START "Results/355.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/355.log &
# 6748 10.0.0.9 55.83975 437.7941
sleep 55.839750 && printMsg $START "Results/356.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/356.log &
# 6748 10.0.0.9 52.34336 1314.408
sleep 52.343360 && printMsg $START "Results/357.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/357.log &
# 6748 10.0.0.9 55.83003 2714.256
sleep 55.830030 && printMsg $START "Results/358.log" && sudo mnexec -a 6748 iperf -c 10.0.0.9 -t 1 > Results/358.log &
# 6748 10.0.0.10 58.53214 5805.096
sleep 58.532140 && printMsg $START "Results/359.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/359.log &
# 6748 10.0.0.10 51.74066 207.105
sleep 51.740660 && printMsg $START "Results/360.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/360.log &
# 6748 10.0.0.10 56.95726 59.94843
sleep 56.957260 && printMsg $START "Results/361.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/361.log &
# 6748 10.0.0.10 53.40976 147.5329
sleep 53.409760 && printMsg $START "Results/362.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/362.log &
# 6748 10.0.0.10 59.7956 301.1135
sleep 59.795600 && printMsg $START "Results/363.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/363.log &
# 6748 10.0.0.10 53.85962 30554.79
sleep 53.859620 && printMsg $START "Results/364.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/364.log &
# 6748 10.0.0.10 54.79208 1377.36
sleep 54.792080 && printMsg $START "Results/365.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/365.log &
# 6748 10.0.0.10 57.93587 330.6474
sleep 57.935870 && printMsg $START "Results/366.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/366.log &
# 6748 10.0.0.10 54.05833 1197.003
sleep 54.058330 && printMsg $START "Results/367.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/367.log &
# 6748 10.0.0.10 53.7471 2980.476
sleep 53.747100 && printMsg $START "Results/368.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/368.log &
# 6748 10.0.0.10 55.85769 80.30857
sleep 55.857690 && printMsg $START "Results/369.log" && sudo mnexec -a 6748 iperf -c 10.0.0.10 -t 1 > Results/369.log &
# 6748 10.0.0.12 58.57311 209.5414
sleep 58.573110 && printMsg $START "Results/370.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/370.log &
# 6748 10.0.0.12 51.74564 10296.71
sleep 51.745640 && printMsg $START "Results/371.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/371.log &
# 6748 10.0.0.12 55.4829 904.0461
sleep 55.482900 && printMsg $START "Results/372.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/372.log &
# 6748 10.0.0.12 55.98521 230.0938
sleep 55.985210 && printMsg $START "Results/373.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/373.log &
# 6748 10.0.0.12 50.19212 13956.03
sleep 50.192120 && printMsg $START "Results/374.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/374.log &
# 6748 10.0.0.12 53.94427 214.5006
sleep 53.944270 && printMsg $START "Results/375.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/375.log &
# 6748 10.0.0.12 56.41128 18263.63
sleep 56.411280 && printMsg $START "Results/376.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/376.log &
# 6748 10.0.0.12 57.94991 280.7074
sleep 57.949910 && printMsg $START "Results/377.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/377.log &
# 6748 10.0.0.12 59.31766 1530.249
sleep 59.317660 && printMsg $START "Results/378.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/378.log &
# 6748 10.0.0.12 54.89716 12709.46
sleep 54.897160 && printMsg $START "Results/379.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/379.log &
# 6748 10.0.0.12 58.93642 553.1682
sleep 58.936420 && printMsg $START "Results/380.log" && sudo mnexec -a 6748 iperf -c 10.0.0.12 -t 1 > Results/380.log &
# 6765 10.0.0.1 24.55644 1102.909
sleep 24.556440 && printMsg $START "Results/381.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/381.log &
# 6765 10.0.0.1 29.09096 315.535
sleep 29.090960 && printMsg $START "Results/382.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/382.log &
# 6765 10.0.0.1 27.21294 4135.309
sleep 27.212940 && printMsg $START "Results/383.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/383.log &
# 6765 10.0.0.1 29.74502 10789.86
sleep 29.745020 && printMsg $START "Results/384.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/384.log &
# 6765 10.0.0.1 25.9717 2530.315
sleep 25.971700 && printMsg $START "Results/385.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/385.log &
# 6765 10.0.0.1 22.36028 246.8203
sleep 22.360280 && printMsg $START "Results/386.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/386.log &
# 6765 10.0.0.1 29.76566 527.8854
sleep 29.765660 && printMsg $START "Results/387.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/387.log &
# 6765 10.0.0.1 25.0358 80.30857
sleep 25.035800 && printMsg $START "Results/388.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/388.log &
# 6765 10.0.0.1 26.36438 1740.343
sleep 26.364380 && printMsg $START "Results/389.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/389.log &
# 6765 10.0.0.1 28.28782 1345.516
sleep 28.287820 && printMsg $START "Results/390.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/390.log &
# 6765 10.0.0.1 28.64471 1361.345
sleep 28.644710 && printMsg $START "Results/391.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/391.log &
# 6765 10.0.0.1 21.04936 4986.292
sleep 21.049360 && printMsg $START "Results/392.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/392.log &
# 6765 10.0.0.1 28.76529 156.4176
sleep 28.765290 && printMsg $START "Results/393.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/393.log &
# 6765 10.0.0.1 26.43811 1064.882
sleep 26.438110 && printMsg $START "Results/394.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/394.log &
# 6765 10.0.0.1 22.39918 252.6619
sleep 22.399180 && printMsg $START "Results/395.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/395.log &
# 6765 10.0.0.1 25.9376 448.1552
sleep 25.937600 && printMsg $START "Results/396.log" && sudo mnexec -a 6765 iperf -c 10.0.0.1 -t 1 > Results/396.log &
# 6765 10.0.0.3 31.36281 1548.251
sleep 31.362810 && printMsg $START "Results/397.log" && sudo mnexec -a 6765 iperf -c 10.0.0.3 -t 1 > Results/397.log &
# 6765 10.0.0.3 37.69985 267.8777
sleep 37.699850 && printMsg $START "Results/398.log" && sudo mnexec -a 6765 iperf -c 10.0.0.3 -t 1 > Results/398.log &
# 6765 10.0.0.3 33.2169 177.893
sleep 33.216900 && printMsg $START "Results/399.log" && sudo mnexec -a 6765 iperf -c 10.0.0.3 -t 1 > Results/399.log &
# 6765 10.0.0.3 35.80446 1225.333
sleep 35.804460 && printMsg $START "Results/400.log" && sudo mnexec -a 6765 iperf -c 10.0.0.3 -t 1 > Results/400.log &
# 6775 10.0.0.2 24.85596 2443.074
sleep 24.855960 && printMsg $START "Results/401.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/401.log &
# 6775 10.0.0.2 20.94351 2746.188
sleep 20.943510 && printMsg $START "Results/402.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/402.log &
# 6775 10.0.0.2 20.43474 904.0461
sleep 20.434740 && printMsg $START "Results/403.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/403.log &
# 6775 10.0.0.2 22.26215 219.5772
sleep 22.262150 && printMsg $START "Results/404.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/404.log &
# 6775 10.0.0.2 25.39846 163.9091
sleep 25.398460 && printMsg $START "Results/405.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/405.log &
# 6775 10.0.0.2 23.82212 4594.33
sleep 23.822120 && printMsg $START "Results/406.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/406.log &
# 6775 10.0.0.2 25.49101 2746.188
sleep 25.491010 && printMsg $START "Results/407.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/407.log &
# 6775 10.0.0.2 27.91673 586.4811
sleep 27.916730 && printMsg $START "Results/408.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/408.log &
# 6775 10.0.0.2 21.74823 1377.36
sleep 21.748230 && printMsg $START "Results/409.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/409.log &
# 6775 10.0.0.2 29.81196 1028.167
sleep 29.811960 && printMsg $START "Results/410.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/410.log &
# 6775 10.0.0.2 24.27561 1409.959
sleep 24.275610 && printMsg $START "Results/411.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/411.log &
# 6775 10.0.0.2 28.85298 448.1552
sleep 28.852980 && printMsg $START "Results/412.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/412.log &
# 6775 10.0.0.2 26.83552 2414.666
sleep 26.835520 && printMsg $START "Results/413.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/413.log &
# 6775 10.0.0.2 23.95093 515.6807
sleep 23.950930 && printMsg $START "Results/414.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/414.log &
# 6775 10.0.0.2 26.54406 3900.418
sleep 26.544060 && printMsg $START "Results/415.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/415.log &
# 6775 10.0.0.2 29.30304 224.774
sleep 29.303040 && printMsg $START "Results/416.log" && sudo mnexec -a 6775 iperf -c 10.0.0.2 -t 1 > Results/416.log &
# 6775 10.0.0.3 14.78275 162.0033
sleep 14.782750 && printMsg $START "Results/417.log" && sudo mnexec -a 6775 iperf -c 10.0.0.3 -t 1 > Results/417.log &
# 6775 10.0.0.5 13.64355 1269.089
sleep 13.643550 && printMsg $START "Results/418.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/418.log &
# 6775 10.0.0.5 12.33658 4087.225
sleep 12.336580 && printMsg $START "Results/419.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/419.log &
# 6775 10.0.0.5 17.3124 804.2609
sleep 17.312400 && printMsg $START "Results/420.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/420.log &
# 6775 10.0.0.5 18.91117 2414.666
sleep 18.911170 && printMsg $START "Results/421.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/421.log &
# 6775 10.0.0.5 18.62441 1115.884
sleep 18.624410 && printMsg $START "Results/422.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/422.log &
# 6775 10.0.0.5 14.82674 124337.8
sleep 14.826740 && printMsg $START "Results/423.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/423.log &
# 6775 10.0.0.5 13.80876 1320186.0
sleep 13.808760 && printMsg $START "Results/424.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/424.log &
# 6775 10.0.0.5 16.18297 346.4836
sleep 16.182970 && printMsg $START "Results/425.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/425.log &
# 6775 10.0.0.5 16.99905 27502.04
sleep 16.999050 && printMsg $START "Results/426.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/426.log &
# 6775 10.0.0.5 12.34191 33946.4
sleep 12.341910 && printMsg $START "Results/427.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/427.log &
# 6775 10.0.0.5 19.87671 147.5329
sleep 19.876710 && printMsg $START "Results/428.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/428.log &
# 6775 10.0.0.5 16.44343 227.4183
sleep 16.443430 && printMsg $START "Results/429.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/429.log &
# 6775 10.0.0.5 18.09318 1004.395
sleep 18.093180 && printMsg $START "Results/430.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/430.log &
# 6775 10.0.0.5 18.64318 794.909
sleep 18.643180 && printMsg $START "Results/431.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/431.log &
# 6775 10.0.0.5 15.57432 147.5329
sleep 15.574320 && printMsg $START "Results/432.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/432.log &
# 6775 10.0.0.5 16.44085 2148.144
sleep 16.440850 && printMsg $START "Results/433.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/433.log &
# 6775 10.0.0.5 16.55222 4540.91
sleep 16.552220 && printMsg $START "Results/434.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/434.log &
# 6775 10.0.0.5 15.86857 480.7339
sleep 15.868570 && printMsg $START "Results/435.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/435.log &
# 6775 10.0.0.5 17.62071 3086.909
sleep 17.620710 && printMsg $START "Results/436.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/436.log &
# 6775 10.0.0.5 16.08377 1040.262
sleep 16.083770 && printMsg $START "Results/437.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/437.log &
# 6775 10.0.0.5 19.1965 534.0955
sleep 19.196500 && printMsg $START "Results/438.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/438.log &
# 6775 10.0.0.5 12.38457 1284.019
sleep 12.384570 && printMsg $START "Results/439.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/439.log &
# 6775 10.0.0.5 15.7592 2714.256
sleep 15.759200 && printMsg $START "Results/440.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/440.log &
# 6775 10.0.0.5 15.24379 358.8564
sleep 15.243790 && printMsg $START "Results/441.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/441.log &
# 6775 10.0.0.5 19.19355 175.8245
sleep 19.193550 && printMsg $START "Results/442.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/442.log &
# 6775 10.0.0.5 18.65937 6837.867
sleep 18.659370 && printMsg $START "Results/443.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/443.log &
# 6775 10.0.0.5 16.6254 160.1196
sleep 16.625400 && printMsg $START "Results/444.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/444.log &
# 6775 10.0.0.5 14.88318 9376.992
sleep 14.883180 && printMsg $START "Results/445.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/445.log &
# 6775 10.0.0.5 17.42171 1802.49
sleep 17.421710 && printMsg $START "Results/446.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/446.log &
# 6775 10.0.0.5 19.87279 1329.871
sleep 19.872790 && printMsg $START "Results/447.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/447.log &
# 6775 10.0.0.5 15.81014 11175.17
sleep 15.810140 && printMsg $START "Results/448.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/448.log &
# 6775 10.0.0.5 16.74172 3234.754
sleep 16.741720 && printMsg $START "Results/449.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/449.log &
# 6775 10.0.0.5 10.95758 76079.9
sleep 10.957580 && printMsg $START "Results/450.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/450.log &
# 6775 10.0.0.5 18.05902 12561.68
sleep 18.059020 && printMsg $START "Results/451.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/451.log &
# 6775 10.0.0.5 16.49972 48781.36
sleep 16.499720 && printMsg $START "Results/452.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/452.log &
# 6775 10.0.0.5 17.65336 559.6757
sleep 17.653360 && printMsg $START "Results/453.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/453.log &
# 6775 10.0.0.5 16.20034 166566.3
sleep 16.200340 && printMsg $START "Results/454.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/454.log &
# 6775 10.0.0.5 15.48329 1169.328
sleep 15.483290 && printMsg $START "Results/455.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/455.log &
# 6775 10.0.0.5 10.01078 376.0434
sleep 10.010780 && printMsg $START "Results/456.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/456.log &
# 6775 10.0.0.5 15.94186 19591.32
sleep 15.941860 && printMsg $START "Results/457.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/457.log &
# 6775 10.0.0.5 13.64806 14624.45
sleep 13.648060 && printMsg $START "Results/458.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/458.log &
# 6775 10.0.0.5 10.6549 4594.33
sleep 10.654900 && printMsg $START "Results/459.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/459.log &
# 6775 10.0.0.5 14.34306 153472.9
sleep 14.343060 && printMsg $START "Results/460.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/460.log &
# 6775 10.0.0.5 18.8996 2049.963
sleep 18.899600 && printMsg $START "Results/461.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/461.log &
# 6775 10.0.0.5 10.65287 2590.201
sleep 10.652870 && printMsg $START "Results/462.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/462.log &
# 6775 10.0.0.5 13.64546 202.3167
sleep 13.645460 && printMsg $START "Results/463.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/463.log &
# 6775 10.0.0.5 17.81621 1077.41
sleep 17.816210 && printMsg $START "Results/464.log" && sudo mnexec -a 6775 iperf -c 10.0.0.5 -t 1 > Results/464.log &
# 6775 10.0.0.6 29.826 80.30857
sleep 29.826000 && printMsg $START "Results/465.log" && sudo mnexec -a 6775 iperf -c 10.0.0.6 -t 1 > Results/465.log &
# 6775 10.0.0.7 43.0649 586.4811
sleep 43.064900 && printMsg $START "Results/466.log" && sudo mnexec -a 6775 iperf -c 10.0.0.7 -t 1 > Results/466.log &
# 6775 10.0.0.7 40.09802 1254.333
sleep 40.098020 && printMsg $START "Results/467.log" && sudo mnexec -a 6775 iperf -c 10.0.0.7 -t 1 > Results/467.log &
# 6775 10.0.0.7 40.94168 432.7035
sleep 40.941680 && printMsg $START "Results/468.log" && sudo mnexec -a 6775 iperf -c 10.0.0.7 -t 1 > Results/468.log &
# 6775 10.0.0.7 47.47524 2746.188
sleep 47.475240 && printMsg $START "Results/469.log" && sudo mnexec -a 6775 iperf -c 10.0.0.7 -t 1 > Results/469.log &
# 6775 10.0.0.7 48.82727 1409.959
sleep 48.827270 && printMsg $START "Results/470.log" && sudo mnexec -a 6775 iperf -c 10.0.0.7 -t 1 > Results/470.log &
# 6775 10.0.0.7 48.89915 3678.869
sleep 48.899150 && printMsg $START "Results/471.log" && sudo mnexec -a 6775 iperf -c 10.0.0.7 -t 1 > Results/471.log &
# 6775 10.0.0.7 41.69937 1603.538
sleep 41.699370 && printMsg $START "Results/472.log" && sudo mnexec -a 6775 iperf -c 10.0.0.7 -t 1 > Results/472.log &
# 6775 10.0.0.7 45.7401 1888.82
sleep 45.740100 && printMsg $START "Results/473.log" && sudo mnexec -a 6775 iperf -c 10.0.0.7 -t 1 > Results/473.log &
# 6775 10.0.0.7 47.1577 50.30224
sleep 47.157700 && printMsg $START "Results/474.log" && sudo mnexec -a 6775 iperf -c 10.0.0.7 -t 1 > Results/474.log &
# 6775 10.0.0.9 24.85878 785.6664
sleep 24.858780 && printMsg $START "Results/475.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/475.log &
# 6775 10.0.0.9 20.43482 3234.754
sleep 20.434820 && printMsg $START "Results/476.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/476.log &
# 6775 10.0.0.9 24.49488 193.0698
sleep 24.494880 && printMsg $START "Results/477.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/477.log &
# 6775 10.0.0.9 29.07883 448.1552
sleep 29.078830 && printMsg $START "Results/478.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/478.log &
# 6775 10.0.0.9 23.83616 267.8777
sleep 23.836160 && printMsg $START "Results/479.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/479.log &
# 6775 10.0.0.9 25.51867 723.9066
sleep 25.518670 && printMsg $START "Results/480.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/480.log &
# 6775 10.0.0.9 28.01322 1329.871
sleep 28.013220 && printMsg $START "Results/481.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/481.log &
# 6775 10.0.0.9 21.80472 1225.333
sleep 21.804720 && printMsg $START "Results/482.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/482.log &
# 6775 10.0.0.9 21.73912 629.1151
sleep 21.739120 && printMsg $START "Results/483.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/483.log &
# 6775 10.0.0.9 24.27773 1393.564
sleep 24.277730 && printMsg $START "Results/484.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/484.log &
# 6775 10.0.0.9 28.88064 1781.532
sleep 28.880640 && printMsg $START "Results/485.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/485.log &
# 6775 10.0.0.9 26.8356 11710.4
sleep 26.835600 && printMsg $START "Results/486.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/486.log &
# 6775 10.0.0.9 28.3505 171.7595
sleep 28.350500 && printMsg $START "Results/487.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/487.log &
# 6775 10.0.0.9 28.16327 193.0698
sleep 28.163270 && printMsg $START "Results/488.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/488.log &
# 6775 10.0.0.9 29.34549 448.1552
sleep 29.345490 && printMsg $START "Results/489.log" && sudo mnexec -a 6775 iperf -c 10.0.0.9 -t 1 > Results/489.log &
# 6790 10.0.0.2 8.488475 202.3167
sleep 8.488475 && printMsg $START "Results/490.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/490.log &
# 6790 10.0.0.2 0.7536182 264.7628
sleep 0.753618 && printMsg $START "Results/491.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/491.log &
# 6790 10.0.0.2 5.941781 207.105
sleep 5.941781 && printMsg $START "Results/492.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/492.log &
# 6790 10.0.0.2 8.112793 186.413
sleep 8.112793 && printMsg $START "Results/493.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/493.log &
# 6790 10.0.0.2 8.603607 267.8777
sleep 8.603607 && printMsg $START "Results/494.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/494.log &
# 6790 10.0.0.2 13.70902 11848.16
sleep 13.709020 && printMsg $START "Results/495.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/495.log &
# 6790 10.0.0.2 12.52065 1142.294
sleep 12.520650 && printMsg $START "Results/496.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/496.log &
# 6790 10.0.0.2 17.45541 277.4435
sleep 17.455410 && printMsg $START "Results/497.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/497.log &
# 6790 10.0.0.2 10.4598 553.1682
sleep 10.459800 && printMsg $START "Results/498.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/498.log &
# 6790 10.0.0.2 11.5071 51117.72
sleep 11.507100 && printMsg $START "Results/499.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/499.log &
# 6790 10.0.0.2 14.86801 1377.36
sleep 14.868010 && printMsg $START "Results/500.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/500.log &
# 6790 10.0.0.2 10.21361 258.6417
sleep 10.213610 && printMsg $START "Results/501.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/501.log &
# 6790 10.0.0.2 13.82783 54196.13
sleep 13.827830 && printMsg $START "Results/502.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/502.log &
# 6790 10.0.0.2 17.00909 6837.867
sleep 17.009090 && printMsg $START "Results/503.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/503.log &
# 6790 10.0.0.2 14.68999 1115.884
sleep 14.689990 && printMsg $START "Results/504.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/504.log &
# 6790 10.0.0.2 17.49873 1622.403
sleep 17.498730 && printMsg $START "Results/505.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/505.log &
# 6790 10.0.0.2 14.60618 553.1682
sleep 14.606180 && printMsg $START "Results/506.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/506.log &
# 6790 10.0.0.2 19.06444 255.6342
sleep 19.064440 && printMsg $START "Results/507.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/507.log &
# 6790 10.0.0.2 18.92854 1211.085
sleep 18.928540 && printMsg $START "Results/508.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/508.log &
# 6790 10.0.0.2 10.55693 3946.303
sleep 10.556930 && printMsg $START "Results/509.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/509.log &
# 6790 10.0.0.2 17.63833 330.6474
sleep 17.638330 && printMsg $START "Results/510.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/510.log &
# 6790 10.0.0.2 18.38022 5942.487
sleep 18.380220 && printMsg $START "Results/511.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/511.log &
# 6790 10.0.0.2 16.6068 2471.814
sleep 16.606800 && printMsg $START "Results/512.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/512.log &
# 6790 10.0.0.2 15.9249 156.4176
sleep 15.924900 && printMsg $START "Results/513.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/513.log &
# 6790 10.0.0.2 17.9518 354.6836
sleep 17.951800 && printMsg $START "Results/514.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/514.log &
# 6790 10.0.0.2 16.88166 11045.23
sleep 16.881660 && printMsg $START "Results/515.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/515.log &
# 6790 10.0.0.2 19.389 1329.871
sleep 19.389000 && printMsg $START "Results/516.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/516.log &
# 6790 10.0.0.2 13.52323 546.736
sleep 13.523230 && printMsg $START "Results/517.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/517.log &
# 6790 10.0.0.2 15.28724 417.7845
sleep 15.287240 && printMsg $START "Results/518.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/518.log &
# 6790 10.0.0.2 19.74657 163.9091
sleep 19.746570 && printMsg $START "Results/519.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/519.log &
# 6790 10.0.0.2 14.14283 1781.532
sleep 14.142830 && printMsg $START "Results/520.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/520.log &
# 6790 10.0.0.2 19.66798 1102.909
sleep 19.667980 && printMsg $START "Results/521.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/521.log &
# 6790 10.0.0.2 14.98465 448.1552
sleep 14.984650 && printMsg $START "Results/522.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/522.log &
# 6790 10.0.0.2 17.92053 222.1604
sleep 17.920530 && printMsg $START "Results/523.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/523.log &
# 6790 10.0.0.2 12.79519 2682.696
sleep 12.795190 && printMsg $START "Results/524.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/524.log &
# 6790 10.0.0.2 15.81489 559.6757
sleep 15.814890 && printMsg $START "Results/525.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/525.log &
# 6790 10.0.0.2 10.97587 334.5371
sleep 10.975870 && printMsg $START "Results/526.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/526.log &
# 6790 10.0.0.2 18.57555 4384.346
sleep 18.575550 && printMsg $START "Results/527.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/527.log &
# 6790 10.0.0.2 16.61881 15687.57
sleep 16.618810 && printMsg $START "Results/528.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/528.log &
# 6790 10.0.0.2 15.10297 1660.8
sleep 15.102970 && printMsg $START "Results/529.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/529.log &
# 6790 10.0.0.2 16.21537 12271.26
sleep 16.215370 && printMsg $START "Results/530.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/530.log &
# 6790 10.0.0.2 15.59008 14624.45
sleep 15.590080 && printMsg $START "Results/531.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/531.log &
# 6790 10.0.0.2 10.05252 7334.943
sleep 10.052520 && printMsg $START "Results/532.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/532.log &
# 6790 10.0.0.2 16.73759 11175.17
sleep 16.737590 && printMsg $START "Results/533.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/533.log &
# 6790 10.0.0.2 14.1115 1314.408
sleep 14.111500 && printMsg $START "Results/534.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/534.log &
# 6790 10.0.0.2 10.73416 925.4418
sleep 10.734160 && printMsg $START "Results/535.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/535.log &
# 6790 10.0.0.2 11.20254 794.909
sleep 11.202540 && printMsg $START "Results/536.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/536.log &
# 6790 10.0.0.2 14.44772 3510.725
sleep 14.447720 && printMsg $START "Results/537.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/537.log &
# 6790 10.0.0.2 11.59062 2098.479
sleep 11.590620 && printMsg $START "Results/538.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/538.log &
# 6790 10.0.0.2 13.96193 223136.9
sleep 13.961930 && printMsg $START "Results/539.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/539.log &
# 6790 10.0.0.2 10.44565 304.6558
sleep 10.445650 && printMsg $START "Results/540.log" && sudo mnexec -a 6790 iperf -c 10.0.0.2 -t 1 > Results/540.log &
# 6790 10.0.0.7 8.516136 179.9857
sleep 8.516136 && printMsg $START "Results/541.log" && sudo mnexec -a 6790 iperf -c 10.0.0.7 -t 1 > Results/541.log &
# 6790 10.0.0.7 0.7666883 1345.516
sleep 0.766688 && printMsg $START "Results/542.log" && sudo mnexec -a 6790 iperf -c 10.0.0.7 -t 1 > Results/542.log &
# 6790 10.0.0.7 4.153955 39061.22
sleep 4.153955 && printMsg $START "Results/543.log" && sudo mnexec -a 6790 iperf -c 10.0.0.7 -t 1 > Results/543.log &
# 6790 10.0.0.7 7.113455 2778.494
sleep 7.113455 && printMsg $START "Results/544.log" && sudo mnexec -a 6790 iperf -c 10.0.0.7 -t 1 > Results/544.log &
# 6790 10.0.0.7 0.003746652 1700.107
sleep 0.003747 && printMsg $START "Results/545.log" && sudo mnexec -a 6790 iperf -c 10.0.0.7 -t 1 > Results/545.log &
# 6790 10.0.0.7 5.946766 193.0698
sleep 5.946766 && printMsg $START "Results/546.log" && sudo mnexec -a 6790 iperf -c 10.0.0.7 -t 1 > Results/546.log &
# 6790 10.0.0.7 8.12734 3855.065
sleep 8.127340 && printMsg $START "Results/547.log" && sudo mnexec -a 6790 iperf -c 10.0.0.7 -t 1 > Results/547.log &
# 6790 10.0.0.7 0.2781483 11439.65
sleep 0.278148 && printMsg $START "Results/548.log" && sudo mnexec -a 6790 iperf -c 10.0.0.7 -t 1 > Results/548.log &
# 6790 10.0.0.7 9.102118 80.30857
sleep 9.102118 && printMsg $START "Results/549.log" && sudo mnexec -a 6790 iperf -c 10.0.0.7 -t 1 > Results/549.log &
# 6790 10.0.0.11 0.770435 1584.893
sleep 0.770435 && printMsg $START "Results/550.log" && sudo mnexec -a 6790 iperf -c 10.0.0.11 -t 1 > Results/550.log &
# 6790 10.0.0.11 9.413283 144.122
sleep 9.413283 && printMsg $START "Results/551.log" && sudo mnexec -a 6790 iperf -c 10.0.0.11 -t 1 > Results/551.log &
# 6790 10.0.0.11 9.049082 23900.82
sleep 9.049082 && printMsg $START "Results/552.log" && sudo mnexec -a 6790 iperf -c 10.0.0.11 -t 1 > Results/552.log &
# 6790 10.0.0.11 2.579194 195.3411
sleep 2.579194 && printMsg $START "Results/553.log" && sudo mnexec -a 6790 iperf -c 10.0.0.11 -t 1 > Results/553.log &
# 6790 10.0.0.11 5.98773 149.2686
sleep 5.987730 && printMsg $START "Results/554.log" && sudo mnexec -a 6790 iperf -c 10.0.0.11 -t 1 > Results/554.log &
# 6790 10.0.0.11 8.132325 1494.869
sleep 8.132325 && printMsg $START "Results/555.log" && sudo mnexec -a 6790 iperf -c 10.0.0.11 -t 1 > Results/555.log &
# 6790 10.0.0.11 0.2831334 651.5807
sleep 0.283133 && printMsg $START "Results/556.log" && sudo mnexec -a 6790 iperf -c 10.0.0.11 -t 1 > Results/556.log &
# 6790 10.0.0.11 9.107103 9598.919
sleep 9.107103 && printMsg $START "Results/557.log" && sudo mnexec -a 6790 iperf -c 10.0.0.11 -t 1 > Results/557.log &
# 6801 10.0.0.3 9.546025 4540.91
sleep 9.546025 && printMsg $START "Results/558.log" && sudo mnexec -a 6801 iperf -c 10.0.0.3 -t 1 > Results/558.log &
# 6801 10.0.0.3 0.3366137 13163.31
sleep 0.336614 && printMsg $START "Results/559.log" && sudo mnexec -a 6801 iperf -c 10.0.0.3 -t 1 > Results/559.log &
# 6801 10.0.0.3 9.210736 3552.025
sleep 9.210736 && printMsg $START "Results/560.log" && sudo mnexec -a 6801 iperf -c 10.0.0.3 -t 1 > Results/560.log &
# 6801 10.0.0.3 8.393201 217.0241
sleep 8.393201 && printMsg $START "Results/561.log" && sudo mnexec -a 6801 iperf -c 10.0.0.3 -t 1 > Results/561.log &
# 6801 10.0.0.3 8.153353 13633.36
sleep 8.153353 && printMsg $START "Results/562.log" && sudo mnexec -a 6801 iperf -c 10.0.0.3 -t 1 > Results/562.log &
# 6801 10.0.0.3 3.416868 1040.262
sleep 3.416868 && printMsg $START "Results/563.log" && sudo mnexec -a 6801 iperf -c 10.0.0.3 -t 1 > Results/563.log &
# 6801 10.0.0.3 0.04213011 5411.695
sleep 0.042130 && printMsg $START "Results/564.log" && sudo mnexec -a 6801 iperf -c 10.0.0.3 -t 1 > Results/564.log &
# 6801 10.0.0.4 9.560572 1211.085
sleep 9.560572 && printMsg $START "Results/565.log" && sudo mnexec -a 6801 iperf -c 10.0.0.4 -t 1 > Results/565.log &
# 6801 10.0.0.4 0.3546362 80.30857
sleep 0.354636 && printMsg $START "Results/566.log" && sudo mnexec -a 6801 iperf -c 10.0.0.4 -t 1 > Results/566.log &
# 6801 10.0.0.4 0.6873996 2945.821
sleep 0.687400 && printMsg $START "Results/567.log" && sudo mnexec -a 6801 iperf -c 10.0.0.4 -t 1 > Results/567.log &
# 6801 10.0.0.4 9.610147 334.5371
sleep 9.610147 && printMsg $START "Results/568.log" && sudo mnexec -a 6801 iperf -c 10.0.0.4 -t 1 > Results/568.log &
# 6801 10.0.0.4 0.01354512 904.0461
sleep 0.013545 && printMsg $START "Results/569.log" && sudo mnexec -a 6801 iperf -c 10.0.0.4 -t 1 > Results/569.log &
# 6801 10.0.0.4 3.988621 18915.83
sleep 3.988621 && printMsg $START "Results/570.log" && sudo mnexec -a 6801 iperf -c 10.0.0.4 -t 1 > Results/570.log &
# 6801 10.0.0.4 1.259076 1720.108
sleep 1.259076 && printMsg $START "Results/571.log" && sudo mnexec -a 6801 iperf -c 10.0.0.4 -t 1 > Results/571.log &
# 6801 10.0.0.5 0.07515692 482847.2
sleep 0.075157 && printMsg $START "Results/572.log" && sudo mnexec -a 6801 iperf -c 10.0.0.5 -t 1 > Results/572.log &
# 6801 10.0.0.5 1.563347 124337.8
sleep 1.563347 && printMsg $START "Results/573.log" && sudo mnexec -a 6801 iperf -c 10.0.0.5 -t 1 > Results/573.log &
# 6801 10.0.0.5 7.93819 940444.9
sleep 7.938190 && printMsg $START "Results/574.log" && sudo mnexec -a 6801 iperf -c 10.0.0.5 -t 1 > Results/574.log &
# 6801 10.0.0.5 0.388282 1641.489
sleep 0.388282 && printMsg $START "Results/575.log" && sudo mnexec -a 6801 iperf -c 10.0.0.5 -t 1 > Results/575.log &
# 6801 10.0.0.5 0.6570629 11848.16
sleep 0.657063 && printMsg $START "Results/576.log" && sudo mnexec -a 6801 iperf -c 10.0.0.5 -t 1 > Results/576.log &
# 6801 10.0.0.5 0.8522365 1584.893
sleep 0.852236 && printMsg $START "Results/577.log" && sudo mnexec -a 6801 iperf -c 10.0.0.5 -t 1 > Results/577.log &
# 6801 10.0.0.5 0.08365283 1129.012
sleep 0.083653 && printMsg $START "Results/578.log" && sudo mnexec -a 6801 iperf -c 10.0.0.5 -t 1 > Results/578.log &
# 6801 10.0.0.5 0.3083636 14120.21
sleep 0.308364 && printMsg $START "Results/579.log" && sudo mnexec -a 6801 iperf -c 10.0.0.5 -t 1 > Results/579.log &
# 6801 10.0.0.5 7.668991 182.1032
sleep 7.668991 && printMsg $START "Results/580.log" && sudo mnexec -a 6801 iperf -c 10.0.0.5 -t 1 > Results/580.log &
# 6801 10.0.0.5 1.561503 1964869.0
sleep 1.561503 && printMsg $START "Results/581.log" && sudo mnexec -a 6801 iperf -c 10.0.0.5 -t 1 > Results/581.log &
# 6801 10.0.0.6 0.5073312 2877.714
sleep 0.507331 && printMsg $START "Results/582.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/582.log &
# 6801 10.0.0.6 1.678696 408.1254
sleep 1.678696 && printMsg $START "Results/583.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/583.log &
# 6801 10.0.0.6 9.155136 47099.48
sleep 9.155136 && printMsg $START "Results/584.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/584.log &
# 6801 10.0.0.6 2.323909 732.4228
sleep 2.323909 && printMsg $START "Results/585.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/585.log &
# 6801 10.0.0.6 1.874009 398.6895
sleep 1.874009 && printMsg $START "Results/586.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/586.log &
# 6801 10.0.0.6 2.787864 21262.73
sleep 2.787864 && printMsg $START "Results/587.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/587.log &
# 6801 10.0.0.6 0.0982004 1700.107
sleep 0.098200 && printMsg $START "Results/588.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/588.log &
# 6801 10.0.0.6 0.5356582 6374.477
sleep 0.535658 && printMsg $START "Results/589.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/589.log &
# 6801 10.0.0.6 7.811893 2530.315
sleep 7.811893 && printMsg $START "Results/590.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/590.log &
# 6801 10.0.0.6 5.241873 8440.131
sleep 5.241873 && printMsg $START "Results/591.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/591.log &
# 6801 10.0.0.6 4.161005 14017370.0
sleep 4.161005 && printMsg $START "Results/592.log" && sudo mnexec -a 6801 iperf -c 10.0.0.6 -t 1 > Results/592.log &
# 6801 10.0.0.7 1.911072 1740.343
sleep 1.911072 && printMsg $START "Results/593.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/593.log &
# 6801 10.0.0.7 5.359066 69.79262
sleep 5.359066 && printMsg $START "Results/594.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/594.log &
# 6801 10.0.0.7 9.173158 290.7315
sleep 9.173158 && printMsg $START "Results/595.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/595.log &
# 6801 10.0.0.7 2.379907 217.0241
sleep 2.379907 && printMsg $START "Results/596.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/596.log &
# 6801 10.0.0.7 3.809636 80661.59
sleep 3.809636 && printMsg $START "Results/597.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/597.log &
# 6801 10.0.0.7 2.831859 2331.412
sleep 2.831859 && printMsg $START "Results/598.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/598.log &
# 6801 10.0.0.7 0.1268662 3510.725
sleep 0.126866 && printMsg $START "Results/599.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/599.log &
# 6801 10.0.0.7 1.226805 1284.019
sleep 1.226805 && printMsg $START "Results/600.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/600.log &
# 6801 10.0.0.7 7.954795 238.3104
sleep 7.954795 && printMsg $START "Results/601.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/601.log &
# 6801 10.0.0.7 5.578486 261.6844
sleep 5.578486 && printMsg $START "Results/602.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/602.log &
# 6801 10.0.0.7 4.188666 572.9217
sleep 4.188666 && printMsg $START "Results/603.log" && sudo mnexec -a 6801 iperf -c 10.0.0.7 -t 1 > Results/603.log &
# 6801 10.0.0.8 1.911151 1933.523
sleep 1.911151 && printMsg $START "Results/604.log" && sudo mnexec -a 6801 iperf -c 10.0.0.8 -t 1 > Results/604.log &
# 6801 10.0.0.8 5.387732 659.2463
sleep 5.387732 && printMsg $START "Results/605.log" && sudo mnexec -a 6801 iperf -c 10.0.0.8 -t 1 > Results/605.log &
# 6801 10.0.0.8 9.183339 267.8777
sleep 9.183339 && printMsg $START "Results/606.log" && sudo mnexec -a 6801 iperf -c 10.0.0.8 -t 1 > Results/606.log &
# 6801 10.0.0.8 6.060277 212.0065
sleep 6.060277 && printMsg $START "Results/607.log" && sudo mnexec -a 6801 iperf -c 10.0.0.8 -t 1 > Results/607.log &
# 6801 10.0.0.8 8.953028 37439778.0
sleep 8.953028 && printMsg $START "Results/608.log" && sudo mnexec -a 6801 iperf -c 10.0.0.8 -t 1 > Results/608.log &
# 6801 10.0.0.9 4.989884 1090.085
sleep 4.989884 && printMsg $START "Results/609.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/609.log &
# 6801 10.0.0.9 9.068102 4594.33
sleep 9.068102 && printMsg $START "Results/610.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/610.log &
# 6801 10.0.0.9 0.0101801 163.9091
sleep 0.010180 && printMsg $START "Results/611.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/611.log &
# 6801 10.0.0.9 8.293012 147.5329
sleep 8.293012 && printMsg $START "Results/612.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/612.log &
# 6801 10.0.0.9 8.963208 3159.966
sleep 8.963208 && printMsg $START "Results/613.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/613.log &
# 6801 10.0.0.9 3.810243 182.1032
sleep 3.810243 && printMsg $START "Results/614.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/614.log &
# 6801 10.0.0.9 2.915512 3765.936
sleep 2.915512 && printMsg $START "Results/615.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/615.log &
# 6801 10.0.0.9 0.1283472 408.1254
sleep 0.128347 && printMsg $START "Results/616.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/616.log &
# 6801 10.0.0.9 1.234734 2049.963
sleep 1.234734 && printMsg $START "Results/617.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/617.log &
# 6801 10.0.0.9 7.997248 1548.251
sleep 7.997248 && printMsg $START "Results/618.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/618.log &
# 6801 10.0.0.9 5.578794 1740.343
sleep 5.578794 && printMsg $START "Results/619.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/619.log &
# 6801 10.0.0.9 4.62084 1426.546
sleep 4.620840 && printMsg $START "Results/620.log" && sudo mnexec -a 6801 iperf -c 10.0.0.9 -t 1 > Results/620.log &
# 6801 10.0.0.11 6.393625 408.1254
sleep 6.393625 && printMsg $START "Results/621.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/621.log &
# 6801 10.0.0.11 9.130973 2714.256
sleep 9.130973 && printMsg $START "Results/622.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/622.log &
# 6801 10.0.0.11 0.01299597 981.1738
sleep 0.012996 && printMsg $START "Results/623.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/623.log &
# 6801 10.0.0.11 8.299413 427.6723
sleep 8.299413 && printMsg $START "Results/624.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/624.log &
# 6801 10.0.0.11 8.976279 264.7628
sleep 8.976279 && printMsg $START "Results/625.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/625.log &
# 6801 10.0.0.11 3.82428 80.30857
sleep 3.824280 && printMsg $START "Results/626.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/626.log &
# 6801 10.0.0.11 3.252126 2049.963
sleep 3.252126 && printMsg $START "Results/627.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/627.log &
# 6801 10.0.0.11 0.1958711 6679.776
sleep 0.195871 && printMsg $START "Results/628.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/628.log &
# 6801 10.0.0.11 1.241134 2651.502
sleep 1.241134 && printMsg $START "Results/629.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/629.log &
# 6801 10.0.0.11 8.100882 18263.63
sleep 8.100882 && printMsg $START "Results/630.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/630.log &
# 6801 10.0.0.11 5.606455 169.7623
sleep 5.606455 && printMsg $START "Results/631.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/631.log &
# 6801 10.0.0.11 7.196287 169.7623
sleep 7.196287 && printMsg $START "Results/632.log" && sudo mnexec -a 6801 iperf -c 10.0.0.11 -t 1 > Results/632.log &
# 6801 10.0.0.12 6.40717 173.7801
sleep 6.407170 && printMsg $START "Results/633.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/633.log &
# 6801 10.0.0.12 0.05450472 219.5772
sleep 0.054505 && printMsg $START "Results/634.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/634.log &
# 6801 10.0.0.12 0.05396004 1169.328
sleep 0.053960 && printMsg $START "Results/635.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/635.log &
# 6801 10.0.0.12 8.31345 1077.41
sleep 8.313450 && printMsg $START "Results/636.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/636.log &
# 6801 10.0.0.12 0.4985106 1077.41
sleep 0.498511 && printMsg $START "Results/637.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/637.log &
# 6801 10.0.0.12 3.851941 442.9444
sleep 3.851941 && printMsg $START "Results/638.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/638.log &
# 6801 10.0.0.12 3.265671 1102.909
sleep 3.265671 && printMsg $START "Results/639.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/639.log &
# 6801 10.0.0.12 0.2094162 280.7074
sleep 0.209416 && printMsg $START "Results/640.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/640.log &
# 6801 10.0.0.12 2.45808 614.57
sleep 2.458080 && printMsg $START "Results/641.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/641.log &
# 6801 10.0.0.12 8.184535 8639.885
sleep 8.184535 && printMsg $START "Results/642.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/642.log &
# 6801 10.0.0.12 6.293855 3855.065
sleep 6.293855 && printMsg $START "Results/643.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/643.log &
# 6801 10.0.0.12 7.498714 147.5329
sleep 7.498714 && printMsg $START "Results/644.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/644.log &
# 6801 10.0.0.12 54.13665 480.7339
sleep 54.136650 && printMsg $START "Results/645.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/645.log &
# 6801 10.0.0.12 51.0189 1426.546
sleep 51.018900 && printMsg $START "Results/646.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/646.log &
# 6801 10.0.0.12 50.74204 24754.32
sleep 50.742040 && printMsg $START "Results/647.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/647.log &
# 6801 10.0.0.12 52.67516 145.8175
sleep 52.675160 && printMsg $START "Results/648.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/648.log &
# 6801 10.0.0.12 56.40473 197.6391
sleep 56.404730 && printMsg $START "Results/649.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/649.log &
# 6801 10.0.0.12 57.48683 7165.363
sleep 57.486830 && printMsg $START "Results/650.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/650.log &
# 6801 10.0.0.12 59.42299 363.078
sleep 59.422990 && printMsg $START "Results/651.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/651.log &
# 6801 10.0.0.12 53.44643 1115.884
sleep 53.446430 && printMsg $START "Results/652.log" && sudo mnexec -a 6801 iperf -c 10.0.0.12 -t 1 > Results/652.log &
# 6813 10.0.0.2 30.41341 417.7845
sleep 30.413410 && printMsg $START "Results/653.log" && sudo mnexec -a 6813 iperf -c 10.0.0.2 -t 1 > Results/653.log &
# 6813 10.0.0.2 36.94529 486.3894
sleep 36.945290 && printMsg $START "Results/654.log" && sudo mnexec -a 6813 iperf -c 10.0.0.2 -t 1 > Results/654.log &
# 6813 10.0.0.2 31.72045 235.5393
sleep 31.720450 && printMsg $START "Results/655.log" && sudo mnexec -a 6813 iperf -c 10.0.0.2 -t 1 > Results/655.log &
# 6813 10.0.0.3 30.4699 3123.224
sleep 30.469900 && printMsg $START "Results/656.log" && sudo mnexec -a 6813 iperf -c 10.0.0.3 -t 1 > Results/656.log &
# 6813 10.0.0.3 36.94741 154.5989
sleep 36.947410 && printMsg $START "Results/657.log" && sudo mnexec -a 6813 iperf -c 10.0.0.3 -t 1 > Results/657.log &
# 6813 10.0.0.3 32.15262 1802.49
sleep 32.152620 && printMsg $START "Results/658.log" && sudo mnexec -a 6813 iperf -c 10.0.0.3 -t 1 > Results/658.log &
# 6813 10.0.0.4 51.88496 16827.97
sleep 51.884960 && printMsg $START "Results/659.log" && sudo mnexec -a 6813 iperf -c 10.0.0.4 -t 1 > Results/659.log &
# 6813 10.0.0.4 59.66784 1115.884
sleep 59.667840 && printMsg $START "Results/660.log" && sudo mnexec -a 6813 iperf -c 10.0.0.4 -t 1 > Results/660.log &
# 6813 10.0.0.4 57.14723 1641.489
sleep 57.147230 && printMsg $START "Results/661.log" && sudo mnexec -a 6813 iperf -c 10.0.0.4 -t 1 > Results/661.log &
# 6813 10.0.0.4 54.41804 1299.125
sleep 54.418040 && printMsg $START "Results/662.log" && sudo mnexec -a 6813 iperf -c 10.0.0.4 -t 1 > Results/662.log &
# 6813 10.0.0.4 56.57083 2331.412
sleep 56.570830 && printMsg $START "Results/663.log" && sudo mnexec -a 6813 iperf -c 10.0.0.4 -t 1 > Results/663.log &
# 6813 10.0.0.4 58.77567 7776.668
sleep 58.775670 && printMsg $START "Results/664.log" && sudo mnexec -a 6813 iperf -c 10.0.0.4 -t 1 > Results/664.log &
# 6813 10.0.0.4 53.65001 553.1682
sleep 53.650010 && printMsg $START "Results/665.log" && sudo mnexec -a 6813 iperf -c 10.0.0.4 -t 1 > Results/665.log &
# 6813 10.0.0.4 51.01874 153472.9
sleep 51.018740 && printMsg $START "Results/666.log" && sudo mnexec -a 6813 iperf -c 10.0.0.4 -t 1 > Results/666.log &
# 6813 10.0.0.5 30.5244 1142.294
sleep 30.524400 && printMsg $START "Results/667.log" && sudo mnexec -a 6813 iperf -c 10.0.0.5 -t 1 > Results/667.log &
# 6813 10.0.0.5 36.96543 175.8245
sleep 36.965430 && printMsg $START "Results/668.log" && sudo mnexec -a 6813 iperf -c 10.0.0.5 -t 1 > Results/668.log &
# 6813 10.0.0.5 32.18028 448.1552
sleep 32.180280 && printMsg $START "Results/669.log" && sudo mnexec -a 6813 iperf -c 10.0.0.5 -t 1 > Results/669.log &
# 6813 10.0.0.6 30.52722 2530.315
sleep 30.527220 && printMsg $START "Results/670.log" && sudo mnexec -a 6813 iperf -c 10.0.0.6 -t 1 > Results/670.log &
# 6813 10.0.0.6 32.20895 140.7899
sleep 32.208950 && printMsg $START "Results/671.log" && sudo mnexec -a 6813 iperf -c 10.0.0.6 -t 1 > Results/671.log &
# 6813 10.0.0.7 32.14642 8440.131
sleep 32.146420 && printMsg $START "Results/672.log" && sudo mnexec -a 6813 iperf -c 10.0.0.7 -t 1 > Results/672.log &
# 6813 10.0.0.7 32.23661 5225.108
sleep 32.236610 && printMsg $START "Results/673.log" && sudo mnexec -a 6813 iperf -c 10.0.0.7 -t 1 > Results/673.log &
# 6813 10.0.0.8 45.48552 80.30857
sleep 45.485520 && printMsg $START "Results/674.log" && sudo mnexec -a 6813 iperf -c 10.0.0.8 -t 1 > Results/674.log &
# 6813 10.0.0.10 32.24292 2471.814
sleep 32.242920 && printMsg $START "Results/675.log" && sudo mnexec -a 6813 iperf -c 10.0.0.10 -t 1 > Results/675.log &
# 6813 10.0.0.10 35.91698 659.2463
sleep 35.916980 && printMsg $START "Results/676.log" && sudo mnexec -a 6813 iperf -c 10.0.0.10 -t 1 > Results/676.log &
# 6813 10.0.0.12 39.31287 8576960.0
sleep 39.312870 && printMsg $START "Results/677.log" && sudo mnexec -a 6813 iperf -c 10.0.0.12 -t 1 > Results/677.log &
# 6813 10.0.0.12 32.28537 1040.262
sleep 32.285370 && printMsg $START "Results/678.log" && sudo mnexec -a 6813 iperf -c 10.0.0.12 -t 1 > Results/678.log &
# 6813 10.0.0.12 30.34782 208015.3
sleep 30.347820 && printMsg $START "Results/679.log" && sudo mnexec -a 6813 iperf -c 10.0.0.12 -t 1 > Results/679.log &
# 6813 10.0.0.12 33.5346 14017370.0
sleep 33.534600 && printMsg $START "Results/680.log" && sudo mnexec -a 6813 iperf -c 10.0.0.12 -t 1 > Results/680.log &
# 6813 10.0.0.12 35.95943 311.8662
sleep 35.959430 && printMsg $START "Results/681.log" && sudo mnexec -a 6813 iperf -c 10.0.0.12 -t 1 > Results/681.log &
# 6826 10.0.0.8 39.04675 14970.56
sleep 39.046750 && printMsg $START "Results/682.log" && sudo mnexec -a 6826 iperf -c 10.0.0.8 -t 1 > Results/682.log &
# 6826 10.0.0.8 39.14826 1040.262
sleep 39.148260 && printMsg $START "Results/683.log" && sudo mnexec -a 6826 iperf -c 10.0.0.8 -t 1 > Results/683.log &
# 6826 10.0.0.8 33.83407 1269.089
sleep 33.834070 && printMsg $START "Results/684.log" && sudo mnexec -a 6826 iperf -c 10.0.0.8 -t 1 > Results/684.log &
# 6826 10.0.0.8 30.98859 232.8006
sleep 30.988590 && printMsg $START "Results/685.log" && sudo mnexec -a 6826 iperf -c 10.0.0.8 -t 1 > Results/685.log &
# 6826 10.0.0.9 41.16877 39061.22
sleep 41.168770 && printMsg $START "Results/686.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/686.log &
# 6826 10.0.0.9 45.82906 4135.309
sleep 45.829060 && printMsg $START "Results/687.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/687.log &
# 6826 10.0.0.9 46.05879 40456.11
sleep 46.058790 && printMsg $START "Results/688.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/688.log &
# 6826 10.0.0.9 45.25599 2844.253
sleep 45.255990 && printMsg $START "Results/689.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/689.log &
# 6826 10.0.0.9 46.00822 3636.092
sleep 46.008220 && printMsg $START "Results/690.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/690.log &
# 6826 10.0.0.9 49.34033 3429.557
sleep 49.340330 && printMsg $START "Results/691.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/691.log &
# 6826 10.0.0.9 45.67468 1052.5
sleep 45.674680 && printMsg $START "Results/692.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/692.log &
# 6826 10.0.0.9 45.66521 52943.14
sleep 45.665210 && printMsg $START "Results/693.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/693.log &
# 6826 10.0.0.9 44.73972 2198.985
sleep 44.739720 && printMsg $START "Results/694.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/694.log &
# 6826 10.0.0.9 44.66519 1254.333
sleep 44.665190 && printMsg $START "Results/695.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/695.log &
# 6826 10.0.0.9 45.89501 1361.345
sleep 45.895010 && printMsg $START "Results/696.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/696.log &
# 6826 10.0.0.9 49.28306 586.4811
sleep 49.283060 && printMsg $START "Results/697.log" && sudo mnexec -a 6826 iperf -c 10.0.0.9 -t 1 > Results/697.log &
MAXTIME=425
timeTracker $MAXTIME & 
wait
