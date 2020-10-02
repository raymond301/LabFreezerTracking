homepage <- dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(
    sidebarMenu(
      id = "explorertabs",
      menuItem("Home",
               tabName = "dashboard",
               icon = icon("dashboard")
      ),
      menuItem("Modules",
               icon = icon("bar-chart"), startExpanded = TRUE,
               menuSubItem(
                 "Add Patient",
                 tabName = "task_1",
                 icon = icon("cog")
               ),
               menuSubItem(
                 "Add Blood Draw",
                 tabName = "task_2",
                 icon = icon("cog")
               ),
               menuSubItem(
                 "Move a Box",
                 tabName = "task_3",
                 icon = icon("cog")
               )
      ),
      menuItem("Data Description",
               icon = icon("th-list"),
               tabName = "datainfo"
      ),
      shiny::hr()
      
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "dashboard",
        
        h1("Welcome to the Biospecimen Tracking App"),
        
        #Creates a box for the stats shown at the top of the screen
        box(
          width = 12,
          title = "What's inside",
          solidHeader = TRUE, collapsible = TRUE,
          
          fluidRow(
            infoBox("Studies:", textOutput("study_count"), width = 3, color = "olive",
                    fill = TRUE, icon = icon("book")),
            infoBox("Patients:", textOutput("patient_count"), width = 3, color = "yellow",
                    fill = TRUE, icon = icon("address-card")),
            infoBox("Blood Draws:", textOutput("blooddraw_count"), width = 3, color = "red",
                    fill = TRUE, icon = icon("syringe")),
            infoBox("Freezer Slots:", textOutput("freezerslot_count"), width = 3, color = "blue",
                    fill = TRUE, icon = icon("vial")),
          ),
        ),
        h2("Database Modules"),
          
        #Creates a box for each of the tabs found on the sidebar
        fluidRow(
          box(
            width = 6,
            title = "Add A Patient",
            solidHeader = TRUE, collapsible = TRUE, 
            box(
              width = 12,
              p("This module is for adding a new patient to the database")
            ),
            actionButton(inputId = "changeTask1", label = "Open Module")
          ),
          box(
            width = 6,
            title = "Add Blood Draw Event",
            solidHeader = TRUE, collapsible = TRUE, 
            box(
              width = 12,
              p("This module is for adding a new blood draw event to the database")
              ),
            actionButton(inputId = "changeTask2", label = "Open Module")
          )
        ),  
        fluidRow(
          box(
            width = 6,
            title = "Data Description",
            solidHeader = TRUE, collapsible = TRUE, 
            box(
              width = 12,
              p("Description of data")
            ),
            actionButton(inputId = "changeDataInfo", label = "Open Module")
        ),
        box(
          width = 6,
          title = "Move A Box",
          solidHeader = TRUE, collapsible = TRUE, 
          box(
            width = 12,
            p("This module is for moving an existing box from one freezer & rack to another.")
          ),
          actionButton(inputId = "changeTask3", label = "Open Module")
        )
        )

      ),
      
      
      
      
      #######################################
      #Sample pages for the other tabs
      tabItem(
        tabName = "task_1",
        fluidPage(
        h3("Add New Patient"),
        renderUI(test1),
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
          actionButton(inputId = "submit_newPatient", label = "Submit"),
          actionButton(inputId = "clear_newPatient", label = "Clear")
          #uiOutput("submitMessage_newPatient")
        )
        )
      ),
      
      
      
      
      
      tabItem(
        tabName = "task_2",
        fluidPage(
        h3("Add Blood Draw Event"),
        box(
          width = 12,
          background = "blue",
          fluidRow(
            box(
              width = 2,
              background = "blue",
              textInput(inputId = "drawId_newDraw", label = "Draw ID")
            ),
            box(
              width = 3,
              background = "blue",
              uiOutput("StudyPicker_newDraw")
            ),
            box(
              width = 3,
              background = "blue",
              uiOutput("autoSamples")
            ),
            box(
              width = 2,
              background = "blue",
              numericInput(inputId = "totalTubes_newDraw", label = "Total Tubes", value = 0, min = 0)
            ),
            box(
              width = 2,
              background = "blue",
              numericInput(inputId = "totalVolume_newDraw", label = "Total mL", value = 0, min = 0)
            )
          ),
          fluidRow(
            box(
              width = 3,
              background = "blue",
              dateInput(inputId = "date_newDraw", label = "Date of Draw", format = "m/d/yyyy")
            ),
            box(
              width = 3,
              background = "blue",
              textInput(inputId = "time_newDraw", label = "Time of Draw", placeholder = "HH:MM")
            ),
            box(
              width = 3,
              background = "blue",
              dateInput(inputId = "processDate_newDraw", label = "Date of Processing", format = "m/d/yyyy")
            ),
            box(
              width = 3,
              background = "blue",
              textInput(inputId = "processTime_newDraw", label = "Time of Processing", placeholder = "HH:MM")
            )
          ),
          
          h4("Tube Types:"),
          
          fluidRow(
            box(
              width = 6,
              title = "Sodium Heparin",
              solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
              fluidRow(
                box(
                  width = 6,
                  title = "Number of Tubes",
                  numericInput(inputId = "sodiumTubes_newDraw", label = NULL, value = 0, min = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "sodiumVolume_newDraw", label = NULL, value = 0, min = 0)
                )
              )
            ),
            box(
              width = 6,
              title = "EDTA",
              solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
              fluidRow(
                box(
                  width = 6,
                  title = "Number of Tubes",
                  numericInput(inputId = "EDTATubes_newDraw", label = NULL, value = 0, min = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "EDTAVolume_newDraw", label = NULL, value = 0, min = 0)
                )
              )
            ),
          ),
          
          fluidRow(
            box(
              width = 6,
              title = "Whole Blood",
              solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
              fluidRow(
                box(
                  width = 6,
                  title = "Number of Tubes",
                  numericInput(inputId = "wholeTubes_newDraw", label = NULL, value = 0, min = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "wholeVolume_newDraw", label = NULL, value = 0, min = 0)
                )
              )
            ),
            box(
              width = 6,
              title = "Streck",
              solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
              fluidRow(
                box(
                  width = 6,
                  title = "Number of Tubes",
                  numericInput(inputId = "streckTubes_newDraw", label = NULL, value = 0, min = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "streckVolume_newDraw", label = NULL, value = 0, min = 0)
                )
              )
            ),
          ),
          
          fluidRow(
            box(
              width = 6,
              title = "ACD",
              solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
              fluidRow(
                box(
                  width = 6,
                  title = "Number of Tubes",
                  numericInput(inputId = "ACDTubes_newDraw", label = NULL, value = 0, min = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "ACDVolume_newDraw", label = NULL, value = 0, min = 0)
                )
              )
            ),
            box(
              width = 6,
              title = "Other",
              solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
              fluidRow(
                box(
                  width = 6,
                  title = "Number of Tubes",
                  numericInput(inputId = "otherTubes_newDraw", label = NULL, value = 0, min = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "otherVolume_newDraw", label = NULL, value = 0, min = 0)
                )
              )
            ),
          ),
          fluidRow(
            column(
              width = 3,
              
              h4("Processed Plasma Tubes:"),
              fluidRow(
                box(
                  width = 6,
                  status = "danger",
                  background = "blue",
                  numericInput(inputId = "plasmaTubes_newDraw", label = "Number of Tubes", value = 0, min = 0)
                ),
                box(
                  width = 6,
                  status = "danger",
                  background = "blue",
                  numericInput(inputId = "plasmaVolume_newDraw", label = "Total Volume (mL)", value = 0, min = 0)
                )
              ),
            ),
            column(
              width = 3,
              
              h4("Processed Serum Tubes:"),
              fluidRow(
                box(
                  width = 6,
                  status = "warning",
                  background = "blue",
                  numericInput(inputId = "serumTubes_newDraw", label = "Number of Tubes", value = 0, min = 0)
                ),
                box(
                  width = 6,
                  status = "warning",
                  background = "blue",
                  numericInput(inputId = "serumVolume_newDraw", label = "Total Volume (mL)", value = 0, min = 0)
                )
              )
            ),
            column(
              width = 5,
              
              h4("Processed Cell Tubes:"),
              fluidRow(
                box(
                  width = 4,
                  status = "success",
                  background = "blue",
                  numericInput(inputId = "cellTubes_newDraw", label = "Number of Tubes", value = 0, min = 0)
                ),
                box(
                  width = 4,
                  status = "success",
                  background = "blue",
                  numericInput(inputId = "cellVolume_newDraw", label = "Total Volume (mL)", value = 0, min = 0)
                ),
                box(
                  width = 4,
                  status = "success",
                  background = "blue",
                  numericInput(inputId = "cellConcentration_newDraw", label = "Concentration (Cells/mL)", value = 0, min = 0)
                )
              ),
            )
          ),
          fluidRow(
            box(
              width = 6,
              background = "blue",
              textAreaInput(inputId = "comments_newDraw", label = "Comments", rows = 2,
                            placeholder = "Add additional comments...")
            )
          ),
          actionButton(inputId = "submit_newDraw", label = "Submit"),
          uiOutput("submitMessage_newDraw")
        )
        )
      ),
      tabItem(
        tabName = "datainfo",
        h1("Data Description")
      ),
      tabItem(
        tabName = "task_3",
        
        h3("Move a box"),
        uiOutput("StudyPicker_moveBox"),
        
        column(
          width = 3,
          
          tags$u(
            h4("Current Box Information:")
          ),
          uiOutput("currentFreezer_moveBox"),
          uiOutput("currentRack_moveBox"),
          uiOutput("box_moveBox"),
          uiOutput("type_moveBox"),
          actionButton("submit_moveBox", "Submit")
        ),
        column(
          width = 3,
          tags$u(
            h4("New Box Location:")
          ),
          uiOutput("newFreezer_moveBox"),
          uiOutput("newRack_moveBox")
        )
      ),
      tabItem(
        tabName = "tab_extra",
      )
    )
  )
)
