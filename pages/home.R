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
               ),
               menuSubItem(
                 "Add Diagnosis",
                 tabName = "task_4",
                 icon = icon("cog")
               )
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
        # Creates a box for each of the tabs found on the sidebar
        # NS Function located in pages/home_helper_module.R
        fluidRow(
          moduleBoxForHomePage('patient_add_01',"Add A Patient","This module is for adding a new patient to the database","changeTask1"),
          moduleBoxForHomePage('bloodraw_add_02',"Add Blood Draw Event","This module is for adding a new blood draw event to the database","changeTask2")
        ),  
        fluidRow(
          moduleBoxForHomePage('diagnosis_add_03',"Add Diagnosis","Add diagnoses descriptions dynamically to database","changeTask4"),
          moduleBoxForHomePage('box_move_04',"Move A Box","This module is for moving an existing box from one freezer & rack to another.","changeTask3")
        )
      ),
      
      
      #######################################
      #   Sample pages for the other tabs   #
      #######################################
      
      # NS Function located in pages/new_patient_module.R
      newPatientForm("task_1"),
      
      # NS Function located in pages/new_blooddraw_module.R
      newBloodDrawEventForm("task_2"),
      
      # NS Function located in pages/move_box_module.R
      moveBoxInPlaceForm("task_3"),
      
      tabItem(
        tabName = "task_4",
        fluidPage(
          h3("Add New Diagnosis Dynamically"),
        )
      ),
      
      tabItem(
        tabName = "tab_extra",
      )
     
    )
  )
)
