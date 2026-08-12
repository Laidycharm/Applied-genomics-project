# ---- Install packages (run once) ----

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

packages <- c(
  "DESeq2",
  "tidyverse",
  "ashr",
  "EnhancedVolcano",
  "pheatmap",
  "RColorBrewer",
  "clusterProfiler",
  "org.Mm.eg.db"
)

BiocManager::install(packages, ask = FALSE)


#Load packages
library(tidyverse)
library(ashr)
library(DESeq2)
library(EnhancedVolcano)
library(pheatmap)
library(RColorBrewer)
library(clusterProfiler)
library(org.Mm.eg.db)


# Install via Bioconductor
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("EnhancedVolcano")
