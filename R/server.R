#' @import shiny shinydashboard htmltools shinybusy
serverFactory <- function(i18n) {
  function(input, output, session) {
    observeEvent(input$selected_language, {
      update_lang(session, input$selected_language)
    })

    ## Home Page
    # output$overview_maps <- eventReactive(input$search_map, {
    #
    #   if (input$map_type == "Poverty") {
    #     renderLeaflet({
    #       map_poverty_sex_age
    #     })
    #   }
    #
    #   if (input$map_type == "$200K+") {
    #     renderLeaflet({
    #       map_over_200_2015_2019
    #     })
    #   }
    #
    #   if (input$map_type == "Inequality") {
    #     renderLeaflet({
    #       map_gini
    #     })
    #   }
    #
    #   if (input$map_type == "Health Insurance") {
    #     renderLeaflet({
    #       map_health_insurance
    #     })
    #   }
    # })

    output$home1 <- renderValueBox({
      valueBox(
        formatC('10+', format="d", big.mark=',')
        ,paste(i18n$t("Map Visualizations"))
        ,icon = icon("map-marked-alt")
        ,color = "purple"
        ,width = 8)
    })
    output$home2 <- renderValueBox({
      valueBox(
        formatC(2857, format="d", big.mark=',')
        ,paste(i18n$t("Care Providers"))
        ,icon = icon('hospital-user')
        ,color = "green"
        ,width = 4)
    })
    output$home3 <- renderValueBox({
      valueBox(
        formatC('500+', format="d", big.mark=',')
        ,paste(i18n$t('Child Cares'))
        ,icon = icon('baby')
        ,color = "yellow"
        ,width = 12)
    })
    output$home4 <- renderValueBox({
      valueBox(
        formatC(7, format="d", big.mark=',')
        ,paste(i18n$t("Cities in Yolo County"))
        ,icon = icon("city")
        ,color = "olive")
    })
    output$home5 <- renderValueBox({
      valueBox(
        formatC(23, format="d", big.mark=',')
        ,paste(i18n$t("Women, Infants, and Children Vendors"))
        ,icon = icon('female')
        ,color = "light-blue")
    })
    output$home6 <- renderValueBox({
      valueBox(
        formatC('6+', format="d", big.mark=',')
        ,paste(i18n$t('Transportation Resources'))
        ,icon = icon('bus')
        ,color = "blue")
    })
    output$home7 <- renderValueBox({
      valueBox(
        formatC('300+', format="d", big.mark=',')
        ,paste(i18n$t("Covid Resources"))
        ,icon = icon("head-side-cough")
        ,color = "aqua")
    })
    output$home8 <- renderValueBox({
      valueBox(
        formatC('100+', format="d", big.mark=',')
        ,paste(i18n$t("Community Organizations"))
        ,icon = icon('users')
        ,color = "maroon")
    })
    output$home9 <- renderValueBox({
      valueBox(
        formatC(i18n$t('More Resources'), format="d", big.mark=',')
        ,paste(i18n$t('Coming Soon'))
        ,icon = icon('angle-double-right')
        ,color = "black")
    })
    output$home10 <- renderValueBox({
      valueBox(
        formatC(i18n$t('Contact Us'), format="d", big.mark=',')
        ,paste(i18n$t('For More Resources'))
        ,icon = icon('address-book')
        ,color = "navy"
        ,href='https://heallab.ucdavis.edu/people/jennifer-phipps')
    })
    output$home11 <- renderValueBox({
      valueBox(
        formatC(i18n$t('Emergency'), format="d", big.mark=',')
        ,paste(i18n$t('Click Here'))
        ,icon = icon('user-injured')
        ,color = "red"
        ,href='https://www.yolocounty.org/government/general-government-departments/office-of-emergency-services')
    })


    output$below_poverty <- renderLeaflet({
      map_poverty_sex_age()
    })

    output$gini_index <- renderLeaflet({
      map_gini()
    })

    output$above_200k <- renderLeaflet({
      map_over_200_2015_2019()
    })

    output$health_insur_yolo <- renderLeaflet({
      map_health_insurance()
    })

    output$health_insur_durham <- renderLeaflet({
      map_health_insurance_durham()
    })


    ## Provider Page
    provider_filtered <- eventReactive(input$search_providers, {
      providers %>%
        filter(Managed_Care_Plan == input$insur,
               Managed_Care_Classification == input$healthcare_type)
    })

    output$provider_map <- renderLeaflet({
      leaflet() %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(data = yolo,
                    color = "black", # you need to use hex colors
                    fillColor = "white",
                    fillOpacity = .3,
                    weight = 3) %>%
        addMarkers(lng = provider_filtered()$Longitude, lat = provider_filtered()$Latitude, popup = htmlEscape(provider_filtered()$Site_Name))
    })

    url <- a("Medi-Cal and CalFresh", href="https://www.yolocounty.org/government/general-government-departments/health-human-services/welfare/medi-cal")
    output$insur_url <- renderUI({
      tagList("Sign up here for: ", url)
    })

    output$provider_info <- renderTable({
      provider_filtered() %>%
        arrange(Site_Name) %>%
        mutate(Address = paste0(Street_Address, " ", City, ", CA ", Zip_Code)) %>%
        select(Site_Name, Address, SITE_TELEPHONE_NUMBER, Last_Name_or_Business_Name, First_Name) %>%
        mutate(Address = str_to_title(Address),
               Address = str_replace(Address, " Ca ", " CA "),
               SITE_TELEPHONE_NUMBER = as.character(SITE_TELEPHONE_NUMBER)) %>%
        rename_with(., str_replace_all, pattern = "_", replacement = " ") %>%
        rename_with(., str_to_title)
    }, escape = F)


    ## Child Care Page
    yolo_day_cares_filtered <- eventReactive(input$search_child_care, {
      yolo_day_cares %>%
        filter(facility_type == input$child_care_type,
               facility_city == input$child_care_city)
    })

    output$child_care_info <- renderDataTable({
      yolo_day_cares_filtered() %>%
        mutate(Address = paste0(facility_address, "\n", facility_city, ", ", facility_state, " ", facility_zip)) %>%
        select(facility_name, facility_administrator, facility_telephone_number, Address) %>%
        rename_with(., str_replace, pattern = "facility", replacement = "") %>%
        rename_with(., str_replace_all, pattern = "_", replacement = " ") %>%
        rename_with(., str_to_title)
    })

    ## Food

    # vendors_filtered <- eventReactive(input$search_food, {
    #   vendors %>%
    #     filter(City == input$food_city)
    # })
    #
    output$wic_map <- renderLeaflet({
      leaflet() %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(data = yolo,
                    color = "black", # you need to use hex colors
                    fillColor = "white",
                    fillOpacity = .3,
                    weight = 3) %>%
        addMarkers(lng = vendors$Longitude, lat = vendors$Latitude, popup = htmlEscape(vendors$Vendor))
    })

    output$wic_info <- renderTable({
      vendors %>%
        arrange(Vendor) %>%
        mutate(Address = paste0(str_to_title(Address), " ", str_to_title(City), ", CA ", Zip.Code)) %>%
        select(Vendor, Address)
    })

    ## Transportation
    output$mylisttransport <- renderUI({
      tags$ul(
        tags$li(a("Yolobus", href="https://www.yolobus.com/")),
        tags$li(a("ConnectTransitCard", href="https://www.connecttransitcard.com/")),
        tags$li(a("Sacramento Regional Transit", href="http://www.sacrt.com/")),
        tags$li(a("Capitol Corridor", href="https://www.capitolcorridor.org/")),
        tags$li(a("Amtrak", href="https://visityolo.com/listing/amtrak/")),
        tags$li(a("Unitrans", href="https://unitrans.ucdavis.edu/"))
      )
    })

    output$mylistdiscounts <- renderUI({
      tags$ul(
        tags$li(a("Discounts", href="https://www.yolohealthyaging.org/transportation"))
      )
    })

    ## Community Orgs Page
    comm_orgs_filtered <- eventReactive(input$search_comm_org, {
      comm_orgs %>%
        filter(resource == input$resource,
               !is.na(value_url))
    })

    output$comm_org_info <- renderDataTable({
      comm_orgs_filtered() %>%
        mutate(comm_main_url = paste0("<a href='", comm_main_url,"'>", comm_main_url,"</a>")) %>%
        mutate(value_url = paste0("<a href='", value_url,"'>", value_url,"</a>")) %>%
        rename_with(., str_replace_all, pattern = "_", replacement = " ") %>%
        rename_with(., str_to_title) %>%
        rename("Main Url" = "Comm Main Url") %>%
        rename("Resource Url" = "Value Url")
    }, escape = F)


    ## Screening Page

    #     output$ACEs_questions <- renderText({
    #       paste("Did you feel that you didn’t have enough to eat, had to wear dirty clothes, \nor had no one to protect or take care of you?",
    #       "Did you lose a parent through divorce, abandonment, death, or other reason?",
    #       "Did you live with anyone who was depressed, mentally ill, or attempted suicide?",
    #       "Did you live with anyone who had a problem with drinking or using drugs, including\n prescription drugs?",
    #       "Did your parents or adults in your home ever hit, punch, beat, or threaten to \nharm each other?",
    #       "Did you live with anyone who went to jail or prison?",
    #       "Did a parent or adult in your home ever swear at you, insult you, or put you down?",
    #       "Did a parent or adult in your home ever hit, beat, kick, or physically hurt you \nin any way?",
    #       "Did you feel that no one in your family loved you or thought you were special?",
    #       "Did you experience unwanted sexual contact (such as fondling or oral/anal/vaginal \nintercourse/penetration)?",
    #       sep = "\n\n")
    #     })

  }
}
