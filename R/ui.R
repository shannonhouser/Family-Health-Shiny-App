#' @import shiny shinydashboard htmltools shinybusy leaflet dplyr shiny.i18n
ui <- function(i18n) {
  shiny::addResourcePath("www", system.file("www", package="YoloHealthApp"))

  fluidPage(

    shiny.i18n::usei18n(i18n),
    # tags$div(
    #   style='.rightAlign{float:right;}',
    #   selectInput(
    #     inputId='selected_language',
    #     label=i18n$t('Change language'),
    #     choices = i18n$get_languages(),
    #     selected = i18n$get_key_translation()
    #   )
    # ),
    #
    radioButtons(inputId='selected_language',
                 label='Language/Idioma/Язык',
                 choices = i18n$get_languages(),
                 selected = i18n$get_key_translation()),

    # tags$a(href = "https://heallab.ucdavis.edu/people/jennifer-phipps", target = "_parent", "Contact us"),

    dashboardPage(skin = "blue",

                  dashboardHeader(title = i18n$t("Yolo County Resources")),

                  dashboardSidebar(
                    sidebarMenu(
                      HTML(paste0(
                        "<br>",
                        "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='https://drupal8-prod.visitcalifornia.com/sites/drupal8-prod.visitcalifornia.com/files/styles/fluid_1200/public/2021-02/VC-Yolo-County-UC-Davis-Arboretum-gty-1152725021-RF-1280x640.jpg?itok=IjeUJh0i' width = '186'></a>",
                        "<br>",
                        "<p style = 'text-align: center;'><small>Welcome to Yolo County, California!</small></p>",
                        "<p style = 'text-align: center;'><small>¡Bienvenido al condado de Yolo, California!</small></p>",
                        "<p style = 'text-align: center;'><small>Добро пожаловать в округ Йоло!</small></p>",
                        "<br>"
                      )),

                      menuItem(i18n$t("Home"), tabName = "home", icon = icon("home")),
                      menuItem(i18n$t("Map Visualizations"), tabName = "map_vis", icon = icon("globe-americas")),
                      menuItem(i18n$t("Find Providers"), tabName = "providers", icon = icon("user-md")),
                      menuItem(i18n$t("Find Child Care"), tabName = "child_care", icon = icon("baby")),
                      menuItem(i18n$t("Food Resources"), tabName = "food", icon = icon("utensils")),
                      menuItem(i18n$t("Transportation"), tabName = "transportation", icon = icon("bus")),
                      menuItem(i18n$t("Find Community Organizations"), tabName = "comm_orgs", icon = icon("users")),
                      menuItem(i18n$t("Other Resources"), tabName = "other_resources", icon = icon("question")),
                      menuItem(i18n$t("Contact Us"), icon = icon("send",lib='glyphicon'),
                               href = "https://heallab.ucdavis.edu/people/jennifer-phipps"),
                      menuItem(i18n$t("Emergency"), icon = icon('user-injured'),
                               href = "https://www.yolocounty.org/government/general-government-departments/office-of-emergency-services")
                      # menuItem("Screening Questions", tabName = "screening", icon = icon("clipboard-list"))

                    )
                  ),

                  dashboardBody(
                    tabItems(
                      tabItem(tabName = "home",

                              titlePanel(p(style="text-align: center;",i18n$t("Welcome to Yolo County Health Resource Center!"))),

                              hr(),

                              h4(p(style="text-align: center;",i18n$t("This shiny app is designed for you to easily access information on Health Resources Provided in Yolo County."))),

                              br(),

                              fluidRow(
                                valueBoxOutput("home1",width=4)
                                ,valueBoxOutput("home2",width=4)
                                ,valueBoxOutput("home3",width=4)
                              ),
                              br(),
                              br(),
                              fluidRow(
                                valueBoxOutput("home4",width=4)
                                ,valueBoxOutput("home5",width=4)
                                ,valueBoxOutput("home6",width=4)
                              ),
                              br(),
                              br(),
                              fluidRow(
                                valueBoxOutput("home7",width=4)
                                ,valueBoxOutput("home8",width=4)
                                ,valueBoxOutput("home9",width=4)
                              ),
                              br(),
                              br(),
                              fluidRow(
                                valueBoxOutput("home10",width=6)
                                ,valueBoxOutput("home11",width=6)
                              )



                      ),
                      # tabItem(tabName = "home",
                      #
                      #         titlePanel(p(style="text-align: center;",i18n$t("Welcome to Yolo County Health Resource Center!"))),
                      #
                      #         hr(),
                      #
                      #         h4(p(style="text-align: center;",i18n$t("This shiny app is designed for you to easily access information on Health Resources Provided in Yolo County."))),
                      #
                      #         br(),
                      #
                      #         box(title = strong(i18n$t("Search for help!")), status = "success", width = 12,
                      #
                      #
                      #           fluidRow(
                      #
                      #             column(4,
                      #                    selectInput(
                      #                      inputId = "insur",
                      #                      label = i18n$t("Choose your Insurance Provider"),
                      #                      choices = providers %>%
                      #                        count(Managed_Care_Plan) %>%
                      #                        pull(1)
                      #                    ),
                      #
                      #                    uiOutput(
                      #                      outputId = "insur_url"
                      #                    )),
                      #
                      #
                      #
                      #             column(2,
                      #                    br(),
                      #                    actionButton(inputId = "search_providers",
                      #                                 label = strong(i18n$t("Search")))
                      #             ),
                      #
                      #             column(2,
                      #                    add_busy_spinner(spin = "fading-circle")
                      #             )
                      #           )
                      #
                      #       ),
                      #
                      #       fluidRow(
                      #         column(12,
                      #                leafletOutput(outputId = "provider_map"))),
                      #       fluidRow(
                      #         column(12,
                      #                tableOutput(outputId = "provider_info")))
                      #
                      # ),

                      tabItem(tabName = "map_vis",

                              titlePanel(p(style="text-align: center;",i18n$t("Map Visualizations of Yolo County"))),

                              hr(),

                              h4(p(style="text-align: center;",i18n$t("This page contains visualizations of Gini index and health insurance of Yolo County."))),

                              br(),

                              # box(title = strong("Choose a Map"), status = "success", width = 12,
                              #
                              # fluidRow(
                              #   selectInput(
                              #     inputId = "map_type",
                              #     label = "Choose what you would like to see mapped",
                              #     choices = c("Poverty", "$200K+", "Inequality", "Health Insurance")
                              #   ),
                              #
                              #   column(2,
                              #          br(),
                              #          actionButton(inputId = "search_map",
                              #                       label = strong("Search"))
                              #   ),
                              #
                              #   column(2,
                              #          add_busy_spinner(spin = "fading-circle")
                              #   )
                              # )
                              # ),
                              #
                              # fluidRow(
                              #   leafletOutput(outputId = "overview_maps")
                              # ),

                              fluidRow(
                                column(4,
                                       tags$iframe(src="www/care_provider_pop_ca.html")
                                )
                              ),

                              fluidRow(

                                column(4,
                                       leafletOutput(outputId = "below_poverty")),

                                column(4,
                                       leafletOutput(outputId = "gini_index")),

                                column(4,
                                       leafletOutput(outputId = "above_200k")),

                              ),

                              br(),
                              br(),

                              fluidRow(

                                column(6,
                                       leafletOutput(outputId = "health_insur_yolo")),

                                column(6,
                                       leafletOutput(outputId = "health_insur_durham")),

                              ),

                              br(),
                              br(),

                              fluidRow(
                                column(6,
                                       HTML(paste0("<iframe src='www/care_provider_pop_yolo.html'> </iframe>"))
                                ),
                                column(6,
                                       HTML(paste0("<iframe src='www/care_provider_yolo.html'> </iframe>"))
                                )
                              ),

                              br(),
                              br(),

                              fluidRow(
                                column(6,
                                       HTML(paste0("<iframe src='www/hospital_pop_yolo.html'> </iframe>"))
                                ),
                                column(6,
                                       HTML(paste0("<iframe src='www/hospital_yolo.html'> </iframe>"))
                                )
                              )

                      ),
                      tabItem(tabName = "providers",

                              titlePanel(p(style="text-align: center;",i18n$t("Find a Physician Near You!"))),

                              hr(),

                              h4(p(style="text-align: center;",i18n$t("This tab helps you find a physician near you. Start by choosing by your insurance provider and what kind of healthcare you are looking for"))),

                              br(),

                              fluidRow(
                                column(12,
                                       leafletOutput(outputId = "provider_map"))),
                              fluidRow(
                                column(12,
                                       tableOutput(outputId = "provider_info")))

                      ),

                      tabItem(tabName = "child_care",

                              titlePanel(p(style="text-align: center;",i18n$t("Find Child Care!"))),

                              hr(),

                              h4(p(style="text-align: center;",i18n$t("This tab helps you find Child Care centers near you. Start by choosing what kind of care you are looking for."))),

                              br(),


                              fluidRow(
                                column(12,
                                       dataTableOutput(outputId = "child_care_info")))

                      ),

                      tabItem(tabName = "food",

                              titlePanel(p(style="text-align: center;",i18n$t("Find Food Resources Here!"))),

                              hr(),

                              h4(p(style="text-align: center;",i18n$t("This tab helps you find information about food."))),

                              br(),

                              box(title = strong(i18n$t("Women, Infants, and Children (WIC) Authorized Vendors")), status = "success", width = 12,

                                  i18n$t("The Women, Infants and Children (WIC) Program is a federally-funded health and nutrition program that provides assistance to pregnant women, new mothers, infants and children under age five. WIC helps California families by providing food instruments and vouchers that can be used to purchase healthy supplemental foods from over 4000 WIC-authorized vendor stores throughout the State. WIC also provides nutritional education, breastfeeding support and help finding healthcare and other community services. Participants must meet income guidelines and other criteria. Currently, 84 WIC agencies provide services monthly to over 1.45 million participants at over 650 sites in local communities throughout the State."),

                                  # fluidRow(
                                  #
                                  #   column(4,
                                  #          selectInput(
                                  #            inputId = "food_city",
                                  #            label = "Choose a City",
                                  #            choices = vendors %>%
                                  #              count(City) %>%
                                  #              pull(1)
                                  #          )),
                                  #
                                  #   column(2,
                                  #          br(),
                                  #          actionButton(inputId = "search_food",
                                  #                       label = strong("Search"))
                                  #   ),
                                  #
                                  #   column(2,
                                  #          add_busy_spinner(spin = "fading-circle")
                                  #   )
                                  # )

                              ),



                              br(),
                              br(),

                              fluidRow(
                                column(6,
                                       HTML(paste0("<iframe src='www/vendor_pop_yolo.html'> </iframe>"))
                                ),
                                column(6,
                                       HTML(paste0("<iframe src='www/vendor_yolo.html'> </iframe>"))
                                )
                              ),
                              #
                              # fluidRow(
                              #     HTML(paste0("<iframe src='vendor_pop_yolo.html'> </iframe>"),width=6),
                              #   column(6,
                              #          HTML(paste0("<iframe src='vendor_yolo.html'> </iframe>"))
                              #   )
                              # ),


                              fluidRow(
                                column(12,
                                       leafletOutput(outputId = "wic_map"))),

                              fluidRow(
                                column(12,
                                       tableOutput(outputId = "wic_info")))

                      ),

                      tabItem(tabName = "transportation",

                              titlePanel(p(style="text-align: center;",i18n$t("Find Transportation Services!"))),

                              hr(),

                              h4(p(style="text-align: center;",i18n$t("This tab helps you find modes of transportation near you and possible discounts."))),

                              br(),

                              h4("Transportation Resources"),

                              uiOutput("mylisttransport"),

                              h4("Discounts"),
                              "Discounts exist for seniors, children, veterans, and many who seek medical attention in the Yolo County area.",

                              uiOutput("mylistdiscounts")

                      ),

                      tabItem(tabName = "comm_orgs",

                              titlePanel(p(style="text-align: center;",i18n$t("Find a Community Organization!"))),

                              hr(),

                              h4(p(style="text-align: center;",i18n$t("This tab helps you find community organizations near you. Start by choosing which resources you are looking for."))),

                              br(),


                              fluidRow(
                                column(8,
                                       dataTableOutput(outputId = "comm_org_info")))

                      ),

                      tabItem(tabName = "other_resources")

                    )
                  )
    )
  )
}
