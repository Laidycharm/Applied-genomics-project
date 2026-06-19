#!/bin/bash

#Run Quality Control Using FastQC

SRR_LIST=$(cat ../data/metadata/SRR_accessions.txt)

for SRR in $SRR_LIST
do
	echo "Run Quality Control on $SRR..."
	fastqc ../data/raw/${SRR}_1.fastq.gz ../data/raw/${SRR}_2.fastq.gz -o ../qc/raw_fastqc/$SRR/
done

