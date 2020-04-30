library(shiny)
library(shinythemes)
library(shinydashboard)
library(tidyverse)
library(plotly)

page_files <- c("pages/about.R","pages/home.R")
purrr::walk(page_files, source, local = environment())
