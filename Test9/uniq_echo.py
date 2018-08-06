#!/usr/bin/python3

import sys

strings = []
for arg in sys.argv[1:]:
	if arg in strings: continue
	strings.append(arg)
	
for element in strings:
	print(element, end=" ")
print()
	

