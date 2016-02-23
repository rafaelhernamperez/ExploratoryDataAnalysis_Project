## The path for this project is the following:
##     (R_default_workspace)/EDA_project
## The path for the data is the following:
##        plot3.R
##     (R_default_workspace)/EDA_project/data

## Execute this project in RStudio as:
##     source("EDA_project/plot3.R")

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

## First step: Load library "plyr", in order to use the ddply() function
library("plyr") 

## Second step: Load library "ggplot2" in forder to paint the advanced chart
library("ggplot2")

## Next step: Read the data and load it in a memory variable
print("Loading data for plot3. Please wait...")
NEI <- readRDS("EDA_project/data/summarySCC_PM25.rds")

print("Extracting subset from data only for Baltimore...")
baltimore <- subset(NEI, fips == "24510")

## Summarize the emissions by "type", using the ddply() function
baltimore_types <- ddply(baltimore, .(type, year), 
	summarize, Emissions = sum(Emissions))

## Paint and save the chart as image file in PNG format
print("Generating and saving chart...")
png("EDA_project/plot3.png", width = 480, height = 480)
qplot(year, Emissions, data = baltimore_types, geom = c("line", "point"), 
	color = type, group = type, ylab = "Emissions", xlab = "Year", 
	main = "Emissions by Type of Source")
dev.off()

## Paint the chart in the screen
qplot(year, Emissions, data = baltimore_types, geom = c("line", "point"),
	color = type, group = type, ylab = "Emissions", xlab = "Year", 
	main = "Emissions by Type of Source")
	
print("Chart created successfully at EDA_project/plot3.png")