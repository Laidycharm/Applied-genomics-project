#!/bin/bash

#Downlaod and Convert SRA files to FASTQ format

SRR_LIST=$(cat ../data/metadata/SRR_accessions.txt)

for SRR in $SRR_LIST 
do 
	echo "Downloading $SRR..."
	prefetch $SRR -o ~/ncbi_cache

	echo "Converting $SRR to FASTQ.."
	fastq-dump --split-files --gzip ~/ncbi_cache/sra/$SRR.sra -o ../data/raw
done







To download reference genome
wget https://ftp.ensembl.org/pub/release-116/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna_rm.primary_assembly.fa.gz

To download reference index
wget https://ftp.ensembl.org/pub/release-116/gtf/mus_musculus/Mus_musculus.GRCm39.116.gtf.gz

