#Creating Soft Links for VCF Files
ln -s /path/to/original/vcfs/*.vcf.gz /path/to/current/vcfs/*.vcf.gz
#Merging VCF files
bcftools merge -m none -O z -o dili_96_merged.vcf.gz file1.vcf.gz file2.vcf.gz...file96.vcf.gz
#Filtering
bcftools filter -s LowQual '-iQUAL>=30 && AD[*:1]>=15' -g8 -G10 -Oz -o dili_96_merged_filtered_pass.vcf.gz dili_96_merged.vcf.gz
#Preparing VEP input file:Remove patient IDs from VCF to create input for Ensembl VEP annotation
bcftools view -h dili_96_merged_filtered_pass.vcf.gz | grep -v '^#CHROM' > header.vcf
bcftools view -H dili_96_merged_filtered_pass.vcf.gz | cut -f1-9 > body.vcf
cat header.vcf <(echo -e "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT") body.vcf | bgzip > vep_input_deidentified.vcf.gz
tabix -p vcf vep_input_deidentified.vcf.gz
#Determining the sorted gene list
#Input1: gene_list.txt
#Input2:vep_results_edited.txt

!/usr/bin/env python3

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
        symbol = line[5]
        if symbol in list1:
            print("\t".join(line))
        else:
            pass
#To count the number of genes
cut -f5 gene_list_practice.txt | sort | uniq -c >  gene_list_sorted2.txt


