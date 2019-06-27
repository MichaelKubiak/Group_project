# Zinbwave:
# zinbwave(dataset, k=how many latent variables we want to infer from the data, epsilon=num_genes)
sce_zinb <- zinbwave(x, k=2, epsilon=2285)

# Constructing a SummarisedExperiment


# This creates a SummarizedExperiement
sume <- SummarizedExperiment(
  assays = list(
    counts = test_data_gene_count_matrix,
    logcounts = log2(test_data_gene_count_matrix)
  ), 
  colData = colnames(test_data_gene_count_matrix)
)

sume
sce_zinb <- zinbwave(sume, k=2, epsilon=2285)
sce_zinb


