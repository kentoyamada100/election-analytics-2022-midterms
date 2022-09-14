# Download Congressional district boundaries
# Source Jeffrey B. Lewis, Brandon DeVine, Lincoln Pitcher, and Kenneth C. Martis. (2013). 
# Digital Boundary Definitions of United States Congressional Districts, 1789-2012.
# [Data file and code book]. Retrieved from https://cdmaps.polisci.ucla.edu.

get_congress_map <- function(cong) {
  
  # Temporary file
  tmp_file <- tempfile()
  
  # Convert "cong" to 3 digits if necessary
  cong <- str_pad(cong, 3, pad = "0")
  
  # download file
  download.file(paste("https://cdmaps.polisci.ucla.edu/shp/districts", cong, ".zip",
                      sep = ""),
                tmp_file)
  
  
  # unzip downloaded file
  unzip(zipfile = tmp_file, exdir = "analysis_data/")
  
  # read file
  shape <- st_read(paste("analysis_data/districtShapes/districts", cong, ".shp", 
                         sep = ""))
  
  return(shape)
}