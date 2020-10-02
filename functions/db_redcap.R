api_url = 'https://redcapcln4-prod.mayo.edu/redcap/api/'

getDbVersion <- function(){
  return( postForm(api_url,token=redcapAPI,content='version') )
}

get_PatientCount <- function(){
  return( nrow(fromJSON(postForm(api_url,token=redcapAPI,content='record',format='json','fields[0]'='record_id',returnFormat='json'))) )
}

get_PatientColumnNames <- function(){
  return( tibble() )
}

###### Whole Data tables ######

getPatients_All <- function(){
  return(fromJSON(postForm(api_url,token=redcapAPI,content='record',format='json',returnFormat='json')))
} 


##### Form Submissions #####
create_Patient <- function(df){
  data <- toJSON(list(as.list(df)), auto_unbox=TRUE)
  result <- fromJSON(postForm(api_url,token=redcapAPI,content='record',
                     format='json',type='flat',returnFormat='json',data=data
  ))
  print(result)
  if(result$count >= 1){
    return(TRUE)
  } else {
    return(FALSE)
  }
  
}