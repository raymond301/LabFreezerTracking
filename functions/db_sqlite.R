patientDBC <- "data/patientdata.db"
pCon <- dbConnect(drv=RSQLite::SQLite(), dbname=patientDBC)

get_PatientCount <- function(){
  return( dbGetQuery(pCon, "SELECT COUNT(DISTINCT clinical_id) from patient;")[[1]] )
}

###### Whole Data tables ######

getPatients_All <- function(){
  return(dbGetQuery(pCon, "SELECT * FROM patient"))
} 