freezerpage <- dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(
    uiOutput("StudyPicker"),
    conditionalPanel(
      condition = "input.freezertabs == 'freezer_tab2'",
      actionButton("newRack_newBox", label = "Create New Rack")
    ),
    
    uiOutput("autoDraws"),
    
    conditionalPanel(
      condition = "input.freezertabs == 'freezer_tab2'",
      
      fluidRow(
        column(width = 6, uiOutput("SlotStart_newBox")),
        column(width = 6, uiOutput("NumTubes_newBox"))
      ),
      uiOutput("StoreDate_newBox"),
      actionButton("addSamples_newBox", "Add Samples")
    )
  ),
  dashboardBody(
    tabsetPanel(id="freezertabs",
                tabPanel("Find",  value='freezer_tab1',
                         h2(paste("Existing Freezer Data")),
                         hr(),
                         # Tree of boxes
                         uiOutput('freezer_rack_tree')
                         
                         ),
                tabPanel("Create New Box",  value='freezer_tab2',
                         h4("Create a new Freezer Box"),
                         fluidRow(
                           box(
                             width = 2,
                             background = "blue",
                             uiOutput("FreezerPicker_newBox")
                           ),
                           box(
                             width = 2,
                             background = "blue",
                             uiOutput("RackPicker_newBox"),
                             #h6("or"),
                             #actionButton("newRack_newBox", label = "New Rack")
                           ),
                           box(
                             width = 2,
                             background = "blue",
                             uiOutput("Name_newBox")  
                           ),
                           box(
                             width = 2,
                             background = "blue",
                             uiOutput("Type_newBox")
                           ),
                           # box(
                           #   width = 4,
                           #   uiOutput("Dimensions_newBox")
                           # )
                           
                         ),
                         
                          actionButton("Save_newBox", label = "Save Box"),
                          actionButton("Clear_newBox", label = "Clear Box"),
                          h5("Current Dimensions:"),
                          uiOutput("Grid_newBox")
                         
                         
                         ),
                tabPanel("Update / Withdraw",  value='freezer_tab3',
                         #h3("Add or Remove vials from exisiting Freezer Box"),
                         #h4(textOutput("current_study3")),
                         #uiOutput("RackPicker_updateBox"),
                         #uiOutput("BoxPicker_updateBox"),
                         h6(""),
                         fluidRow(
                           box(
                             width = 2,
                             background = "blue",
                             uiOutput("RackPicker_updateBox"),
                             #h6("or"),
                             #actionButton("newRack_newBox", label = "New Rack")
                           ),
                           box(
                             width = 2,
                             background = "blue",
                             uiOutput("BoxPicker_updateBox")  
                           ),
                           box(
                             width = 2,
                             background = "blue",
                             uiOutput("TypePicker_updateBox")
                           )
                         ),
                         uiOutput("Grid_updateBox"),                     
                         h4(textOutput("current_study3"))

                         )
                )
    
  )
)
