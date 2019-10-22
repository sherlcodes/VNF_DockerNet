import os

os.system("ps -ef | egrep \"iperf\" > iperfs")
lines = open("iperfs").readlines()
for line in lines:
	values = line.split()
	pid = values[1]
	print pid,
	if values[0] == "root":
		os.system("kill -9 " + str(pid))