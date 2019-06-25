

sce <- SingleCellExperiment(
  assays = list(
    counts = test_data_gene_count_matrix,
    logcounts = log2(test_data_gene_count_matrix)
  ), 
  colData = colnames(test_data_gene_count_matrix)
)


test_data_gene_count_matrix <- read.delim("/home/izzy_r/Group_project/Project_repo/Group_project/2_Alternative_pipeline/test_data_gene_count_matrix.csv", row.names=1)

library(scater)

example_sce <- sce
example_sce <- calculateQCMetrics(example_sce)
colnames(colData(example_sce))

plotPCA(sce, colour_by = "cell_type1")



sce <- sc3(sce, ks = )