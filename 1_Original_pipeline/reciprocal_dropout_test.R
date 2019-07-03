counts <- as.data.frame(read.delim("./combined_data","\t", header=TRUE, row.names = 1))
library("scde")
counts <- clean.counts(counts, min.lib.size = 1,min.reads = 1,min.detected = 1)
models <- scde.error.models(counts, n.cores=4,threshold.segmentation = TRUE, save.crossfit.plots = FALSE, save.model.plots = FALSE, verbose = 1)
magnitudes <- scde.expression.magnitude(models,counts=counts)
require("boot")
require("parallel")
k<-0.95
cell.names <- colnames(counts)
names(cell.names) <- cell.names
reciprocal.dist <- as.dist(1-do.call(rbind, mclapply(cell.names, function(nam1){
  unlist(lapply(cell.names, function(nam2){
    f1<-scde.failure.probability(models=models[nam1,,drop=FALSE],magnitudes=magnitudes[,nam2])
    f2<-scde.failure.probability(models = models[nam2,,drop=FALSE],magnitudes=magnitudes[,nam1])
    pnf<-sqrt((1-f1)*(1-f2))*k + (1-k)
    boot::corr(log10(cbind(counts[,nam1],counts[,nam2])+1),w=pnf)
  }))
},mc.cores=4)),upper=FALSE)
write.table(reciprocal.dist,file="./Group_project/recip_dist",sep="\t")


direct.dist.rec <- as.dist(read.table("recip_dist", sep="\t"))

library(tsne)
dim.red.dist.rec <- tsne(direct.dist.rec, max_iter = 10000)


library(mclust)
BIC.rec <- Mclust(dim.red.dist.rec,G=1:40, modelNames = c("EII","VVI","VII","EEE","EEI","EEV","VEI","VEV","EVI","VVV"), prior = priorControl())
svg(filename="./Group_project/BIC.svg",
    width=5,
    height=4,
    pointsize=10)
plot(BIC.rec)
dev.off()
