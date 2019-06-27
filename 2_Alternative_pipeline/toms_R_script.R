# Aiming for a full analysis from start to finish on this script
library(SummarizedExperiment)
library(SingleCellExperiment)
library(scater)
library(SC3)


# Load in data (set wd to project directory first)
gene_expression_matrix <- read.delim("/home/tsc21/Documents/BS7120/Group_project/combined_data.txt", row.names = 1, header = TRUE)
info_file <- read.delim("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/SraRunTable_all.txt")

truncated_expression_matrix <- gene_expression_matrix[1:22085,]

head(info_file)

sce <- SingleCellExperiment(
  assays = list(
    counts = as.matrix(truncated_expression_matrix),
    logcounts = log2(as.matrix(truncated_expression_matrix) + 1)
  ), 
  colData = info_file
)


# Scater section

sce <- calculateQCMetrics(sce)
colnames(colData(sce))


colnames(rowData(sce))


plotHighestExprs(sce, exprs_values = "counts")

plotExprsFreqVsMean(sce)

plotRowData(sce, x = "n_cells_by_counts", y = "mean_counts")




#normalised data for SC3 analysis
norm_sce <- normalize(sce)
plotExplanatoryVariables(norm_sce)

rowData(norm_sce)$feature_symbol <- rownames(norm_sce)
# remove features with duplicated names
norm_sce <- norm_sce[!duplicated(rowData(norm_sce)$feature_symbol), ]


plotPCA(norm_sce, colour_by = "cell_type")


norm_sce <- sc3(norm_sce, ks = 5:15, biology = TRUE)

sc3_interactive(norm_sce)

sc3_export_results_xls(norm_sce)

sc3_consensus(norm_sce)
sc3_plot_consensus(sce, k = 2:10)



head(col_data[ , grep("sc3_", colnames(col_data))])


plotPCA(
  norm_sce, 
  colour_by = "sc3_3_clusters", 
  size_by = "sc3_3_log2_outlier_score"
)
