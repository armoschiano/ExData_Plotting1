# clean up workspace
rm(list=ls())

# Download and unzip the dataset:
zipName <- "exdata_data_household_power_consumption.zip"

if (!file.exists(zipName)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, zipName)
}  

fileName <- "household_power_consumption.txt" 
if (!file.exists(fileName)) { 
    unzip(zipName) 
}

# to prevent huge memory usage, first read the data  
# for just 100 rows to determine column classes
tab100rows <- read.table(fileName, 
                         header = TRUE, 
                         sep = ";",
                         na.strings = "?",
                         nrows = 100
                         )

# get classes
classes <- sapply(tab100rows, class)

# then, read the entire data withe the colClasses argument set
myData <- read.table(fileName, 
                   header = TRUE, 
                   sep = ";",
                   colClasses = classes,
                   nrows = 2100000,
                   na.strings = "?",
                   comment.char = ""
                   )

# Convert Date column to Date class
myData$Date <- as.Date(myData$Date, "%d/%m/%Y")

# Create a subset of the data from 2007-02-01 and 2007-02-02
subsetData <- myData[myData$Date %in% as.Date(c("2007-02-01","2007-02-02")), ]

# call a graphic device
png("plot1.png", width=480, height=480)

# make histogram
hist(subsetData$Global_active_power, 
     col="red", 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)"
    )

# close the graphic device
dev.off()

    



