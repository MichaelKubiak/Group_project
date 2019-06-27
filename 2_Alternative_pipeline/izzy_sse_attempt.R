# Aiming for a full analysis from start to finish on this script
library(SummarizedExperiment)
library(SingleCellExperiment)
library(scater)
library(SC3)


# Load in data (set wd to project directory first)
gene_expression_matrix <- read.delim("./combined_data.txt", row.names = 1, header = TRUE)
info_file <- read.delim("./2_Alternative_pipeline/Full_Experiment_metadata.txt")

gene_expression_matrix <- data.frame(gene_expression_matrix)
# start=0, end=466
# Create SummarizedExperiment for Zinbwave input
makeSummarizedExperimentFromDataFrame(df = gene_expression_matrix, start.field=1:1, end.field=22088:466,ignore.strand=FALSE,
                                      seqnames.field=c("seqnames", "seqname", "chromosome", "chrom", "chr", "chromosome_name", "seqid"),
                                      starts.in.df.are.0based = TRUE)
# Zinbwave zero accounting

# Take Zinbwave SingleCellExperiment output to SC3
