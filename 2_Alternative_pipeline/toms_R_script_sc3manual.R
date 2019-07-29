#This code is based on the SC3 tutorial. 

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("SC3")
BiocManager::install("SingleCellExperiment")
#BiocManager::install("SummarizedExperiment")
BiocManager::install("zinbwave")
BiocManager::install("scater")

#library(SummarizedExperiment)
library(SingleCellExperiment)
library(scater)
library(SC3)
library(zinbwave)


gene_expression_matrix_selfgenerated <- read.deli ("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/count_matrix", row.names = 1, header = TRUE)
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
library(BiocParallel)
sce_self <- zinbwave(sum_exp_selfgenerated, K=5:25, epsilon=21625, BPPARAM = BiocParallel::MulticoreParam(3), verbose = TRUE)
plotPCA(sce_self,colour_by = "cell_type")






#normalised data for SC3 analysis
norm_sce_selfgenerated <- normalizeSCE(object = sce_self, 
                         #exprs_values = as.matrix(truncated_expression_matrix), 
                         return_log = TRUE,
                         centre_size_factors = TRUE,
                         preserve_zeroes = FALSE
)


plotExplanatoryVariables(norm_sce_selfgenerated)
plotPCA(norm_sce_selfgenerated, colour_by = "cell_type")


#prepare data for sc3 clustering
sce_self <- sc3_prepare(norm_sce_selfgenerated)


#estimate the optimal cluster number for k within dataset
sce_self <- sc3_estimate_k(sce_self)

str(metadata(sce_self)$sc3)


#calc distances between cells
sce_self<- sc3_calc_dists(sce_self)

names(metadata(sce_self)$sc3$distances)



#transform distance matrix
sce_self <- sc3_calc_transfs(sce_self)

names(metadata(sce_self)$sc3$transformations)


#cluster data based data similarities, non-biased
sce_self <- sc3_kmeans(sce_self, ks = 2:25)

names(metadata(sce_self)$sc3$kmeans)


#clustering solution after kmean 
col_data <- colData(sce_self)
head(col_data[ , grep("sc3_", colnames(col_data))])


sce_self <- sc3_calc_consens(sce_self)


names(metadata(sce_self)$sc3$consensus)

names(metadata(sce_self)$sc3$consensus$`2`)



col_data <- colData(sce_self)
head(col_data[ , grep("sc3_", colnames(col_data))])



#Biology=TRUE
sce_self <- sc3_calc_biology(sce_self, ks = 2:25)

#cell outliers for each k
col_data <- colData(sce_self)
head(col_data[ , grep("sc3_", colnames(col_data))])


#DE and marker gene calc'd for each value k 
row_data <- rowData(sce_self)
head(row_data[ , grep("sc3_", colnames(row_data))])


reducedDim(sce_self, withDimnames = TRUE)
plotReducedDim(sce_self, use_dimred = "PCA", colour_by = "cell_type")


sc3_interactive(sce_self)
sc3_export_results_xls(sce_self)

pca_plot_self <- plotPCA(sce_self, colour_by = "cell_type", ncomponents = 3)
tsne_plot_self <- plotTSNE(sce_self, colour_by = "cell_type", ncomponents = 3)
pca_plot_author <- plotPCA(sce, colour_by = "cell_type", ncomponents = 3)

plotTSNE(sce_selfgenerated, colour_by = "cell_type", rerun = TRUE)


col_data

tsne_plot_sel_generated_genecount <- plotTSNE(sce_selfgenerated, colour_by = "sc3_10_clusters", rerun = TRUE, ncomponents = 3)

#View(tsne_plot_sel_generated_genecount)
tsne_plot_sel_generated_genecount

png(filename="/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/tsne_plot_10_selfgenerated.png", width=650, height=500)
plot(tsne_plot_sel_generated_genecount)
dev.off()

remove(test)
sc3_plot_silhouette(sce_author, k = 6)
