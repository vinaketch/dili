#!/usr/bin/env python3

import os

import sys

input=sys.argv[1]

f = open(input,'r')

for line in f:
	list1=[]
	line = line.strip()
	line = line.split()

	if line[0] == '-':
		print('-')
	else:
		pos=line[0]
		aa=line[1].split('/')
		print(aa[0] + pos + aa[-1])

