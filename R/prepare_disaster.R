

disaster <- read.csv(here("original","disaster.csv"), header = TRUE, na.strings = c(""))

#Cleaning disaster data
disaster |>
  dplyr::filter(Year >= 2000 & Year <= 2019) |> 
  dplyr::filter(Disaster.Type=="Earthquake" | Disaster.Type=="Drought") |>
  dplyr::select(Year, ISO, Disaster.Type) |>
  rename(year = Year) |>
  group_by(year, ISO) |>
  mutate(drought0 = ifelse(Disaster.Type == "Drought", 1, 0),
         earthquake0 = ifelse(Disaster.Type == "Earthquake", 1, 0)) |>
  summarize(drought = max(drought0),
            earthquake = max(earthquake0)) |> 
  ungroup() -> disasters 

#Saving data
#write.csv(disasters, here("data","disaster_cleaned.csv"),row.names = FALSE)
save(disasters, file = here("data", "disasters.Rda"))
