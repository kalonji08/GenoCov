#!/bin/bash

# Read arguments
mapping_file="$1"
path_file="$2"
output_file="$3"
threads="$4"
memory="$5"  # in format like "2G" for 2 gigabytes

# Default values in case they are not provided
threads=${threads:-1}
memory=${memory:-1G}

# Read paths from path-file.txt
while IFS= read -r line; do
    if [[ $line == path_to_MAGs* ]]; then
        mags_path="${line#*=}"
        mags_path="${mags_path// /}"
    elif [[ $line == path_to_Raw_reads* ]]; then
        reads_path="${line#*=}"
        reads_path="${reads_path// /}"
    fi
done < "$path_file"

# Clear the output file or create it if it doesn't exist
> "$output_file"

# Start processing each line from mapping-file.txt
while IFS=$'\t' read -r mag forward reverse; do
    # Skip the header line and any lines with missing values
    if [ "$mag" == "MAG_Name" ] || [ -z "$mag" ] || [ -z "$forward" ] || [ -z "$reverse" ]; then
        continue
    fi

    # Construct intermediate file names based on the MAG name
    sam_file="${mag%.fa}_aligned.sam"
    bam_file="${mag%.fa}_aligned.bam"
    sorted_bam_file="${mag%.fa}_aligned_sorted.bam"

    echo "Processing $mag with reads $forward and $reverse..."

    # Check if the MAG is indexed, and if not, index it
    if [ ! -f "$mags_path/${mag}.1.bt2" ]; then
        echo "Indexing $mag..."
        bowtie2-build "$mags_path/$mag" "$mags_path/$mag"
    fi

    # Align reads to the MAG using Bowtie2 with provided thread count
    bowtie2 -x "$mags_path/$mag" -1 "$reads_path/$forward" -2 "$reads_path/$reverse" -S "$sam_file" -p "$threads"

    # Convert SAM to BAM, sort BAM, and compute coverage with provided memory configuration
    samtools view -@ "$threads" -bS "$sam_file" > "$bam_file"
    samtools sort -@ "$threads" -m "$memory" "$bam_file" -o "$sorted_bam_file"
    coverage=$(samtools depth -@ "$threads" "$sorted_bam_file" | awk '{sum+=$3} END {print sum/NR}')

    # Append to output file
    echo "$mag $coverage" >> "$output_file"

    # Clean up intermediate files
    rm "$sam_file" "$bam_file" "$sorted_bam_file"

    echo "$mag processing completed!"

done < "$mapping_file"

echo "Coverage calculation completed! Check $output_file for results."
