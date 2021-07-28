if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, tigris, leaflet, ggplot2, ggmap, maps,
               mapdata, zipcodeR, sf, USAboundaries, XML, acs,
               stringr, htmltools, janitor, usethis, here)

tracts <- tracts(state = 'CA', county = "yolo", cb=TRUE)
api.key.install(key="9ec0e76890fc15208ffc735423da847eb242a3e1")
geo<-geo.make(state=c("CA"),
              county= 113, tract="*")
durham_tracts <- tracts(state = 'NC', county = "durham", cb=TRUE)


health_insur_age_edu <- read.csv(here("data-raw/input/health_insurance_age_education.csv")) %>%
  clean_names()

health_insur_age_edu <- health_insur_age_edu %>%
  mutate(id = str_remove(id, "\\d*\\D{2}")) %>%
  rename("GEOID" = "id")

no_insur <- health_insur_age_edu[c(1,3,str_which(names(health_insur_age_edu), "no_health_insurance_coverage"))]

no_insur <- no_insur %>%
  mutate(not_insured = rowSums(no_insur[,c(3:10)]),
         not_insured_pct = not_insured/estimate_total,
         percent_insured = (estimate_total - not_insured)/estimate_total)

no_insur <- no_insur %>%
  geo_join(tracts, ., "GEOID", "GEOID")


# Durham
health_insur_age_edu_durham <- read.csv(here("data-raw/input/health_insurance_age_education_durham.csv")) %>%
  clean_names()

health_insur_age_edu_durham <- health_insur_age_edu_durham %>%
  mutate(id = str_remove(id, "\\d*\\D{2}")) %>%
  rename("GEOID" = "id")

no_insur_durham <- health_insur_age_edu_durham[c(1,3,str_which(names(health_insur_age_edu_durham), "no_health_insurance_coverage"))]

no_insur_durham <- no_insur_durham[c(1,2,str_which(names(no_insur_durham), "estimate_total_"))]


no_insur_durham <- no_insur_durham %>%
  mutate(not_insured = rowSums(no_insur_durham[,c(3:10)]),
         not_insured_pct = not_insured/estimate_total,
         percent_insured = (estimate_total - not_insured)/estimate_total)

no_insur_durham <- no_insur_durham %>%
  geo_join(durham_tracts, ., "GEOID", "GEOID")

no_insur_durham <- no_insur_durham %>%
  mutate(not_insured_pct = ifelse(GEOID == "37063980100", 0, not_insured_pct))


usethis::use_data(no_insur, no_insur_durham, overwrite=TRUE)
