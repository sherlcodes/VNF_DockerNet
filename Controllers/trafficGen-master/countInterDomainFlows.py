import json

def count_inter_domain_flow():
	config_file = "/home/mininet/ScalableSDN/Suraj_ScalableSDN/PARC-master/cc_client/switch_controller_config.json"
	data = json.load(open(config_file))
	controllers = {}
	for k in data:
		if data[k] not in controllers:
			controllers[data[k]] = [k]
		else:
			controllers[data[k]].append(k)

	host_controller_map = {}
	for c in controllers:
		host_controller_map[c] = []
		for s in controllers[c]:
			if int(s) not in [1,2,3]:
				host_controller_map[c].append((int(s)-3)*2-1)
				host_controller_map[c].append((int(s)-3)*2)

	inverted_dict = {}
	for k,v in host_controller_map.items():
		for s in v:
			inverted_dict[s] = k

	lines = open("test_flow.csv").readlines()
	count = 0
	for line in lines:
		values = line.split(",")
		from_host = int(values[0])
		to_host = int(values[1])
		if from_host in inverted_dict and to_host in inverted_dict:
			from_controller = inverted_dict[from_host]
			to_controller = inverted_dict[to_host]
			if from_controller != to_controller:
				count += 1
	return count

if __name__ == '__main__':
	print(count_inter_domain_flow())