covs <- read.csv(here("original", "covariates.csv"), header = TRUE)
save(covs, file = here("data", "covs.Rda"))

source(here("R", "prepare_mortality.R"))
source(here("R", "prepare_disaster.R"))
source(here("R", "prepare_conflict.R"))

#put all data frames into list
alllist <- list(covs, confdata, mortality, disasters)

#merge all data frames in list
alllist |> reduce(left_join, by = c('ISO', 'year')) -> finaldata

# need to fill in NAs with 0's for armconf1, drought, earthquake
finaldata <- finaldata |>
  mutate(armconf1 = replace_na(armconf1, 0),
         drought = replace_na(drought, 0),
         earthquake = replace_na(earthquake, 0),
         totdeath = replace_na(totdeath, 0))

write.csv(finaldata, file = here("data", "finaldata.csv"), row.names = FALSE)

dim(finaldata)
names(finaldata)
length(unique(finaldata$ISO))
