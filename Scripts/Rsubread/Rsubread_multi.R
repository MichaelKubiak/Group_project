#! /usr/bin/Rscript
library(Rsubread)
library(argparse)

# Argparse
parser <- ArgumentParser(description="takes fastq files inputs and output file prefix for scPipe iterations")
parser$add_argument('--SRR', help='SRR prefix on input/output files')
parser$add_argument('--build_index', help='Set to TRUE if an index has not previously been constructed or the reference have been changed', default = FALSE)

arguments <- parser$parse_args()
prefix <- arguments[1]
rebuild_index <- arguments[2]
data_dir = "."

if (rebuild_index=='T'){
  rebuild_index=TRUE
}

print(isTRUE(rebuild_index))

# Reference file path:
reference_fasta = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/Reference_genome/ensembl/Homo_sapiens.GRCh38.dna.primary_assembly.fa")  
reference_anno = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/Reference_genome/ensembl/Homo_sapiens.GRCh38.97.chr.gtf") 

# breakdown file names into constituent parts for file renaming
fastq_file1 = paste(prefix, "_1.fastq.gz", sep = "")
fq_R1 = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/DATA_fastQ/Test_fastq/", fastq_file1) 

fastq_file2 = paste(prefix, "_2.fastq.gz", sep = "")
fq_R2 = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/DATA_fastQ/Test_fastq/", fastq_file2)


# Rsubread build/align to human reference genome if no index present
if (rebuild_index == TRUE){
  print("Building index from reference files")
  Rsubread::buildindex(basename=file.path(data_dir, "read_index"), reference=reference_fasta, 
                       gappedIndex = TRUE, indexSplit = TRUE)
  index = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/testing/", prefix)
} else{
  print("using available reference index:")
  print(prefix)
  index = file.path("/home/izzy_r/Group_project/Project_repo/Group_project/testing/Index")
}


print("Rsubread align start")
out.aln.bam <- paste(prefix, "out.aln.bam", sep = "")
Rsubread::align(index=file.path(index, "read_index"),
                readfile1=fq_R1,readfile2=fq_R2,
                output_file=file.path(data_dir, out.aln.bam), 
                type=0, nthreads=3 )
print("Rsubread align end")

featurecounting <- Rsubread::featureCounts(files = file.path(data_dir, out.aln.bam),
                                           
                                           #annotation
                                           annot.inbuilt = NULL,
                                           annot.ext = reference_anno,
                                           isGTFAnnotationFile = TRUE,
                                           GTF.featureType = "exon",
                                           GTF.attrType = "gene_name",
                                           chrAliases = NULL,
                                           
                                           #level of summarisation
                                           useMetaFeatures = TRUE,
                                           
                                           #overlap between reads and features
                                           allowMultiOverlap = FALSE,
                                           minOverlap = 1,
                                           fracOverlap = 0,
                                           fracOverlapFeature = 0,
                                           largestOverlap = FALSE,
                                           nonOverlap = 0,
                                           nonOverlapFeature = NULL,
                                           
                                           #Read shifts, extension and reduction
                                           readShiftType = "upstream",
                                           readShiftSize = 0,
                                           readExtension5 = 0,
                                           readExtension3 = 0,
                                           read2pos = 0,
                                           
                                           #multi-mapping reads
                                           countMultiMappingReads = TRUE,
                                           
                                           #fractional counting
                                           fraction = FALSE,
                                           
                                           #long reads with nanopore etc
                                           isLongRead = FALSE,
                                           
                                           #read filtering
                                           minMQS = 0,
                                           splitOnly = FALSE,
                                           nonSplitOnly = FALSE,
                                           primaryOnly = FALSE,
                                           ignoreDup = FALSE,
                                           
                                           #strandness
                                           strandSpecific = 0,
                                           
                                           #exon-exon junctions
                                           juncCounts = FALSE,
                                           genome = reference_fasta,
                                           
                                           #Pair-end data parameters
                                           isPairedEnd = TRUE,
                                           requireBothEndsMapped = TRUE,
                                           
                                           checkFragLength = FALSE,
                                           minFragLength = 20,
                                           maxFragLength = 300,
                                           countChimericFragments = TRUE,
                                           autosort = TRUE,
                                           
                                           #CPU thread count
                                           nthreads = 3,
                                           
                                           #read group
                                           byReadGroup = FALSE,
                                           
                                           #Report assignment result for each read
                                           reportReads = "CORE",
                                           #Null = save report file in working directory
                                           reportReadsPath = NULL,
                                           
                                           #miscellaneous
                                           maxMOp =10,
                                           tmpDir=".",
                                           verbose = TRUE
)

# Write the output to a file:
gene_counting.csv <- paste(prefix, "gene_counting.csv", sep = "")
write.table(featurecounting[["counts"]],file = gene_counting.csv, col.names = NA, sep = "\t")


