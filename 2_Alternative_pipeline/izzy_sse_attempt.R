# Aiming for a full analysis from start to finish on this script
library(SummarizedExperiment)
library(SingleCellExperiment)
library(scater)
library(SC3)
library(zinbwave)

# Load in data (set wd to project directory first)
gene_expression_matrix <- read.delim("./combined_data", row.names = 1, header = TRUE)
info_file <- read.delim("2_Alternative_pipeline/SraRunTable_all.txt")

truncated_expression_matrix <- gene_expression_matrix[1:22085,]
# gene_expression_matrix <- data.frame(gene_expression_matrix)
# start=0, end=466

# Remove all 0 expressed genes from the dataset:
truncated_expression_matrix <- truncated_expression_matrix[rowSums(truncated_expression_matrix[, -1])>0, ]
truncated_expression_matrix
# Create SummarizedExperiment for Zinbwave input
#sum_exp <- makeSummarizedExperimentFromDataFrame(df = gene_expression_matrix, start.field=1:1, end.field=22088:466,ignore.strand=FALSE,
#                                      starts.in.df.are.0based = TRUE)

# Go straight to making a summarisedexperiment?
sum_exp <- SummarizedExperiment(
  assays = list(
    counts = as.matrix(truncated_expression_matrix),
    logcounts = log2(as.matrix(truncated_expression_matrix) + 1)
  ), 
  colData = info_file
)

# printing the summarisedexperiment data
sum_exp

# Zinbwave zero accounting:
# This is a flexible zero-inflated negative binomial model for low dimensional representations of single-cell RNA Seq
# data. 
# Zimbwave takes a SummarizedExperiment and returns a SingleCellExperiment object
# k=how many latent variables we want to infer from the data, epsilon=num_genes
sce <- zinbwave(sum_exp, K=14, epsilon=13437)

# Data normalisation with Scater
# Takes SingleCellExperiment input
norm_sce <- normalize(sce)
plotExplanatoryVariables(norm_sce)

norm_sce

norm_sce <- calculateQCMetrics(norm_sce)


# SC3 clustering 
# define feature names in feature_symbol column
rowData(norm_sce)$feature_symbol
rowData(norm_sce)$feature_symbol <- rownames(norm_sce)
rowData(norm_sce)$feature_symbol

# plot PCA 
plotPCA(sce, colour_by = "cell_type")

# SC3 
sce <- sc3(norm_sce, ks = 9:19, biology = TRUE)

# Display browser based interactive graphing.
sc3_interactive(sce)

# create xls file of results
# sc3_export_results_xls(sce)

col_data <- colData(sce)
head(col_data[ , grep("sc3_", colnames(col_data))])

plotPCA(
  sce, 
  colour_by = "sc3_3_clusters", 
  size_by = "sc3_3_log2_outlier_score"
)
