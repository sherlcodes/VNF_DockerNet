#!/bin/bash
ret=$(sudo docker ps -q)
if [ -z $ret ]
then
	echo "*** No Exited docker" 
else
	echo -n "*** Exited "
	sudo docker kill $(sudo docker ps -q)
fi
ret=$(sudo docker ps -a -q)
if [ -z $ret ]
then
	echo "*** No Killed docker"
else
	echo -n "*** Killed "
	sudo docker rm $(sudo docker ps -a -q)
fi
sudo docker ps -a
