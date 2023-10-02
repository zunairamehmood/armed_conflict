# https://github.com/vincentarelbundock/countrycode

file_names_vector <- c("infantmortality.csv","maternalmortality.csv","neonatalmortality.csv","under5mortality.csv")
#CREATE A LIST OF DATA FRAMES FROM A DIRECTORY WITH CSV FILES
create.df.list <- function(file_names_vector){
  L <- length(file_names_vector)
  df_list <- list() #Initiates empty list
  length(df_list) <- L #Should have same number of elements in list as the number of files
  for (i in 1:L){ 
    df_list[[i]] <- read.csv(here("original",file_names_vector[i]), 
                             header = TRUE, na.strings = c(""))
  }
  return(df_list)
}
data_list <- create.df.list(file_names_vector)

#CLEANING DATA FRAME LIST 
clean.df.list <- function(df_list){
  L <- length(df_list)
  cleaned_df_list <- list()
  length(cleaned_df_list) <- L
  for (i in 1:L){ 
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
cleaned_data_list <- clean.df.list(create.df.list(file_names_vector))

# LIST OF ALL MORTALITY DATA FRAMES
mortalitydata_list <- cleaned_data_list


# MERGE ALL DATA FRAMES IN LIST
mortalitydata_list |> reduce(full_join, by = c('Country.Name', 'Year')) -> mortality


# ADD ISO3 TO DATA
mortality$ISO <- countrycode(mortality$Country.Name, 
                          origin = "country.name", 
                          destination = "iso3c")
mortality <- select(mortality, -Country.Name)
mortality$year <- mortality$Year
mortality$Year <- NULL

#SAVING DATA
save(mortality, file = here("data", "mortality.Rda"))
#write.csv(cleaned_mortality_data, here("data","mortality_cleaned.csv"),row.names = FALSE)
