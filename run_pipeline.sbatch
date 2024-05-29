#SBATCH --job-name=gsloh  # Name of the job
#SBATCH --partition=bmh
#SBATCH --chdir=/home/mlensink/gsloh_pseudogenization
#SBATCH --account=gmonroegrp            # Name of the partition
#SBATCH --nodes=1                       # Number of nodes
#SBATCH --ntasks=50                      # Number of tasks (usually, cores)
#SBATCH --mem=10G                       # Memory needed
#SBATCH --time=48:00:00                 # Time limit hrs:min:sec
#SBATCH --output=gsloh_%j.out       # Standard output
#SBATCH --error=gsloh_%j.err        # Standard error

#define permutation 
export NUM_RUNS=1000

#load correct environment

#Run snakemake
snakemake -j 50