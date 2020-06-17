
getBoxSummary_lvl1 <- function(rid, tid, bid){
 # rid = "TCR1" 
 # bid = "11" 
 # tid = "Plasma"
  df <- getBox_byIDs(rid, tid, bid)
 ## as.Date(df$store_date) ## NEED TO FIX DATES
  tbl <- as.data.frame(table(df$status))
  if(nrow(tbl) == 2){
    return(paste(tbl$Var1[1],":",tbl$Freq[1],"  ",tbl$Var1[2],":",tbl$Freq[2]))
  } else {
    return("Error")
  }
}