library(SingleCellExperiment)
library(scater)

# Create a SingleCellExperiment object
sce <- SingleCellExperiment(
  assays <- list(
    counts <- test_data_gene_count_matrix,
    logcounts <- log2(test_data_gene_count_matrix)
  ), 
  colData <- colnames(test_data_gene_count_matrix)
)

# Gene_matrix for current analysis here
# Note: setwd("/home/izzy_r/Group_project/Project_repo/Group_project")
test_data_gene_count_matrix <- read.delim("./2_Alternative_pipeline/test_data_gene_count_matrix.csv", row.names=1)

# scater quality control matrix
sce <- calculateQCMetrics(sce, use_spikes = FALSE)
colData(sce)


#plotPCA(sce)
#sce <- sc3(sce, ks = )