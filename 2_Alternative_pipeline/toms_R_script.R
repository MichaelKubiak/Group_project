# Aiming for a full analysis from start to finish on this script
library(SummarizedExperiment)
library(SingleCellExperiment)
library(SC3)
library(zinbwave)


gene_expression_matrix <- read.delim("/home/tsc21/Documents/BS7120/Group_project/combined_data.txt", row.names = 1, header = TRUE)
info_file <- read.delim("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/SraRunTable_all.txt")

truncated_expression_matrix <- gene_expression_matrix[1:22085,]
# start=0, end=466

# Remove all 0 expressed genes from the dataset:
truncated_expression_matrix <- truncated_expression_matrix[rowSums(truncated_expression_matrix[, -1])>0, ]
truncated_expression_matrix
# Create SummarizedExperiment for Zinbwave input
#sum_exp <- makeSummarizedExperimentFromDataFrame(df = gene_expression_matrix, start.field=1:1, end.field=22088:466,ignore.strand=FALSE,
#starts.in.df.are.0based = TRUE)

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
library(BiocParallel)
sce <- zinbwave(sum_exp, K=10, epsilon=21625, normalizedValues=TRUE, BPPARAM=MulticoreParam(4))






#normalised data for SC3 analysis
norm_sce <- normalize(sce)
plotExplanatoryVariables(norm_sce)

rowData(norm_sce)$feature_symbol <- rownames(norm_sce)
# remove features with duplicated names
norm_sce <- norm_sce[!duplicated(rowData(norm_sce)$feature_symbol), ]

# plot PCA
plotPCA(norm_sce, colour_by = "cell_type")


#sc3 analysis
norm_sce <- sc3(norm_sce, ks = 5:15, biology = TRUE)

#visualise sc3 analysis
sc3_interactive(norm_sce)

#create an xls file 
sc3_export_results_xls(norm_sce)

sc3_consensus(norm_sce)
sc3_plot_consensus(sce, k = 5:15)



head(col_data[ , grep("sc3_", colnames(col_data))])


plotPCA(
  norm_sce, 
  colour_by = "cell_type", 
  size_by = "cell_type"
)
