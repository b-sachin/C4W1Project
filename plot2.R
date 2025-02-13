library(sqldf)
library(lubridate)

if(!file.exists("./data")){dir.create("./data")}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile = "./data/raw_data.zip",method = "curl")

# list zip archive
file_names <- unzip("./data/raw_data.zip", list=TRUE)

# extract files from zip file
unzip("./data/raw_data.zip",exdir="./data", overwrite=TRUE)

# use when zip file has only one file
data_file <- file.path("./data", file_names$Name[1])

#----------#----------#----------#----------#----------

# Read data only for Feb. 1, 2007 & Feb. 2, 2007
df=read.csv.sql(data_file, "select * from file where Date in ('1/2/2007','2/2/2007')",header = TRUE,sep = ";")
unlink(temp)

# Replace missing values coded as "?" to NA
df[df == "?"] <- NA

# Remove incomplete observation
df=df[complete.cases(df), ]

# Combine Date & Time column as DateTime and store in POSIXct format
df$DateTime <-dmy_hms(paste(df$Date,df$Time))

# Remove Date and Time column
df <- df[ ,!(names(df) %in% c("Date","Time"))]

# Set new Graphic Device as PNG
png(filename="plot2.png", width=480, height=480)

# Plot 
plot(df$Global_active_power~df$DateTime, type="l", ylab="Global Active Power (kilowatts)",xlab="")

# Close Device
dev.off()