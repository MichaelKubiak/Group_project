library(igraph)
print("hi")
read.graph(ftree, "../1_Original_pipeline/Foetal/ftree")
print("did this")
svg(filename="~/min_span.svg",
    width=20,
    height=20,
    pointsize=10)
plot (ftree,vertex.size=4, vertex.label=NA)
dev.off()
print(plotted)