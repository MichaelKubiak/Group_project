library(scater)
data("sc_example_counts")
data("sc_example_cell_info")
example_sce <- SingleCellExperiment(
  assays = list(counts = sc_example_counts), 
  colData = sc_example_cell_info
)
example_sce

example_sce <- calculateQCMetrics(example_sce)
colnames(colData(example_sce))

colnames(rowData(example_sce))

example_sce <- calculateQCMetrics(example_sce, 
                                  feature_controls = list(ERCC = 1:20, mito = 500:1000),
                                  cell_controls = list(empty = 1:5, damaged = 31:40))
plotHighestExprs(example_sce, exprs_values = "counts")
plotExprsFreqVsMean(example_sce)

plotColData(example_sce, x = "total_features_by_counts",
            y = "pct_counts_feature_control", colour = "Mutation_Status") +
  theme(legend.position = "top") +
  stat_smooth(method = "lm", se = FALSE, size = 2, fullrange = TRUE)

example_sce2 <- example_sce
example_sce2$plate_position <- paste0(
  rep(LETTERS[1:5], each = 8), 
  rep(formatC(1:8, width = 2, flag = "0"), 5)
)
plotPlatePosition(example_sce2, colour_by = "Gene_0001",
                  by_exprs_values = "counts") 
plotRowData(example_sce, x = "n_cells_by_counts", y = "mean_counts")
