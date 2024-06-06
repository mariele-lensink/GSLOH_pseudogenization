#!/bin/bash

#SBATCH --job-name=gsloh  # Name of the job
#SBATCH --partition=bmh
#SBATCH --chdir=/home/mlensink/GSLOH_pseudogenization
#SBATCH --account=gmonroegrp            # Name of the partition
#SBATCH --nodes=1                       # Number of nodes
#SBATCH --ntasks=50                      # Number of tasks (usually, cores)
#SBATCH --mem=10G                       # Memory needed
#SBATCH --time=48:00:00                 # Time limit hrs:min:sec
#SBATCH --output=gsloh_%j.out       # Standard output
#SBATCH --error=gsloh_%j.err        # Standard error


#load correct environment
source ~/.bashrc
source ~/anaconda3/etc/profile.d/conda.sh
# Activate your conda environment if needed
conda activate pseudogene_pipeline

#define permutation
export NUM_RUNS=1000

#Run snakemake
snakemake -j 50
