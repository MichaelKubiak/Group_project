# Aiming for a full analysis from start to finish on this script
library(SummarizedExperiment)
library(SingleCellExperiment)
library(scater)
library(SC3)


# Load in data (set wd to project directory first)
gene_expression_matrix <- read.delim("./2_Alternative_pipeline/Full_data_gene_count_matrix.csv", row.names = 1)
info_file <- read.delim("./2_Alternative_pipeline/Full_Experiment_metadata.txt")

# Create SummarizedExperiment for Zinbwave input


# Zinbwave zero accounting

# Take Zinbwave SingleCellExperiment output to SC3
