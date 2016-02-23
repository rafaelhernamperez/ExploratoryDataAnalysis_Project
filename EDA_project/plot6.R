## The path for this project is the following:
##     (R_default_workspace)/EDA_project
## The path for the data is the following:
##        plot6.R
##     (R_default_workspace)/EDA_project/data

## Execute this project in RStudio as:
##     source("EDA_project/plot6.R")

## Previously, the zip file was uncompressed at "EDA_project/data" directory
## This directory will contain two files:
##    - summarySCC_PM25.rds - This file contains a data frame with all of the PM2.5 
##                            emissions data for 1999, 2002, 2005, and 2008. For 
##                            each year, the table contains number of tons of PM2.5 
##                            emitted from a specific type of source for the entire
##                            year.
##    - Source_Classification_Code.rds - This file provides a mapping from the SCC
##                            digit strings in the Emissions table to the actual 
##                            name of the PM2.5 source. 

## First step: Load library "dplyr"
library("dplyr") 

## Second step: Load library "ggplot2" in forder to paint the advanced chart
library("ggplot2")

library(grid)
library(scales)
library(httr) 

## Next step: Read the data and load it in a memory variable
print("Loading data for plot5. Please wait...")
NEI <- readRDS("EDA_project/data/summarySCC_PM25.rds")
SCC <- readRDS("EDA_project/data/Source_Classification_Code.rds")

## Filter the SCC only for motor vehicles sources 
motor_scc <- filter(SCC, grepl("[Vv]ehicle", EI.Sector))

## Extract only the NEI joined to SCC only for motor vehicles 
mrg <- merge(NEI, motor_scc, by.x = "SCC", by.y = "SCC")

## Free from memory the unnecessary variables
remove(NEI, SCC, motor_scc)

## Filter data only for Baltimore
print("Extracting data for Baltimore...")
baltimore <- mrg[mrg$fips=="24510",]

## Filter data only for Los Angeles
print("Extracting data for Los Angeles...")
losangeles <- mrg[mrg$fips=="06037",]

## Free from memory the unnecessary variables
remove(mrg)

## Sum the emissions from motor vechicles in Baltimore grouped by year
print("Calculating total of emissions from motor vehicles by year in Baltimore...")
emiss_baltimore <- with(baltimore, aggregate(Emissions, by = list(year, fips), sum))
colnames(emiss_baltimore) <- c("Year", "fips", "Emissions")
emiss_baltimore$county = "Baltimore"

## Sum the emissions from motor vechicles in Los Angeles grouped by year
print("Calculating total of emissions from motor vehicles by year in Los Angeles...")
emiss_losangeles <- with(losangeles, aggregate(Emissions, by = list(year, fips), sum))
colnames(emiss_losangeles) <- c("Year", "fips", "Emissions")
emiss_losangeles$county = "Los Angeles"

## Bind Baltimore and Los Angeles
emiss_both <- rbind(emiss_baltimore, emiss_losangeles)

## Paint and save the chart as image file in PNG format
print("Generating and saving chart...")
png("EDA_project/plot6.png", width = 480, height = 480)

ggplot(emiss_both, aes(x=factor(Year), y=Emissions, fill=county)) +
     geom_bar(aes(fill = county), position = "dodge", stat="identity") +
     labs(x = "Year") + labs(y = "Emissions") +
     xlab("Year") +
     ggtitle(expression("Baltimore & Los Angeles"))

dev.off()

## Paint the chart in the screen
ggplot(emiss_both, aes(x=factor(Year), y=Emissions, fill=county)) +
     geom_bar(aes(fill = county), position = "dodge", stat="identity") +
     labs(x = "Year") + labs(y = "Emissions") +
     xlab("Year") +
     ggtitle(expression("Baltimore & Los Angeles"))
	
print("Chart created successfully at EDA_project/plot6.png")