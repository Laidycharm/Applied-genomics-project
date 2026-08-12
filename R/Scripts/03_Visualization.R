# 1. VST transformation (for all visualizations)
vsd <- vst(dds, blind = FALSE)
vst_mat <- assay(vsd)

# Create figures directory
dir.create("R/Results/Figures", recursive = TRUE, showWarnings = FALSE)

# 2. PCA Plot
pca_data <- plotPCA(vsd, intgroup = "Condition", returnData = TRUE)
pct_var <- round(100 * attr(pca_data, "percentVar"))

pca_plot <- ggplot(pca_data, aes(x = PC1, y = PC2,
                                 colour = Condition, label = name)) +
  geom_point(size = 6, alpha = 0.9) +
  ggrepel::geom_text_repel(size = 3.5) +
  xlab(paste0("PC1: ", pct_var[1], "% variance")) +
  ylab(paste0("PC2: ", pct_var[2], "% variance")) +
  scale_colour_manual(values = c("Control" = "#2B5C8F",
                                 "Flu4" = "#E47F22",
                                 "Flu8" = "#CA392B")) +
  theme_bw() +
  ggtitle("PCA of VST-transformed counts") +
  theme(legend.position = "right",
        plot.title = element_text(hjust = 0.5))

# Save the plot
ggsave("R/Results/Figures/PCA_plot.png",
       plot = pca_plot,
       width = 8, height = 6, dpi = 300)

# Display the plot
print(pca_plot)

cat("PCA plot saved successfully\n")



# 2. Sample Distance Heatmap
# Calculate sample distances
sampleDists <- dist(t(vst_mat))
sampleDistMatrix <- as.matrix(sampleDists)

# Set row and column names to condition + sample ID
rownames(sampleDistMatrix) <- paste(vsd$Condition, colnames(vst_mat), sep = "_")
colnames(sampleDistMatrix) <- rownames(sampleDistMatrix)

# Create annotation for conditions
annotation <- data.frame(Condition = vsd$Condition)
rownames(annotation) <- rownames(sampleDistMatrix)

# Color scheme
colors <- colorRampPalette(rev(brewer.pal(9, "Blues")))(255)

# Plot and save
png("R/Results/Figures/sample_distance_heatmap.png",
    width = 800, height = 700)
pheatmap(sampleDistMatrix,
         main = "Sample Distance Heatmap")
dev.off()
cat("Done\n")


# Volcano plots
# Flu4 vs Control
png("R/Results/Figures/volcano_Flu4_vs_Control.png",
    width = 900, height = 700)
EnhancedVolcano(res_D4,
                lab = rownames(res_D4),
                x = "log2FoldChange",
                y = "padj",
                title = "Flu4 vs Control",
                pCutoff = 0.05,
                FCcutoff = 1,
                pointSize = 2,
                labSize = 3,
                col = c("grey30", "forestgreen", "royalblue", "red2"),
                legendPosition = "right")
dev.off()
cat("Volcano Flu4 done\n")


# Flu8 vs Control
png("R/Results/Figures/volcano_Flu8_vs_Control.png",
    width = 900, height = 700)
EnhancedVolcano(res_D8,
                lab = rownames(res_D8),
                x = "log2FoldChange",
                y = "padj",
                title = "Flu8 vs Control",
                pCutoff = 0.05,
                FCcutoff = 1,
                pointSize = 2,
                labSize = 3,
                col = c("grey30", "forestgreen", "royalblue", "red2"),
                legendPosition = "right")
dev.off()

# Flu8 vs Flu4
png("R/results/figures/volcano_Flu8_vs_Flu4.png",
    width = 900, height = 700)
EnhancedVolcano(res_D8vs4,
                lab = rownames(res_D8vs4),
                x = "log2FoldChange",
                y = "padj",
                title = "Flu8 vs Flu4",
                pCutoff = 0.05,
                FCcutoff = 1,
                pointSize = 2,
                labSize = 3,
                col = c("grey30", "forestgreen", "royalblue", "red2"),
                legendPosition = "right")
dev.off()

cat("Volcano plots saved\n")


# Heatmaps
# Get top 50 DEGs from Flu8 vs Control (most informative comparison)
top_genes <- as.data.frame(res_D8) %>%
  tibble::rownames_to_column("gene_id") %>%
  filter(!is.na(padj)) %>%
  arrange(padj) %>%
  head(50) %>%
  pull(gene_id)

# Extract VST values for those genes
heatmap_mat <- vst_mat[top_genes, ]

# Scale by row (so we see relative expression, not absolute)
heatmap_mat_scaled <- t(scale(t(heatmap_mat)))

# Create annotation showing condition for each sample
annotation_col <- data.frame(Condition = vsd$Condition)
rownames(annotation_col) <- colnames(heatmap_mat)

# Color scheme
annotation_colors <- list(
  Condition = c("Control" = "#2B5C8F",
                "Flu4" = "#E47F22",
                "Flu8" = "#CA392B"))

# Plot and save
png("R/Results/Figures/top_DEG_heatmap.png",
    width = 900, height = 1000)
pheatmap(heatmap_mat_scaled,
         annotation_col = annotation_col,
         annotation_colors = annotation_colors,
         show_rownames = TRUE,
         show_colnames = TRUE,
         cluster_cols = TRUE,
         cluster_rows = TRUE,
         fontsize_row = 7,
         main = "Top 50 DEGs - Flu8 vs Control")
dev.off()

cat("Top DEG heatmap saved\n")


# Get top 50 DEGs from Flu4 vs Control (most informative comparison)
top_genes2 <- as.data.frame(res_D4) %>%
  tibble::rownames_to_column("gene_id") %>%
  filter(!is.na(padj)) %>%
  arrange(padj) %>%
  head(50) %>%
  pull(gene_id)

# Extract VST values for those genes
heatmap_mat2 <- vst_mat[top_genes2, ]

# Scale by row (so we see relative expression, not absolute)
heatmap_mat_scaled2 <- t(scale(t(heatmap_mat2)))

# Create annotation showing condition for each sample
annotation_col2 <- data.frame(Condition = vsd$Condition)
rownames(annotation_col2) <- colnames(heatmap_mat2)

# Color scheme
annotation_colors <- list(
  Condition = c("Control" = "#2B5C8F",
                "Flu4" = "#E47F22",
                "Flu8" = "#CA392B"))

# Plot and save
png("R/Results/Figures/top_DEG_heatmapII.png",
    width = 900, height = 1000)
pheatmap(heatmap_mat_scaled2,
         annotation_col = annotation_col2,
         annotation_colors = annotation_colors,
         show_rownames = TRUE,
         show_colnames = TRUE,
         cluster_cols = TRUE,
         cluster_rows = TRUE,
         fontsize_row = 7,
         main = "Top 50 DEGs - Flu4 vs Control")
dev.off()

cat("Top DEG heatmapII saved\n")


png("R/Results/Figures/sample_distance_heatmap.png",
    width = 800, height = 700)
pheatmap(sampleDistMatrix,
         clustering_distance_rows = sampleDists,
         clustering_distance_cols = sampleDists,
         col = colors,
         annotation_col = annotation,
         main = "Sample Distance Heatmap")
dev.off()
cat("Sample distance heatmap done\n")

