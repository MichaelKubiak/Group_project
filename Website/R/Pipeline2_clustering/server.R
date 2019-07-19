library(shiny)
library(plotly)

list_colours<-function(input,sce,cols){

  for (type in sc3_clusters[[paste0("sc3_",toString(input$clusts),"_clusters")]]){
    for (n in 1:input$clusts){
      if (type %in% n){
        cols<-append(cols, input[[paste0("Cluster_", type)]])
      }
    }
    
  }
  return (cols)
  
}

load("./author_gene_count_sc3.RData")
function(input,output){
  output$plot1<-renderPlotly({
    cols<-c()
    cols<-list_colours(input,sce,cols)
    
    plot_ly(as.data.frame(tsne_plot_10$plot_env$df_to_plot),
               x=~X1,y=~X2,z=~X3, 
               hoverinfo="text", 
               text=paste( sep= "\n", sce$Run, sc3_clusters[[paste0("sc3_",toString(input$clusts),"_clusters")]]),
               marker=list(color=cols,size=1),
               type="scatter3d" )
  })
}
