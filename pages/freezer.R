freezerpage <- dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(
    uiOutput("StudyPicker")
  ),
  dashboardBody(
    tabsetPanel(id="freesertabs",
                tabPanel("Find",  value='freezer_tab1',
                         h2(paste("Locate Existing Freezer Data")),
                         h3(textOutput("current_study")),
                         hr(),
                         # Tree of boxes
                         uiOutput('freezer_rack_tree')
                         
                         ),
                tabPanel("Create New",  value='freezer_tab2',
                         h2("Load Processed Tubes into new Freezer Box"),
                         h3(textOutput("current_study2"))
                         ),
                tabPanel("Update / Withdraw",  value='freezer_tab2',
                         h2("Add or Remove vials from exisiting Freezer Box"),
                         h3(textOutput("current_study3"))
                         )
                )
    
  )
)
