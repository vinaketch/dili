Association analysis
1. Making plink file:
plink2   --vcf  dili_96_merged_filtered_pass_corrected_AF_10genes_assoc.vcf  --allow-no-sex   --make-pgen   --out dili_96  --set-missing-var-ids @:#   --double-id

--allow-no-sex-ignores missing sex info.

--make-pgen-converts the VCF into PLINK2 binary format:

.pgen → genotypes

.pvar → variant info

.psam → sample info

--out dili_96-sets the prefix for all output files.

--set-missing-var-ids @:#-replaces missing SNP IDs with CHR:POS (e.g., 1:12345).

--double-id-sets Family ID (FID) = Individual ID (IID) when only one ID exists in the VCF.


2.LD pruning

Assign unique IDs to all variants

 plink2 --pfile dili_96        --set-all-var-ids @:#:\$r:\$a        --make-pfile        --out dili_96_unique

Remove duplicate variants
plink2 --pfile dili_96_unique        --rm-dup exclude-all        --make-pfile        --out dili_96_dedup


Perform pruning

option 1

plink2 --pfile dili_96_dedup        --indep-pairwise 50 5 0.2        --out pruned


Create a pruned dataset


plink2 --pfile dili_96_dedup        --extract pruned.prune.in        --make-pfile        --out dili_96_pruned


option 2

Retain more variants using less stringent r2 
plink2 --pfile dili_96_dedup        --indep-pairwise 50 5 0.5        --out pruned_corrected

Create a pruned dataset

plink2 --pfile dili_96_dedup        --extract pruned_corrected.prune.in       --make-pfile        --out dili_96_pruned_corrected


3.Association testing (logistic regression)

#Fix phenotype file.
#awk 'NR==1 {print $1, $2, $3; next} {print $2, $2, $3}' phenotype_categorical.txt > phenotype_fixed.txt

#Fix covariates
#awk 'NR==1 {print $1, $2, $3, $4, $5, $6, $7, $8; next} {print $2, $2, $3, $4, $5, $6, $7, $8}' covariates.txt > covariates_fixed.txt

Run association
option 1

plink2   --pfile dili_96_pruned   --pheno phenotype_fixed.txt   --pheno-name Phenotype   --covar covariates_corrected.txt  --covar-name gender,smoker,alcohol,hiv_status   --glm firth-fallback   --adjust   --out dili_96_assoc

option2
 
plink2   --pfile dili_96_pruned_corrected   --pheno phenotype_fixed.txt   --pheno-name Phenotype   --covar covariates_corrected.txt  --covar-name gender,smoker,alcohol,hiv_status   --glm firth-fallback   --adjust   --out dili_96_assoc_corrected

4.SNPs with significant or suggestive associations.
Extract SNPs with p < 0.05
Check the column number
head -n 1 dili_96_assoc.Phenotype.glm.logistic.hybrid | tr '\t' '\n' | nl
Significant snps
option 1
awk 'NR==1 || $16 < 0.05' dili_96_assoc.Phenotype.glm.logistic.hybrid >  dili_96_assoc_sig.txt

option 2
awk 'NR==1 || $16 < 0.05' dili_96_assoc_corrected.Phenotype.glm.logistic.hybrid > dili_96_assoc_sig_corrected.txt

end
