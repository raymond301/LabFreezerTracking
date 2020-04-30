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
                 "Operation #1",
                 tabName = "task_1",
                 icon = icon("cog")
               ),
               menuSubItem(
                 "Operation #2",
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
      ),
      tabItem(
        tabName = "tab_extra",
      )
    )
  )
)