if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, tigris, leaflet, ggplot2, ggmap, maps,
               mapdata, zipcodeR, sf, USAboundaries, XML, acs,
               stringr, htmltools, janitor, usethis, here)


## Day Care Centers
day_cares <- read.csv(here("data-raw/input/community-care-licensing-child-care-center-locations-.csv")) %>%
  clean_names()

yolo_day_cares <- day_cares %>%
  filter(county_name == "YOLO",
         facility_status != "CLOSED") %>%
  mutate(facility_city = str_remove_all(facility_city, ",")) %>%
  mutate(across(.cols = c(facility_type, facility_name, facility_administrator, facility_address, facility_city), str_to_title))

usethis::use_data(yolo_day_cares, overwrite = TRUE)
