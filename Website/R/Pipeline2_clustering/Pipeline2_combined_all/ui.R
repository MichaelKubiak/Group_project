library(shiny)
library(plotly)
library(colourpicker)


#Load data within the 'RData' file that are required to create the graph
load("./complete_genecounting.RData")
fluidPage(
  titlePanel("Graphs"),
  sidebarLayout(
    sidebarPanel(
      selectInput("graph","Which graph would you like?", choices = c("Author_CellType_PCA " = "b",
                                                                     "Author_GeneCount_PCA" = "c",
                                                                     "Author_CellType_tSNE" = "d",
                                                                     "Author_GeneCount_tSNE"= "e",
                                                                     "Self_CellType_PCA"    = "f",
                                                                     "Self_GeneCount_PCA"   = "g",
                                                                     "Self_CellType_tSNE"   = "h",
                                                                     "Self_GeneCount_tSNE"  = "i")),
      
      #Assign colours to each cell type. Can be changed when graph is loaded
      conditionalPanel(condition="input.graph == 'b' ||input.graph == 'd' ||input.graph == 'f' ||input.graph == 'h'",  
                       colourInput("Oligodenrocytes",  "Oligodenrocytes",  value="#000080"),
                                                                     colourInput("Hybrid",           "Hybrid",           value="#FF0000"),
                                                                     colourInput("Astrocytes",       "Astrocytes",       value="#FFA500"),
                                                                     colourInput("OPC",              "OPC",              value="#008000"),
                                                                     colourInput("Microglia",        "Microglia",        value="#964B00"),
                                                                     colourInput("Neurons",          "Neurons",          value="#9966CC"),
                                                                     colourInput("Endothelial",      "Endothelial",      value="#00FFFF"),
                                                                     colourInput("Fetal_quiescent",  "Fetal_quiescent",  value="#FD6C9E"),
                                                                     colourInput("Fetal_replicating","Fetal_replicating",value="#808080")
                                                      
      ),
      conditionalPanel(condition="input.graph == 'c' ||input.graph == 'e' ||input.graph == 'g' ||input.graph == 'i'", 
        sliderInput("clusts", "Number of clusters to colour:", min=5, max=25, value = 10),
        colourInput("Cluster_1",   "Cluster_1",   value="#000080"),
        colourInput("Cluster_2",   "Cluster_2",   value="#FF0000"),
        colourInput("Cluster_3",   "Cluster_3",   value="#FFA500"),
        colourInput("Cluster_4",   "Cluster_4",   value="#008000"),
        colourInput("Cluster_5",   "Cluster_5",   value="#964B00"),
        conditionalPanel(
          condition= "input.clusts > 5",
          colourInput("Cluster_6", "Cluster_6", value="#9966CC"),
          conditionalPanel(
            condition= "input.clusts > 6",
            colourInput("Cluster_7", "Cluster_7", value="#00FFFF"),
            conditionalPanel(
              condition= "input.clusts > 7",
              colourInput("Cluster_8", "Cluster_8", value="#FD6C9E"),
              conditionalPanel(
                condition= "input.clusts > 8",
                colourInput("Cluster_9", "Cluster_9", value="#808080"),
                conditionalPanel(
                  condition= "input.clusts > 9",
                  colourInput("Cluster_10", "Cluster_10", value="#FF00FF"),
                  conditionalPanel(
                    condition= "input.clusts > 10",
                    colourInput("Cluster_11", "Cluster_11", value="#FFD700"),
                    conditionalPanel(
                      condition= "input.clusts > 11",
                      colourInput("Cluster_12", "Cluster_12", value="#3FFF00"),
                      conditionalPanel(
                        condition= "input.clusts > 12",
                        colourInput("Cluster_13", "Cluster_13", value="#00FF7F"),
                        conditionalPanel(
                          condition= "input.clusts > 13",
                          colourInput("Cluster_14", "Cluster_14", value="#CCCCFF"),
                          conditionalPanel(
                            condition= "input.clusts > 14",
                            colourInput("Cluster_15", "Cluster_15", value="#FFFF00"),
                            conditionalPanel(
                              condition= "input.clusts > 15",
                              colourInput("Cluster_16", "Cluster_16", value="#40E0D0"),
                              conditionalPanel(
                                condition= "input.clusts > 16",
                                colourInput("Cluster_17", "Cluster_17", value="#50C878"),
                                conditionalPanel(
                                  condition= "input.clusts > 17",
                                  colourInput("Cluster_18", "Cluster_18", value="#4B0082"),
                                  conditionalPanel(
                                    condition= "input.clusts > 18",
                                    colourInput("Cluster_19", "Cluster_19", value="#808000"),
                                    conditionalPanel(
                                      condition= "input.clusts > 19",
                                      colourInput("Cluster_20", "Cluster_20", value="#007BA7"),
                                      conditionalPanel(
                                        condition= "input.clusts > 20",
                                        colourInput("Cluster_21", "Cluster_21", value="#C0C0C0"),
                                        conditionalPanel(
                                          condition= "input.clusts > 21",
                                          colourInput("Cluster_22", "Cluster_22", value="#89CFF0"),
                                          conditionalPanel(
                                            condition= "input.clusts > 22",
                                            colourInput("Cluster_23", "Cluster_23", value="#800000"),
                                            conditionalPanel(
                                              condition= "input.clusts > 23",
                                              colourInput("Cluster_24", "Cluster_24", value="#C8A2C8"),
                                              conditionalPanel(
                                                condition= "input.clusts > 24",
                                                colourInput("Cluster_25", "Cluster_25", value="#7B3F00")
                                              )
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )),
      mainPanel(
        #Display the graph generated in the 'server.R' file
        plotlyOutput("plot1")
      )
    )
  )