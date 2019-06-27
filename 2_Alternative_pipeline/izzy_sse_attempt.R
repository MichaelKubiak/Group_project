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
                    
                                      starts.in.df.are.0based = TRUE)

# Zinbwave zero accounting:
# This is a flexible zero-inflated negative binomial model for low dimensional representations of single-cell RNA Seq
# data. 
# Zimbwave takes a SummarizedExperiment and returns a SingleCellExperiment object
sce <- zinbwave(sum_object, k=2, epsilon=22085)

# SC3 clustering 

# define feature names in feature_symbol column
rowData(sce)$feature_symbol <- rownames(sce)
# remove features with duplicated names
sce <- sce[!duplicated(rowData(sce)$feature_symbol), ]

#plot PCA 
plotPCA(sce, colour_by = "cell_type")


sce <- sc3(sce, ks = 2:10, biology = TRUE)

# Display browser based interactive graphing
sc3_interactive(sce)
sc3_export_results_xls(sce)

col_data <- colData(sce)
head(col_data[ , grep("sc3_", colnames(col_data))])

plotPCA(
  sce, 
  colour_by = "sc3_3_clusters", 
  size_by = "sc3_3_log2_outlier_score"
)
