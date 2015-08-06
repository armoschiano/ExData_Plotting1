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

# create a new column to represent daytimes
subsetData$DateTime <- strptime(paste(subsetData$Date, subsetData$Time), 
                             format="%Y-%m-%d %H:%M:%S")

# call a graphic device
png("plot2.png", width=480, height=480)

# set locale to "English" to show labels in english language
Sys.setlocale("LC_TIME", "English")

# make plot
plot(subsetData$DateTime, subsetData$Global_active_power, 
     type = "l", 
     xlab = "",
     ylab = "Global Active Power (kilowatts)"
)

# customize the x axis
axis(1, at=1:3, labels=c("Thu", "Fri", "Sat"))

# close the graphic device
dev.off()





