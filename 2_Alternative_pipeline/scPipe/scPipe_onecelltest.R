library(scPipe)
library(SingleCellExperiment)
data_dir = "."

# file path:
reference_fasta = file.path("../Reference_genome/ncbi/hg19/hg19.fna")  
reference_anno = file.path("../Reference_genome/ncbi/hg19/hg19.gff") 
# barcode_annotation_fn = system.file("extdata", "barcode_anno.csv", package = "scPipe")

fq_R1 = file.path("../DATA_fastQ/SRR1975007_1.fastq.gz") 
fq_R2 = file.path("../DATA_fastQ/SRR1975007_2.fastq.gz")

# Fastq reformatting
sc_trim_barcode(file.path(data_dir, "combined.fastq.gz"),
                fq_R1,
                fq_R2,
                read_structure = list(bs1=0, bl1=10, bs2=0, bl2=10, us=0, ul=10))


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
barcode_annotation_fn <- sc_detect_bc(combined_fasta, outcsv = "./out_barcode.csv", 
                                      bc_len = 10, max_reads = 3000000) 
# barcode_annotation_fn <- system.file("./out_barcode")

sc_demultiplex(file.path(data_dir, "out.map.bam"), data_dir, barcode_annotation_fn,has_UMI=FALSE)

sc_gene_counting(data_dir, barcode_annotation_fn)


# Quality Control
if(.Platform$OS.type != "windows"){
  sce = create_sce_by_dir(data_dir)
  dim(sce)
}


