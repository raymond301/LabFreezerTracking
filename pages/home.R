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
                 "Add Biospecimen",
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
            infoBox("Studies:", 31, width = 3, color = "olive",
                    fill = TRUE, icon = icon("book")),
            infoBox("Patients:", 81, width = 3, color = "yellow",
                    fill = TRUE, icon = icon("address-card")),
            infoBox("Blood Draws:", 287, width = 3, color = "blue",
                    fill = TRUE, icon = icon("syringe")),
            infoBox("Freezer Slots:", 1197, width = 3, color = "red",
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
            title = "Operation #2",
            solidHeader = TRUE, collapsible = TRUE,
            box(
              width = 12,
              p("A brief explanation of what is in operation 2")
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
        h1("Add Patient")
      ),
      tabItem(
        tabName = "task_2",
        h1("Add Biospecimen")
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