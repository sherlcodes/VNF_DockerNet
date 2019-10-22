lines = open("test_flow.csv").readlines()
to_write = open("test_flow1.csv","w")
for line in lines:
	values = line.split(",")
	x = float(values[3]) 
	while x > 100:
		x = x - 100
	to_write.write(values[0] +", "+ values[1] +", "+ values[2]+ ", " + str(x) + "\n")

	