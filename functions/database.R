databaseFile <- "data/labdata.db"
con <- dbConnect(drv=RSQLite::SQLite(), dbname=databaseFile)

# get a list of all tables inside this dataabase
dbListTables(con)
