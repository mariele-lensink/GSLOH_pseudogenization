import os

# Get the number of runs from the environment variable
NUM_RUNS = int(os.getenv('NUM_RUNS', 1000))

# Define directories
mutants_dir = 'mutants'
output_dir = 'output'

# Ensure directories exist
os.makedirs(mutants_dir, exist_ok=True)
os.makedirs(output_dir, exist_ok=True)

# Rule to run SLiM script
rule run_slim:
    input:
        slim_script = 'gsloh.slim'
    output:
        mutant_files = expand(f"{mutants_dir}/gsloh_mutants_{{i}}.txt", i=range(1, NUM_RUNS + 1))
    shell:
        """
        for i in $(seq 1 {NUM_RUNS}); do
            slim -d i=$i {input.slim_script}
        done
        """

# Rule to analyze mutants with the Python script
rule analyze_mutants:
    input:
        mutant_files = expand(f"{mutants_dir}/gsloh_mutants_{{i}}.txt", i=range(1, NUM_RUNS + 1)),
        python_script = 'analyze_mutants.py'
    output:
        final_output = f"{output_dir}/final_output.txt"
    shell:
        """
        python {input.python_script}
        """

# Define the final rule
rule all:
    input:
        final_output = f"{output_dir}/final_output.txt"
