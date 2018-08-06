#!/usr/bin/python3

import sys

array = sorted(sys.argv[1:], key=int)
print (array[len(array)//2])
