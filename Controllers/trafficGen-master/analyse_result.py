import sys
import os
from os.path import getsize

file_list = []

file_dir = "/home/mininet/ScalableSDN/Suraj_ScalableSDN/PARC-master/trafficGen-master/Results"
count = 0
to_be_deleted = []
for basename in os.listdir(file_dir):
    filename = os.path.join(file_dir, basename)
    if filename.endswith(".log") and os.path.isfile(filename):
        if getsize(filename) == 0:
        	count += 1
        	flow_num = int(filename.split("/")[-1].split(".")[0]) + 1
        	to_be_deleted.append(flow_num)
        	# print filename, getsize(filename)
print to_be_deleted
print len(to_be_deleted)

# lines = open("test_flow.csv").readlines()
# to_write = open("test_flow1.csv","w")
# for i in xrange(len(lines)):
# 	if (i+1) not in to_be_deleted: 
# 		values = lines[i].split(",")
# 		x = float(values[3]) 
# 		while x > 100:
# 			x = x - 100
# 		to_write.write(values[0] +", "+ values[1] +", "+ values[2]+ ", " + str(x) + "\n")
