#!/bin/bash

# Download reference genome and index

To download reference genome
wget https://ftp.ensembl.org/pub/release-116/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna_rm.primary_assembly.fa.gz -o ../reference/genome/Mus_musculus.GRCm39.dna_rm.primary_assembly.fa.gz

To download reference index
wget https://ftp.ensembl.org/pub/release-116/gtf/mus_musculus/Mus_musculus.GRCm39.116.gtf.gz -o ../reference/annotation/Mus_musculus.GRCm39.116.gtf.gz
