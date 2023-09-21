## **GenoCov: A Metagenomic Coverage Calculator**

**GenoCov** is a straightforward and efficient bash-based tool designed to calculate coverage of Metagenome-Assembled Genomes (MAGs) against shotgun metagenomic reads.

### **Features:**

- Automates read mapping, SAM to BAM conversion, sorting, and coverage calculation.
- Uses **`bowtie2`** for alignment and **`samtools`** for SAM/BAM processing.
- User-friendly configuration via a mapping file and a paths file.

### **Dependencies:**

1. **[Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)**
2. **[Samtools](http://www.htslib.org/)**

### **Installation:**

Just clone the GitHub repository:
git clone [repository-link]
cd [GenoCov]
chmod +x MetagenomicsCoverageCalculator.sh

Usage:
./MetagenomicsCoverageCalculator.sh -m mapping-file.txt -p path-file.txt -o output-file.txt

### **Preparing Input Files:**

1. **Mapping File**:
    - A tab-delimited file with three columns: MAG_Name, forward read file, reverse read file.
    - Example:
MAG_Name	forward	        reverse
MAG51.fa	reads1_1.fq	reads1_2.fq
MAG46.fa	reads2_1.fq	reads2_2.fq

**Paths File**:

- A file containing paths to the directories holding MAGs and raw reads.
- Example:

path_to_MAGs=/path/to/MAGs-directory
path_to_Raw_reads=/path/to/reads-directory

### **Output:**

A file listing each MAG and its calculated coverage, e.g.,

MAG51.fa 35.6
MAG46.fa 42.1

### **Troubleshooting:**

- Ensure that **`bowtie2`** and **`samtools`** are correctly installed and available in your **`$PATH`**.
- Check permissions for input read files and MAGs. They should be readable.
- If an error mentions an unavailable Bowtie2 index, make sure the MAG is present in the specified directory and try manually indexing it using **`bowtie2-build`**.

### **Contribution:**

Feel free to fork, open issues, or send pull requests. All contributions are welcome!

### **License:**

### **Acknowledgements:**

GenoCov is developed by Kalonji Tshiskedi

































