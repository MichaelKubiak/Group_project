library(scPipe)
library(SingleCellExperiment)
data_dir = "."

# file path:
ERCCfa_fn = system.file("extdata", "ERCC92.fa", package = "scPipe")
ERCCanno_fn = system.file("extdata", "ERCC92_anno.gff3", package = "scPipe")
barcode_annotation_fn = system.file("extdata", "barcode_anno.csv", package = "scPipe")

# The read structure for this example is paired-ended, with the first longer read mapping to transcripts and second shorter read consisting of 6bp UMIs followed by 8bp cell barcodes. NOTE: by convention, scPipe always assumes read1 refers to the read with the transcript sequence, which is usually the longer read. These data are also available in the in extdata folder:
fq_R1 = system.file("extdata", "simu_R1.fastq.gz", package = "scPipe")
fq_R2 = system.file("extdata", "simu_R2.fastq.gz", package = "scPipe")

#Fastq reformatting
sc_trim_barcode(file.path(data_dir, "combined.fastq.gz"),
                fq_R1,
                fq_R2,
                read_structure = list(bs1=-1, bl1=0, bs2=6, bl2=8, us=0, ul=6))

if(.Platform$OS.type != "windows"){
  Rsubread::buildindex(basename=file.path(data_dir, "ERCC_index"), reference=ERCCfa_fn)
  
  Rsubread::align(index=file.path(data_dir, "ERCC_index"),
                  readfile1=file.path(data_dir, "combined.fastq.gz"),
                  output_file=file.path(data_dir, "out.aln.bam"), phredOffset=64)
}

# Assigning reads to annotated exons
if(.Platform$OS.type != "windows"){
  sc_exon_mapping(file.path(data_dir, "out.aln.bam"),
                  file.path(data_dir, "out.map.bam"),
                  ERCCanno_fn)
}

# De-multiplexing data and counting genes
if(.Platform$OS.type != "windows"){
  sc_demultiplex(file.path(data_dir, "out.map.bam"), data_dir, barcode_annotation_fn,has_UMI=FALSE)
  
  sc_gene_counting(data_dir, barcode_annotation_fn)
}

