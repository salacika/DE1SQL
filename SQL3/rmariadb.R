#install.packages("RMariaDB")

library(RMariaDB)

# connect
birdstrikesDb <- dbConnect(RMariaDB::MariaDB(), user='root', password='AlmaKorte6', dbname='birdstrikes', host='localhost')


# list all tables stored in db
dbListTables(birdstrikesDb)

# compose a query
query<-paste("SELECT * FROM birdstrikes WHERE state='Texas'")

# execute query
rs = dbSendQuery(birdstrikesDb,query)


# fetch the result of the query in a data frame
dbRows<-dbFetch(rs)

#close connection
dbDisconnect(birdstrikesDb)