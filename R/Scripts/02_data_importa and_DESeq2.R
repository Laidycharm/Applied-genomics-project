# Import all tabular files
#list all tabular files in counts folder
files <- list.files(
  path = "counts/featurecounts_counts",
  pattern = "\\.tabular$",
  full.names =  TRUE
)

print(files) #confirms that all the files are listed

# Read each count file
count_list <- lapply(files, function(f) {
  read.delim(f, header = TRUE)
})

#Merge all count tables by Geneid
count_matrix <- Reduce(function(x,y) merge(x,y, by = "Geneid", all = TRUE
),
    count_list)

#Set gene IDs as row names
rownames(count_matrix) <- count_matrix$Geneid
count_matrix$Geneid <- NULL #remove the redundant Geneid column

#Covert to integer matrix (required by DESEq2)
count_matrix <- as.matrix(count_matrix)
storage.mode(count_matrix) <- "integer"

#Quick check
view(count_matrix)
head(count_matrix)

# Load metadata from tsv
metadata <- read.table("data/metadata/sample_info.tsv",
                       header = TRUE,
                       stringsAsFactors = FALSE)

# Confirm if loaded correctly
print(metadata)

# Set condition as a factor with control as the reference level
metadata$Condition <- factor(metadata$Condition,
                             levels = c("Control", "Flu4", "Flu8"))

# Match metadata row order to count matrix column order
# This is critical - DEQEQ2 requires they align exactly
metadata <- metadata[match(colnames(count_matrix),metadata$SampleID), ]

# Set SampleId as rownames (DESEq2 uses this to match colData to Countdata)
rownames(metadata) <- metadata$SampleID
metadata$SampleID <- NULL
rownames(metadata)
colnames(metadata)

#confirm alignment before proceeding
cat("count_matrix columns:\n"); print(colnames(count_matrix))
cat("metadata rows:\n");        print(rownames(count_matrix))
cat("Do they match?", all(colnames(count_matrix) == rownames(metadata)), "\n")

# Create DESeq2 object
dds<- DESeqDataSetFromMatrix(
  countData = count_matrix,
  colData = metadata,
  design = ~ Condition)

# Set the reference level (control = baseline for comparison)
dds$Condition <- relevel(dds$Condition, ref = "Control")

# pre-filter low-count genes
#Remove genes with fewer than 10 counts across all samples combined
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep, ]
cat ("Genes after filtering:", nrow(dds), "\n")

# Run DESeq2
dds <- DESeq(dds)

# Extract results - all pairwise comparison-
#Flu4 vs Control
res_D4 <- results (dds,
                   contrast = c("Condition", "Flu4", "Control"),
                   alpha = 0.05)

#Flu8 vs Control
res_D8 <- results (dds,
                   contrast = c("Condition", "Flu8", "Control"),
                   alpha = 0.05)

#Flu8 vs Flu4
res_D8vs4 <- results (dds,
                   contrast = c("Condition", "Flu8", "Flu4"),
                   alpha = 0.05)
cat("=== FluD4 vs Control ===\n");  summary(res_D4)
cat("=== FluD8 vs Control ===\n");  summary(res_D8)
cat("=== FluD8 vs FluD4 ===\n");    summary(res_D8vs4)

# Export for each comparison
resultsNames(dds)  # run this first to see exact coefficient names

shrink_and_export <- function(dds, contrast, filename_prefix) {
  
  # LFC shrinkage using ashr for contrasts
  res_s <- lfcShrink(dds,
                     contrast = contrast,
                     type = "ashr")
  
  # Full results table
  df_all <- as.data.frame(res_s) %>%
    tibble::rownames_to_column("gene_id") %>%
    arrange(padj)
  
  write_tsv(
    df_all,
    paste0("R/results/Tables/", filename_prefix, "_all_genes.tsv")
  )
  
  # Significant DEGs
  df_sig <- df_all %>%
    filter(!is.na(padj), padj < 0.05, abs(log2FoldChange) > 1)
  
  write_tsv(
    df_sig,
    paste0("R/results/Tables/", filename_prefix, "_sig_DEGs.tsv")
  )
  
  cat(filename_prefix, "significant DEGs:", nrow(df_sig),
      "(up:", sum(df_sig$log2FoldChange > 0),
      "| down:", sum(df_sig$log2FoldChange < 0), ")\n")
  
  return(invisible(df_all))
}

# Run for each comparison
shrink_and_export(dds, c("Condition", "Flu4", "Control"),
                  "Flu4_vs_Control")
shrink_and_export(dds, c("Condition", "Flu8", "Control"),
                  "Flu8_vs_Control")
shrink_and_export(dds, c("Condition", "Flu8", "Flu4"),
                  "Flu8_vs_Flu4")

# Save DESeq2 object
saveRDS(dds, "R/results/Tables/dds_object.rds")
cat("Analysis complete.\n")





