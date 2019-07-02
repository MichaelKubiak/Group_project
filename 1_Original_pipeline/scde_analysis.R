#library(rPython)
#python.load("../data_combination.py")
counts <- as.data.frame(read.delim("../combined_data","\t", header=TRUE, row.names = 1))
library("scde")
counts <- clean.counts(counts, min.lib.size = 1,min.reads = 1,min.detected = 1)
models <- scde.error.models(counts, n.cores=4,threshold.segmentation = TRUE, save.crossfit.plots = FALSE, save.model.plots = FALSE, verbose = 1)

valid.cells<-models$corr.a > 0
models <- models[valid.cells,]
write.table(models, file = "./Group_project/models",sep="\t")
prior <- scde.expression.prior(models, counts)
write.table(prior,file="./Group_project/prior",sep="\t")
# Adjusted distance calculation by direct dropout
p.self.fail <- scde.failure.probability(models, counts = counts)
write.table(p.self.fail,file="./Group_project/failprob",sep="\t")
n.simulations <- 1000 
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
write.table
library(tsne)
dim.red.dist <- tsne(direct.dist, max_iter = 10000)
write.table(dim.red.dist,file="./Group_project/distance",sep="\t")


library(mclust)
BIC <- mclustBIC(dim.red.dist,G=1:40, modelNames = c("EII","VVI","VII","EEE","EEI","EEV","VEI","VEV","EVI","VVV"), prior = priorControl())
svg(filename="./Group_project/BIC.svg",
    width=5,
    height=4,
    pointsize=10)
plot(BIC)
dev.off()

#library(igraph)
#dist.graph <- graph_from_adjacency_matrix(direct.dist)
#min.span.tree <- mst(dist.graph)
#plot(min.span.tree)
#com.struct <- cluster_leading_eigen(min.span.tree)
#plot (com.struct)
