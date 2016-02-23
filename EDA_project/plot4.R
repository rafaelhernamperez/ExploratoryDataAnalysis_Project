## The path for this project is the following:
##     (R_default_workspace)/EDA_project
## The path for the data is the following:
##        plot4.R
##     (R_default_workspace)/EDA_project/data

## Execute this project in RStudio as:
##     source("EDA_project/plot4.R")

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
print("Loading data for plot4. Please wait...")
NEI <- readRDS("EDA_project/data/summarySCC_PM25.rds")
SCC <- readRDS("EDA_project/data/Source_Classification_Code.rds")

## Filter the SCC only for coal-combustion related sources 
coals_scc <- filter(SCC, grepl("Coal", SCC.Level.Three))

## Extract only the NEI joined to SCC only for coal-combustion 
mrg <- merge(NEI, coals_scc, by.x = "SCC", by.y = "SCC")

## Sum the emissions of coal combustions grouped by year
print("Calculating total of emissions of coal combustion by year...")
emissions <- with(mrg, aggregate(Emissions, by = list(year), sum))
colnames(emissions) <- c("Year", "Emissions")

## Paint and save the chart as image file in PNG format
print("Generating and saving chart...")
png("EDA_project/plot4.png", width = 480, height = 480)
g = ggplot(emissions, aes(Year, Emissions))
g + geom_point(color = "black") + geom_line(color = "blue") + 
    labs(x = "Year") + 
    labs(y = "Emissions") + 
    labs(title = "Emissions of Coal Combustion")
dev.off()

## Paint the chart in the screen
g = ggplot(emissions, aes(Year, Emissions))
g + geom_point(color = "black") + geom_line(color = "blue") + 
    labs(x = "Year") + 
    labs(y = "Emissions") + 
    labs(title = "Emissions of Coal Combustion")
	
print("Chart created successfully at EDA_project/plot4.png")