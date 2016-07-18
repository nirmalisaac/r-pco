# store the current directory
initial.dir<-getwd()
# change to the new directory
setwd("F:/RData/")
# load library rodbc for database connectivity
library(RODBC)
# load library gg
library(ggplot2)
# open connection to database maia
conn <- odbcDriverConnect("Driver=SQL Server; Server=172.16.2.98; Database=MAIA; Uid=maia; Pwd=continue;")
# execute store procedure to retrieve sale data as on date
data <-sqlQuery(conn, "EXEC[Sales Analysis for directors FY12-13 with GD]")
# close the database connection
odbcCloseAll()
# save the data file to an rds file
saveRDS(data, file="salesanalysis.rds")
# read the values into sales from the rds file
sales <- readRDS("salesanalysis.rds")
# selecting the columns only needed for the analysis
newsale <- sales[ , c("Mon","Quarter","Amount","Purcost","Actual Commitment")]
#Renaming the column actual committment to commitment
colnames(newsale)[5] <- "Commitment" 
# creating a new column for computation
newsale <- within(newsale, margin <- (Amount -Purcost - Commitment))
# saving the results into an rds file for further manipulation
saveRDS(newsale, file="salesanalysis.rds")
#reading the file into a data frame sales
sales <- readRDS("salesanalysis.rds")
#  attach the data fram sales
attach(sales)
# order the months to the required format
sales$Mon2 <- factor(sales$Mon, levels = c("April", "May", "June", "July", "August", "September","November","December","January","February","March"))
#  change the scientific notation to numeric values
opt <- options(scipen = 10)
ggplot(data = sales, aes(y = Amount, x = Mon2)) + geom_bar(stat="identity") + ggtitle("Monthly Sales amount") + labs(x="Month",y="Sales Amount")
# press return to exit
readline("Press <Enter> to continue")
# close the output file
detach(sales)
# unload the libraries
#setwd(initial.dir)
detach("package:RODBC")
detach("package:ggplot2")
# change back to the original directory
#setwd(initial.dir)
