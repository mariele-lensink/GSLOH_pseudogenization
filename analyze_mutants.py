import csv
import os
from Bio import SeqIO
from Bio.Seq import Seq
from threading import Lock
from pathlib import Path

lock = Lock()

def translate_dna(dna_sequence):
    """Translate a DNA sequence to a protein sequence."""
    dna_seq = Seq(str(dna_sequence))
    protein_seq = dna_seq.translate(to_stop=False)
    return protein_seq

def calculate_relative_length(protein_seq, ancestral_length):
    """Calculate the length of the protein sequence relative to the ancestral length."""
    try:
        start = protein_seq.index('M')
        end = protein_seq.index('*', start)
        protein_length = end - start
    except ValueError:
        # In case 'M' or '*' is not found
        protein_length = 0

    return protein_length, protein_length / ancestral_length * 100

def process_mutant_file(ancestral_record, ancestral_protein, ancestral_length, mutant_file_path, output_file):
    lof_proteins_count = 0
    total_mutants = 0

    with open(output_file, 'a', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)

        for record in SeqIO.parse(mutant_file_path, "fasta"):
            total_mutants += 1
            mutant_dna = record.seq
            mutant_protein = translate_dna(mutant_dna)
            length, percentage_length = calculate_relative_length(mutant_protein, ancestral_length)
            
            if length < len(ancestral_protein) * 0.9:
                lof_proteins_count += 1

        file_number = Path(mutant_file_path).stem.split('_')[-1]
        with lock:
            csvwriter.writerow([file_number, lof_proteins_count, f"{(lof_proteins_count / total_mutants) * 100:.2f}%"])


if __name__ == "__main__":
    # Read and translate the ancestral DNA sequence from a FASTA file
    ancestral_file_path = 'corrected_AT2G25450.txt'
    ancestral_record = next(SeqIO.parse(ancestral_file_path, "fasta"))
    ancestral_protein = translate_dna(ancestral_record.seq)
    ancestral_length = len(ancestral_protein)-1
    
    # Directory containing mutant files generated by SLiM script
    mutants_directory = 'mutants/'
    output_file = 'output/final_output.txt'

    # Clear or create the output file
    with open(output_file, 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow(["File_Number", "Count", "Percentage"])
    
    # Process each mutant file
    for mutant_file in Path(mutants_directory).glob("gsloh_mutants_*.txt"):
        process_mutant_file(ancestral_record, ancestral_protein, ancestral_length, mutant_file, output_file)

