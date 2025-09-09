#!/usr/bin/env python3

import os

import sys

gene_list = sys.argv[1]

vep_file = sys.argv[2]

g = open(gene_list, "r")

v = open(vep_file, "r")

list1 = []

for line in g:
    line = line.strip()
    list1.append(line)


for line in v:
    line = line.strip()
    if line.startswith("Existing"):
        pass
    else:
        line=line.split()
        id = line[0].split(",")
        id = id[0]
        line[0] = id
        symbol = line[4]
        if symbol in list1:
            print("\t".join(line))
        else:
            pass
