### Test Mininet Topology command
```
sudo mn --custom ~/mininet/custom/topo-clos-like.py --topo clostree --switch ovs-stp --controller ref
sudo mn --custom ~/mininet/custom/topo-clos-like.py --topo clostree --switch ovs-stp --controller=remote,ip=127.0.0.1,port=6633
```
### Create host_pid.list
```
ps -ef|grep mininet:h > host_pid.list
```
### Run trafficgen
```
sudo python RunTest.py "StartTest.sh" "ExecuteTest.sh" "FinishTest.sh"
```

write1 failed: Connection reset by peer
connect failed: Connection reset by peer
This is caused if there are many multiple connections between hosts. 
https://github.com/weaveworks/weave/issues/3123



## Not Required anymore
### A sample command to invoke trafficGen from each host
```
sh runTrafficGenerator.sh --flowFile flow.csv --hostId 0 --hostsPerRack 20 --ipBase 10.0 --scaleFactorSize 1 --scaleFactorTime 1000 --showConfig true --debug true --logfile traffGen.log
```
### To compile project use
```
make clean
make
```

### To compile trafficGen only use following
```
g++ main.cpp utils.cpp -o trafficGen -pthread -std=gnu++11 -L /home/mininet/boost_1_61_0/Suraj_ScalableSDN/lib -lboost_thread -lboost_system -lboost_program_options
```
### Avoid ``error while loading shared libraries: libboost_program_options.so.1.61.0``
By using 
```
export LD_LIBRARY_PATH=/home/mininet/boost_1_61_0/Suraj_ScalableSDN/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
```

***Can be viewed with markdown viewer***
e.g. ``https://dillinger.io/`` or ``https://github.com/``
