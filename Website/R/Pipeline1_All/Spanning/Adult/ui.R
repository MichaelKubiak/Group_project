library(shiny)
library(plotly)
library(colourpicker)

fluidPage(
  titlePanel("Spanning Tree Adult Neurons"),
  fluidRow(
    column(4,
      selectInput("data", "Dataset", c("Author Generated Count Matrix"="auth", 
                                       "Original Pipeline Reproduced Count Matrix"="orig", 
                                       "New Pipeline Count Matrix"="sec"))
    )
  ),
  fluidRow(
    column(2,
      checkboxInput("path", "Show longest path",value = TRUE),
      colourInput("C1",   "Community 1",   value="#000080"),
      colourInput("C2",   "Community 2",   value="#FF0000"),
      colourInput("C3",   "Community 3",   value="#FFA500"),
      colourInput("C4",   "Community 4",   value="#008000"),
      colourInput("C5",   "Community 5",   value="#964B00"),
      colourInput("C6", "Community 6", value="#9966CC")
    ),
    column(2,
      colourInput("C7", "Community 7", value="#00FFFF"),
      colourInput("C8", "Community 8", value="#FD6C9E"),
      colourInput("C9", "Community 9", value="#CCCCFF"),
      colourInput("C10", "Community 10", value="#FF00FF"),
      colourInput("C11", "Community 11", value="#FFD700"),
      colourInput("C12", "Community 12", value="#3FFF00"),
      colourInput("C13", "Community 13", value="#00FF7F")
    ),
    conditionalPanel(condition = "input.data == 'sec'",
      column(2,
             colourInput("C14", "Community 14", value="#CCCCFF"),
             colourInput("C15", "Community 15", value="#FFFF00"),
             colourInput("C16", "Community 16", value="#40E0D0"),
             colourInput("C17", "Community 17", value="#50C878"),
             colourInput("C18", "Community 18", value="#4B0082")
             )
    ),
    column(6,
      plotOutput("plot1")
    )
  )
  
)
