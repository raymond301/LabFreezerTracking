newBloodDrawEventForm <- function(id) {
  ns <- NS(id)
  
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
  )
}