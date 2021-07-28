if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, tigris, leaflet, ggplot2, ggmap, maps,
               mapdata, zipcodeR, sf, USAboundaries, XML, acs,
               stringr, htmltools, janitor, usethis, here)


providers <- read.csv(here("data-raw/input/care-provider-network-apr-2021.csv")) %>%
  mutate(
    Site_Name = str_to_title(Site_Name),
    Managed_Care_Classification = case_when(
      str_detect(Site_Name, "Pharmacy") == TRUE ~ "Pharmacy",
      Managed_Care_Classification == "" ~ "Other",
      TRUE ~ Managed_Care_Classification
    )
  )

usethis::use_data(providers, overwrite = TRUE)
