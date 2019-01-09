#!/usr/bin/bash
#
#SBATCH --job-name=trim_se
#SBATCH --ntasks=1
#SBATCH --get-user-env
#SBATCH --cpus-per-task=12
#SBATCH --mem=4000
#SBATCH --partition=highio
#SBATCH --time=2160
#SBATCH --output=/results/SLURM_debug/trim_se_%A_%a.out
#SBATCH --error=/results/SLURM_debug/trim_se_%A_%a.out

set -e
set -x


#----------------------------------------------------------------------------------------
# Trim low quality bases w/ Trimmomatic for single-end reads
#----------------------------------------------------------------------------------------
trim_dir=$1
OUT_DIR=$2
FILES=$3

FILELINE=$((SLURM_ARRAY_TASK_ID + 1 ))
F1=$(sed "${FILELINE}q;d" "$FILES")

# Might need to change this based on the fastq filename 
#name=${F1/_R1_001.fastq.gz/}; name=${name/.R1.fastq.gz}; name=$(basename $name)
#name=${F1/_R1_001.fq.gz/}; name=${name/.R1.fq.gz}; name=$(basename $name)
name=${F1/.R1.gz/}; name=${name/.R1.fq.gz}; name=$(basename $name)

java -jar $trim_dir/trimmomatic-0.35.jar \
    SE -threads 12 -phred33 $F1 \
    ${OUT_DIR}/${name}.trim.fq.gz  \
    ILLUMINACLIP:$trim_dir/adapters/TruSeq3-SE.fa:2:30:10 LEADING:5 TRAILING:5 \
    SLIDINGWINDOW:4:15 MINLEN:36

