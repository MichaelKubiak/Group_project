library(rPython)
python.load("data_combination.py")
counts <- as.matrix(as.data.frame(read.delim("combined_data","\t", header=TRUE, row.names = 1)))
library("scde")
models <- scde.error.models(counts)
prior <- scde.expression.prior(models, counts)
file.names <- list.files(path=".", pattern="*.csv", full.names=TRUE, recursive=FALSE)

p.self.fail <- scde.failure.probability(models,counts)
n.simulations <- 10 
k<-0.9
cell.names <- colnames(counts)
names(cell.names) <- cell.names
dl<-lapply(1:n.simulations,function(i){
  scd1 <- do.call(cbind,lapply(cell.names,function(nam){
    x <- counts[,nam]
    x[!as.logical(rbinom(length(x),1,1-p.self.fail[,nam]*k))] <- NA
    x
  }))
  rownames(scd1) <- rownames(counts)
  cor(log10(scd1+1),use="pairwise.complete.obs")

})
direct.dist <- as.dist(1-Reduce("+",dl)/length(dl))

