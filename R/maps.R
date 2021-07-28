
#' @import janitor tigris dplyr leaflet ggplot2 ggmap stringr
map_over_200_2015_2019 <- function() {
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

  leaflet() %>%
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
              position = "bottomright",
              title = "Percent of Households<br>above $200k",
              labFormat = labelFormat(suffix = "%"))

}


#' @import janitor tigris dplyr leaflet ggplot2 ggmap stringr
map_poverty_sex_age <- function() {
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

  leaflet() %>%
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
              position = "bottomright",
              title = "Percent of People<br>below Poverty Line",
              labFormat = labelFormat(suffix = "%"))

}


#' @import janitor tigris dplyr leaflet ggplot2 ggmap stringr
map_gini <- function() {
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

  leaflet() %>%
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
              position = "bottomright",
              title = "Gini Index")
}

#' @import janitor tigris dplyr leaflet ggplot2 ggmap stringr
map_health_insurance <- function() {
  popup_health_insurance <- paste0("GEOID: ", no_insur$GEOID, "<br>", "Percent Without Insurance: ", round(no_insur$not_insured_pct*100,2), "%")
  pal_health_insurance <- colorNumeric(
    palette = "YlGnBu",
    domain = no_insur$not_insured_pct
  )

  leaflet() %>%
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


}

#' @import janitor tigris dplyr leaflet ggplot2 ggmap stringr
map_health_insurance_durham <- function() {
  popup_health_insurance <- paste0("GEOID: ", no_insur_durham$GEOID, "<br>", "Percent Without Insurance: ", round(no_insur_durham$not_insured_pct*100,2), "%")
  pal_health_insurance <- colorNumeric(
    palette = "YlGnBu",
    domain = no_insur_durham$not_insured_pct
  )

  leaflet() %>%
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

}
