library(tidyverse)

# States with multiple congressional districts
# Set working directory
setwd('/Users/kentoyamada/Documents/R-Projects/election-analytics-2022-midterms/analysis_data/dra/multiple_seats')
filenames <- list.files(pattern = "*.csv")
multiple <- map_df(filenames, read.csv, stringsAsFactors = FALSE, .id = 'filename')

# State names
statenames <- substr(filenames, start = 1, stop = 2)
multiple <- multiple %>%
  mutate(state = statenames[as.numeric(filename)])

# Extract relevant data
multiple_df <- multiple %>%
  # 2020 Presidential election data
  select(state, ID, Rep_2020_Pres, Dem_2020_Pres, Total_2020_Pres) %>%
  # Drop ID = 0
  filter(ID != 0) %>%
  # District numbers
  mutate(District = str_pad(ID, 2, pad = "0")) %>%
  # Define district names
  mutate(District = paste(state, District, sep = "-")) %>%
  select(-c(state, ID))

# States with single congressional districts
# Set working directory
setwd('/Users/kentoyamada/Documents/R-Projects/election-analytics-2022-midterms/analysis_data/dra/single_seat')
filenames <- list.files(pattern = "*.csv")
single <- map_df(filenames, read.csv, stringsAsFactors = FALSE, .id = 'filename')

# State names
statenames <- substr(filenames, start = 1, stop = 2)

# Aggregate to the state-level
single_df <- single %>%
  # Drop ID = 0
  filter(ID != 0) %>%
  group_by(filename) %>%
  # Add up 2020 votes
  summarize(Rep_2020_Pres = sum(Rep_2020_Pres),
            Dem_2020_Pres = sum(Dem_2020_Pres),
            Total_2020_Pres = sum(Total_2020_Pres))

# Add state/district names
single_df <- bind_cols(single_df, as_tibble(statenames))

# Define district names
single_df <- single_df %>%
  mutate(District = paste(value, "01", sep = "-")) %>%
  select(-c(value, filename))

# Write csv
setwd('/Users/kentoyamada/Documents/R-Projects/election-analytics-2022-midterms/analysis_data')
bind_rows(single_df, multiple_df) %>%
  write.csv(file = "dra_2020_pres.csv")
  
  
  

