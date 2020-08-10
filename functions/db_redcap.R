api_url = 'https://redcapcln4-prod.mayo.edu/redcap/api/'

getDbVersion <- function(){
  return( postForm(api_url,token=redcapAPI,content='version') )
}

get_PatientCount <- function(){
  return( nrow(fromJSON(postForm(api_url,token=redcapAPI,content='record',format='json','fields[0]'='record_id',returnFormat='json'))) )
}

