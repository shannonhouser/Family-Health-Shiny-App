library(tidyverse)
library(tigris)
library(leaflet)

# Map Packages
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(zipcodeR)
library(sf)
library(USAboundaries)
library(XML)
library(acs)
library(stringr) # to pad fips codes
library(htmltools)
library(janitor)
library(tidygeocoder)

api.key.install(key="9ec0e76890fc15208ffc735423da847eb242a3e1")
geo<-geo.make(state=c("CA"),
              county= 113, tract="*")

# Over 200K
income_2015_2019 <-acs.fetch(endyear = 2019, span = 5, geography = geo,
                             table.number = "B19001", col.names = "pretty")


poverty_sex_age <- acs.fetch(endyear = 2019, span = 5, geography = geo,
                             table.number = "B17001", col.names = "pretty")


gini <- acs.fetch(endyear = 2019, span = 5, geography = geo,
                  table.number = "B19083", col.names = "pretty")

counties <- counties(state = "CA")

yolo <- counties %>%
  filter(NAME == "Yolo")

tracts <- tracts(state = 'CA', county = "yolo", cb = TRUE)

usethis::use_data(income_2015_2019, poverty_sex_age, gini, yolo, tracts, overwrite = FALSE)
