library(shiny)
library(shinythemes)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(RSQLite)
#library(redcap) ### Assumes .redcaprc in ~/
library(RCurl)
options(RCurlOptions = list(ssl.verifypeer = FALSE))
library(jsonlite)
library(DT)

### This lib was previously in CRAN, but for now, must be installed by dev.
if("dqshiny" %in% rownames(installed.packages()) == FALSE) {remotes::install_github("daqana/dqshiny")}
library(dqshiny)

module_files <- c("pages/new_patient_module.R", "pages/new_blooddraw_module.R", "pages/move_box_module.R", "pages/home_helper_module.R")
purrr::walk(module_files, source, local = environment())

page_files <- c("pages/about.R","pages/home.R", "pages/freezer.R", "pages/query.R")
purrr::walk(page_files, source, local = environment())


#########################################
###          Global Constants         ###
#########################################
redcapAPI <- Sys.getenv('FREEZER_REDCAP_TOKEN')
freezerNameList <- c("676","677","678","679","655","656","657","658","659")

########################################
###       Database Functions         ###
########################################
source("functions/freezer_database.R")

if(exists("redcapAPI") && redcapAPI != ""){
  print("Connecting to RedCap...")
  source("functions/db_redcap.R")
} else {
  print("Connecting to SQLite3...")
  source("functions/db_sqlite.R")
}

source("functions/summarize.R")

