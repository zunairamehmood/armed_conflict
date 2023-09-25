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

usethis::use_git_remote("origin", url = NULL, overwrite = TRUE)
usethis::use_git() #Initiate and Commit Files
usethis::use_github() #Push to GitHub
########################################


disaster_df <- read.csv(here("original","disaster.csv"), 
                                  header = TRUE, na.strings = c(""))
disaster_cleaned <- filter(disaster_df,(Year>= 2000 & Year<=2019) & (Disaster.Type=="Earthquake" | Disaster.Type=="Drought"))
disaster_cleaned <- select(disaster_cleaned, Year, ISO, Disaster.Type)
disaster_cleaned$earthquake <- ifelse(disaster_cleaned$Disaster.Type=="Earthquake",1,0)
disaster_cleaned$drought <- ifelse(disaster_cleaned$Disaster.Type=="Drought",1,0)

disaster_cleaned2 <- disaster_cleaned %>% group_by(ISO,Year) %>% summarize(drought=sum(drought),earthquake = sum(earthquake)) 

