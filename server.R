library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  ###################################################
  #####              Home Page                  #####
  ###################################################
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
  
  
  
  ###################################################
  #####             Freezer Page                #####
  ###################################################
  output$StudyPicker <- renderUI({
    selectInput(inputId = "select_study", label = "Working on:", choices = get_StudyList() )
  })
  output$current_study <- output$current_study2 <- output$current_study3 <- renderText({ input$select_study })
  
  output$freezer_rack_tree <- renderUI({
    myRacks <- getRacks_ByStudy(input$select_study)
    lapply(1:length(myRacks), function(i) {
      myBoxes <- getBoxes_ByRack(myRacks[i])
      justPlasma <- myBoxes %>% filter(box_type == "Plasma")
      justCells <- myBoxes %>% filter(box_type == "Cells")
      box(width = 12,title = paste("Rack:",myRacks[i]),solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
          fluidRow(
            box(width = 6,title = "Plasma", solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                fluidRow(
                  lapply(1:nrow(justPlasma), function(i) {
                      box(width = 5,title = paste("Box:",justPlasma$box[i]), solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                          p( getBoxSummary_lvl1(myRacks[i],"Plasma",justPlasma$box[i]) ) )
                    }
                  )
                )),
            box(width = 6,title = "Cells", solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                fluidRow(
                  lapply(1:nrow(justCells), function(i) {
                    box(width = 5,title = paste("Box:",justCells$box[i]), solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                        p( getBoxSummary_lvl1(myRacks[i],"Cells",justCells$box[i]) ) )
                  }
                  )
                ))
          )
      )
    })
  })
  
  output$FreezerPicker_newBox <- renderUI({
    tags$div(title = "The freezer that the box is in...",
      selectInput("freezer_newBox", label = "Freezer", choices = 1:9)
    )
  })
  output$RackPicker_newBox <- renderUI({
    tags$div(title = "The rack the new box is in...",
      textInput("rack_newBox", label = "Rack")
    )
  })
  output$ID_newBox <- renderUI({
    tags$div(title = "The ID of the new box...",
      textInput("id_newBox", label = "Box ID")
    )
  })
  output$Dimensions_newBox <- renderUI({
    tags$div(title = "The dimensions of the new box...",
      tagList(
        div(style = "display:inline-block", selectInput("rows_newBox", label = "Rows", choices = 1:10, width = 80)),
#        div(style = "display:inline-block", p(" X ")),
        div(style = "display:inline-block", selectInput("cols_newBox", label = "Columns", choices = 1:10, width = 80)),
        
      ),
    )

  })

  
  
  
})
