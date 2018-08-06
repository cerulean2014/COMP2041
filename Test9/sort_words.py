#!/usr/bin/python3

import sys

for line in sys.stdin:
	line = line.strip()
	words = line.split(' ')
	for word in sorted(words):
		print(word, end=' ')
	print()
