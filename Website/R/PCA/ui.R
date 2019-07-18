library(shiny)
library(plotly)
library(colourpicker)


load("./pca_data.RData")

fluidPage(
  titlePanel("PCA plot"),
  sidebarLayout(
    sidebarPanel(
      colourInput("colad", "Select colour for adult neurons", value="blue"),
      colourInput("colfq", "Select colour for foetal quiescent neurons", value="red"),
      colourInput("colfr", "Select colour for foetal replicating neurons", value="orange")
    ),
    mainPanel(
      plotlyOutput("plot1"),
      verbatimTextOutput("Hi")
    )
  )
  
)
