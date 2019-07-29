#Creates all quality plots produced by SC3 for each k value. Not used in final analysis as the resulting RData file was too large for R to handle efficiently

library(SC3)

#Create a vector containing the range of k values present in our singleCellExperiment objects
k_values <- c(5:25)

#Create all consensus matrices for all k values for the author data
for (i in k_values){
  test <- sc3_plot_consensus(sce_author, k = i)
  name  <- paste0("consensus_matrix_", i, "_author")
  assign(name, test)
}

#Create all cluster stability plots for all k values for the author data
for (i in k_values){
  test <- sc3_plot_cluster_stability(sce_author, k = i)
  name  <- paste0("cluster_stability_", i, "_author")
  assign(name, test)
}

#Create all differential expressed gene matrix for all k values for the author data
for (i in k_values){
  test <- sc3_plot_de_genes(sce_author, k = i)
  name  <- paste0("de_gene_", i, "_author")
  assign(name, test)
}

#Create all expression plots for all k values for the author data
for (i in k_values){
  test <- sc3_plot_expression(sce_author, k = i)
  name  <- paste0("expression_", i, "_author")
  assign(name, test)
}
 
#Create all gene marker plots for all k values for the author data
for (i in k_values){
  test <- sc3_plot_markers(sce_author, k = i)
  name  <- paste0("markers_", i, "_author")
  assign(name, test)
}



#Create all consensus matrix for all k values for the self data
for (i in k_values){
  test <- sc3_plot_consensus(sce_self, k = i)
  name  <- paste0("consensus_matrix_", i, "_self")
  assign(name, test)
}

#Create all cluster stability plots for all k values for the self data
for (i in k_values){
  test <- sc3_plot_cluster_stability(sce_self, k = i)
  name  <- paste0("cluster_stability_", i, "_self")
  assign(name, test)
}

#Create all differentially expressed gene plots for all k values for the self data
for (i in k_values){
  test <- sc3_plot_de_genes(sce_self, k = i)
  name  <- paste0("de_gene_", i, "_self")
  assign(name, test)
}

#Create all consensus matrix for all k values for the self data
for (i in k_values){
  test <- sc3_plot_expression(sce_self, k = i)
  name  <- paste0("expression_", i, "_self")
  assign(name, test)
}

#Create all marker gene plotsfor all k values for the self data
for (i in k_values){
  test <- sc3_plot_markers(sce_self, k = i)
  name  <- paste0("markers_", i, "_self")
  assign(name, test)
}

#silhouette plots did not work using this method, but does work when not assigning the plot to an object. Another reason why this code was not used
sc3_plot_silhouette(sce_author, k = 10)
