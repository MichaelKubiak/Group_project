library(shiny)
library(plotly)


#Load the data within the 'RData' file, required to make the graphs




#Function will create list 'cols' containing hex colour codes assigned by the 'ui.R' file
#depending on the cell type of the cell.
function(input,output){
  
  
  output$plot1<-renderPlotly({
    cols<-c()
    
    
    if (input$zinbwave == T){
      load("./test_data_zinbwave.RData")
      print("fist")
    }else if (input$zinbwave == F){
      load("./complete_genecounting.RData")
      print("second")
    }
    
    
    if (input$graph == "b" ||input$graph == "c"){ 
      graph_to_use <- pca_plot_author$plot_env$df_to_plot
    }else if (input$graph == "d" ||input$graph == "e"){
      graph_to_use <- tsne_plot_author$plot_env$df_to_plot
    }else if (input$graph == "f" ||input$graph == "g"){
      graph_to_use <- pca_plot_self$plot_env$df_to_plot
    }else if (input$graph == "h" ||input$graph == "i"){
      graph_to_use <- tsne_plot_self$plot_env$df_to_plot
    }
    
    if (input$graph == "b" ||input$graph == "c" ||input$graph == "d" ||input$graph == "e"){
      sce_run_data <- sce_author$Run
      sce_cell_type <- sce_author$cell_type
    }else if (input$graph == "f" ||input$graph == "g" ||input$graph == "h" ||input$graph == "i"){
      sce_run_data <- sce_self$Run
      sce_cell_type <- sce_self$cell_type
    }
    
    if (input$graph == "b" ||input$graph == "d"){
      cluster_assignment <- sce_author$cell_type
    }else if (input$graph == "f" ||input$graph == "h"){
      cluster_assignment <- sce_self$cell_type
    }else if (input$graph == "c" ||input$graph == "e"){
      cluster_assignment <- sc3_clusters_author[[paste0("sc3_",toString(input$clusts),"_clusters")]]
    }else if (input$graph == "g" ||input$graph == "i"){
      cluster_assignment <- sc3_clusters_self[[paste0("sc3_",toString(input$clusts),"_clusters")]]
    }
    
    
    if (input$graph == "b" ||input$graph == "d" ||input$graph == "f" ||input$graph == "h"){
      
      for (type in sce_cell_type){
        if (type %in% "oligodenrocytes"){
          cols<-append(cols,input$Oligodenrocytes)
        }else if (type %in% "hybrid"){
          cols<-append(cols,input$Hybrid)
        }else if (type %in% "astrocytes"){
          cols<-append(cols,input$Astrocytes)
        }else if (type %in% "OPC"){
          cols<-append(cols,input$OPC)
        }else if (type %in% "microglia"){
          cols<-append(cols,input$Microglia)
        }else if (type %in% "neurons"){
          cols<-append(cols,input$Neurons)
        }else if (type %in% "endothelial"){
          cols<-append(cols,input$Endothelial)
        }else if (type %in% "fetal_quiescent"){
          cols<-append(cols,input$Fetal_quiescent)
        }else{
          cols<-append(cols,input$Fetal_replicating)
        }
      }
    }
    
    else if (input$graph == "c" ||input$graph == "e" ||input$graph == "g" ||input$graph == "i"){
      for (type in cluster_assignment){
        for (n in 1:input$clusts){
          if (type %in% n){
            cols<-append(cols, input[[paste0("Cluster_", type)]])
          }
        }
      }
    }
    #output$graphs <- ((renderPlotly(input$plot1)

    
    plot_ly(as.data.frame(
      graph_to_use),
      x=~X1,y=~X2,z=~X3, 
      hoverinfo="text", 
      text=paste( sep= "\n", sce_run_data, cluster_assignment),
      marker=list(color=cols,size=1.5),
      type="scatter3d")
    
  })
  
  
  
  

  }

