#!/usr/bin/python3

import sys, re
l = list(sys.argv[1])
result = []
for char in l:
	match = re.match(r'\w', char)
	if match: result.append(char.lower())
maxlen = (len(result)+1) // 2
i = 0
p = 1
while i < maxlen:
	if result[i] != result[len(result)-1-i]:
		p = 0
		break
	i += 1
if p == 0: print("False")
else: print("True")

