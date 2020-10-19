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
  print(paste("Database Version:",getDbVersion()))
  print(paste("Logged In:",session$user ))
  
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
  observeEvent(input$changeTask4, {
    shinydashboard::updateTabItems(session, "explorertabs", "task_4")
  })
  observeEvent(input$changeDataInfo, {
    shinydashboard::updateTabItems(session, "explorertabs", "datainfo")
  })
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("sqlite", "zip", sep=".")
    },
    content = function(fname) {
      zip(zipfile=fname, files="data/storagedata.db")
    },
    contentType = "application/zip"
  )
  
  
  ###################################################
  #####          Home Page - Patient Form       #####
  ###################################################
  clearPatientForm <- function(){
    updateTextInput(session, "patient_clinicalid", value = "")
    updateTextInput(session, "patient_clinicalId2", value = "")
    updateTextInput(session, "patient_firstname", value = "")
    updateTextInput(session, "patient_lastname", value = "")
    updateDateInput(session, "patient_birthdate", value = NULL)
    updateRadioButtons(session, "patient_mortality", selected = "0")
    updateRadioButtons(session, "patient_gender", selected = "0")
    updateRadioButtons(session, "vipStatus_newPatient", selected = "N")
    updateTextAreaInput(session, "comments_newPatient", value = "")
  }
  
  output$newPatientDiagnosisSelect <- renderUI({
    list <- rownames( get_allDiagnosis() )
    names(list) <- get_allDiagnosis()$term
    selectInput("patient_diagnosis", label = "Diagnosis:", choices = list)
  })

    observeEvent(input$submit_newPatient, {
    #adds a new patient to the database from form
    diagTbl <- get_allDiagnosis()
    inputDF <- data.frame(
      record_id	= input$patient_clinicalid,
      secondary_id = input$patient_clinicalId2,
      deceased = input$patient_mortality,
      vip_flag = input$patient_vipstatus,
      last_name =	input$patient_lastname,
      first_name = input$patient_firstname,
      sex	= input$patient_gender,
      date_of_birth = input$patient_birthdate,
      primary_diagnosis_descript = diagTbl[input$patient_diagnosis,]$term,
      primary_diagnosis_codesour = diagTbl[input$patient_diagnosis,]$code_type,
      primary_diagnosis_code = diagTbl[input$patient_diagnosis,]$code,
      tumor_stage = input$patient_disease_stage
    )
    #Check to ensure entry goes into the database.
    if( create_Patient(inputDF) ){
      showNotification("Patient Added", duration = 120, type = "message")
      clearPatientForm()
    } else {
      showNotification("Error: Entry not saved to database. Contact Developer.", duration = 100, type = "error")
    }
  })
  
  observeEvent(input$clear_newPatient, {
    clearPatientForm()
  })
  
  
  
  ###################################################
  #####         Home Page - Blood Draw Form     #####
  ###################################################
  output$StudyPicker_newDraw <- renderUI({
    selectInput(inputId = "studyId_newDraw", label = "Study ID", choices = get_StudyList())
  })
  output$autoSamples <- renderUI({
    pats <- getPatients_All()
    autocomplete_input("autoRecordId", "Patient ID:", c('', pats$record_id), max_options = 15)
  })
  
  observeEvent(input$submit_newDraw, {
    inputDrawDF <- data.frame(
      draw_id = input$drawId_newDraw,
      record_id = input$autoRecordId,
      study_name = input$studyId_newDraw,
      total_tubes_received = input$totalTubes_newDraw,
      total_volume_received = as.character(input$totalVolume_newDraw),
      draw_date = as.numeric(input$date_newDraw),
      draw_time = as.numeric(gsub("[[:punct:]]|[[:alpha:]]", "", input$time_newDraw)),
      #draw_time = as.numeric(input$time_newDraw),
      process_date= as.numeric(input$processDate_newDraw),
      process_time = as.numeric(gsub("[[:punct:]]|[[:alpha:]]", "", input$processTime_newDraw)),
      num_sodium_heparin_tubes = input$sodiumTubes_newDraw,
      num_of_edta_tubes = input$EDTATubes_newDraw,
      num_whole_blood_tubes = input$wholeTubes_newDraw,
      num_streck_tubes = input$streckTubes_newDraw,
      num_acd_tubes = input$ACDTubes_newDraw,
      num_other_tubes = input$otherTubes_newDraw,
      processed_plasma_tubes = input$plasmaTubes_newDraw,
      processed_plasma_volume = input$plasmaVolume_newDraw,
      processed_serum_tubes = input$serumTubes_newDraw,
      processed_serum_volume = input$serumVolume_newDraw,
      processed_cell_tubes = input$cellTubes_newDraw,
      processed_cell_volume = input$cellVolume_newDraw,
      processed_cell_conc = input$cellConcentration_newDraw,
      comments = input$comments_newDraw,
      retired = "F"
      
    )
    if( add_NewDraw(inputDrawDF) ){
      showNotification(paste("Blood Draw:",input$drawId_newDraw,"Successfully Added!"), duration = 100, type = "default")
    } else {
      showNotification("Error: Blood Draw did not sucessfully record in db.", duration = 100, type = "error")
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
    selectInput("box_moveBox", label = "Box:", choices = getBoxes_ByRack(input$currentRack_moveBox)$box)
  })
  output$type_moveBox <- renderUI({
    selectInput("type_moveBox", label = "Box Type:", choices = unique(getBoxes_ByRack(input$currentRack_moveBox)$box_type) )
  })
  output$newRack_moveBox <- renderUI({
    selectInput("newRack_moveBox", label = "Rack:", choices = getRacks_ByStudy(input$study_moveBox))
  })
  output$currentFreezer_moveBox <- renderUI({
    selectInput("currentFreezer_moveBox", label = "Freezer:", choices = c('AUTO',freezerNameList))
  })
  output$newFreezer_moveBox <- renderUI({
    selectInput("newFreezer_moveBox", label = "Freezer:", choices = freezerNameList)
  })
  
  
  ###################################################
  #####    Home Page - New Diagnosis Module     #####
  ###################################################
  
  output$recentDiagnosisTable = renderDT(get_allDiagnosis(), selection = 'none', rownames = F, editable = F)
  
  observeEvent(input$submit_dynamic_diagnosis, {
    inputDF <- data.frame(
      term = input$dynamic_diagnosis_term,
      code_type = input$dynamic_diagnosis_codetype,
      code = input$dynamic_diagnosis_code,
      upload_date = format(Sys.time(), "%m/%d/%y")
    )
    if( add_NewDiagnosis(inputDF) ){
      showNotification(paste("Diagnosis:",input$dynamic_diagnosis_term,"Successfully Added!"), duration = 100, type = "default")
      updateTextInput(session, "dynamic_diagnosis_term", value = "")
      updateTextInput(session, "dynamic_diagnosis_codetype", value = "")
      updateTextInput(session, "dynamic_diagnosis_code", value = "")
      output$recentDiagnosisTable = renderDT(get_allDiagnosis(), selection = 'none', rownames = F, editable = F)
    } else {
      showNotification("Error: Diagnosis did not sucessfully record in db.", duration = 100, type = "error")
    }
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
      currentRackID <- myRacks[i]
      myBoxes <- getBoxes_ByRack(currentRackID)
      justPlasma <- myBoxes %>% filter(box_type == "Plasma")
      justCells <- myBoxes %>% filter(box_type == "Cells")
      box(width = 12,title = paste("Rack:",currentRackID),solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
          fluidRow(
            box(width = 6,title = "Plasma", solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                fluidRow(
                  lapply(1:nrow(justPlasma), function(i) {
                    box(width = 5,title = paste("Box:",justPlasma$box[i]), solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                        p( getBoxSummary_lvl1(currentRackID,"Plasma",justPlasma$box[i]) ) )
                  }
                  )
                )),
            box(width = 6,title = "Cells", solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                fluidRow(
                  lapply(1:nrow(justCells), function(i) {
                    box(width = 5,title = paste("Box:",justCells$box[i]), solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                        p( getBoxSummary_lvl1(currentRackID,"Cells",justCells$box[i]) ) )
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
  storeDates_newBox <- vector(mode = "character", length = 100)
  
  observeEvent(input$addSamples_newBox, {
    slotStart <- as.numeric(input$slotStart_newBox)
    slotEnd <- slotStart + as.numeric(input$numTubes_newBox) - 1
    
    #updateActionButton(session, paste0("slot", slotEnd), label = "a")
    for(i in slotStart:slotEnd){
      
      currSlot <- paste0("slot", i, "_newBox")
      updateActionButton(session, currSlot, label = input$auto1, icon("vial"))
      
      slotContents_newBox[i] <<- input$auto1
      storeDates_newBox[i] <<- as.numeric(input$storeDate_newBox)
      
      #showNotification(slotContents_newBox[i], duration = 10)
      #showNotification(storeDates_newBox[i], duration = 10)
    }
    #showNotification(storeDates_newBox[1], duration = 10)
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

    ### please add "freezer_name"
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
      if(is_newBox(inputDF$rack, inputDF$box_type, inputDF$box)){
        for(i in 1:100){
          inputDF$slot <- i
          inputDF$blood_draw_id <- slotContents_newBox[i]
          inputDF$store_date <- as.numeric(storeDates_newBox[i])
          newRow <- bind_rows(newRow, inputDF)
        }
        add_NewBox(newRow)
        showNotification("Box Added", duration = 100, type = "message")
      }else{
        showNotification("Box already exists", duration = 100, type = "error")
      }
    }else{
      showNotification("Contact Developer. Input ID not found", duration = 100, type = "error")
    }
  })
  
  observeEvent(input$Clear_newBox, {
    slotContents_newBox <<- vector(mode = "character", length = 100)
    storeDates_newBox <<- vector(mode = "character", length = 100)
    for(i in 1:100){
      currSlot <- paste0("slot", i, "_newBox")
      updateActionButton(session, currSlot, label = i, icon(""))
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
  UpdatePullModal <- function(slt, name, slotObj, failed = FALSE) {
    modalDialog(
      fluidRow(
        column(9, h3("Update this Record",style="color:#0BB798") )
        ),
        fluidRow(
          column(2, disabled(numericInput("updatepull_slot", "Slot", slt))),
          column(4, disabled(textInput('updatepull_rack',"Rack", slotObj[1,]$rack)) ),
          column(4, disabled(textInput('updatepull_box',"Box", paste(slotObj[1,]$box,'-',slotObj[1,]$box_type))) )
        ),
        fluidRow(
          column(4, h4(paste('Sample:',name),style='margin-top: 25px') ),
          column(4, selectInput('updatepull_slot_status', "Status", choices=c("Frozen","Pulled"), selected = slotObj[1,]$status )  ),
          column(2, numericInput("updatepull_volume", "Amount (mL)", slotObj[1,]$frozen_volume) )
        ),
        hr(),
        fluidRow(
          column(4, dateInput("updatepull_store_date","Storage Date",slotObj[1,]$store_date, format="mm/dd/yyyy"), offset = 1 ),
          column(4, dateInput("updatepull_pulled_date","Pulled Date",slotObj[1,]$pulled_date, format="mm/dd/yyyy"), offset = 1 )
        ),
        fluidRow(
          column(10, offset = 1, textAreaInput("updatepull_frozen_comment",'Comments',slotObj[1,]$frozen_comment, width="100%"),
                 hidden(numericInput("updatepull_slot_id", "", slotObj[1,]$id))
          )
        ),
        if (failed)
          div(tags$b("Error! Unable to update database", style = "color: red;")),
        
        footer = tagList(
          modalButton("Cancel"),
          actionButton("ok_updaterecord", "OK")
        )
      )
  }
  
  observeEvent(input$ok_updaterecord, {
    #print(input$updatepull_slot_id)
    if( update_slot(input$updatepull_slot_id,input$updatepull_slot_status,input$updatepull_volume,input$updatepull_store_date,input$updatepull_pulled_date) ){
      showNotification(paste("Slot:",input$updatepull_slot,"Successfully",input$updatepull_slot_status,"!"), duration = 100, type = "default")
      removeModal()
    } else {
      showNotification("Error: Freezer Slot did not sucessfully record in db.", duration = 100, type = "error")
      showModal(UpdatePullModal(failed = TRUE))
    }
    
  })
  
  
  observeEvent(input$slot1_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 1, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 1, input$type_updateBox)
    showModal(UpdatePullModal(1, label, slObj))
  })
  observeEvent(input$slot2_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 2, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 2, input$type_updateBox)
    showModal(UpdatePullModal(2, label, slObj))
  })
  observeEvent(input$slot3_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 3, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 3, input$type_updateBox)
    showModal(UpdatePullModal(3, label, slObj))
  })
  observeEvent(input$slot4_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 4, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 4, input$type_updateBox)
    showModal(UpdatePullModal(4, label, slObj))
  })
  observeEvent(input$slot5_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 5, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 5, input$type_updateBox)
    showModal(UpdatePullModal(5, label, slObj))
  })
  observeEvent(input$slot6_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 6, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 6, input$type_updateBox)
    showModal(UpdatePullModal(6, label, slObj))
  })
  observeEvent(input$slot7_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 7, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 7, input$type_updateBox)
    showModal(UpdatePullModal(7, label, slObj))
  })
  observeEvent(input$slot8_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 8, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 8, input$type_updateBox)
    showModal(UpdatePullModal(8, label, slObj))
  })
  observeEvent(input$slot9_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 9, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 9, input$type_updateBox)
    showModal(UpdatePullModal(9, label, slObj))
  })
  observeEvent(input$slot10_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 10, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 10, input$type_updateBox)
    showModal(UpdatePullModal(10, label, slObj))
  })
  observeEvent(input$slot11_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 11, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 11, input$type_updateBox)
    showModal(UpdatePullModal(11, label, slObj))
  })
  observeEvent(input$slot12_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 12, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 12, input$type_updateBox)
    showModal(UpdatePullModal(12, label, slObj))
  })
  observeEvent(input$slot13_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 13, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 13, input$type_updateBox)
    showModal(UpdatePullModal(13, label, slObj))
  })
  observeEvent(input$slot14_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 14, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 14, input$type_updateBox)
    showModal(UpdatePullModal(14, label, slObj))
  })
  observeEvent(input$slot15_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 15, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 15, input$type_updateBox)
    showModal(UpdatePullModal(15, label, slObj))
  })
  observeEvent(input$slot16_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 16, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 16, input$type_updateBox)
    showModal(UpdatePullModal(16, label, slObj))
  })
  observeEvent(input$slot17_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 17, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 17, input$type_updateBox)
    showModal(UpdatePullModal(17, label, slObj))
  })
  observeEvent(input$slot18_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 18, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 18, input$type_updateBox)
    showModal(UpdatePullModal(18, label, slObj))
  })
  observeEvent(input$slot19_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 19, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 19, input$type_updateBox)
    showModal(UpdatePullModal(19, label, slObj))
  })
  observeEvent(input$slot20_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 20, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 20, input$type_updateBox)
    showModal(UpdatePullModal(20, label, slObj))
  })
  observeEvent(input$slot21_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 21, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 21, input$type_updateBox)
    showModal(UpdatePullModal(21, label, slObj))
  })
  observeEvent(input$slot22_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 22, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 22, input$type_updateBox)
    showModal(UpdatePullModal(22, label, slObj))
  })
  observeEvent(input$slot23_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 23, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 23, input$type_updateBox)
    showModal(UpdatePullModal(23, label, slObj))
  })
  observeEvent(input$slot24_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 24, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 24, input$type_updateBox)
    showModal(UpdatePullModal(24, label, slObj))
  })
  observeEvent(input$slot25_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 25, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 25, input$type_updateBox)
    showModal(UpdatePullModal(25, label, slObj))
  })
  observeEvent(input$slot26_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 26, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 26, input$type_updateBox)
    showModal(UpdatePullModal(26, label, slObj))
  })
  observeEvent(input$slot27_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 27, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 27, input$type_updateBox)
    showModal(UpdatePullModal(27, label, slObj))
  })
  observeEvent(input$slot28_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 28, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 28, input$type_updateBox)
    showModal(UpdatePullModal(28, label, slObj))
  })
  observeEvent(input$slot29_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 29, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 29, input$type_updateBox)
    showModal(UpdatePullModal(29, label, slObj))
  })
  observeEvent(input$slot30_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 30, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 30, input$type_updateBox)
    showModal(UpdatePullModal(30, label, slObj))
  })
  observeEvent(input$slot31_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 31, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 31, input$type_updateBox)
    showModal(UpdatePullModal(31, label, slObj))
  })
  observeEvent(input$slot32_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 32, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 32, input$type_updateBox)
    showModal(UpdatePullModal(32, label, slObj))
  })
  observeEvent(input$slot33_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 33, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 33, input$type_updateBox)
    showModal(UpdatePullModal(33, label, slObj))
  })
  observeEvent(input$slot34_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 34, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 34, input$type_updateBox)
    showModal(UpdatePullModal(34, label, slObj))
  })
  observeEvent(input$slot35_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 35, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 35, input$type_updateBox)
    showModal(UpdatePullModal(35, label, slObj))
  })
  observeEvent(input$slot36_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 36, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 36, input$type_updateBox)
    showModal(UpdatePullModal(36, label, slObj))
  })
  observeEvent(input$slot37_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 37, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 37, input$type_updateBox)
    showModal(UpdatePullModal(37, label, slObj))
  })
  observeEvent(input$slot38_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 38, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 38, input$type_updateBox)
    showModal(UpdatePullModal(38, label, slObj))
  })
  observeEvent(input$slot39_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 39, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 39, input$type_updateBox)
    showModal(UpdatePullModal(39, label, slObj))
  })
  observeEvent(input$slot40_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 40, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 40, input$type_updateBox)
    showModal(UpdatePullModal(40, label, slObj))
  })
  observeEvent(input$slot41_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 41, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 41, input$type_updateBox)
    showModal(UpdatePullModal(41, label, slObj))
  })
  observeEvent(input$slot42_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 42, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 42, input$type_updateBox)
    showModal(UpdatePullModal(42, label, slObj))
  })
  observeEvent(input$slot43_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 43, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 43, input$type_updateBox)
    showModal(UpdatePullModal(43, label, slObj))
  })
  observeEvent(input$slot44_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 44, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 44, input$type_updateBox)
    showModal(UpdatePullModal(44, label, slObj))
  })
  observeEvent(input$slot45_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 45, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 45, input$type_updateBox)
    showModal(UpdatePullModal(45, label, slObj))
  })
  observeEvent(input$slot46_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 46, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 46, input$type_updateBox)
    showModal(UpdatePullModal(46, label, slObj))
  })
  observeEvent(input$slot47_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 47, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 47, input$type_updateBox)
    showModal(UpdatePullModal(47, label, slObj))
  })
  observeEvent(input$slot48_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 48, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 48, input$type_updateBox)
    showModal(UpdatePullModal(48, label, slObj))
  })
  observeEvent(input$slot49_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 49, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 49, input$type_updateBox)
    showModal(UpdatePullModal(49, label, slObj))
  })
  observeEvent(input$slot50_updateBox, {
    label = getSamples_byLocation(input$rack_updateBox, input$box_updateBox, 50, input$type_updateBox)
    slObj = getSlot_byLocation(input$rack_updateBox, input$box_updateBox, 50, input$type_updateBox)
    showModal(UpdatePullModal(50, label, slObj))
  })
  
  
})
