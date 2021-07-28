if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, tigris, leaflet, ggplot2, ggmap, maps,
               mapdata, zipcodeR, sf, USAboundaries, XML, acs,
               stringr, htmltools, janitor, usethis, here)

comm_orgs <- readxl::read_xlsx(here("data-raw/input/yolo_county_community_orgs.xlsx")) %>%
  clean_names()

comm_orgs <- comm_orgs %>%
  mutate(comm_main_url = str_extract(name_of_organization, "https.*")) %>%
  mutate(name_of_organization = str_remove(name_of_organization, " https.*")) %>%
  mutate(across(.cols = 2:ncol(.),
                ~str_replace(., " ", "\n"))) %>%
  pivot_longer(cols = c(2:16),
               names_to = "resource",
               values_to = 'value_url') %>%
  mutate(resource = str_replace_all(resource, "_", " "),
         resource = str_to_title(resource))

usethis::use_data(comm_orgs, overwrite = TRUE)
