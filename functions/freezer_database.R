freezerDBC <- "data/storagedata.db"
fCon <- dbConnect(drv=RSQLite::SQLite(), dbname=freezerDBC)

###### Summary Counts ######
get_StudyCount <- function(){
  return( dbGetQuery(fCon, "SELECT COUNT(DISTINCT study_name) from blood_draw;")[[1]] )
}
get_BloodDrawCount <- function(){
  return( dbGetQuery(fCon, "SELECT COUNT(DISTINCT draw_id) from blood_draw WHERE retired = \"F\";")[[1]] )
}
get_FreezerSlotCount <- function(){
  return( dbGetQuery(fCon, "SELECT COUNT(DISTINCT id) from freezer_slot WHERE status = \"Frozen\";")[[1]] )
}

###### Functions used in input saving ######
get_FreezerColumnNames <- function(){
  return(dbGetQuery(fCon,"SELECT * FROM blood_draw LIMIT 0"))
}
add_NewDraw <- function(df){
  ## should return TRUE on successful submission
  return(dbWriteTable(fCon, "blood_draw", df, append = TRUE))
}

get_BoxColumnNames <- function(){
  return(dbGetQuery(fCon,"SELECT * FROM freezer_slot LIMIT 0"))
}
add_NewBox <- function(df){
  dbWriteTable(fCon, "freezer_slot", df, append = TRUE)
}

is_newBox <- function(rid, tid, bid){
  return( nrow(dbGetQuery(fCon, paste0("SELECT * FROM freezer_slot WHERE rack = \"",rid,"\" AND box = \"",bid,"\" AND box_type = \"",tid,"\";"))) == 0)
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
  return( sort(dbGetQuery(fCon, paste0("SELECT DISTINCT rack FROM freezer_slot JOIN blood_draw ON blood_draw.draw_id = freezer_slot.blood_draw_id WHERE blood_draw.study_name = \"",sid,"\";"))$rack) )
}
getBoxes_ByRack <- function(rid){
  return( dbGetQuery(fCon, paste0("SELECT DISTINCT box,box_type FROM freezer_slot WHERE rack = \"",rid,"\"")) )
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
getTypes_byLocation <- function(rid, bid){
  return( dbGetQuery(fCon, paste0("SELECT box_type FROM freezer_slot WHERE rack = \"",rid,"\" AND box = \"",bid,"\";")) )
}
getSlot_byLocation <- function(rid, bid, sid, tid){
  return( dbGetQuery(fCon, paste0("SELECT * FROM freezer_slot WHERE rack = \"",rid,"\" AND box = \"",bid,"\" AND slot = \"",sid,"\" AND box_type = \"",tid,"\";")) )
}

getEntireRack_byIDs <- function(fid, rid){
  return( dbGetQuery(fCon, paste0("SELECT * FROM freezer_slot WHERE freezer_name = \"",fid,"\" AND rack = \"",rid,"\"")) )
}

######### Lookup Table for Dynamic Diagnosis Labels ############

add_NewDiagnosis <- function(df){
  dbWriteTable(fCon, "diagnosis", df, append = TRUE)
}

get_allDiagnosis <- function(){
  return(dbGetQuery(fCon,"SELECT term,code_type,code FROM diagnosis"))
}


##### Submit Change to Database ##### 

update_slot <- function(id, status, vol, stored, pulled){
  #sFmt = as.character(format(stored, "%m/%d/%Y")) # Already formatted in input field
  if(status == "Frozen"){
    sql <- paste0("UPDATE freezer_slot SET status = '",status,"', frozen_volume = '",vol,"', store_date = '",stored,"' WHERE id = ",id,";")
  } else {
    #pFmt = as.character(format(pulled, "%m/%d/%Y"))
    sql <- paste0("UPDATE freezer_slot SET status = '",status,"', frozen_volume = '",vol,"', store_date = '",stored,"', pulled_date = '",pulled,"' WHERE id = ",id,";")
  }
  return(dbExecute(fCon, sql))
}

# get a list of all tables inside this dataabase
# dbListTables(con)