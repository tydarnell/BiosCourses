library(shiny)
library(tm)
library(tidyverse)
library(wordcloud)
library(memoise)
library(data.table)
library(wordcloud)

#Read in data set of top collaborators

top10=fread("~/Bios611/project3/p2_abstracts/top10.csv")

#get list of collaborators
collabs=unique(top10$Collaborators)

#create list of abstracts for each collaborator
wordlist=list()
for(i in 1:14){
  wordlist[i]=list(top10%>%filter(Collaborators==collabs[i])%>%select(Abstract))
}
#name the group of abstracts by collaborator
names(wordlist)=collabs

books <<- collabs

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(book) {
  
  text <- wordlist[book]
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})

# Define UI -----
ui <- fluidPage(
  # Application title
  titlePanel("Word Cloud"),
  
  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      selectInput("selection", "Choose an Instituion:",
                  choices = books),
      actionButton("update", "Change"),
      hr(),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 300,  value = 100)
    ),
    
    # Show Word Cloud
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define server logic -----
server <- function(input, output, session) {
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(4,0.5),
                   max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
}


# Run the app -----
shinyApp(ui = ui, server = server)