library(SC3)
library(scater)
library(SingleCellExperiment)
library(zinbwave)

test_data_gene_count_matrix <- read.delim("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/Full_data_gene_count_matrix.csv", row.names = 1)

info_file <- read.delim("/home/tsc21/Documents/BS7120/Group_project/SraRunTable(1).txt")



head(info_file)

sce <- SingleCellExperiment(
  assays = list(
    counts = as.matrix(test_data_gene_count_matrix),
    logcounts = log2(as.matrix(test_data_gene_count_matrix) + 1)
  ), 
  colData = info_file
)


sce_zinb <- zinbwave(sce, k=2, epsilon=22085)
?zinbwave

# define feature names in feature_symbol column
rowData(sce)$feature_symbol <- rownames(sce)
# remove features with duplicated names
sce <- sce[!duplicated(rowData(sce)$feature_symbol), ]


plotPCA(sce, colour_by = "cell_type")


sce <- sc3(sce, ks = 2:10, biology = TRUE)

sc3_interactive(sce)

sc3_export_results_xls(sce)




col_data <- colData(sce)
head(col_data[ , grep("sc3_", colnames(col_data))])


plotPCA(
  sce, 
  colour_by = "sc3_3_clusters", 
  size_by = "sc3_3_log2_outlier_score"
)





