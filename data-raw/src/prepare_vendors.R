if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, tigris, leaflet, ggplot2, ggmap, maps,
               mapdata, zipcodeR, sf, USAboundaries, XML, acs,
               stringr, htmltools, janitor, usethis, here)


## Food
vendors <- read.csv(here("data-raw/input/vendor.csv")) %>%
  filter(County == " YOLO")

usethis::use_data(vendors, overwrite = TRUE)
