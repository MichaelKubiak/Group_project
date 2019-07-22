if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("SC3")
BiocManager::install("SingleCellExperiment")
#BiocManager::install("SummarizedExperiment")
#BiocManager::install("zinbwave")
BiocManager::install("scater")

#library(SummarizedExperiment)
library(SingleCellExperiment)
library(scater)
library(SC3)
#library(zinbwave)


gene_expression_matrix_selfgenerated <- read.delim("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/count_matrix", row.names = 1, header = TRUE)
gene_expression_matrix_selfgenerated <- gene_expression_matrix[,order(names(gene_expression_matrix_selfgenerated))]
info_file <- read.delim("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/SraRunTable_465.csv")


truncated_expression_matrix_selfgenerated <- gene_expression_matrix_selfgenerated[1:22085,]
# start=0, end=466

# Remove all 0 expressed genes from the dataset:
truncated_expression_matrix_selfgenerated <- truncated_expression_matrix_selfgenerated[rowSums(truncated_expression_matrix_selfgenerated[, -1])>0, ]

head(info_file)
# Create SummarizedExperiment for Zinbwave input
#sum_exp <- makeSummarizedExperimentFromDataFrame(df = gene_expression_matrix, start.field=1:1, end.field=22088:466,ignore.strand=FALSE,
#starts.in.df.are.0based = TRUE)

# Go straight to making a summarisedexperiment?
sum_exp_selfgenerated <- SingleCellExperiment(
  assays = list(
    counts = as.matrix(truncated_expression_matrix_selfgenerated),
    logcounts = log2(as.matrix(truncated_expression_matrix_selfgenerated) + 1)
  ), 
  colData = info_file
)

rowData(sum_exp_selfgenerated)$feature_symbol <- rownames(sum_exp_selfgenerated)


# printing the summarisedexperiment data
sum_exp_selfgenerated




# Zinbwave zero accounting:
# This is a flexible zero-inflated negative binomial model for low dimensional representations of single-cell RNA Seq
# data. 
# Zimbwave takes a SummarizedExperiment and returns a SingleCellExperiment object
# k=how many latent variables we want to infer from the data, epsilon=num_genes
#library(BiocParallel)
#sce <- zinbwave(sum_exp, K=5:25, epsilon=21625, BPPARAM = BiocParallel::MulticoreParam(3), verbose = TRUE)
#plotPCA(sce,colour_by = "cell_type")






#normalised data for SC3 analysis
norm_sce_selfgenerated <- normalizeSCE(object = sum_exp_selfgenerated, 
                         #exprs_values = as.matrix(truncated_expression_matrix), 
                         return_log = TRUE,
                         centre_size_factors = TRUE,
                         preserve_zeroes = FALSE
)


plotExplanatoryVariables(norm_sce_selfgenerated)
plotPCA(norm_sce_selfgenerated, colour_by = "cell_type")


#prepare data for sc3 clustering
sce_selfgenerated <- sc3_prepare(norm_sce_selfgenerated)


#estimate the optimal cluster number for k within dataset
sce_selfgenerated <- sc3_estimate_k(sce_selfgenerated)

str(metadata(sce_selfgenerated)$sc3)


#calc distances between cells
sce_selfgenerated <- sc3_calc_dists(sce_selfgenerated)

names(metadata(sce_selfgenerated)$sc3$distances)



#transform distance matrix
sce_selfgenerated <- sc3_calc_transfs(sce_selfgenerated)

names(metadata(sce_selfgenerated)$sc3$transformations)


#cluster data based data similarities, non-biased
sce_selfgenerated <- sc3_kmeans(sce_selfgenerated, ks = 5:25)

names(metadata(sce_selfgenerated)$sc3$kmeans)


#clustering solution after kmean 
col_data <- colData(sce_selfgenerated)
head(col_data[ , grep("sc3_", colnames(col_data))])


sce_selfgenerated <- sc3_calc_consens(sce_selfgenerated)


names(metadata(sce_selfgenerated)$sc3$consensus)

names(metadata(sce_selfgenerated)$sc3$consensus$`2`)



col_data <- colData(sce_selfgenerated)
head(col_data[ , grep("sc3_", colnames(col_data))])



#Biology=TRUE
sce_selfgenerated <- sc3_calc_biology(sce_selfgenerated, ks = 5:25)

#cell outliers for each k
col_data <- colData(sce_selfgenerated)
head(col_data[ , grep("sc3_", colnames(col_data))])


#DE and marker gene calc'd for each value k 
row_data <- rowData(sce_selfgenerated)
head(row_data[ , grep("sc3_", colnames(row_data))])


reducedDim(sce_selfgenerated, withDimnames = TRUE)
plotReducedDim(sce_selfgenerated, use_dimred = "PCA", colour_by = "cell_type")


sc3_interactive(sce_selfgenerated)
sc3_export_results_xls(sce_selfgenerated)

plotPCA(sce_selfgenerated, colour_by = "cell_type")

plotTSNE(sce_selfgenerated, colour_by = "cell_type", rerun = TRUE)


col_data

tsne_plot_sel_generated_genecount <- plotTSNE(sce_selfgenerated, colour_by = "sc3_10_clusters", rerun = TRUE, ncomponents = 3)

View(tsne_plot_sel_generated_genecount)
tsne_plot_sel_generated_genecount

png(filename="/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/tsne_plot_10_selfgenerated.png", width=650, height=500)
plot(tsne_plot_sel_generated_genecount)
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
