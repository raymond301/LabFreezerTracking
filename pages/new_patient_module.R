newPatientForm <- function(id) {
  ns <- NS(id)
  tabItem(
    tabName = "task_1",
    fluidPage(
      h3("Add New Patient"),
      box(
        width = 12,
        background = "blue",
        fluidRow(
          box(
            width = 3,
            background = "blue",
            textInput(inputId = "patient_firstname", label = "Patient Name", placeholder = "First Name"),
          ),
          box(
            width = 3,
            background = "blue",
            textInput(inputId = "patient_lastname", label = "", placeholder = "Last Name"),
          ),
          box(
            width = 2,
            background = "blue",
            dateInput(inputId = "patient_birthdate", label = "Birth Date", format = "m-d-yyyy")
          ),
          box(
            width = 2,
            background = "blue",
            textInput(inputId = "patient_clinicalid", label = "Clinical ID", placeholder = "No hyphens...")
          )
        ),
        fluidRow(
          box(
            width = 4,
            background = "blue",
            radioButtons(inputId = "patient_mortality", label = "Mortality Status:", 
                         choices = c("Alive" = 0, "Dead" = 1), selected = 0)
          ),
          box(
            width = 4,
            background = "blue",
            radioButtons(inputId = "patient_gender", label = "Sex:", 
                         choices = c("Male" = 1, "Female" = 2, "Unknown/Other" = 3), selected = 3)
          ),
          box(
            width = 4,
            background = "blue",
            textInput(inputId = "patient_clinicalId2", label = "Second Clinical ID/External ID (optional)", 
                      placeholder = "Enter Second Clinical ID Number...")
          )  
        ),
        fluidRow(
          # box(
          #   width = 4,
          #   background = "blue",
          #   dateInput(inputId = "patient_deathdate", label = "Death Date (MM/DD/YYYY)", format = "m/d/yyyy")
          # ),
          box(
            width = 4,
            background = "blue",
            radioButtons(inputId = "patient_vipstatus", label = "Flag as VIP:", 
                         choices = c("Yes" = 1, "No" = 0), selected = 0)
          ),
          box(
            width = 4,
            background = "blue",
            textAreaInput(inputId = "comments_newPatient", label = "Comments (optional)", rows = 2,
                          placeholder = "Add additional comments...")
            
          )
        ),
        fluidRow(
          box(
            width = 6,
            background = "blue",
            uiOutput("newPatientDiagnosisSelect")
          ),
          box( 
            width = 4,
            background = "blue",
            selectInput("patient_disease_stage", label = "Progression:", choices = c("","Stage 1","Stage 1/2","Stage 2","Stage 2/3","Stage 3","Stage 3/4","Stage 4") )
          )
        ),
        actionButton(inputId = "submit_newPatient", label = "Submit"),
        actionButton(inputId = "clear_newPatient", label = "Clear")
        #uiOutput("submitMessage_newPatient")
      )
    )
  )
}