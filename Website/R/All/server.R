library(shiny)
library(plotly)

list_colours<-function(input,sc3_10_clusters,cols, Cluster_6){
  
  for (type in get(paste0("sc3_",toString(input$clusts),"_clusters"))){
    for (n in 5:input$clusts){
      if (type %in% n){
        cols<-append(cols,get(paste0("Cluster_",type)))
      }
    }
  }
  
}
sc3_10_clusters<-sce$sc3_10_clusters

load("../../Author_gene_count_TSNE/author_gene_count_sc3.RData")
function(input,output){
  output$plot1<-renderPlotly({
    
    Cluster_6<-input$Cluster_6
    cols<-c()
    list_colours(input,sc3_10_clusters,cols, Cluster_6)
    #for (type in sce$sc3_5_clusters){
    #  if (type %in% "1"){
    #    cols<-append(cols,input$Cluster_1)
    #  }else if (type %in% "2"){
    #    cols<-append(cols,input$Cluster_2)
    #  }else if (type %in% "3"){
    #    cols<-append(cols,input$Cluster_3)
    #  }else if (type %in% "4"){
    #    cols<-append(cols,input$Cluster_4)
    #  }else{
    #    cols<-append(cols,input$Cluster_5)
    #  }
    #}
    
    #p<-plot_ly(as.data.frame(tsne_plot_10$plot_env$df_to_plot),
    #           x=~X1,y=~X2,z=~X3, 
    #           hoverinfo="text", 
    #           text=paste( sep= "\n", sce$Run, sce$sc3_5_clusters),
    #           marker=list(color=cols,size=1),
    #           type="scatter3d" )
      #layout(scene=scene)
    #p
  })
}
