
#============= Downloading the file ====================

#Create a temporary folder to download the data file. 
#This folder will be deleted at the end of this process.
tmpDir <- format(Sys.time(),"%m%d%Y_%H%M")
if (!file.exists(tmpDir)) {dir.create(tmpDir)}

currDir <- getwd()

setwd(tmpDir)

#Download the zip file into the temporary folder.
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","household_power_consumption.zip")

#Unzip the file. The new file would be household_power_consumption.txt
unzip("household_power_consumption.zip")

#=============== Loading the data ======================
#Load the data: sqldf package will be used to read the data using sql.
#Filter condition: Date should be 1/2/2007 or 2/2/2007
#First check if sqldf package is available. If not, install the package.
if (!is.element("sqldf",installed.packages()) ) {install.packages("sqldf")}
library(sqldf)
data1<-read.csv.sql("household_power_consumption.txt", sql="Select * from file where Date in ('1/2/2007','2/2/2007')", header=TRUE,sep=";")
closeAllConnections()
setwd(currDir)

#add a new field "datetime", by merging two columns Date and Time.
#While merging, the pattern is provided to read the data accurately
data1<-cbind(data1, datetime=as.POSIXct(paste(data1$Date, data1$Time), format="%d/%m/%Y %H:%M:%S"))

#================= Plotting Data =================
#Plot the data: Histogram of Global_active_power data
#Open the png device to save the plot as a png file
png("plot1.png",width=480,height=480,units="px", bg="transparent")

#Plot the histogram
hist(data1$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")

#Close the png device
dev.off()

#Delete the temporary folder including the data files
unlink(tmpDir, recursive=TRUE)

#Close all connections before ending the process
closeAllConnections()
