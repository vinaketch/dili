# === Libraries ===
library(readxl)
library(ggplot2)
library(dplyr)
library(stringr)

# === 1. Read data ===
data <- read_excel("dili_96nat2_acetylator_status_genotype_alt.xlsx")

# === 2. Clean column names ===
names(data) <- str_trim(names(data))

# === 3. Create acetylator status ===
data <- data %>%
  mutate(
    genotype = str_trim(genotype),
    variant_status = ifelse(genotype %in% c("*1/*1", "*1/*4", "*4/*4"),
                            "Fast acetylator",
                            "Slow acetylator")
  )

# ✅ Ensure "Fast acetylator" is plotted first
data$variant_status <- factor(data$variant_status,
                              levels = c("Fast acetylator", "Slow acetylator"))

# === 4. Normality check (Shapiro–Wilk test) for each group ===
normality <- data %>%
  group_by(variant_status) %>%
  summarise(p_shapiro = shapiro.test(alt_measurement)$p.value)

print(normality)

all_normal <- all(normality$p_shapiro > 0.05)

# === 5. Choose statistical test ===
if (all_normal) {
  test_result <- t.test(alt_measurement ~ variant_status, data = data)
  p_value <- test_result$p.value
  test_name <- "t-test"
} else {
  test_result <- wilcox.test(alt_measurement ~ variant_status, data = data)
  p_value <- test_result$p.value
  test_name <- "Wilcoxon test"
}

# Format p-value
p_label <- paste0(test_name, ": p = ", formatC(p_value, format = "f", digits = 3))

# === 6. Define max y for scale ===
max_y <- ceiling(max(data$alt_measurement, na.rm = TRUE) / 200) * 200

# === 7. Plot ===
p <- ggplot(data, aes(x = variant_status, y = alt_measurement, fill = variant_status)) +
  geom_boxplot(
    width = 0.6,
    color = "black",
    outlier.shape = NA,
    linewidth = 0.5
  ) +
  geom_point(
    size = 3,
    shape = 21,
    fill = "black",
    color = "black",
    alpha = 0.7,
    position = position_nudge(x = 0)
  ) +
  scale_fill_manual(values = c("Fast acetylator" = "#ff7f50",
                               "Slow acetylator" = "#6fb1ff")) +
  scale_y_continuous(
    breaks = seq(0, max_y, by = 200),
    limits = c(0, max_y)
  ) +
  labs(
    title = "ALT Levels by NAT2 Acetylator Status",
    x = "NAT2 Acetylator Status",
    y = "ALT Measurements (IU/L)"
  ) +
  annotate("text", x = 1.5, y = max_y * 0.95, label = p_label, size = 5, fontface = "bold") +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black", linewidth = 0.6),
    axis.ticks = element_line(color = "black", linewidth = 0.6),
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 18),
    axis.text = element_text(size = 16),
    legend.position = "none"
  )

# === 8. Display plot ===
print(p)

# === 9. Save plot ===
ggsave("ALT_by_acetylator_status.png", plot = p, width = 8, height = 6, dpi = 300)

cat("\n✅ Plot saved as 'ALT_by_acetylator_status.png' in your working directory.\n")
cat("Statistical test used:", test_name, "\n")
cat("P-value:", round(p_value, 3), "\n")
