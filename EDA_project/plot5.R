## The path for this project is the following:
##     (R_default_workspace)/EDA_project
## The path for the data is the following:
##        plot5.R
##     (R_default_workspace)/EDA_project/data

## Execute this project in RStudio as:
##     source("EDA_project/plot5.R")

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
mrg <- mrg[mrg$fips=="24510",]

## Sum the emissions from motor vechicles in Baltimore grouped by year
print("Calculating total of emissions from motor vehicles by year in Baltimore...")
emissions <- with(mrg, aggregate(Emissions, by = list(year, fips), sum))
colnames(emissions) <- c("Year", "fips", "Emissions")

## Paint and save the chart as image file in PNG format
print("Generating and saving chart...")
png("EDA_project/plot5.png", width = 480, height = 480)

g = ggplot(emissions, aes(Year, Emissions))
g + geom_point(color = "red") + geom_line(color = "blue") + 
    labs(x = "Year") + 
    labs(y = "Emissions") + 
    labs(title = "Motor Vehicles in Baltimore City")
dev.off()

## Paint the chart in the screen
g = ggplot(emissions, aes(Year, Emissions))
g + geom_point(color = "red") + geom_line(color = "blue") + 
    labs(x = "Year") + 
    labs(y = "Emissions") + 
    labs(title = "Motor Vehicles in Baltimore City")
	
print("Chart created successfully at EDA_project/plot5.png")