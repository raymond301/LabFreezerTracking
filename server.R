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
  
  output$current_study2 <- output$current_study3 <- renderText({ paste("Current Study:", input$select_study) })
  
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
  
  #Create new box page
  bdlist <<- c()
  ### Query to pull all blood draw ids, for auto-complete (study specific)
  observeEvent(input$select_study, {
    output$autoDraws <- renderUI({
      autocomplete_input("auto1", "Blood Draws:", c('',getBloodDrawIDs_ByStudy(input$select_study)), max_options = 10)
    })
  })
  
  observeEvent(input$auto1, {
    bdlist <<- c(bdlist, input$auto1)
    bdlist <<- bdlist[bdlist != ""]
    if(length(bdlist) > 0){
      output$autoListNav <- renderUI({
          radioButtons("picked_bd", "Prepared IDs", choices = bdlist)
      })
    }
    update_autocomplete_input(session,"auto1",value = "")
  })
  
  output$FreezerPicker_newBox <- renderUI({
    tags$div(title = "The freezer the box is in...", style = "margin-bottom: -10px; margin-top: -5px",
      selectInput("freezer_newBox", label = "Freezer", choices = 1:9)
    )
  })
  output$RackPicker_newBox <- renderUI({
    tags$div(title = "The rack the new box is in...", style = "margin-bottom: -10px; margin-top: -5px",
      selectInput("rack_newBox", label = "Rack", choices = getRacks_ByStudy(input$select_study))
    )
  })
  observeEvent(input$newRack_newBox, {
    showModal(modalDialog(
      title = "Create a new Freezer Rack",
      fluidRow(
        box(
          width = 5,
          selectInput("Study_newRack", label = "Study", choices = get_StudyList(), selected = input$select_study)
        ),
        box(
          width = 3,
          selectInput("Freezer_newRack", label = "Freezer", choices = 1:9)
        ),
        box(
          width = 4,
          textInput("Name_newRack", label = "Rack Name")
        )
      ),
      actionButton("Save_newRack", label = "Save Rack")
    ))
  })
  output$Name_newBox <- renderUI({
    tags$div(title = "The name of the new box...", style = "margin-bottom: -4px; margin-top: -5px",
      textInput("name_newBox", label = "Box Name")
    )
  })
  output$Type_newBox <- renderUI({
    tags$div(title = "The type of tubes to be stored in the box...", style = "margin-bottom: -10px; margin-top: -5px",
      selectInput("type_newBox", label = "Box Type", choices = c("Cells", "Plasma"))
    )
  })
#   output$Dimensions_newBox <- renderUI({
#     tags$div(title = "The dimensions of the new box...",
#       tagList(
#         div(style = "display:inline-block", selectInput("rows_newBox", label = "Rows", choices = 1:10, width = 80)),
#         div(style = "display:inline-block", selectInput("cols_newBox", label = "Columns", choices = 1:10, width = 80)),
#         
#       ),
#     )
# 
#   })
  
  output$Grid_newBox <- renderUI({
    # numCols <- as.numeric(input$cols_newBox)
    # numRows <- as.numeric(input$rows_newBox)
    numCols <- 10
    numRows <- 10
    
    div(style = " white-space: nowrap; overflow-x: auto; overflow-y: hidden",
    lapply(1:numRows, function(j){
      div(style = "display:block;",
        lapply(1:numCols, function(i){
         div(style = "display:inline-block; margin: 0px 0px; ",
          
         list(
           #tags$u(h6(paste0("Slot ", i + ((j-1)*numCols) ))),

           actionButton(paste0("slot", i + ((j-1)*numCols)), label = i + ((j-1)*numCols), width = 46)
         )
        )
      })
      )
    })
    )
    

  })
  
  #Update box page
  
  output$RackPicker_updateBox <- renderUI({
    tags$div(title = "The rack the box is in...", style = "margin-bottom: -10px; margin-top: -5px",
        selectInput("rack_updateBox", label = "Rack", choices = getRacks_ByStudy(input$select_study))
    )
  })
  output$BoxPicker_updateBox <- renderUI({
    tags$div(title = "The box to update...", style = "margin-bottom: -10px; margin-top: -5px",
        selectInput("box_updateBox", label = "Box", choices = getBoxes_ByRack(input$rack_updateBox))
    )
  })
  output$TypePicker_updateBox <- renderUI({
    tags$div(title = "The type of box to update...", style = "margin-bottom: -10px; margin-top: -5px",
        selectInput("type_updateBox", label = "Box Type", choices = c("Cells", "Plasma"))
    )
  })
  output$Grid_updateBox <- renderUI({
    numCols <- 10
    numRows <- 10
    backgroundColor <- NULL
    
    div(style = " white-space: nowrap; overflow-x: auto; overflow-y: hidden",
        lapply(1:numRows, function(j){
          div(style = "display:block;",
              lapply(1:numCols, function(i){
                 slotStatus <- getStatus_byLocation(input$rack_updateBox, input$box_updateBox,
                                                   i + ((j-1)*numCols), input$type_updateBox)
                 if(nrow(slotStatus) > 0){
                   if(slotStatus == "Frozen"){
                     backgroundColor <- "green"
                   }else if(slotStatus == "Pulled"){
                     backgroundColor <- "red"
                   }
                 }
                
                div(style = "display:inline-block; margin: 0px 0px -15px 0px; ",
                    list(
                      box(
                        width = 98, 
                        background = backgroundColor,
                        div(style = "display:inline-block; margin: -15px -5px 0px -5px; ",
                        tags$u(h6(paste0("Slot ", i + ((j-1)*numCols) ))),
                        actionButton(paste0("slot", i + ((j-1)*numCols)), 
                                   label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox,
                                                                 i + ((j-1)*numCols), input$type_updateBox), width = 90)
                        )
                      )
                    )
                )
              })
          )
        })
    )
  })

  
  
  
})
