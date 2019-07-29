library(shiny)
library(plotly)
library(colourpicker)


load("./pca_data.RData")

fluidPage(
  titlePanel("PCA plot"),
  fluidRow(
    column(4,
           selectInput("data", "Dataset", c("Author Generated Count Matrix"="auth", 
                                            "Original Pipeline Reproduced Count Matrix"="orig", 
                                            "New Pipeline Count Matrix"="sec"))
    )
  ),
  fluidRow(
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
