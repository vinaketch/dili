#!/usr/bin/env python3

import os

import sys

keys_file = sys.argv[1]

gnomad_file = sys.argv[2]

f = open(keys_file, "r")

v = open(gnomad_file, "r")

list1=[]
list2=[]
list_afr=[]
list_eas=[]
list_eur=[]
list_sas=[]


for line1 in v:
	line1 =line1.strip()
	line1_list =line1.split()
	list2.append(line1_list[0])
	list_afr.append(line1_list[8])
	list_eas.append(line1_list[12])
	list_eur.append(line1_list[15])
	list_sas.append(line1_list[17])

dictionary_afr = dict(zip(list2, list_afr))
dictionary_eas = dict(zip(list2, list_eas))
dictionary_eur = dict(zip(list2, list_eur))
dictionary_sas = dict(zip(list2, list_sas))



for line in f:
	line=line.strip()
	key=line
	list3=[]
	afr_af=dictionary_afr[key]
	if afr_af == '-':
		list3.append(afr_af)
	elif 'E' in afr_af :
		list3.append('<0.1')
	else:
		list3.append(str(round(float(afr_af)*100,1)))

	eur_af=dictionary_eur[key]
	if eur_af == '-':
		list3.append(eur_af)
	elif 'E' in eur_af :
		list3.append('<0.1')
	else:
		list3.append(str(round(float(eur_af)*100,1)))

	sas_af=dictionary_sas[key]
	if sas_af == '-':
		list3.append(sas_af)
	elif 'E' in sas_af :
		list3.append('<0.1')
	else:
		list3.append(str(round(float(sas_af)*100,1)))

	eas_af=dictionary_eas[key]
	if eas_af == '-':
		list3.append(eas_af)
	elif 'E' in eas_af :
		list3.append('<0.1')
	else:
		list3.append(str(round(float(eas_af)*100,1)))


	print('\t'.join(list3))





