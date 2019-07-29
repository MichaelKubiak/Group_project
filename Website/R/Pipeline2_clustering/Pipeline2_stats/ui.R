library(shiny)
library(plotly)
library(colourpicker)



fluidPage(
  titlePanel("Graphs"),
  sidebarLayout(
    sidebarPanel(
      selectInput("graph","Please select the plot you wish to view", 
                  choices = c("Consensus Matrix"                = "b",
                              "Silhouette Plot"                 = "c",
                              "Expression Matrix"               = "d",
                              "Cluster Stability"               = "e",
                              "Differentially Expressed Genes"  = "f",
                              "Marker Genes"                    = "g"
                              )),
      
      selectInput("dataset", "Select the gene count matrix", 
                  choices = c("Author Gene Count Matrix"        = "b",
                              "Self Gene Count Matrix"          = "c")),
      
      checkboxInput("zinbwave", "Zinbwave initialised",value = FALSE),
      
      sliderInput("clusts", "Number of clusters to colour:", min=5, max=25, value = 10)

      # conditionalPanel(condition = "input.graph == 'b'",
      #                  colourInput("Similar", "Similar", value = "#FF0000"),
      #                  colourInput("Indifferent", "Indifferent", value = "#FFFFFF"),
      #                  colourInput("Different", "Different", value = "#0000FF"))
      ),

    mainPanel(
      #Display the graph generated in the 'server.R' file
      plotOutput("plot1")
    )
  )
)