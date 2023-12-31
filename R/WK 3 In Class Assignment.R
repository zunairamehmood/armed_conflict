install.packages("here")
library(here)
install.packages("dplyr")
library(dplyr)
install.packages("tidyverse")
library(tidyverse)
install.packages("countrycode")
library(countrycode) # https://github.com/vincentarelbundock/countrycode

#CREATE A LIST OF DATA FRAMES FROM A DIRECTORY WITH CSV FILES
create.df.list <- function(directory){
  file_names_vector <- list.files(directory)
  L <- length(file_names_vector)
  df_list <- list() #Initiates empty list
  length(df_list) <- L #Should have same number of elements in list as the number of files
  for (i in 1:L){ 
    df_list[[i]] <- read.csv(here("original",file_names_vector[i]), 
                             header = TRUE, na.strings = c(""))
  }
  return(df_list)
}
data_list <- create.df.list(here("original"))

#CLEANING DATA FRAME LIST 
clean.df.list <- function(df_list){
  file_names_vector <- list.files(here("original"))
  L <- length(df_list)
  cleaned_df_list <- list()
  length(cleaned_df_list) <- L
  for (i in 2:L){ 
    cleaned_df_list[[i]] <- select(df_list[[i]], Country.Name, paste("X",c(2000:2019), sep=""))
    cleaned_df_list[[i]] <- pivot_longer(data = cleaned_df_list[[i]],
                                         cols = starts_with("X"),
                                         names_prefix = "X",
                                         names_to = "Year",
                                         names_transform = list(Year=as.double),
                                         values_to = strsplit(file_names_vector[i], "[.]")[[1]][1])
  }
  return(cleaned_df_list)
}
cleaned_data_list <- clean.df.list(create.df.list(here("original")))

# LIST OF ALL MORTALITY DATA FRAMES
mortalitydata_list <- cleaned_data_list[-1]


# MERGE ALL DATA FRAMES IN LIST
mortalitydata_list |> reduce(full_join, by = c('Country.Name', 'Year')) -> cleaned_mortality_data


# ADD ISO3 TO DATA
cleaned_mortality_data$ISO <- countrycode(cleaned_mortality_data$Country.Name, 
                          origin = "country.name", 
                          destination = "iso3c")
cleaned_mortality_data <- select(cleaned_mortality_data, -Country.Name)


#Sample code from last class
write.csv(cleaned_mortality_data, here("data","mortality_cleaned.csv"),row.names = FALSE)
