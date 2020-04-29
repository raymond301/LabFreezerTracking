library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    dashboardPage(skin = "green", 
        dashboardHeader(title = "Biospecimen Tracking"),
        dashboardSidebar(),
        dashboardBody()
    )
))
