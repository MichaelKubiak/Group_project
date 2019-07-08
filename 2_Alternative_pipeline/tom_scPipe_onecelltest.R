BiocManager::install("scPipe")
BiocManager::install("SingleCellExperiment")
BiocManager::install("Rsubread")


library(scPipe)
library(SingleCellExperiment)
library(Rsubread)
data_dir = "/home/tsc21/Documents/BS7120/Group_project/scPipe/"

# file path:
reference_fasta = file.path("/home/tsc21/Documents/BS7120/Group_project/scPipe/Reference_genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa")  
reference_anno = file.path("/home/tsc21/Documents/BS7120/Group_project/scPipe/Reference_genome/Homo_sapiens.GRCh38.97.chr.gff3") 
# barcode_annotation_fn = system.file("extdata", "barcode_anno.csv", package = "scPipe")

fq_R1 = file.path("/home/tsc21/Documents/BS7120/Group_project/scPipe/Test/Cell1.fastq") 
fq_R2 = file.path("/home/tsc21/Documents/BS7120/Group_project/scPipe/Test/cell2.fastq")

# Fastq reformatting
sc_trim_barcode(file.path(data_dir, "combined.fastq.gz"),
                fq_R1,
                fq_R2,
                read_structure = list(bs1=0, bl1=4, bs2=0, bl2=4, us=0, ul=0))


Rsubread::buildindex(basename=file.path(data_dir, "read_index"), reference=reference_fasta, 
                     gappedIndex = TRUE, indexSplit = TRUE)

Rsubread::align(index=file.path(data_dir, "read_index"),
                readfile1=file.path(data_dir, "combined.fastq.gz"),
                output_file=file.path(data_dir, "out.aln.bam"), 
                type=0, nthreads=3 )


# Assigning reads to annotated exons
sc_exon_mapping(file.path(data_dir, "out.aln.bam"),
                file.path(data_dir, "out.map.bam"),
                reference_anno)


# De-multiplexing data and counting genes

combined_fasta = file.path("combined.fastq.gz")
sc_detect_bc("/home/tsc21/Documents/BS7120/Group_project/scPipe/combined.fastq.gz", outcsv = "/home/tsc21/Documents/BS7120/Group_project/scPipe/out_barcode.csv", 
                                      bc_len = 4, max_reads = 3000000) 

barcode_annotation_fn <- file.path("/home/tsc21/Documents/BS7120/Group_project/scPipe/out_barcode.csv")

# barcode_annotation_fn <- system.file("./out_barcode")

sc_demultiplex(file.path(data_dir, "out.map.bam"), data_dir, barcode_annotation_fn,has_UMI=FALSE)

sc_gene_counting(data_dir, barcode_annotation_fn)


# Quality Control
if(.Platform$OS.type != "windows"){
  scPipe_sce = create_sce_by_dir(data_dir)
  dim(scPipe_sce)
}


