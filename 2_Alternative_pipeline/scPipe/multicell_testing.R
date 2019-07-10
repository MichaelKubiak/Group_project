#! /usr/bin/Rscript
library(scPipe)
library(SingleCellExperiment)
library(argparse)

# Argparse
parser <- ArgumentParser(description="takes fastq files inputs and output file prefix for scPipe iterations")
parser$add_argument('--SRR', help='SRR prefix on input/output files')
parser$add_argument('--build_index', help='Set to TRUE if an index has not previously been constructed or the reference have been changed', default = FALSE)

arguments <- parser$parse_args()
prefix <- arguments[1]
rebuild_index <- arguments[2]
data_dir = "."
print(rebuild_index)
if (rebuild_index=='T'){
  rebuild_index=TRUE
}

print(isTRUE(rebuild_index))

# Reference file path:
reference_fasta = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/Reference_genome/ensembl/Homo_sapiens.GRCh38.dna.primary_assembly.fa")  
reference_anno = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/Reference_genome/ensembl/Homo_sapiens.GRCh38.97.chr.gff3") 

# breakdown file names into constituent parts for file renaming
fastq_file1 = paste(prefix, "_1.fastq.gz", sep = "")
fq_R1 = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/DATA_fastQ/Test_fastq/", fastq_file1) 

fastq_file2 = paste(prefix, "_2.fastq.gz", sep = "")
fq_R2 = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/DATA_fastQ/Test_fastq/", fastq_file2)

# Fastq reformatting
# Rename combined fastQ:
combined_fastq.gz = paste(prefix, "combined_fastq.gz", sep = "")
# trim barcodes
print("barcoding start")
sc_trim_barcode(file.path(data_dir, combined_fastq.gz),
                fq_R1,
                fq_R2,
                read_structure = list(bs1=0, bl1=4, bs2=0, bl2=4, us=0, ul=0))
print("barcoding end")

# Rsubread build/align to human reference genome if no index present
index_folder =file.path("/home/izzy_r/Group_project/Project_repo/Group_project/2_Alternative_pipeline/scPipe/reference_index/")
if (rebuild_index == TRUE){
  print("Building index from reference files")
  Rsubread::buildindex(basename=file.path(data_dir, "read_index"), reference=reference_fasta, 
                       gappedIndex = TRUE, indexSplit = TRUE)
  index = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/testing/", prefix)
} else{
  print("using available reference index:")
  index = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/testing/Index/")
}



out.aln.bam <- paste(prefix, "out.aln.bam", sep = "")
print("Rsubread align start")
Rsubread::align(index=file.path(index, "read_index"),
                readfile1=file.path(data_dir, combined_fastq.gz),
                output_file=file.path(data_dir, out.aln.bam), 
                type=0, nthreads=3 )
print("Rsubread align end
      ")
# Assigning reads to annotated exons
print("assign reads to exon start")
out.map.bam <- paste(prefix, "out.map.bam", sep = "")
out.map.bam
sc_exon_mapping(file.path(data_dir, out.aln.bam),
                file.path(data_dir, out.map.bam),
                reference_anno, bc_len = 4, UMI_len = 0)
print("assign reads to exon end")

# Demultiplexing data
# create outbarcode.csv
print("demultiplex data start")
bc_anno_csv = paste(prefix, "barcode.csv", sep = "")
sc_detect_bc(combined_fastq.gz,
             outcsv = bc_anno_csv,
             bc_len = 4, max_reads = 3000000)

# locate the barcode file
barcode_annotation_fn <- file.path(data_dir, bc_anno_csv)

# Demultiplexing
sc_demultiplex(file.path(data_dir, out.map.bam), data_dir, barcode_annotation_fn, has_UMI=FALSE)

print("demultiplex data end")

# Gene counting step
print("Gene counting start")
sc_gene_counting(data_dir, barcode_annotation_fn)
print("Gene counting end")




