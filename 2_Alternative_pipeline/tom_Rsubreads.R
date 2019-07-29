
library(SingleCellExperiment)
library(Rsubread)
#library(devtools)
#install_github("rezakj/iCellR")

# Initial one cell test for Rsubread

data_dir = "/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/scPipe/Test"

# file path:
reference_fasta = file.path("/home/tsc21/Documents/BS7120/Group_project/scPipe/Reference_genome/GRCh38.p12.genome.fa")  
reference_anno = file.path("/home/tsc21/Documents/BS7120/Group_project/scPipe/Reference_genome/gencode.v31.annotation.gtf") 
# barcode_annotation_fn = system.file("extdata", "barcode_anno.csv", package = "scPipe")

fq_R1 = file.path("/home/tsc21/Documents/BS7120/Group_project/scPipe/Test/Barcoding/SRR1974543_1.fastq.gz") 
fq_R2 = file.path("/home/tsc21/Documents/BS7120/Group_project/scPipe/Test/Barcoding/SRR1974543_2.fastq.gz")


#Only run if the indext file is required for the reference genome
#Rsubread::buildindex(basename=file.path(data_dir, "read_index"), reference=reference_fasta, 
#                     gappedIndex = TRUE, indexSplit = TRUE)

Rsubread::align(index=file.path(data_dir, "Index/read_index"),
                readfile1=fq_R1,readfile2=fq_R2,
                output_file=file.path(data_dir, "out.aln.bam"), 
                type=0, nthreads=3 )

featurecounting <- Rsubread::featureCounts(files = file.path(data_dir, "out.aln.bam"),

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

#Use to check the object made by 'featureCounts'
#featurecounting

write.table(featurecounting[["counts"]],file = "gene_counting.csv", col.names = NA, sep = "\t")


