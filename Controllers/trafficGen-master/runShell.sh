#!/bin/bash
START=$(date +%s%N)
printMsg() {
    tt=$((($(date +%s%N) - $1)/1000000))
    echo "$2 -> Time taken: $tt milliseconds"
}


#iperf -s > /dev/null &
# All iperf servers are running
# 15095 11.0.1.6 26.26408 274.2176
sleep 6.264080 && printMsg $START "Results/0.log" && iperf -c 127.0.0.1 -t 5 > Results/0.log &
# 15095 11.0.1.6 28.26408 274.2176
sleep 8.264080 && printMsg $START "Results/1.log" && iperf -c 127.0.0.1 -t 15 > Results/1.log &
wait
