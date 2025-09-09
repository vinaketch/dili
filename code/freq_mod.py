#!/usr/bin/env python3

import os

import sys

ac_file = sys.argv[1]

vep_file = sys.argv[2]

f = open(ac_file, "r")

v = open(vep_file, "r")

list1=[]
list2=[]

for line in f:
	line=line.strip()
	line = line.split()

	chrom=line[0][3:]
	pos = line[1]
	ref = line[2]
	alt = line[3]
	ac = line[4]

	if len(ref) == 1 and len(alt) == 1:
		pos = pos + "-" + pos
		var = chrom + ":" + pos + "_" + ref + "/" + alt

	elif len(ref) > len(alt):
		if alt in ref:
			del_len = len(ref) - len(alt)
			end = int(pos) + del_len
			pos = pos + "-" + pos # str(end)
			var = chrom + ":" + pos + "_" + ref[len(alt):] + "/" + "-"

		else:
			pos = pos + "-" + pos
			var = chrom + ":" + pos + "_" + ref + "/" + alt


	elif len(ref) < len(alt):
		if ref in alt:
			pos = pos + "-" + pos
			var =  chrom + ":" + pos + "_" + "-" + "/" + alt[len(ref):] 

		else:
			pos = pos + "-" + pos
			var = chrom + ":" + pos + "_" + ref + "/" + alt

	else:
		pass

	list1.append(var)
	af = round(int(ac)/192*100, 1)
	list2.append(af)

dictionary = dict(zip(list1, list2))

# print(dictionary)


check = []

list3 = []

for line in v:
	line = line.strip()
	line = line.split()
	loc = line[1]
	alleles = line[2]

	test2 = loc + alleles
	loc = loc.split("-")
	loc1 = loc[0].split(":")
	loc = loc1[0] + ":" + loc1[1] + "-" + loc1[1]

	if alleles.count("/") == 1:
		var2 = loc + "_" + alleles
		print(dictionary[var2])
		check.append("a")

	elif alleles.count("/") > 1 and (test2 not in check):
	#	print('check')

		alleles = alleles.split("/")
		ref1 = alleles[0]

		for i in alleles[1:]:
			if len(i) < len(ref1) and (i != "-"):

				if i in ref1:
					var2 = loc + "_" + ref1[:-1*len(i)] + "/" + "-"
					if var2 not in dictionary:
						dictionary[var2] = 'check'
						print(dictionary[var2])
					else:
						print(dictionary[var2])

				else:
					var2 = loc + "_" + ref1 + "/" + i
					print(dictionary[var2])

			elif len(i) > len(ref1) and (ref1 != "-"):
				if ref1 in i:
					var2 = loc + "_" + "-" + "/" + i[len(ref1):]  
					if var2 not in dictionary:
						dictionary[var2] = 'check'
						print(dictionary[var2])
					else:
						print(dictionary[var2])

				else:
					var2 = loc + "_" + ref1 + "/" + i
					print(dictionary[var2])

			else:
				var2 = loc + "_" + ref1 + "/" + i
				print(dictionary[var2])

			
		check.append(test2)

		# if loc[0] == loc[1]:

		# 	for i in alleles[1:]:
		# 		var2 = loc + "_" + ref1 + "/" + i
		# 		print(dictionary[var2])

		# 	check.append(test2)
		# 	# list3.append(loc)


		# elif loc[0] != loc[1]:

		# 	for i in alleles[1:]:
		# 		var2 = loc[0] + "-" + loc[0] + "_" + ref1 + "/" + i
		# 		print(dictionary[var2])

		# 	check.append(test2)
		# 	# list3.append(loc)

	elif alleles.count("/") > 1 and (test2 in check):
		pass


		# alt1 = alleles[1]
		# alt2 = alleles[2]

		# if ref1 == "-" and check[-1] == "a":
		# 	var2 = loc + "_" + ref1 + "/" + alt1
		# 	print(dictionary[var2])
		# 	check.append("b")

		# elif ref1 == "-" and check[-1] == "b":
		# 	var2 = loc + "_" + ref1 + "/" + alt2
		# 	print(dictionary[var2])
		# 	check.append("a")






