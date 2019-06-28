#library(rPython)
#python.load("../data_combination.py")
counts <- as.data.frame(read.delim("../combined_data","\t", header=TRUE, row.names = 1))
library("scde")
models <- scde.error.models(counts, n.cores=4,threshold.segmentation = TRUE, save.crossfit.plots = FALSE, save.model.plots = FALSE, verbose = 1)
valid.cells<-models$corr.a > 0
models <- models[valid.cells,]
prior <- scde.expression.prior(models, counts)
# Adjusted distance calculation by direct dropout
p.self.fail <- scde.failure.probability(models,counts = counts)
n.simulations <- 500 
k<-0.9
cell.names <- colnames(counts)
names(cell.names) <- cell.names
require(parallel)

simulate <- function(i){
  scd1 <- do.call(cbind,lapply(cell.names,function(nam){
    x <- counts[,nam];
    x[!as.logical(rbinom(length(x),1,1-p.self.fail[,nam]*k))] <- NA;
    x;
  }))
  rownames(scd1) <- rownames(counts)
  cor(log10(scd1+1),use="pairwise.complete.obs")
  
}
dl<-mclapply(1:n.simulations,simulate, mc.cores = 4)
direct.dist <- as.dist(1-Reduce("+",dl)/length(dl))

library(tsne)
dim.red.dist <- tsne(direct.dist, max_iter = 10000)

library(mclust)
BIC <- mclustBIC(dim.red.dist,G=1:40, modelNames = c("EII","VVI","VII","EEE","EEI","EEV","VEI","VEV","EVI","VVV"))
plot(BIC)

library(igraph)
#mst()

