import pandas as pd

# === Load cleaned PLINK results ===
plink = pd.read_csv("assoc_results_cleaned.txt", sep='\s+')

# Add Position column to match VEP format (e.g., 3:119780404-119780404)
plink["Position"] = plink["CHR"].astype(str) + ":" + plink["BP"].astype(str) + "-" + plink["BP"].astype(str)

# === Load VEP annotation file ===
vep = pd.read_csv("vep_annotated.txt", sep="\t")  # change separator if needed

# === Merge PLINK + VEP on Position ===
merged = pd.merge(plink, vep, on="Position")

# === Filter for significant SNPs (p < 0.05) ===
significant = merged[merged["P"] < 0.05]

# === Save output ===
merged.to_csv("assoc_annotated_merged.txt", sep="\t", index=False)
significant.to_csv("assoc_annotated_significant.txt", sep="\t", index=False)

# === Done ===
print(f"✅ Done. Merged total: {len(merged)} SNPs")
print(f"🔎 Significant SNPs (P < 0.05): {len(significant)}")
