install.packages("here")
library(here)
install.packages("dplyr")
library(dplyr)
install.packages("tidyverse")
library(tidyverse)


maternal.mortality.df <- read.csv(here("original","maternalmortality.csv"), 
                                  header = TRUE, na.strings = c(""))

maternal.mortality.subset <- select(maternal.mortality.df, Country.Name, paste("X",c(2000:2019), sep=""))
maternal.mortality.subset <- pivot_longer(data = maternal.mortality.subset,
                                          cols = starts_with("X"),
                                          names_prefix = "X",
                                          names_to = "Year",
                                          names_transform = list(Year=as.double),
                                          values_to = "MatMor")
head(maternal.mortality.subset,20)
tail(maternal.mortality.subset,20)

########################################
install.packages("usethis")
library(usethis) 
gitcreds::gitcreds_set()

usethis::use_git_config(user.name = "zunairamehmood", user.email = "zunaira.m.alam@gmail.com",)
usethis::git_sitrep()

usethis::use_git() #Initiate and Commit Files
usethis::use_github() #Push to GitHub
