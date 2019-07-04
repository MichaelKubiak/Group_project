if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("SC3")
BiocManager::install("SingleCellExperiment")
BiocManager::install("SummarizedExperiment")
BiocManager::install("zinbwave")
BiocManager::install("scater")

library(SummarizedExperiment)
library(SingleCellExperiment)
library(scater)
library(SC3)
library(zinbwave)


gene_expression_matrix <- read.delim("/home/tsc21/Documents/BS7120/Group_project/Data/combined_data", row.names = 1, header = TRUE)
info_file <- read.delim("/home/tsc21/Documents/BS7120/Group_project/Data/SraRunTable_all.txt")


truncated_expression_matrix <- gene_expression_matrix[1:22085,]
# start=0, end=466

# Remove all 0 expressed genes from the dataset:
truncated_expression_matrix <- truncated_expression_matrix[rowSums(truncated_expression_matrix[, -1])>0, ]

head(info_file)
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

rowData(sum_exp)$feature_symbol <- rownames(sum_exp)


# printing the summarisedexperiment data
sum_exp




# Zinbwave zero accounting:
# This is a flexible zero-inflated negative binomial model for low dimensional representations of single-cell RNA Seq
# data. 
# Zimbwave takes a SummarizedExperiment and returns a SingleCellExperiment object
# k=how many latent variables we want to infer from the data, epsilon=num_genes
library(BiocParallel)
sce <- zinbwave(sum_exp, K=9:19, epsilon=21625, verbose = TRUE)
plotPCA(sce,colour_by = "cell_type")






#normalised data for SC3 analysis
norm_sce <- normalize(sce)
plotExplanatoryVariables(norm_sce)
plotPCA(norm_sce, colour_by = "cell_type")


#prepare data for sc3 clustering
sce <- sc3_prepare(norm_sce)


#estimate the optimal cluster number for k within dataset
sce <- sc3_estimate_k(sce)

str(metadata(sce)$sc3)


#calc distances between cells
sce <- sc3_calc_dists(sce)

names(metadata(sce)$sc3$distances)



#transform distance matrix
sce <- sc3_calc_transfs(sce)

names(metadata(sce)$sc3$transformations)


#cluster data based data similarities, non-biased
sce <- sc3_kmeans(sce, ks = 9:19)

names(metadata(sce)$sc3$kmeans)


#clustering solution after kmean 
col_data <- colData(sce)
head(col_data[ , grep("sc3_", colnames(col_data))])


sce <- sc3_calc_consens(sce)


names(metadata(sce)$sc3$consensus)

names(metadata(sce)$sc3$consensus$`2`)



col_data <- colData(sce)
head(col_data[ , grep("sc3_", colnames(col_data))])



#Biology=TRUE
sce <- sc3_calc_biology(sce, ks = 9:19)

#cell outliers for each k
col_data <- colData(sce)
head(col_data[ , grep("sc3_", colnames(col_data))])


#DE and marker gene calc'd for each value k 
row_data <- rowData(sce)
head(row_data[ , grep("sc3_", colnames(row_data))])


reducedDim(sce, withDimnames = TRUE)
plotReducedDim(sce, use_dimred = "PCA", colour_by = "cell_type")


sc3_interactive(sce)
sc3_export_results_xls(sce)

plotPCA(sce, colour_by = "cell_type")

plotTSNE(sum_exp_test, colour_by = "sc3_10_clusters", rerun = TRUE)




tsne_plot_10 <- plotTSNE(sce, colour_by = "sc3_10_clusters", rerun = TRUE)

tsne_plot_10

png(filename="/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/tsne_plot_10.png", width=650, height=500)
plot(tsne_plot_10)
dev.off()



#sum_exp_test <- SingleCellExperiment(
#  assays = list(
#    counts = as.matrix(truncated_expression_matrix),
#    logcounts = log2(as.matrix(truncated_expression_matrix) + 1)
#  ), 
#  colData = info_file
#)

#rowData(sum_exp_test)$feature_symbol <- rownames(sum_exp_test)

#tsne_pre_sc3 <- plotTSNE(sum_exp_test, rerun = TRUE)

#png(filename="/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/tsne_pre_sc3.png", width=650, height=500)
#plot(tsne_pre_sc3)
#dev.off()


#plotExpression(sce, rownames(sce))

#COMPARE with distances made by Mike with the journal's pipeline

#mike_dist <- read.delim("/home/tsc21/Documents/BS7120/Group_project/distance_matrix", row.names = 1, header = TRUE)
#mike_dist <- as.dist(mike_dist)
#truncated_mike_matrix <- truncated_expression_matrix[rowSums(truncated_expression_matrix[, -1])>0, ]

#sum_exp_mike <- SingleCellExperiment(
#  assays = list(
#    counts = as.matrix(truncated_mike_matrix),
#    logcounts = log2(as.matrix(truncated_mike_matrix) + 1)
#  ), 
#  colData = info_file
#)
#plotPCA(sum_exp_mike, colour_by = "cell_type")

#plotTSNE(sum_exp_mike, colour_by = "cell_type")
