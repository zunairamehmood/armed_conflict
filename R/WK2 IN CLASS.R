install.packages("here")
library(here)
install.packages("dplyr")
library(dplyr)
install.packages("tidyverse")
library(tidyverse)

maternal_mortality_df <- read.csv(here("original","maternalmortality.csv"), 
                                  header = TRUE, na.strings = c(""))

maternal_mortality_cleaned <- select(maternal_mortality_df, Country.Name, paste("X",c(2000:2019), sep=""))
maternal_mortality_cleaned <- pivot_longer(data = maternal_mortality_cleaned,
                                          cols = starts_with("X"),
                                          names_prefix = "X",
                                          names_to = "Year",
                                          names_transform = list(Year=as.double),
                                          values_to = "MatMor")

head(maternal_mortality_cleaned,20)
tail(maternal_mortality_cleaned,20)

write.csv(maternal_mortality_cleaned, here("data","maternal_mortality_cleaned.csv"),row.names = FALSE)

########################################
install.packages("usethis")
library(usethis) 
gitcreds::gitcreds_set()

usethis::use_git_config(user.name = "zunairamehmood", user.email = "zunaira.m.alam@gmail.com")
usethis::git_sitrep()

usethis::use_git() #Initiate and Commit Files
usethis::use_github() #Push to GitHub
########################################

