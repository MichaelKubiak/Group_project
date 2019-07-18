library(shiny)
library(plotly)

list_colours<-function(input,sce,cols){

  for (type in sce[[paste0("sc3_",toString(input$clusts),"_clusters")]]){
    for (n in 1:input$clusts-4){
      if (type %in% n){
        cols<-append(cols, input[[paste0("Cluster_", type)]])
      }
    }
    
  }
  return (cols)
  
}

load("../../Author_gene_count_TSNE/author_gene_count_sc3.RData")
function(input,output){
  output$plot1<-renderPlotly({
    cols<-c()
    cols<-list_colours(input,sce,cols)
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
    
    p<-plot_ly(as.data.frame(tsne_plot_10$plot_env$df_to_plot),
               x=~X1,y=~X2,z=~X3, 
               hoverinfo="text", 
               text=paste( sep= "\n", sce$Run, sce$sc3_5_clusters),
               marker=list(color=cols,size=1),
               type="scatter3d" )
      #layout(scene=scene)
    p
  })
}
