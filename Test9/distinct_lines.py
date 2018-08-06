#!/usr/bin/python3

import sys, re

counter = 0
array = []
for line in sys.stdin:
	counter += 1
	line = re.sub(' +', ' ', line.lower()).strip()
	#print(line)
	if line in array: continue
	array.append(line)
	if len(array) == int(sys.argv[1]): 
		print("%d distinct lines seen after %d lines read." %(int(sys.argv[1]), counter))
		exit()
print("End of input reached after %d lines read -  %d different lines not seen." %(counter, int(sys.argv[1])))
