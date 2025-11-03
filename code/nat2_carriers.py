import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.stats as stats

# === 1. Load genotype data ===
geno = pd.read_csv("genotypes.txt", sep="\t", header=None, names=["Sample", "GT"])
geno = geno.dropna(subset=["GT"])

# === 2. Create carrier vs non-carrier ===
def carrier_status(gt):
    if gt == "0/0":
        return "Non-carrier (Wildtype)"
    else:  # 0/1 or 1/1
        return "Carrier (Variant)"

geno["Carrier_Status"] = geno["GT"].apply(carrier_status)

# === 3. Load phenotype (ALT) data ===
alt = pd.read_csv("phenotype.txt", sep="\t")  # columns: Sample, ALT

# === 4. Merge by sample ID ===
merged = pd.merge(alt, geno, on="Sample")

# === 5. Kruskal–Wallis test ===
groups = [group["ALT"].values for name, group in merged.groupby("Carrier_Status")]
if len(groups) > 1:
    stat, p = stats.kruskal(*groups)
    print(f"Kruskal–Wallis p-value = {p:.4e}")
else:
    p = None
    print("Not enough groups for statistical testing.")

# === 6. Plotting ===
plt.figure(figsize=(6, 6))
sns.set(style="ticks", font_scale=1.2)  # no grid

palette_colors = ["#4C72B0", "#C44E52"]  # Blue for Non-carrier, Red for Carrier

sns.boxplot(
    x="Carrier_Status",
    y="ALT",
    data=merged,
    order=["Non-carrier (Wildtype)", "Carrier (Variant)"],
    palette=palette_colors,
    showfliers=False,
    width=0.6
)

# Labels and title
plt.title(
    f"ALT Levels by Carrier Status\n(Kruskal–Wallis p = {p:.3e})" if p else "ALT Levels by Carrier Status",
    fontsize=14, weight='bold'
)
plt.xlabel("Carrier Status", fontsize=13)
plt.ylabel("ALT (U/L)", fontsize=13)
plt.tight_layout()

# Save figure
plt.savefig("nat2_boxplot_carriers.png", dpi=300, bbox_inches="tight")
print("✅ Boxplot saved as nat2_boxplot_carriers.png")
