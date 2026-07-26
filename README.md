
This project uses RNA-seq data from the GSE96870 dataset (NCBI SRA) with SRR_accesssion I.D of :SRR5364316, SRR5364317, SRR5364318,SRR5364319, SRR5364321, SRR5364322,SRR5364323,SRR5364325,SRR5364330. Nine paired reads samples derived from mouse (Mus musculus) cerebellum tissue. The dataset 
includes paired-end Illumina sequencing reads comparing female and male non-infected control mice to mice infected with Influenza A across two time points (Day 4 and Day 8 
post-infection). Samples are organized into three conditions with two biological replicates each: Non-Infected (Day 0), Influenza-infected (Day 4), 
and Influenza-infected (Day 8).

## FASTQC QUALITY ASSESSMENT

FastQC was run on the raw paired-end reads for each sample and inspected three metrics across all sra ( Per base sequence quality,Adapter content,Sequence duplication levels). 


## Week 3: Alignment Results

All 6 samples were aligned to the Mus musculus reference genome (GRCm39) using HISAT2. The overall alignment rates for each sample are shown below:

| SampleID    | Condition          | Replicate | Alignment Rate |
|-------------|--------------------|-----------|----------------|
| SRR5364316  | Non-Infected_Day0  | 1         | 100%           |
| SRR5364317  | Non-Infected_Day0  | 2         | 100%           |
| SRR5364322  | Non-Infected Day0  | 3         |                |
| SRR5364318  | Influenza_Day4     | 1         | 100%           |
| SRR5364319  | Influenza_Day4     | 2         |                |
| SRR5364323  | Influenza_Day4     | 3         | 100%           |
| SRR5364321  | Influenza_Day8     | 1         | 100%           |
| SRR5364325  | Influenza_Day8     | 2         |                |
| SRR5364330  | Influenza_Day8     | 3         | 100%           |

No samples were flagged for low alignment rate. All samples exceeded the 75% threshold, indicating high quality alignments across all conditions.












