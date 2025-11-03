# === Load libraries ===
library(readxl)
library(ggplot2)
library(dplyr)
library(stringr)
library(ggpubr)

# === 1. Read and clean data ===
data <- read_excel("dili_96nat2_acetylator_status_genotype_alt.xlsx") %>%
  rename_with(str_trim) %>%
  mutate(
    acetylator_status = str_to_title(acetylator_status)
  ) %>%
  filter(acetylator_status %in% c("Fast", "Intermediate", "Slow")) %>%
  mutate(
    acetylator_status = factor(acetylator_status,
                               levels = c("Fast", "Intermediate", "Slow"))
  )

# === 2. Check normality ===
normality <- data %>%
  group_by(acetylator_status) %>%
  summarise(p_shapiro = shapiro.test(alt_measurement)$p.value, .groups = "drop")

all_normal <- all(normality$p_shapiro > 0.05)

# === 3. Choose test ===
if (all_normal) {
  test_result <- aov(alt_measurement ~ acetylator_status, data = data)
  p_value <- summary(test_result)[[1]][["Pr(>F)"]][1]
  test_name <- "ANOVA"
} else {
  test_result <- kruskal.test(alt_measurement ~ acetylator_status, data = data)
  p_value <- test_result$p.value
  test_name <- "Kruskal-Wallis"
}

p_label <- paste0(test_name, ": p = ", formatC(p_value, format = "f", digits = 3))

# === 4. Define max y and colors ===
max_y <- ceiling(max(data$alt_measurement, na.rm = TRUE) / 200) * 200
group_colors <- c("Fast"="#ff7f50", "Intermediate"="#6fb1ff", "Slow"="#d28ef5")

# === 5. Create plot with straight points ===
p <- ggplot(data, aes(x = acetylator_status, y = alt_measurement, fill = acetylator_status)) +
  geom_boxplot(
    outlier.shape = NA,
    width = 0.6,
    color = "black",
    linewidth = 0.5
  ) +
  geom_point(
    size = 3,
    shape = 21,
    fill = "black",
    color = "black",
    alpha = 0.8
    # No position argument: points stay perfectly vertical
  ) +
  scale_fill_manual(values = group_colors) +
  scale_y_continuous(
    breaks = seq(0, max_y, by = 200),
    limits = c(0, max_y)
  ) +
  labs(
    title = "ALT Levels by Acetylator Status",
    x = "Acetylator Status",
    y = "ALT Measurements (IU/L)"
  ) +
  annotate("text", x = 2, y = max_y * 0.95, label = p_label, size = 5, fontface = "bold") +
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

# === 6. Display and save ===
print(p)

ggsave(
  filename = "ALT_by_acetylator_status.png",
  plot = p,
  width = 8,
  height = 6,
  dpi = 300
)

cat("Plot saved as 'ALT_by_acetylator_status.png' in your current working directory.\n")
