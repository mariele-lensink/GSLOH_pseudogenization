rule all:
    input:
        "final_output.txt"

rule run_slim:
    output:
        "gsloh_mutants_{i}.txt"
    shell:
        """
        slim my_slim_script.slim {wildcards.i} > {output}
        """

rule analyze_output:
    input:
        "gsloh_mutants_{i}.txt"
    output:
        "temp_analysis_{i}.txt"
    shell:
        """
        python analyze_mutants.py {input}
        """

rule combine_results:
    input:
        expand("temp_analysis_{i}.txt", i=range(1, 1001))
    output:
        "final_output.txt"
    run:
        import pandas as pd
        dfs = [pd.read_csv(f) for f in input]
        combined_df = pd.concat(dfs, ignore_index=True)
        combined_df.to_csv(output[0], index=False)
