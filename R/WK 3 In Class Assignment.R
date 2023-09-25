install.packages("here")
library(here)
install.packages("dplyr")
library(dplyr)
install.packages("tidyverse")
library(tidyverse)

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
                                         values_to = "MortalityRate")
  }
  return(cleaned_df_list)
}
cleaned_data_list <- clean.df.list(create.df.list(here("original")))

#SEPARATING THE FILES
(file_names_vector <- list.files(here("original")))
infant.mortality.df <- cleaned_data_list[[2]]
infant.mortality.df$infant.MR <- infant.mortality.df$MortalityRate 
infant.mortality.df$MortalityRate <- NULL

maternal.mortality.df <- cleaned_data_list[[3]]
maternal.mortality.df$maternal.MR <- maternal.mortality.df$MortalityRate 
maternal.mortality.df$MortalityRate <- NULL

neonatal.mortality.df <- cleaned_data_list[[4]]
neonatal.mortality.df$neonatal.MR <- neonatal.mortality.df$MortalityRate 
neonatal.mortality.df$MortalityRate <- NULL

under5.mortality.df <- cleaned_data_list[[5]]
under5.mortality.df$under5.MR <- under5.mortality.df$MortalityRate 
under5.mortality.df$MortalityRate <- NULL

merged.mortality.data <- merge(infant.mortality.df,maternal.mortality.df,neonatal.mortality.df,under5.mortality.df, by=c("Country.Name","Year"))

# https://github.com/vincentarelbundock/countrycode
install.packages("countrycode")
library(countrycode)


#Sample code from last class
write.csv(maternal_mortality_cleaned, here("data","maternal_mortality_cleaned.csv"),row.names = FALSE)
