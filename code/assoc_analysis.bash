GWAS association analysis

1. Making plink file:
plink2   --vcf dili_96_merged_filtered_pass_corrected_AF_10genes.vcf.gz --allow-no-sex   --make-pgen   --out dili_96  --set-missing-var-ids @:#   --double-id

--allow-no-sex-ignores missing sex info.

--make-pgen-converts the VCF into PLINK2 binary format:

.pgen → genotypes

.pvar → variant info

.psam → sample info

--out dili_96-sets the prefix for all output files.

--set-missing-var-ids @:#-replaces missing SNP IDs with CHR:POS (e.g., 1:12345).

--double-id-sets Family ID (FID) = Individual ID (IID) when only one ID exists in the VCF.


2.Association testing (logistic regression)

GWAS association tests should be done on all available SNPs

Fix phenotype file.
awk 'NR==1 {print $1, $2, $3; next} {print $2, $2, $3}' phenotype_categorical.txt > phenotype_fixed.txt
Fix covariates
awk 'NR==1 {print $1, $2, $3, $4, $5, $6, $7, $8; next} {print $2, $2, $3, $4, $5, $6, $7, $8}' covariates.txt > covariates_fixed.txt

Run association
plink2   --pfile dili_96   --pheno phenotype_fixed.txt   --pheno-name Phenotype   --covar covariates_fixed.txt  --covar-name gender,smoker,alcohol,hiv_status,diabetes,hypertension   --glm firth-fallback   --adjust   --out dililogistic

3.SNPs with significant or suggestive associations.
Extract SNPs with p < 0.05
Check the column number
head -n 1 dililogistic.Phenotype.glm.logistic.hybrid | tr '\t' '\n' | nl
Significant snps
awk 'NR==1 || $16 < 0.05' dililogistic.Phenotype.glm.logistic.hybrid >  dililogistic_sig.txt

4.LD clumping of significant SNPs
Identify index SNPs (the strongest association signals)
LD clumping after association (to report independent significant SNPs).
Make a list of significant SNP ids
First
Normalize variant IDs
plink2 --pfile dili_96   --set-all-var-ids @:#   --make-pgen   --out dili_96_setids

Remove duplicates
 plink2 --pfile dili_96_setids   --rm-dup force-first   --make-pgen   --out dili_96_nodup

Clumping
plink2 --pfile dili_96_nodup   --clump dililogistic.Phenotype.glm.logistic.hybrid   --clump-p1 0.05   --clump-r2 0.2   --clump-kb 500   --extract sig_snps_list.txt   --out dililogistic_clumped

