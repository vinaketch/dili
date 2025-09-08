#Creating Soft Links for VCF Files
ln -s /path/to/original/vcfs/*.vcf.gz /path/to/current/vcfs/*.vcf.gz

#Merging VCF files
bcftools merge -m none -O z -o dili_96_merged_filtered_pass.vcf.gz file1.vcf.gz file2.vcf.gz...file96.vcf.gz


#Filtering

bcftools filter -s LowQual '-iQUAL>=30 && AD[*:1]>=15' -g8 -G10 -Oz -o dili_96_merged_filtered.vcf.gz dili_96_merged.vcf.gz


#Preparing VEP Input File
