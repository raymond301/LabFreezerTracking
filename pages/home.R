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
        h2("Module Access"),
          
        #Creates a box for each of the tabs found on the sidebar
        fluidRow(
          box(
            width = 6,
            title = "Add Patient",
            solidHeader = TRUE, collapsible = TRUE, 
            box(
              width = 12,
              p("This module is for adding a new patient to the database")
            ),
            actionButton(inputId = "changeTask1", label = "Open Module")
          ),
          box(
            width = 6,
            title = "Add Blood Draw",
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
        )
        )

      ),
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
              width = 4,
              background = "blue",
              textInput(inputId = "patientName", label = "Patient Name", placeholder = "Enter Patient Last Name..."),
            ),
            box(
              width = 4,
              background = "blue",
              dateInput(inputId = "birthDate", label = "Birth Date (MM/DD/YYYY)", format = "m/d/yyyy")
            ),
            box(
              width = 4,
              background = "blue",
              numericInput(inputId = "clinicalId", label = "Clinical ID Number", value = NULL)
            )
          ),
          fluidRow(
            box(
              width = 4,
              background = "blue",
              radioButtons(inputId = "mortality", label = "Mortality Status:", 
                           choices = c("Alive" = "A", "Dead" = "D", "Unknown" = "U"), selected = "U")
            ),
            box(
              width = 4,
              background = "blue",
              radioButtons(inputId = "gender", label = "Gender:", 
                           choices = c("Male" = "M", "Female" = "F", "Unknown/Other" = "U"), selected = "U")
            ),
            box(
              width = 4,
              background = "blue",
              textInput(inputId = "clinicalId2", label = "Second Clinical ID/External ID (optional)", 
                        placeholder = "Enter Second Clinical ID Number...")
            )  
          ),
          fluidRow(
            box(
              width = 4,
              background = "blue",
              dateInput(inputId = "deathDate", label = "Death Date (MM/DD/YYYY)", format = "m/d/yyyy")
            ),
            box(
              width = 4,
              background = "blue",
              radioButtons(inputId = "vipStatus", label = "Flag as VIP:", 
                           choices = c("Yes" = "Y", "No" = "N"), selected = "N")
            ),
            box(
              width = 4,
              background = "blue",
              textAreaInput(inputId = "patientComments", label = "Comments (optional)", rows = 2,
                            placeholder = "Add additional comments...")
              
            )
          ),
          actionButton(inputId = "addPatient", label = "Submit")
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
              width = 6,
              background = "blue",
              numericInput(inputId = "clinicalId_bloodDraw", label = "Patient Clinical Number", value = NULL)
            ),
            box(
              width = 6,
              background = "blue",
              textInput(inputId = "studyID", label = "Study ID")
            )
          ),
          fluidRow(
            box(
              width = 6,
              background = "blue",
              dateInput(inputId = "drawDate", label = "Date of Draw", format = "m/d/yyyy")
            ),
            box(
              width = 6,
              background = "blue",
              textInput(inputId = "drawTime", label = "Time of Draw", placeholder = "HH:MM")
            )
          ),
          fluidRow(
            box(
              width = 6,
              background = "blue",
              dateInput(inputId = "processDate", label = "Date of Processing", format = "m/d/yyyy")
            ),
            box(
              width = 6,
              background = "blue",
              textInput(inputId = "processTime", label = "Time of Processing", placeholder = "HH:MM")
            )
          ),
          h4("Total Amount Received:"),
          fluidRow(
            box(
              width = 6,
              background = "blue",
              numericInput(inputId = "totalTubes", label = "Number of tubes", value = 0)
            ),
            box(
              width = 6,
              background = "blue",
              numericInput(inputId = "totalVolume", label = "Total volume (mL)", value = 0)
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
                  numericInput(inputId = "sodiumTubes", label = NULL, value = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "sodiumVolume", label = NULL, value = 0)
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
                  numericInput(inputId = "EDTATubes", label = NULL, value = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "EDTAVolume", label = NULL, value = 0)
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
                  numericInput(inputId = "wholeTubes", label = NULL, value = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "wholeVolume", label = NULL, value = 0)
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
                  numericInput(inputId = "streckTubes", label = NULL, value = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "streckVolume", label = NULL, value = 0)
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
                  numericInput(inputId = "ACDTubes", label = NULL, value = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "ACDVolume", label = NULL, value = 0)
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
                  numericInput(inputId = "otherTubes", label = NULL, value = 0)
                ),
                box(
                  width = 6,
                  title = "Total Volume (mL)",
                  numericInput(inputId = "otherVolume", label = NULL, value = 0)
                )
              )
            ),
          ),
          
          h4("Processed Plasma Tubes:"),
          
          fluidRow(
            box(
              width = 6,
              background = "blue",
              numericInput(inputId = "plasmaTubes", label = "Number of Tubes", value = 0)
            ),
            box(
              width = 6,
              background = "blue",
              numericInput(inputId = "plasmaVolume", label = "Total Volume (mL)", value = 0)
            )
          ),
          
          h4("Processed Cell Tubes:"),
          
          fluidRow(
            box(
              width = 6,
              background = "blue",
              numericInput(inputId = "cellTubes", label = "Number of Tubes", value = 0)
            ),
            box(
              width = 6,
              background = "blue",
              numericInput(inputId = "cellVolume", label = "Total Volume", value = 0)
            )
          ),
          
          fluidRow(
            box(
              width = 6,
              background = "blue",
              textAreaInput(inputId = "drawComments", label = "Comments", rows = 2,
                            placeholder = "Add additional comments...")
            )
          ),
          actionButton(inputId = "addDraw", label = "Submit")
          
        )
        )
      ),
      tabItem(
        tabName = "datainfo",
        h1("Data Description")
      ),
      tabItem(
        tabName = "tab_extra",
      )
    )
  )
)
