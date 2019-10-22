lines = open("flows.csv").readlines()
to_write = open("test_flow.csv","w")

maxHostNum = 12

for line in lines:
	values = line.split(",")
	if int(values[0]) <= 24 and int(values[1]) <= 24:
		to_write.write(line)
