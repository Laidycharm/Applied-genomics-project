#!/bin/bash

#Downlaod and Convert SRA files to FASTQ format

SRR_LIST=$(cat ../data/metadata/SRR_accession.txt)

for SRR in $SRR_LIST 
do 
# Skip if already converted
    if [ -f ../data/raw/${SRR}_1.fastq.gz ]; then
        echo "$SRR already exists, skipping..."
        continue
fi
	echo "Downloading $SRR..."
    prefetch $SRR -O ~/ncbi_cache

    echo "Converting $SRR to FASTQ..."
    # Check which path structure prefetch used
    if [ -f ~/ncbi_cache/sra/$SRR/$SRR.sra ]; then
        fastq-dump --split-files --gzip ~/ncbi_cache/sra/$SRR/$SRR.sra -O ~/Applied-genomics-project/data/raw
    elif [ -f ~/ncbi_cache/$SRR/$SRR.sra ]; then
        fastq-dump --split-files --gzip ~/ncbi_cache/$SRR/$SRR.sra -O ~/Applied-genomics-project/data/raw
    else
        echo "ERROR: Could not find $SRR.sra after download!"
    fi
done
