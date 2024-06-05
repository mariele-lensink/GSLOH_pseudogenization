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
    params:
        num_runs = NUM_RUNS
    log: "logs/run_slim.log"
    shell:
        """
        for i in $(seq 1 {params.num_runs}); do
            slim -d i=$i {input.slim_script} > {log} 2>&1
        done
        """

# Rule to analyze mutants with the Python script
rule analyze_mutants:
    input:
        mutant_files = expand(f"{mutants_dir}/gsloh_mutants_{{i}}.txt", i=range(1, NUM_RUNS + 1)),
        python_script = 'analyze_mutants.py'
    output:
        final_output = f"{output_dir}/final_output.txt"
    log:
        "logs/analyze_mutants.log"
    shell:
        """
        python {input.python_script} > {log} 2>&1
        """

# Define the final rule
rule all:
    input:
        final_output = f"{output_dir}/final_output.txt"