if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, tigris, leaflet, ggplot2, ggmap, maps,
               mapdata, zipcodeR, sf, USAboundaries, XML, acs,
               stringr, htmltools, janitor, usethis, here)

counties <- counties(state = "CA")

yolo <- counties %>%
  filter(NAME == "Yolo")

usethis::use_data(yolo, overwrite = TRUE)
