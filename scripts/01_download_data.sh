!/bin/bash

#Downlaod and Convert SRA files to FASTQ format

SRR_LIST=$(cat ../data/metadata/SRR_accessions.txt)

for SRR in $SRR_LIST 
do 
	echo "Downloading $SRR..."
	prefetch $SRR -o ~/ncbi_cache

	echo "Converting $SRR to FASTQ.."
	fastq-dump --split-files --gzip ~/ncbi_cache/sra/$SRR.sra -o ../data/raw
done








