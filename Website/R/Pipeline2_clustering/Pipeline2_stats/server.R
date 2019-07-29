library(shiny)
library(plotly)
#library(SC3)





#Function will create list 'cols' containing hex colour codes assigned by the 'ui.R' file
#depending on the cell type of the cell.
function(input,output){
  output$plot1<-renderPlot({
    
    #Load the data within the 'RData' file, required to make the graphs
    if (input$zinbwave == T){
      load("../Pipeline2_complete_allwithzinbwave/test_data_zinbwave.RData")
      print("fist")
    }else if (input$zinbwave == F){
      load("../Pipeline2_complete_allwithzinbwave/complete_genecounting.RData")
      print("second")
    }
    
    if (input$dataset == "b"){
      if (input$graph == "b"){
        sc3_plot_consensus(sce_author, k = input$clusts)
      }else if (input$graph == "c"){
        sc3_plot_silhouette(sce_author, k = input$clusts)
      }else if (input$graph == "d"){
        sc3_plot_expression(sce_author, k = input$clusts)
      }else if (input$graph == "e"){
        sc3_plot_cluster_stability(sce_author, k = input$clusts)
      }else if (input$graph == "f"){
        sc3_plot_de_genes(sce_author, k = input$clusts)
      }else if (input$graph == "g"){
        sc3_plot_markers(sce_author, k = input$clusts)
      }
    }else if (input$dataset == "c"){
      if (input$graph == "b"){
        sc3_plot_consensus(sce_self, k = input$clusts)
      }else if (input$graph == "c"){
        sc3_plot_silhouette(sce_self, k = input$clusts)
      }else if (input$graph == "d"){
        sc3_plot_expression(sce_self, k = input$clusts)
      }else if (input$graph == "e"){
        sc3_plot_cluster_stability(sce_self, k = input$clusts)
      }else if (input$graph == "f"){
        sc3_plot_de_genes(sce_self, k = input$clusts)
      }else if (input$graph == "g"){
        sc3_plot_markers(sce_self, k = input$clusts)
      }
    }
  })
}