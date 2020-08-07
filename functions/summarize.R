
getBoxSummary_lvl1 <- function(rid, tid, bid){
  df <- getBox_byIDs(rid, tid, bid)
 ## as.Date(df$store_date) ## NEED TO FIX DATES
  tbl <- as.data.frame(table(df$status))
  if(nrow(tbl) == 2){
    return(paste(tbl$Var1[1],":",tbl$Freq[1],"  ",tbl$Var1[2],":",tbl$Freq[2]))
  } else {
    return("Error")
  }
}

check_PatientInput <- function(df){
  validInput <- TRUE
  
  if(grepl("\\#|\\/|\\%", df$last_name)){
    showNotification("Name contains invalid characters", duration = 120, type = "error")
    validInput <- FALSE
  }
  if(is.na(as.numeric(df$clinical_id))){
    showNotification("Clinical ID is not a number", duration = 120, type = "error")
    validInput <- FALSE
  }
  if(!is_NewPatient(df$clinical_id)){
    showNotification("Clinical ID already in database", duration = 120, type = "error")
    validInput <- FALSE
  }
  
  return(validInput)
}

check_DrawInput <- function(df){
  validInput <- TRUE
  
  if(grepl("\\#|\\/|\\%", df$draw_id)){
    showNotification("Draw ID contains invalid characters", duration = 120, type = "error")
    validInput <- FALSE
  }
  if(df$draw_time > 2359 | df$draw_time %% 100 > 59){
    showNotification("Time of Draw is out of range", duration = 120, type = "error")
    validInput <- FALSE
  }
  if(df$process_time > 2359 | df$process_time %% 100 > 59){
    showNotification("Time of Processing is out of range", duration = 120, type = "error")
    validInput <- FALSE
  }
  
  return(validInput)
}

