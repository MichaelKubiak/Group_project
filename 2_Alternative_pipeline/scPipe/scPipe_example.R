# To process the data, we need the genome fasta file, gff3 exon annotation and a cell barcode annotation. The barcode annotation should be a .csv file with at least two columns, where the first column has the cell id and the second column contains the barcode sequence. We use ERCC spike-in genes for this demo. All files can be found in the extdata folder of the scPipe package:
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

