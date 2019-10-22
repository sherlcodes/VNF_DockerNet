import os

for i in xrange(1,7):
	command = "ovs-ofctl --protocols=OpenFlow13 add-flow s"+ str(i) +" dl_type=0x0806,actions=drop"
	os.system(command)
