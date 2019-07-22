library(shiny)
library(plotly)

list_colours<-function(input,sce_selfgenerated,cols){

  for (type in sc3_clusters[[paste0("sc3_",toString(input$clusts),"_clusters_self")]]){
    for (n in 1:input$clusts){
      if (type %in% n){
        cols<-append(cols, input[[paste0("Cluster_", type)]])
      }
    }
    
  }
  return (cols)
  
}

load("./selfgenerated_genecounting.RData")
function(input,output){
  output$plot1<-renderPlotly({
    cols<-c()
    cols<-list_colours(input,sce_selfgenerated,cols)

    plot_ly(as.data.frame(tsne_plot_sel_generated_genecount$plot_env$df_to_plot),
               x=~X1,y=~X2,z=~X3, 
               hoverinfo="text", 
               text=paste( sep= "\n", sce_selfgenerated$Run, sc3_clusters[[paste0("sc3_",toString(input$clusts),"_clusters_self")]]),
               marker=list(color=cols,size=1),
               type="scatter3d" )
  })
}

