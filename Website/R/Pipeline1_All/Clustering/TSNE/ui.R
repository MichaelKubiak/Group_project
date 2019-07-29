library(shiny)
library(plotly)
library(colourpicker)

#Load data within the 'RData' file that are required to create the graph
load("../clust_workspace.RData")
fluidPage(
  titlePanel("tSNE plot for variable counting matrices"),
  fluidRow(
    column(4,
           selectInput("data", "Dataset", c("Author Generated Count Matrix"="auth", 
                                            "Original Pipeline Reproduced Count Matrix"="orig", 
                                            "New Pipeline Count Matrix"="sec"))
    )
  ),
  fluidRow(
    column(2,
           selectInput("selection", "Clustering type", c("mClust" = "b", "Cell types" = "c")),
           conditionalPanel(condition="input.selection == 'b'",
                            colourInput("Cluster_1",   "Cluster_1",   value="#000080"),
                            colourInput("Cluster_2",   "Cluster_2",   value="#FF0000"),
                            colourInput("Cluster_3",   "Cluster_3",   value="#FFA500"),
                            colourInput("Cluster_4",   "Cluster_4",   value="#008000")
           ),
           conditionalPanel(condition="input.selection =='c'",
                            colourInput("t1",   "Astrocytes",   value="#000080"),
                            colourInput("t2",   "Endothelial Cells",   value="#FF0000"),
                            colourInput("t3",   "Foetal Quiescent Neurons",   value="#FFA500"),
                            colourInput("t4",   "Foetal Replicating Neurons",   value="#008000")
           )
    ),
    column(2,
           conditionalPanel(condition="input.selection == 'b'",
                            colourInput("Cluster_5",   "Cluster_5",   value="#964B00"),
                            colourInput("Cluster_6", "Cluster_6", value="#9966CC"),
                            colourInput("Cluster_7", "Cluster_7", value="#00FFFF"),
                            colourInput("Cluster_8", "Cluster_8", value="#FD6C9E"),
                            conditionalPanel("input.data != 'auth'",
                                             colourInput("Cluster_9", "Cluster_9", value="#808080"),
                                             conditionalPanel("input.data == 'orig'",
                                             colourInput("Cluster_10", "Cluster_10", value="#FF00FF")
                            
                                             )
                            )
          ),
           conditionalPanel(
             condition="input.selection == 'c'",
             colourInput("t5",   "Hybrid Cells",   value="#964B00"),
             colourInput("t6", "Microglia", value="#9966CC"),
             colourInput("t7", "Neurons", value="#00FFFF"),
             colourInput("t8", "Oligodendrocytes", value="#FD6C9E"),
             colourInput("t9", "OPC", value="#808080")
           )
    ),
    column(6,
           #Display the graph made in the 'server.R' file
           plotlyOutput("plot1")
    )
  )
  
)
