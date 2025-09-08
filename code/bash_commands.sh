#Creating Soft Links for VCF Files
ln -s /path/to/original/vcfs/*.vcf.gz /path/to/current/vcfs/*.vcf.gz
#Merging VCF files
bcftools merge -m none -O z -o dili_96_merged.vcf.gz file1.vcf.gz file2.vcf.gz...file96.vcf.gz
#Filtering
bcftools filter -s LowQual '-iQUAL>=30 && AD[*:1]>=15' -g8 -G10 -Oz -o dili_96_merged_filtered_pass.vcf.gz dili_96_merged.vcf.gz
#Preparing VEP input file
# Purpose: Remove patient IDs from VCF to create input for Ensembl VEP annotation
bcftools view -h dili_96_merged_filtered_pass.vcf.gz | grep -v '^#CHROM' > header.vcf
bcftools view -H dili_96_merged_filtered_pass.vcf.gz | cut -f1-9 > body.vcf
cat header.vcf <(echo -e "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT") body.vcf | bgzip > vep_input_deidentified.vcf.gz
tabix -p vcf vep_input_deidentified.vcf.gz
