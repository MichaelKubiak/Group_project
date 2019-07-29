library(shiny)
library(plotly)

#Function that creates the list 'cols' depending on the k value used for clustering
#The 'ui.R' file will assign a colour to each cluster number
list_colours<-function(input,clust,cols,types){
  
  if (input$selection == "b"){
    if(input$data == "auth"){
      i <- 8
    }else if (input$data == "orig"){
      i<-10
    }else{
      i<-9
    }
    for (type in clust$classification){
      for (n in 1:i){
        if (type %in% n){
          cols<-append(cols, input[[paste0("Cluster_", type)]])
        }
      }
    }
    
  }
  else{
    print(types)
    for (type in types){
      print(type)
      for(n in 1:9){
        print(n)
        if (type %in% n){
          cols<-append(cols, input[[paste0("t", n)]])
          
        } 
      }
    }
    print(cols)
  }
  return (cols)
  
}

load("../clust_workspace.RData")
#Function will create the 3D tSNE plot using 'cols' for plot colour assignments
#The hover text for each cell within the plot will provide the name of the cell and its cluster assignment for the specified K value
function(input,output){
  
  
  output$plot1<-renderPlotly({
    data<-get(input$data)
    types<-c()
    if (input$selection == "c"){
      for (name in colnames(data$counts)){
        name<-strsplit(name, "o|g|_")[[1]][1]
        print(name)
        if (input$data == "auth"){
          types<-append(types, data$run$cell_type[data$run$Sample_Name == name])
        }else {
          types<-append(types, data$run$cell_type[data$run$Run == name])
          
        }
      }
    }
    cols<-c()
    cols<-list_colours(input,data$clust,cols, types)
    data$dim.red.dist <- as.data.frame(data$dim.red.dist)
    data$dim.red.dist$cols<-factor(cols)
    p<-plot_ly(data$dim.red.dist,x=~V1,y=~V2,z=~V3,marker=list(color=data$dim.red.dist$cols,size=1))
#    plot_ly(marker=list(size=1)) %>%
 #       add_markers(x = data$dim.red.dist$V1[data$dim.red.dist$cols==input$t1], y = data$dim.red.dist$V2[data$dim.red.dist$cols==input$t1], z = data$dim.red.dist$V3[data$dim.red.dist$cols==input$t1], name = "Astrocyte") %>%
  #      add_markers(x = data$dim.red.dist$V1[data$dim.red.dist$cols==input$t2], y = data$dim.red.dist$V2[data$dim.red.dist$cols==input$t2], z = data$dim.red.dist$V3[data$dim.red.dist$cols==input$t2], name = "Endothelial") %>%
   #     add_markers(x = data$dim.red.dist$V1[data$dim.red.dist$cols==input$t3], y = data$dim.red.dist$V2[data$dim.red.dist$cols==input$t3], z = data$dim.red.dist$V3[data$dim.red.dist$cols==input$t3], name = "Foetal Quiescent") %>%
    #    add_markers(x = data$dim.red.dist$V1[data$dim.red.dist$cols==input$t4], y = data$dim.red.dist$V2[data$dim.red.dist$cols==input$t4], z = data$dim.red.dist$V3[data$dim.red.dist$cols==input$t4], name = "Foetal Replicating") %>%
     #   add_markers(x = data$dim.red.dist$V1[data$dim.red.dist$cols==input$t5], y = data$dim.red.dist$V2[data$dim.red.dist$cols==input$t5], z = data$dim.red.dist$V3[data$dim.red.dist$cols==input$t5], name = "Hybrid") %>%
      #  add_markers(x = data$dim.red.dist$V1[data$dim.red.dist$cols==input$t6], y = data$dim.red.dist$V2[data$dim.red.dist$cols==input$t6], z = data$dim.red.dist$V3[data$dim.red.dist$cols==input$t6], name = "Microglia") %>%
       # add_markers(x = data$dim.red.dist$V1[data$dim.red.dist$cols==input$t7], y = data$dim.red.dist$V2[data$dim.red.dist$cols==input$t7], z = data$dim.red.dist$V3[data$dim.red.dist$cols==input$t7], name = "Neuron") %>%
        #add_markers(x = data$dim.red.dist$V1[data$dim.red.dist$cols==input$t8], y = data$dim.red.dist$V2[data$dim.red.dist$cols==input$t8], z = data$dim.red.dist$V3[data$dim.red.dist$cols==input$t8], name = "Oligodendrocyte") %>%
        #add_markers(x = data$dim.red.dist$V1[data$dim.red.dist$cols==input$t9], y = data$dim.red.dist$V2[data$dim.red.dist$cols==input$t9], z = data$dim.red.dist$V3[data$dim.red.dist$cols==input$t9], name = "OPC") %>%
        #layout(legend = list())
    
    
    })
}

