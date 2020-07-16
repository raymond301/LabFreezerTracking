library(shiny)
library(shinythemes)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(RSQLite)

### This lib was previously in CRAN, but for now, must be installed by dev.
if("dqshiny" %in% rownames(installed.packages()) == FALSE) {remotes::install_github("daqana/dqshiny")}
library(dqshiny)

page_files <- c("pages/about.R","pages/home.R", "pages/freezer.R")
purrr::walk(page_files, source, local = environment())


#########################################
###          Global Constants         ###
#########################################
redcapAPI <- Sys.getenv('FREEZER_REDCAP_TOKEN')
freezerNameList <- c("R001","R002","R003","R004","R005","R006","R007","R008")


########################################
###       Database Functions         ###
########################################
source("functions/freezer_database.R")
if(exists("redcapAPI")){
  source("functions/db_sqlite.R")
} else {
  source("functions/db_redcap.R")
}
source("functions/summarize.R")

