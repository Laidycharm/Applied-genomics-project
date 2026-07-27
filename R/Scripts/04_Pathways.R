# Get significant DEGs from Flu8 vs Control
sig_genes <- as.data.frame(res_D8) %>%
  tibble::rownames_to_column("gene_id") %>%
  filter(!is.na(padj), padj < 0.05, abs(log2FoldChange) > 1) %>%
  pull(gene_id)

cat("Number of significant DEGs:", length(sig_genes), "\n")


# KEGG &
# Convert Ensembl IDs to Entrez IDs (required for KEGG)
gene_entrez <- bitr(sig_genes,
                    fromType = "ENSEMBL",
                    toType = "ENTREZID",
                    OrgDb = org.Mm.eg.db)

cat("Genes successfully mapped:", nrow(gene_entrez), "\n")

# GO Biological Process Enrichment
go_BP <- enrichGO(gene = gene_entrez$ENTREZID,
                  OrgDb = org.Mm.eg.db,
                  ont = "BP",
                  pAdjustMethod = "BH",
                  pvalueCutoff = 0.05,
                  qvalueCutoff = 0.05,
                  readable = TRUE)

# Show top 5 GO terms
cat("\nTop 5 GO Biological Process terms:\n")
head(as.data.frame(go_BP), 5)

# KEGG Pathway Enrichment
kegg <- enrichKEGG(gene = gene_entrez$ENTREZID,
                   organism = "mmu",
                   pAdjustMethod = "BH",
                   pvalueCutoff = 0.05)

# Show top 3 KEGG pathways
cat("\nTop 3 KEGG pathways:\n")
head(as.data.frame(kegg), 3)


# GO dotplot
png("R/Results/Figures/GO_BP_dotplot.png",
    width = 900, height = 700)
dotplot(go_BP, showCategory = 10,
        title = "Top GO Biological Process Terms")
dev.off()

# KEGG dotplot
png("R/Results/Figures/KEGG_dotplot.png",
    width = 900, height = 700)
dotplot(kegg, showCategory = 10,
        title = "Top KEGG Pathways")
dev.off()

cat("Enrichment plots saved\n")



