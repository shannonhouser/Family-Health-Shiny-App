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

## Providers

#providers <- read.csv("../Data/State_of_California_Geocoded_Providers__2019_California_Clinics_Geocoded.csv")
providers <- read.csv("../Data/care-provider-network-apr-2021.csv", stringsAsFactors = FALSE) %>% 
  mutate(
    Site_Name = str_to_title(Site_Name),
    Managed_Care_Classification = case_when(
      str_detect(Site_Name, "Pharmacy") == TRUE ~ "Pharmacy",
      Managed_Care_Classification == "" ~ "Other",
      TRUE ~ Managed_Care_Classification
    )
  )

## Day Care Centers
day_cares <- read.csv("../Data/community-care-licensing-child-care-center-locations-.csv") %>% 
  clean_names()

yolo_day_cares <- day_cares %>% 
  filter(county_name == "YOLO",
         facility_status != "CLOSED") %>% 
  mutate(facility_city = str_remove_all(facility_city, ",")) %>% 
  mutate(across(.cols = c(facility_type, facility_name, facility_administrator, facility_address, facility_city), str_to_title))

## Food
vendors <- read.csv("../Data/vendor.csv") %>% 
  filter(County == " YOLO")

## Community Organizations

counties <- counties(state = "CA")

yolo <- counties %>% 
  filter(NAME == "Yolo")

comm_orgs <- readxl::read_xlsx("../Data/yolo_county_community_orgs.xlsx") %>% 
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

## Maps for Home Page

tracts <- tracts(state = 'CA', county = "yolo", cb=TRUE)
api.key.install(key="9ec0e76890fc15208ffc735423da847eb242a3e1")
geo<-geo.make(state=c("CA"),
              county= 113, tract="*")
durham_tracts <- tracts(state = 'NC', county = "durham", cb=TRUE)

# Over 200K
income_2015_2019 <-acs.fetch(endyear = 2019, span = 5, geography = geo,
                             table.number = "B19001", col.names = "pretty")

income_2015_2019_df <- data.frame(paste0(str_pad(income_2015_2019@geography$state, 2, "left", pad="0"), 
                                         str_pad(income_2015_2019@geography$county, 3, "left", pad="0"), 
                                         str_pad(income_2015_2019@geography$tract, 6, "left", pad="0")), 
                                  income_2015_2019@estimate,
                                  stringsAsFactors = FALSE)

names(income_2015_2019_df)[1] <- "GEOID"

colnames(income_2015_2019_df)[2:18] <- str_remove(colnames(income_2015_2019_df[2:18]), "\\D*")

names(income_2015_2019_df)[2] <- "Total"

income_2015_2019_df <- income_2015_2019_df %>% 
  clean_names()

income_2015_2019_df_over_200 <- income_2015_2019_df %>% 
  select(c(1:2, 18)) 

names(income_2015_2019_df_over_200)<-c("GEOID", "total", "over_200")
income_2015_2019_df_over_200$percent <- 100*(income_2015_2019_df_over_200$over_200/income_2015_2019_df_over_200$total)


income_2015_2019_df_over_200_merged<- geo_join(tracts, income_2015_2019_df_over_200, "GEOID", "GEOID")
income_2015_2019_df_over_200_merged <- income_2015_2019_df_over_200_merged[income_2015_2019_df_over_200_merged$ALAND>0,]



popup <- paste0("GEOID: ", income_2015_2019_df_over_200_merged$GEOID, "<br>", "Percent of Households above $200k: ", round(income_2015_2019_df_over_200_merged$percent,2))
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = income_2015_2019_df_over_200_merged$percent
)

map_over_200_2015_2019 <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = income_2015_2019_df_over_200_merged, 
              fillColor = ~pal(percent), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup) %>%
  addLegend(pal = pal, 
            values = income_2015_2019_df_over_200_merged$percent, 
            position = "bottomleft", 
            title = "Percent of Households<br>above $200k",
            labFormat = labelFormat(suffix = "%")) 

# Below Poverty Line

poverty_sex_age <- acs.fetch(endyear = 2019, span = 5, geography = geo,
                             table.number = "B17001", col.names = "pretty")

poverty_sex_age_df <- data.frame(paste0(str_pad(poverty_sex_age@geography$state, 2, "left", pad="0"), 
                                        str_pad(poverty_sex_age@geography$county, 3, "left", pad="0"), 
                                        str_pad(poverty_sex_age@geography$tract, 6, "left", pad="0")), 
                                 poverty_sex_age@estimate,
                                 stringsAsFactors = FALSE) %>% 
  clean_names()

poverty_sex_age_df <- poverty_sex_age_df %>% 
  select(c(1:3))

names(poverty_sex_age_df) <- c("GEOID", "total", "poverty") 

poverty_sex_age_df_merged <- poverty_sex_age_df %>% 
  mutate(percent = round((poverty/total)*100, 2)) %>% 
  geo_join(tracts, ., "GEOID", "GEOID")

popup_poverty_sex_age <- paste0("GEOID: ", poverty_sex_age_df_merged$GEOID, "<br>", "Percent of Households below $25k: ", round(poverty_sex_age_df_merged$percent,2))
pal_poverty_sex_age <- colorNumeric(
  palette = "YlGnBu",
  domain = poverty_sex_age_df_merged$percent
)

map_poverty_sex_age <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = poverty_sex_age_df_merged, 
              fillColor = ~pal_poverty_sex_age(percent), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup_poverty_sex_age) %>%
  addLegend(pal = pal_poverty_sex_age, 
            values = poverty_sex_age_df_merged$percent, 
            position = "bottomleft", 
            title = "Percent of People<br>below Poverty Line",
            labFormat = labelFormat(suffix = "%")) 

# Gini Index

gini <- acs.fetch(endyear = 2019, span = 5, geography = geo,
                  table.number = "B19083", col.names = "pretty")

gini_df <- data.frame(paste0(str_pad(poverty_sex_age@geography$state, 2, "left", pad="0"), 
                             str_pad(poverty_sex_age@geography$county, 3, "left", pad="0"), 
                             str_pad(poverty_sex_age@geography$tract, 6, "left", pad="0")), 
                      gini@estimate,
                      stringsAsFactors = FALSE) %>% 
  clean_names()

names(gini_df) <- c("GEOID", "gini_index") 

gini_df_merged <- gini_df %>% 
  geo_join(tracts, ., "GEOID", "GEOID")

popup_gini <- paste0("GEOID: ", gini_df_merged$GEOID, "<br>", "Gini Index: ", round(gini_df_merged$gini_index,2))
pal_gini <- colorNumeric(
  palette = "YlGnBu",
  domain = gini_df_merged$gini_index
)

map_gini <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = gini_df_merged, 
              fillColor = ~pal_gini(gini_index), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup_gini) %>%
  addLegend(pal = pal_gini, 
            values = gini_df_merged$gini_index, 
            position = "bottomleft", 
            title = "Gini Index") 

# Health Insurance

health_insur_age_edu <- read.csv("../Data/health_insurance_age_education.csv") %>%
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


popup_health_insurance <- paste0("GEOID: ", no_insur$GEOID, "<br>", "Percent Without Insurance: ", round(no_insur$not_insured_pct*100,2), "%")
pal_health_insurance <- colorNumeric(
  palette = "YlGnBu",
  domain = no_insur$not_insured_pct
)

map_health_insurance <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = no_insur,
              fillColor = ~pal_health_insurance(not_insured_pct),
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7,
              weight = 1,
              smoothFactor = 0.2,
              popup = popup_health_insurance) %>%
  addLegend(pal = pal_health_insurance,
            values = no_insur$not_insured_pct,
            position = "bottomleft",
            title = "Percent of People<br> without Health Insurance",
            labFormat = labelFormat(suffix = "%"))

# Durham Health Insurance

health_insur_age_edu_durham <- read.csv("../Data/health_insurance_age_education_durham.csv") %>%
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


popup_health_insurance <- paste0("GEOID: ", no_insur_durham$GEOID, "<br>", "Percent Without Insurance: ", round(no_insur_durham$not_insured_pct*100,2), "%")
pal_health_insurance <- colorNumeric(
  palette = "YlGnBu",
  domain = no_insur_durham$not_insured_pct
)

map_health_insurance_durham <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = no_insur_durham,
              fillColor = ~pal_health_insurance(not_insured_pct),
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7,
              weight = 1,
              smoothFactor = 0.2,
              popup = popup_health_insurance) %>%
  addLegend(pal = pal_health_insurance,
            values = no_insur_durham$not_insured_pct,
            position = "bottomleft",
            title = "Percent of People<br> without Health Insurance",
            labFormat = labelFormat(suffix = "%"))


