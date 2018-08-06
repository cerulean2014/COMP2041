#!/usr/bin/python3

import sys
line = sys.stdin.readline()
while line:
	words = line.split(' ')
	result = []
	for word in words:
		word = word.strip()
		temp = word
		word = word.lower()
		data = {}
		for letter in word:
			if letter not in data: data[letter] = 1
			else: data[letter] += 1
		last = -1
		equalwith = 1
		for element in data:
			if last == -1: last = data[element]
			else:
				if data[element] != last:
					equalwith = 0
					break
		if equalwith == 1: result.append(temp)
	output = ' '.join(result)
	print(output)
	line = sys.stdin.readline()	
