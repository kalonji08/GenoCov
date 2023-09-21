#!/bin/bash

# Check dependencies
if ! command -v bowtie2 &> /dev/null; then
    echo "bowtie2 could not be found. Please install Bowtie2."
    exit
fi

if ! command -v samtools &> /dev/null; then
    echo "samtools could not be found. Please install Samtools."
    exit
fi

# Argument parsing
while getopts ":m:p:o:" opt; do
    case $opt in
        m) mapping_file="$OPTARG"
        ;;
        p) path_file="$OPTARG"
        ;;
        o) output_file="$OPTARG"
        ;;
        \?) echo "Invalid option -$OPTARG" >&2
        ;;
    esac
done

# Check for input arguments
if [[ ! -f "$mapping_file" ]] || [[ ! -f "$path_file" ]]; then
    echo "Mapping or path file not provided or does not exist."
    exit
fi

# Pass arguments to the core script
./core_coverage_calculation.sh "$mapping_file" "$path_file" "$output_file"
