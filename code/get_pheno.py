#!/usr/bin/env python3

import os
import sys

infile = sys.argv[1]

f = open(infile, 'r')

dict1 = {
'*1':'if',
'*4':'if',
'*5':'df',
'*6':'df',
'*7':'df',
'*10':'uf',
'*14':'df',
'*15':'df',
'*16':'df',
'*19':'df',
'*21':'uf',
'*27':'df',
'*29':'df',
'*30':'df',
'*31':'df',
'*32':'df',
'*33':'df',
'*34':'df',
'*35':'df',
'*36':'df',
'*37':'df',
'*38':'df',
'*39':'df',
'*40':'df',
'*41':'uf',
'*42':'uf',
'*43':'uf',
'*44':'uf',
'*45':'uf',
'*46':'df',
'*47':'df',
'*48':'df',
'*49':'df',
'*50':'df'

}

all_pheno = []

for line in f:
	pheno = []
	if '[' in line:
		all_pheno.append('Indeterminate')

	elif 'or' in line:
		all_pheno.append('Indeterminate')

	elif '~' in line:
		all_pheno.append('Indeterminate')

	else:
		diplo = line.strip().split('/')
		
		for i in diplo:
			pheno.append(dict1[i])

		if pheno.count('if') == 2:
			all_pheno.append('fast-acetylator')
	
		elif pheno.count('df') == 2:
			all_pheno.append('slow-acetylator')

		elif pheno.count('if') == 1 and (pheno.count('df') == 1):
			all_pheno.append('intermediate-acetylator') 		

		else:
			all_pheno.append('indeterminate')

print ('\n'.join(all_pheno))




