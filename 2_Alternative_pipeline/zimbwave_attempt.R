library(SC3)
library(scater)
library(SingleCellExperiment)
library(zinbwave)



test_data_gene_count_matrix <- read.delim("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/Full_data_gene_count_matrix.csv", row.names = 1)

info_file <- read.delim("/home/tsc21/Documents/BS7120/Group_project/SraRunTable(1).txt")

library(SummarizedExperiment)

sum_object<- SummarizedExperiment(
  assays = list(
    counts = as.matrix(test_data_gene_count_matrix),
    logcounts = log2(as.matrix(test_data_gene_count_matrix))
  ), 
  colData = info_file
)
sum_object


?SummarizedExperiment


sce_zinb <- zinbwave(sum_object, k=2, epsilon=22085)
?zinbwave
