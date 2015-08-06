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
png("plot4.png", width=480, height=480)

# set locale to "English" to show labels in english language
Sys.setlocale("LC_TIME", "English")

# set the parameters to a 2 x 2 matrix to insert 4 graphs
par(mfrow=c(2,2))

# make plot 1
plot(subsetData$DateTime, subsetData$Global_active_power, 
     type = "l", 
     xlab = "",
     ylab = "Global Active Power"
)

# make plot 2
plot(subsetData$DateTime, subsetData$Voltage, 
     type = "l", 
     xlab = "datetime",
     ylab = "Voltage"
)

# make plot 3
plot(subsetData$DateTime, subsetData$Sub_metering_1, 
     type = "l", 
     xlab = "",
     ylab = "Energy sub metering"
)

# add lines
lines(subsetData$DateTime, subsetData$Sub_metering_2, col = "red")
lines(subsetData$DateTime, subsetData$Sub_metering_3, col = "blue")

# add legend
legend("topright",
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col = c("black", "red", "blue"),
       lwd = 1
)

# make plot 4
plot(subsetData$DateTime, subsetData$Global_reactive_power, 
     type = "l", 
     xlab = "datetime",
     ylab = "Global_reactive_power"
)

# customize the x axis
axis(1, at=1:3, labels=c("Thu", "Fri", "Sat"))

# close the graphic device
dev.off()





