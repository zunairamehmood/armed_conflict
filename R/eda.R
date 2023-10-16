source("../.Rprofile") # Use for quarto doc.

finaldata <- read.csv(here("data", "finaldata.csv"), header = TRUE)
# Model
# Y_it <- Beta0 + Beta1*conflict_i,t-1 + beta2*covs_it + i + t

head(finaldata)
tail(finaldata)
glimpse(finaldata)


finaldata %>% count(ISO)
finaldata %>% count(region)
finaldata %>% count(year)
summary(finaldata)

ggplot(finaldata, aes(year,infantmortality,alpha=0.1 ))+geom_point()
ggplot(finaldata, aes(year,maternalmortality,alpha=0.1 ))+geom_point()
ggplot(finaldata, aes(year,neonatalmortality,alpha=0.1 ))+geom_point()
ggplot(finaldata, aes(year,under5mortality,alpha=0.1 ))+geom_point()

ggplot(finaldata, aes(year,infantmortality,alpha=0.1 ))+geom_smooth()
ggplot(finaldata, aes(year,maternalmortality,alpha=0.1 ))+geom_smooth()
ggplot(finaldata, aes(year,neonatalmortality,alpha=0.1 ))+geom_smooth()
ggplot(finaldata, aes(year,under5mortality,alpha=0.1 ))+geom_smooth()


ggplot(finaldata, aes(year,infantmortality))+geom_smooth() +
  geom_smooth(data=finaldata,mapping=aes(year,maternalmortality)) +
  geom_smooth(data=finaldata,mapping=aes(year,neonatalmortality)) +
  geom_smooth(data=finaldata,mapping=aes(year,under5mortality)) 
graph1+graph2+graph3+graph4

If the boxplots overlap does it mean its not meaningful?

