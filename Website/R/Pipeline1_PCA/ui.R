library(shiny)
library(plotly)
library(colourpicker)


load("./pca_data.RData")

fluidPage(
  titlePanel("PCA plot"),
  fluidRow(height=10,
    column(3,
      colourInput("colad", "Adult neurons", value="blue"),
      colourInput("colfq", "Foetal quiescent neurons", value="red"),
      colourInput("colfr", "Foetal replicating neurons", value="orange")
    ),
    column(8,
      plotlyOutput("plot1")
    )
  )
  
)
