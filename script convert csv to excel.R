install.packages("readr")
install.packages("writexl")
install.packages("fs")

# Required packages
library(readr)      # For reading CSV files efficiently
library(writexl)    # For writing Excel files
library(fs)         # For file system operations

# Set working directory (modify these paths according to your system)
input_dir <- "C:/Users/alex/iCloudDrive/Downloads/Jeremy/Input"
output_dir <- "C:/Users/alex/iCloudDrive/Downloads/Jeremy/Output"

# Create Output directory if it doesn't exist
if (!dir_exists(output_dir)) {
  dir_create(output_dir)
}

# Get list of all CSV files in the Input folder
csv_files <- dir_ls(input_dir, regexp = "\\.csv$", recurse = FALSE)

# Check if there are any CSV files
if (length(csv_files) == 0) {
  stop("No CSV files found in the Input folder")
}

# Process each CSV file
for (file_path in csv_files) {
  # Read the CSV file
  data <- read_csv(file_path, show_col_types = FALSE)
  
  # Extract file name without extension
  file_name <- path_file(file_path)
  base_name <- path_ext_remove(file_name)
  
  # Create output file path with .xlsx extension
  output_file <- path(output_dir, paste0(base_name, ".xlsx"))
  
  # Write to Excel format
  write_xlsx(data, output_file)
  
  # Print progress message
  cat(sprintf("Converted %s to %s\n", file_name, path_file(output_file)))
}

cat("Conversion complete!\n")
