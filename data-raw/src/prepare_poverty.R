if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, tigris, leaflet, ggplot2, ggmap, maps,
               mapdata, zipcodeR, sf, USAboundaries, XML, acs,
               stringr, htmltools, janitor, usethis, here)

tracts <- tracts(state = 'CA', county = "yolo", cb=TRUE)
api.key.install(key="9ec0e76890fc15208ffc735423da847eb242a3e1")
geo<-geo.make(state=c("CA"),
              county= 113, tract="*")
durham_tracts <- tracts(state = 'NC', county = "durham", cb=TRUE)


poverty_sex_age <- acs.fetch(endyear = 2019, span = 5, geography = geo,
                             table.number = "B17001", col.names = "pretty")

usethis::use_data(poverty_sex_age, overwrite = TRUE)
