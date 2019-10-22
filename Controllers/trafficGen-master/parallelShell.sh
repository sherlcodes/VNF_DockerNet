#!/bin/sh

command() {
    echo $1 start
    sleep 3      # keep the seconds value within 0-3
    echo $1 complete
}

echo First Group:
sleep 2 && command 1 &
sleep 3 && command 2 &
sleep 4 && command 3 &
wait

echo Second Group:
command 4 &
command 5 &
command 6 &
wait

echo Third Group:
command 7 &
command 8 &
command 9 &
wait

echo Not really a group, no need for background/wait:
command 10
