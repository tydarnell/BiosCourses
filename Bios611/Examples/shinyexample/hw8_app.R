library(tidyverse)
library(shiny)

police=read_delim("https://www.chapelhillopendata.org/explore/dataset/police-incident-reports-written/download/?format=csv&refine.date_of_report=2017&timezone=America/New_York&use_labels_for_header=true",
delim=";")

ui <- fluidPage(
  
  # App title ----
  titlePanel("Police Data"),
    
    # Main panel for displaying outputs ----
    mainPanel(
      # Input: Integer for the v-line position ----
      numericInput("num","number",min=18,max=92,value=30
      ),
      # Output: Histogram and table----
      plotOutput("agePlot")
      
    )
    )


# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # renderPlot creates histogram and links to ui
  output$agePlot <- renderPlot({
    police %>%
      filter(!is.na(`Victim Age`))%>%
    ggplot(aes(x=`Victim Age`)) +
      geom_histogram(bins=74) +
      geom_vline(xintercept=input$num)
  })
}

shinyApp(ui = ui, server = server)