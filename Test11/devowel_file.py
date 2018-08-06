#!/usr/bin/python3

import sys, re

with open(sys.argv[1], 'r') as f:
	data = f.read()
data = re.sub(r'[aeiou]', '', data, flags = re.I)

f=open(sys.argv[1], 'w')
f.write(data)
f.close()
