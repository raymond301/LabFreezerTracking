moduleBoxForHomePage <- function(id, titleStr="Add A...", description="Description", buttonID='taskn') {
  ns <- NS(id)
  box(
    width = 6,
    title = titleStr,
    solidHeader = TRUE, collapsible = TRUE, 
    box(
      width = 12,
      p(description)
    ),
    actionButton(inputId = buttonID, label = "Open Module")
  )
}