## The path for this project is the following:
##     (R_default_workspace)/EDA_project
## The path for the data is the following:
##        plot2.R
##     (R_default_workspace)/EDA_project/data

## Execute this project in RStudio as:
##     source("EDA_project/plot2.R")

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

## First step: Read the data and load it in a memory variable
print("Loading data for plot2. Please wait...")
NEI <- readRDS("EDA_project/data/summarySCC_PM25.rds")

print("Extracting subset from data only for Baltimore...")
baltimore <- subset(NEI, fips == "24510")

## Group the sum of emissions by year
print("Calculating total of emissions per year for Baltimore...")
emissions <- with(baltimore, aggregate(Emissions, by = list(year), sum))

## Naming the columns of the "emissions" table
colnames(emissions) <- c("Year", "Emissions")

## Paint and save the chart as image file in PNG format
print("Generating and saving chart...")
png("EDA_project/plot2.png", width = 480, height = 480)
plot(emissions$Year, emissions$Emissions, pch = 19, col = "green", type = "b", 
	ylab = "Emissions", xlab = "Year", main = "Baltimore's emissions per Year")
dev.off()

## Paint the chart in the screen
plot(emissions$Year, emissions$Emissions, pch = 19, col = "green", type = "b", 
	ylab = "Emissions", xlab = "Year", main = "Baltimore's emissions per Year")
	
print("Chart created successfully at EDA_project/plot2.png")