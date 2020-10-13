#######################################################	
# Define general layout tag list	
#######################################################

headerTagList <- list(	
    tags$style(type = "text/css", ".navbar .navbar-nav {float: right; font-size: 14px} .navbar .navbar-nav li a {font-size: 14px} .nav-tabs {font-size: 12px}"),
    tags$base(target = "_blank")	
)

footerTagList <- list(
    tags$footer(id = "myFooter",
                shiny::includeHTML("footer.html")
    )
)

#######################################################
# Define the full user-interface
#######################################################

ui <- navbarPage(
    title = strong("Biospecimen Tracking"), selected = "Home",	
    tabPanel("Home", homepage, icon = icon("home")),	
    tabPanel("Freezer", freezerpage, icon = icon("clipboard")),	
    tabPanel("Query", querypage, icon = icon("question-circle")),	
    tabPanel("About", aboutpage, icon = icon("info-circle")),	
    header = headerTagList,	
    footer = footerTagList,
    collapsible = TRUE,	inverse = TRUE,
    windowTitle = "Database"
)

shinyUI(ui)