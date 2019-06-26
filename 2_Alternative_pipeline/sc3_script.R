library(SC3)
library(scater)
library(SingleCellExperiment)


test_data_gene_count_matrix <- read.delim("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/Full_data_gene_count_matrix.csv", row.names = 1)

info_file <- read.delim("/home/tsc21/Documents/BS7120/Group_project/SraRunTable(1).txt")



head(info_file)

yan
sce <- SingleCellExperiment(
  assays = list(
    counts = as.matrix(test_data_gene_count_matrix),
    logcounts = log2(as.matrix(test_data_gene_count_matrix) + 1)
  ), 
  colData = info_file
)


# define feature names in feature_symbol column
rowData(sce)$feature_symbol <- rownames(sce)
# remove features with duplicated names
sce <- sce[!duplicated(rowData(sce)$feature_symbol), ]


plotPCA(sce, colour_by = "cell_type")


sce <- sc3(sce, ks = 10, biology = TRUE)

sc3_interactive(sce)

