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
  observeEvent(input$changeTask3, {
    shinydashboard::updateTabItems(session, "explorertabs", "task_3")
  })
  observeEvent(input$changeDataInfo, {
    shinydashboard::updateTabItems(session, "explorertabs", "datainfo")
  })
  
  ###################################################
  #####          Home Page - Patient Page       #####
  ###################################################
  
  #adds a new patient to the database
  observeEvent(input$submit_newPatient, {

    newRow <- get_PatientColumnNames()

    # if("clinical_id" %in% colnames(newRow)){
    #   cat("found: clinical_id")
    # }else{
    #   cat("not found: clinical_id \n")
    # }
    inputDF <- data.frame(
      last_name <- input$patientName_newPatient,
      date_of_birth <- as.numeric(input$birthDate_newPatient),
      clinical_id <- input$clinicalId_newPatient,
      deceased <- input$mortality_newPatient,
      sex <- input$gender_newPatient,
      secondary_id <- as.numeric(input$clinicalId2_newPatient),
      date_of_death <- as.numeric(input$deathDate_newPatient),
      vip_flag <- input$vipStatus_newPatient,
      comments <- input$comments_newPatient
    )
    dbColumns <- colnames(newRow)
    inputColumns <- c("last_name", "date_of_birth", "clinical_id", "deceased", "sex", "secondary_id", 
                      "date_of_death", "vip_flag", "comments")
    
    # inputDF <- data.frame(last_name, date_of_birth, clinical_id, deceased, sex, secondary_id,
    #                       date_of_death, vip_flag, comments)
    colnames(inputDF) <- inputColumns
    
    cat("Valid Columns: ")
    cat(intersect(dbColumns, inputColumns))
    cat("\n")
    
    cat("In database, not input: ")
    cat(setdiff(dbColumns, inputColumns))
    cat("\n")
    
    cat("In input, not database: ")
    cat(setdiff(inputColumns, dbColumns))
    cat("\n")
    
    
    #Check for valid inputs
    if(setequal(union(inputColumns, dbColumns), dbColumns)){
      newRow <- bind_rows(newRow, inputDF)
      
      if(check_PatientInput(newRow)){
            
            add_NewPatient(newRow)
            showNotification("Patient Added", duration = 120, type = "message")
      }

    }else{
      showNotification("Contact Developer. Input ID not found", duration = 100, type = "error")
      #output$submitMessage_newPatient <- renderText({"ERROR: Contact Developer. Input ID not found in database"})
    }
  })
  
  ###################################################
  #####         Home Page - Blood Draw Page     #####
  ###################################################
  
  output$StudyPicker_newDraw <- renderUI({
    selectInput(inputId = "studyId_newDraw", label = "Study ID", choices = get_StudyList())
  })
  
  observeEvent(input$submit_newDraw, {
    
    inputDF <- data.frame(
      
      draw_id <- input$drawId_newDraw,
      study_name <- input$studyId_newDraw,
      total_tubes_received <- input$totalTubes_newDraw,
      total_volume_received <- as.character(input$totalVolume_newDraw),
      draw_date <- as.numeric(input$date_newDraw),
      draw_time <- as.numeric(gsub("[[:punct:]]|[[:alpha:]]", "", input$time_newDraw)),
      #draw_time <- as.numeric(input$time_newDraw),
      process_date<- as.numeric(input$processDate_newDraw),
      process_time <- as.numeric(gsub("[[:punct:]]|[[:alpha:]]", "", input$processTime_newDraw)),
      
      num_sodium_heparin_tubes <- input$sodiumTubes_newDraw,
      num_of_edta_tubes <- input$EDTATubes_newDraw,
      num_whole_blood_tubes <- input$wholeTubes_newDraw,
      num_streck_tubes <- input$streckTubes_newDraw,
      num_acd_tubes <- input$ACDTubes_newDraw,
      num_other_tubes <- input$otherTubes_newDraw,
      
      processed_plasma_tubes <- input$plasmaTubes_newDraw,
      processed_plasma_volume <- input$plasmaVolume_newDraw,
      processed_serum_tubes <- input$serumTubes_newDraw,
      processed_serum_volume <- input$serumVolume_newDraw,
      processed_cell_tubes <- input$cellTubes_newDraw,
      processed_cell_volume <- input$cellVolume_newDraw,
      
      comments <- input$comments_newDraw
    )
    
    inputColumns <- c("draw_id", "study_name", "total_tubes_received", "total_volume_received", "draw_date",
                      "draw_time", "process_date", "process_time", "num_sodium_heparin_tubes", "num_of_edta_tubes",
                      "num_whole_blood_tubes", "num_streck_tubes", "num_acd_tubes", "num_other_tubes",
                      "processed_plasma_tubes", "processed_plasma_volume", "processed_serum_tubes",
                      "processed_serum_volume", "processed_cell_tubes", "processed_cell_volume", "comments")
    
    colnames(inputDF) <- inputColumns
    
    newRow <- get_FreezerColumnNames()
    dbColumns <- colnames(newRow)
    
    cat("Valid Columns: ")
    cat(intersect(dbColumns, inputColumns))
    cat("\n")
    
    cat("In database, not input: ")
    cat(setdiff(dbColumns, inputColumns))
    cat("\n")
    
    cat("In input, not database: ")
    cat(setdiff(inputColumns, dbColumns))
    cat("\n")
    
    
    if(setequal(union(inputColumns, dbColumns), dbColumns)){
      
      newRow <- bind_rows(newRow, inputDF)
      
      if(check_DrawInput(newRow)){
        
        add_NewDraw(newRow)
        showNotification("Blood Draw Added", duration = 100, type = "message")
      }
      
      
      #output$submitMessage_newDraw <- renderText({"Blood Draw Added"})
      
    }else{
      showNotification("Contact Developer. Input ID not found", duration = 100, type = "error")
      #output$submitMessage_newDraw <- renderText({"ERROR. Contact Developer. Input ID not found in database"})
    }
  })
  
  ###################################################
  #####          Home Page - Move Box Page      #####
  ###################################################
  
  output$StudyPicker_moveBox <- renderUI({
    selectInput(inputId = "study_moveBox", label = "Current Study:", choices = get_StudyList() )
  })
  output$currentRack_moveBox <- renderUI({
    selectInput("currentRack_moveBox", label = "Rack:", choices = getRacks_ByStudy(input$study_moveBox))
  })
  output$box_moveBox <- renderUI({
    selectInput("box_moveBox", label = "Box:", choices = getBoxes_ByRack(input$currentRack_moveBox))
  })
  output$type_moveBox <- renderUI({
    selectInput("type_moveBox", label = "Box Type:", choices = getTypes_byLocation(input$currentRack_moveBox, input$box_moveBox))
  })
  output$newRack_moveBox <- renderUI({
    selectInput("newRack_moveBox", label = "Rack:", choices = getRacks_ByStudy(input$study_moveBox))
  })
  output$currentFreezer_moveBox <- renderUI({
    selectInput("currentFreezer_moveBox", label = "Freezer:", choices = freezerNameList)
  })
  output$newFreezer_moveBox <- renderUI({
    selectInput("newFreezer_moveBox", label = "Freezer:", choices = freezerNameList)
  })
  
  ###################################################
  #####             Freezer Page                #####
  ###################################################
  output$StudyPicker <- renderUI({
    selectInput(inputId = "select_study", label = "Working on:", choices = get_StudyList() )
  })
  output$current_study <- output$current_study2 <- output$current_study3 <- renderText({ input$select_study })
  
  output$current_study2 <- output$current_study3 <- renderText({ paste("Current Study:", input$select_study) })
  
  ### Query to pull all blood draw ids, for auto-complete (study specific)
  observeEvent(input$select_study, {
    output$autoDraws <- renderUI({
      autocomplete_input("auto1", "Blood Draws:", c('',getBloodDrawIDs_ByStudy(input$select_study)), max_options = 10)
    })
  })
  
  ###################################################
  #####     Freezer Page  - FIND TAB            #####
  ###################################################
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
  
  
  ###################################################
  #####     Freezer Page  - CREATE TAB          #####
  ###################################################
  output$FreezerPicker_newBox <- renderUI({
    tags$div(title = "The freezer the box is in...", style = "margin-bottom: -10px; margin-top: -5px",
             selectInput("freezer_newBox", label = "Freezer:", choices = freezerNameList)
    )
  })
  output$RackPicker_newBox <- renderUI({
    tags$div(title = "The rack the new box is in...", style = "margin-bottom: -10px; margin-top: -5px",
             selectInput("rack_newBox", label = "Rack:", choices = getRacks_ByStudy(input$select_study))
    )
  })
  observeEvent(input$newRack_newBox, {
    showModal(modalDialog(
      title = "Create a new Freezer Rack",
      fluidRow(
        box(
          width = 5,
          background = "blue",
          height = 90,
          selectInput("Study_newRack", label = "Study", choices = get_StudyList(), selected = input$select_study)
        ),
        box(
          width = 3,
          background = "blue",
          height = 90,
          selectInput("Freezer_newRack", label = "Freezer", choices = freezerNameList)
        ),
        box(
          width = 4,
          background = "blue",
          height = 90,
          textInput("Name_newRack", label = "Rack Name")
        )
      ),
      actionButton("Save_newRack", label = "Save Rack")
    ))
  })
  output$Name_newBox <- renderUI({
    tags$div(title = "The name of the new box...", style = "margin-bottom: -4px; margin-top: -5px",
             textInput("name_newBox", label = "Box Name:")
    )
  })
  output$Type_newBox <- renderUI({
    tags$div(title = "The type of tubes to be stored in the box...", style = "margin-bottom: -10px; margin-top: -5px",
             selectInput("type_newBox", label = "Box Type:", choices = c("Cells", "Plasma"))
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
    numCols <- 10
    numRows <- 10
    div(style = " white-space: nowrap; overflow-x: auto; overflow-y: hidden",

    lapply(1:numRows, function(j){
      div(style = "display:block;",
        lapply(1:numCols, function(i){
         div(style = "display:inline-block; margin: 0px 0px; ",
          
         list(
           #tags$u(h6(paste0("Slot ", i + ((j-1)*numCols) ))),

           actionButton(paste0("slot", i + ((j-1)*numCols), "_newBox"), label = i + ((j-1)*numCols), width = 100)
         )
        )
      })
      )
    })

    )
  })
  
  output$SlotStart_newBox <- renderUI({
    tags$div(title = "The starting slot to enter the samples...", style = "margin-right: -15px;",
             textInput("slotStart_newBox", label = "Starting Slot:")
    )
  })
  output$NumTubes_newBox <- renderUI({
    tags$div(title = "The number of slots to enter samples into...", style = "margin-left: -20px;",
             textInput("numTubes_newBox", label = "# of Samples:")
    )
  })
  output$StoreDate_newBox <- renderUI({
    tags$div(title = "The date the sample is put into the freezer",
             dateInput("storeDate_newBox", label = "Store Date: (MM/DD/YYYY)", format = "m/d/yyyy")
    )
  })
  
  slotContents_newBox <- vector(mode = "character", length = 100)
  storeDates_newBox <- vector(mode = "numeric", length = 100)
  
  observeEvent(input$addSamples_newBox, {
    slotStart <- as.numeric(input$slotStart_newBox)
    slotEnd <- slotStart + as.numeric(input$numTubes_newBox) - 1
    
    #updateActionButton(session, paste0("slot", slotEnd), label = "a")
    for(i in slotStart:slotEnd){
      
      currSlot <- paste0("slot", i, "_newBox")
      updateActionButton(session, currSlot, label = input$auto1, icon("vial"))
      slotContents_newBox[i] <<- input$auto1
      storeDates_newBox[i] <<- as.numeric(input$storeDate_newBox)
      #showNotification(slotContents_newBox[50], duration = 10)
    }
    #showNotification(slotContents_newBox[1], duration = 10)
  })
  
  
  observeEvent(input$Save_newBox, {
    
    
    inputDF <- data.frame(
      
      rack <- input$rack_newBox,
      box <- input$name_newBox,
      box_type <- input$type_newBox,
      slot <- 1,
      blood_draw_id <- "",
      status <- "Frozen",
      store_date <- 0
      
    )

    inputColumns <- c("rack", "box", "box_type", "slot", "blood_draw_id", "status", "store_date")
    colnames(inputDF) <- inputColumns
    
    newRow <- get_BoxColumnNames()
    dbColumns <- colnames(newRow)
    
    
    cat("Valid Columns: ")
    cat(intersect(dbColumns, inputColumns))
    cat("\n")
    
    cat("In database, not input: ")
    cat(setdiff(dbColumns, inputColumns))
    cat("\n")
    
    cat("In input, not database: ")
    cat(setdiff(inputColumns, dbColumns))
    cat("\n")

    if(setequal(union(inputColumns, dbColumns), dbColumns)){
      
      for(i in 1:100){
        
        inputDF$slot <- i
        inputDF$blood_draw_id <- slotContents_newBox[i]
        inputDF$store_date < storeDates_newBox[i]
        
        newRow <- bind_rows(newRow, inputDF)
      }
      
      add_NewBox(newRow)
      showNotification("Box Added", duration = 100, type = "message")
      
    }else{
      showNotification("Contact Developer. Input ID not found", duration = 100, type = "error")
    }
  })
  
  
  ###################################################
  #####     Freezer Page  - UPDATE TAB          #####
  ###################################################
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
             selectInput("type_updateBox", label = "Box Type", choices = getTypes_byLocation(input$rack_updateBox, input$box_updateBox))
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
                            actionButton(paste0("slot", i + ((j-1)*numCols), "_updateBox"), 
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
  
  
  
  ####################################################
  #####  MODAL & Submit new record to Database   #####
  ####################################################
  # Return the UI for a modal dialog with data selection input. If 'failed' is
  # TRUE, then display a message that the previous value was invalid.
  newDrawModal <- function(slt, name, slotObj, failed = FALSE) {
    modalDialog(
      fluidRow(
        column(9, span(
          h4(paste("Update record for Slot #",slt,":", name)),
          style="color:#0BB815"))
      ),
      fluidRow(
        column(4, paste("Status:",slotObj[1,]$status) ),
        column(4, actionButton(paste0("pull_slot",slt), label = "Pull")
        ),
        column(4, )
      ),
      hr(),
      fluidRow(
        column(6, dateInput("draw_date","Date", format="mm/dd/yy")
        )
      ),
      fluidRow(
        column(4, h5('Amount (mL):')),
        column(4, textInput("total_received_tube","#")
        )
      ),
      fluidRow(
        column(4, h5('Comments:')),
        column(4, textInput("total_received_tube","#")
        )
      ),
      if (failed)
        div(tags$b("Error! Unable to update database", style = "color: red;")),
      
      footer = tagList(
        modalButton("Cancel"),
        actionButton("ok_drawrecord", "OK")
      )
    )
  }
  
  observeEvent(input$slot1_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 1, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 1, input$type_updateBox)
    print(slObj)
    showModal(newDrawModal(1, label, slObj))
  })
  
  
  
  
})
