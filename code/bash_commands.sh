#merge vcf files
bcftools merge -m none -0 *vcf.gz > merge.vcf