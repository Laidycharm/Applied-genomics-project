#!/bin/bash

#Align all samples to the reference genome using HISAT2

SRR_LIST=$(cat ../data/metadata/SRR_accession.txt)

for SRR in $SRR_LIST
do 
	echo "Aligning $SRR..."
	hisat2 -p 4 -x ../reference/index/mouse_index\
	-1 ../data/raw/${SRR}_1.fastq.gz \
	-2 ../data/raw/${SRR}_2.fastq.gz \
	-S ../alignment/sam/${SRR}.sam \
	2> ../alignment/logs/${SRR}_align.log
done
