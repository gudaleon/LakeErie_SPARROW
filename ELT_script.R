getwd()
q<-read.csv('/Users/alex.neumann/Downloads/flows_LE.csv')
head(q)
typeof(q)
rm(q)
q_clean <- q[!is.na(q$Value), ] #remove NA values
summary(q_clean)
# Make sure the 'Date' column is in Date format
q_clean$Date2 <- as.Date(q_clean$Date, format = "%d/%m/%Y")
q_clean$WaterYear <- ifelse(format(q_clean$Date2, "%m") < 10, as.numeric(format(q_clean$Date2, "%Y")), as.numeric(format(q_clean$Date2, "%Y")) + 1)
write.csv(q_clean,"q_clean.csv")

# Load the dplyr library
library(dplyr)

# Filter q_clean to keep only stations with at least 365 records per water year
q_filtered <- q_clean %>%
  group_by(STATION_NUMBER, WaterYear) %>%
  filter(n() > 364) %>%
  ungroup()

station_year_counts <- q_filtered %>%
  group_by(STATION_NUMBER, WaterYear) %>%
  summarize(Count = n())

# Load necessary libraries
library(dplyr)
library(purrr)

q_filtered <- q_filtered %>%
  rename(Station = STATION_NUMBER)

q_filtered <- q_filtered %>%
  rename(DATE = Date)

q_filtered <- q_filtered %>%
  rename("Flow (m3/s)" = Value)

# Iterate over each unique station
unique_stations <- unique(q_filtered$Station)

getwd()
setwd("/Users/alex.neumann/Downloads/q_test")

# Using walk to iterate without expecting a return
walk(unique_stations, function(station) {
  # Filter for the current station
  station_data <- q_filtered %>%
    filter(Station == station) %>%
    arrange(Date2) %>%
    select(DATE, `Flow (m3/s)`)
  
  # Construct the filename
  file_name <- paste0("q_",station, ".csv")
  
  # Write to CSV
  write.csv(station_data, file_name, row.names = FALSE, quote = FALSE)
})


# Set the path to the directory containing the files
folder_path <- "/Users/alex.neumann/Downloads/q_test" # Replace with your folder path

# List all files with a specific pattern, for example, CSV files
flow_files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)

# Print the variable to see the file names
print(flow_files)

######Creating data for Total Phosphorus

wq<-read.csv('/Users/alex.neumann/Downloads/TP_LE.csv')
wq$Date2 <- as.Date(wq$DATE, format = "%d/%m/%Y")
wq <- wq %>%
  rename("TP (mg/L)" = 'TP..mg.L.')

setwd("/Users/alex.neumann/Downloads/wq_test")
# Iterate over each unique station
unique_stations <- unique(wq$STATION)

# Using walk to iterate without expecting a return
walk(unique_stations, function(station) {
  # Filter for the current station
  station_data <- wq %>%
    filter(station == STATION) %>%
    arrange(Date2) %>%
    select(DATE, 'TP (mg/L)')
  
  # Construct the filename
  file_name <- paste0("wq_",station, ".csv")
  
  # Write to CSV
  write.csv(station_data, file_name, row.names = FALSE, quote = FALSE)
})


# Set the path to the directory containing the files
folder_path <- "/Users/alex.neumann/Downloads/wq_test" # Replace with your folder path

# List all files with a specific pattern, for example, CSV files
wq_files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)

# Print the variable to see the file names
print(wq_files)

setwd("/Users/alex.neumann/Downloads/ELT")
getwd()
list_wq_q_stations<-read.csv("q_wq_stations.csv",header = TRUE)


logFile = "project_file.llp"
cat("Tributaries", file = logFile, append = TRUE, sep = "\n")

for (i in 1:length(list_wq_q_stations$TP_STATION)){
cat(paste0(list_wq_q_stations[i,2],",LE,CAN,100"), file = logFile, append = TRUE, sep = "\n")
}

cat("", file = logFile, append = TRUE, sep = "\n")
cat("Mon Tributary Loads", file=logFile, append = TRUE, sep = "\n")
#Alouette River at Harris Rd,AMPA,input4\Flow_08MH005.csv,input4\WQ_Alouette River at Harris Rd_AMPA.csv,,Beale

for (i in 1:length(list_wq_q_stations$TP_STATION)){
  line <- paste0(list_wq_q_stations[i,2],",TP,","E:\\Alex\\LE\\Loading\\Inputs\\",list_wq_q_stations[i,3],",E:\\Alex\\LE\\Loading\\Inputs\\",list_wq_q_stations[i,4],",,Beale")
  cat(line, file = logFile, append = TRUE, sep = "\n")
}


cat("", file = logFile, append = TRUE, sep = "\n")
cat("Mon Tributary Ratios", file = logFile, append = TRUE, sep = "\n")
for (i in 1:length(list_wq_q_stations$TP_STATION)){
cat(paste0(list_wq_q_stations[i,2],",1,0"), file = logFile, append = TRUE, sep = "\n")
}
cat("", file = logFile, append = TRUE, sep = "\n")
cat("Basins", file = logFile, append = TRUE, sep = "\n")
cat("LE,0,1", file = logFile, append = TRUE, sep = "\n")
#dir.create(paste0(path,"/export"))

