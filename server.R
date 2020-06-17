library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  output$study_count <- renderText({ get_StudyCount() })
  output$patient_count <- renderText({ format(get_PatientCount(),big.mark=",",scientific=FALSE) })
  output$blooddraw_count <- renderText({ format(get_BloodDrawCount(),big.mark=",",scientific=FALSE) })
  output$freezerslot_count <- renderText({ format(get_FreezerSlotCount(),big.mark=",",scientific=FALSE) })
  
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
