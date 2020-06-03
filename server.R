library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  #Updates the screen based on the buttons on the homepage
  observeEvent(input$changeTask1, {
    shinydashboard::updateTabItems(session, "explorertabs", "task_1")
  })
  observeEvent(input$changeTask2, {
    shinydashboard::updateTabItems(session, "explorertabs", "task_2")
  })
  observeEvent(input$changeDataInfo, {
    shinydashboard::updateTabItems(session, "explorertabs", "datainfo")
  })
  
  
  
})
