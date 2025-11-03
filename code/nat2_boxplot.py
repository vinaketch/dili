import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.stats as stats

# === 1. Load genotype data (no header) ===
geno = pd.read_csv("genotypes.txt", sep="\t", header=None, names=["Sample", "GT"])
geno = geno.dropna(subset=["GT"])

# Convert numeric genotypes to readable names
geno["Genotype"] = geno["GT"].replace({
    "0/0": "Wildtype (0/0)",
    "0/1": "Heterozygous (0/1)",
    "1/1": "Homozygous Mutant (1/1)"
})

# === 2. Load phenotype (ALT) data ===
alt = pd.read_csv("phenotype.txt", sep="\t")  # columns: Sample, ALT

# === 3. Merge by sample ID ===
merged = pd.merge(alt, geno, on="Sample")

# === 4. Kruskal–Wallis test ===
groups = [group["ALT"].values for name, group in merged.groupby("Genotype")]
if len(groups) > 1:
    stat, p = stats.kruskal(*groups)
    print(f"Kruskal–Wallis p-value = {p:.4e}")
else:
    p = None
    print("Not enough genotype groups for statistical testing.")

# === 5. Plotting ===
plt.figure(figsize=(8, 6))
sns.set(style="ticks", font_scale=1.2)  # no grid

genotype_order = ["Wildtype (0/0)", "Heterozygous (0/1)", "Homozygous Mutant (1/1)"]
palette_colors = ["#4C72B0", "#55A868", "#C44E52"]  # Blue, Green, Red

sns.boxplot(
    x="Genotype",
    y="ALT",
    data=merged,
    order=genotype_order,
    palette=palette_colors,
    showfliers=False,
    width=0.6
)

# Labels and title
plt.title(
    f"ALT Levels by NAT2 Genotype\n(Kruskal–Wallis p = {p:.3e})" if p else "ALT Levels by NAT2 Genotype",
    fontsize=14, weight='bold'
)
plt.xlabel("NAT2 Genotype", fontsize=13)
plt.ylabel("ALT (U/L)", fontsize=13)
plt.tight_layout()

# Save figure
plt.savefig("nat2_boxplot_clean.png", dpi=300, bbox_inches="tight")
print("✅ Clean boxplot saved as nat2_boxplot_clean.png")
