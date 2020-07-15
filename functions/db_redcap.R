api_url = 'https://redcapcln4-prod.mayo.edu/redcap/api/'

getDbVersion <- function(){
  return( postForm(api_url,token=redcapAPI,content='version') )
}