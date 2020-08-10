patientDBC <- "data/patientdata.db"
pCon <- dbConnect(drv=RSQLite::SQLite(), dbname=patientDBC)

get_PatientCount <- function(){
  return( dbGetQuery(pCon, "SELECT COUNT(DISTINCT clinical_id) from patient;")[[1]] )
}

get_PatientColumnNames <- function(){
  return(dbGetQuery(pCon,"SELECT * FROM patient LIMIT 0"))
}

add_NewPatient <- function(df){
  dbWriteTable(pCon, "patient", df, append = TRUE)
}

is_NewPatient <- function(cid){
  return( nrow(dbGetQuery(pCon, paste0("SELECT * FROM patient WHERE clinical_id = \"",cid,"\";"))) == 0)
}

###### Whole Data tables ######

getPatients_All <- function(){
  return(dbGetQuery(pCon, "SELECT * FROM patient"))
} 