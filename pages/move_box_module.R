moveBoxInPlaceForm <- function(id) {
  ns <- NS(id)
 
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
  )

}