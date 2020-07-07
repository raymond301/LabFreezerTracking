patientDBC <- "data/patientdata.db"
freezerDBC <- "data/storagedata.db"
pCon <- dbConnect(drv=RSQLite::SQLite(), dbname=patientDBC)
fCon <- dbConnect(drv=RSQLite::SQLite(), dbname=freezerDBC)

###### Summary Counts ######
get_StudyCount <- function(){
  return( dbGetQuery(fCon, "SELECT COUNT(DISTINCT study_name) from blood_draw;")[[1]] )
}
get_PatientCount <- function(){
  return( dbGetQuery(pCon, "SELECT COUNT(DISTINCT clinical_id) from patient;")[[1]] )
}
get_BloodDrawCount <- function(){
  return( dbGetQuery(fCon, "SELECT COUNT(DISTINCT draw_id) from blood_draw WHERE retired = \"F\";")[[1]] )
}
get_FreezerSlotCount <- function(){
  return( dbGetQuery(fCon, "SELECT COUNT(DISTINCT id) from freezer_slot WHERE status = \"Frozen\";")[[1]] )
}


###### Unique lists for Dropdown menus ######
get_StudyList <- function(){
  return( sort(dbGetQuery(fCon, "SELECT DISTINCT study_name from blood_draw;")$study_name) )
}


###### Find by Id Lookup Functions ######

getBloodDraws_ByPatientID <- function(pid){
  return( dbGetQuery(fCon, paste0("SELECT * FROM blood_draw WHERE record_id = \"",pid,"\"")) )
}

getBloodDrawIDs_ByStudy <- function(sid){
  return( dbGetQuery(fCon, paste0("SELECT draw_id FROM blood_draw WHERE study_name = \"",sid,"\""))$draw_id )
}

getRacks_ByStudy <- function(sid){
  return( dbGetQuery(fCon, paste0("SELECT DISTINCT rack FROM freezer_slot JOIN blood_draw ON blood_draw.draw_id = freezer_slot.blood_draw_id WHERE blood_draw.study_name = \"",sid,"\";"))$rack )
}

getBoxes_ByRack <- function(rid){
  return( dbGetQuery(fCon, paste0("SELECT DISTINCT box FROM freezer_slot WHERE rack = \"",rid,"\"")) )
}

getBox_byIDs <- function(rid, tid, bid){
  return( dbGetQuery(fCon, paste0("SELECT * FROM freezer_slot WHERE rack = \"",rid,"\" AND box = \"",bid,"\" AND box_type = \"",tid,"\";")) )
}

getSamples_byLocation <- function(rid, bid, sid, tid){
  return( dbGetQuery(fCon, paste0("SELECT DISTINCT blood_draw_id FROM freezer_slot WHERE rack = \"",rid,"\" AND box = \"",bid,"\" AND slot = \"",sid,"\" AND box_type = \"",tid,"\";")) )
}

getStatus_byLocation <- function(rid, bid, sid, tid){
  return( dbGetQuery(fCon, paste0("SELECT DISTINCT status FROM freezer_slot WHERE rack = \"",rid,"\" AND box = \"",bid,"\" AND slot = \"",sid,"\" AND box_type = \"",tid,"\";")) )
}
###### Whole Data tables ######

getPatients_All <- function(){
  return(dbGetQuery(pCon, "SELECT * FROM patient"))
} 


# get a list of all tables inside this dataabase
# dbListTables(con)