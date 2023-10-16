library(tidyverse)
library(here)
library(texreg)
library(multgee)
library(table1)
filter <- dplyr::filter
lag <- dplyr::lag

finaldata <- read.csv(here("data", "finaldata.csv"), header = TRUE)
glimpse(finaldata)

finaldata_baseline <- filter(finaldata, year == 2000) %>%
  mutate(country_name = as.factor(country_name),
         armconf1 = factor(armconf1, levels = c(0,1), labels=c("No","Yes")),
         earthquake = factor(earthquake, levels = c(0,1), labels=c("No","Yes")),
         drought = factor(drought, levels = c(0,1), labels=c("No","Yes"))
)
glimpse(finaldata_baseline)

label(finaldata_baseline$armconf1) <- "Armed Conflict"
label(finaldata_baseline$country_name) <- "Country"
label(finaldata_baseline$year) <- "Year"

label(finaldata_baseline$maternalmortality) <- "Maternal Mortality Rate per 100,000 live births"
label(finaldata_baseline$infantmortality) <- "Infant Mortality Rate per 1,000 live births"
label(finaldata_baseline$neonatalmortality) <- "Neonatal Mortality Rate per 1,000 live births"
label(finaldata_baseline$under5mortality) <- "Under 5 Mortality Rate per 1,000 live births"

label(finaldata_baseline$GDP) <- "Gross Domestic Product (GDP)"
label(finaldata_baseline$OECD) <- "OECD Member"
label(finaldata_baseline$popdens)<- "Population Density"
label(finaldata_baseline$urban) <- "Urban Residence"
label(finaldata_baseline$agedep) <- "Age Dependency Ratio"
label(finaldata_baseline$male_edu) <- "Male Education"
label(finaldata_baseline$temp) <- "Temperature"
label(finaldata_baseline$earthquake) <- "Earthquakes"
label(finaldata_baseline$drought) <- "Droughts"  

caption <- "Table 1: Description of Data Used in the Study"
rndr <- function(x, name, ...) {
  if (!is.numeric(x)) return(render.categorical.default(x))
  what <- switch(name,
                 maternalmortality = "Median [Min, Max]",
                 infantmortality= "Median [Min, Max]",
                 neonatalmortality= "Median [Min, Max]",
                 under5mortality= "Median [Min, Max]",
                 GDP = "Median [Min, Max]",
                 popdens = "Median [Min, Max]" ,
                 urban = "Median [Min, Max]",
                 agedep = "Median [Min, Max]",
                 male_edu = "Median [Min, Max]",
                 temp = "Median [Min, Max]",
                 totdeath = "Median [Min, Max]")
  parse.abbrev.render.code(c("", what))(x)
}

table1( ~ maternalmortality + infantmortality + neonatalmortality + under5mortality + GDP + popdens + urban + agedep + male_edu + temp +drought +earthquake| armconf1, data = finaldata_baseline, 
        #render = rndr,
        caption = caption,
        render.continuous=c("Median [Min, Max]"))

####################################################################
finaldata <- read.csv(here("data", "finaldata.csv"), header = TRUE)
finaldata |>
  dplyr::select(country_name, ISO, year, maternalmortality) |>
  dplyr::filter(year < 2018) |>
  arrange(ISO, year) |>
  group_by(ISO) |>
  mutate(diffmatmor = maternalmortality - maternalmortality[1L]) |>
  filter(diffmatmor > 0 & year==2017) |>
  select(ISO) 

finaldata <- read.csv(here("data", "finaldata.csv"), header = TRUE) |>
finaldata_increased_matmor <- dplyr::filter(finaldata, (ISO == "BRN" | ISO == "CAN" | ISO == "DOM" |ISO == "HTI" |ISO == "JAM" |ISO == "KWT" |ISO == "LBN" |ISO == "LBY" |ISO == "LCA" | ISO == "MUS" |ISO == "SYR" |ISO == "USA" |ISO == "VEN")& year < 2018)


#########
finaldata_increased_matmor |>
  ggplot(aes(x = year, y = maternalmortality, group = ISO)) +
  geom_line(aes(color=ISO)) + geom_point(size=0.3)+
  xlim(c(2000,2017)) +
  labs(y = "Maternal mortality", x = "Year") + 
  theme_bw()


