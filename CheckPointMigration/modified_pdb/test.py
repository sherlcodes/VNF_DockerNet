#!/bin/python2.7
import itertools, time
from datetime import datetime
 
# Wait for 5 seconds
i=0
for elt in itertools.count():
	now = datetime.now()
	i=i+1
	current_time = now.strftime("%H:%M:%S")
	print("Current Time =", current_time)
	time.sleep(5)
