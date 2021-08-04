# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


library(shiny)
#library(shi18ny)
## devtools::install_github("datasketch/shi18ny")
library(shinydashboard)
library(htmltools)
library(shinybusy)
library(shiny.i18n)
library(leaflet)
library(tidyverse)

i18n <- Translator$new(translation_json_path=paste0(system.file("/Data/translate.js", package="YoloHealthApp")))
i18n$set_translation_language('English')

source("providers.R")
print("hi")
# Define UI for application that draws a histogram
ui <- fluidPage(

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
                                     tags$iframe(src="care_provider_pop_ca.html")
                              )
                            ),

                            fluidRow(

                              column(6,
                                     leafletOutput(outputId = "below_poverty")),

                              column(6,
                                     leafletOutput(outputId = "above_200k")),

                            ),

                            br(),
                            br(),

                            fluidRow(

                              column(6,
                                     leafletOutput(outputId = "gini_index")),

                              column(6,
                                     leafletOutput(outputId = "health_insur_yolo")),

                            ),

                            br(),
                            br(),

                            fluidRow(
                              column(6,
                                HTML(paste0("<iframe src='care_provider_pop_yolo.html'> </iframe>"))
                              ),
                              column(6,
                                     HTML(paste0("<iframe src='care_provider_yolo.html'> </iframe>"))
                              )
                            ),

                            br(),
                            br(),

                            fluidRow(
                              column(6,
                                     HTML(paste0("<iframe src='hospital_pop_yolo.html'> </iframe>"))
                              ),
                              column(6,
                                     HTML(paste0("<iframe src='hospital_yolo.html'> </iframe>"))
                              )
                            )

                    ),
                    tabItem(tabName = "providers",

                            titlePanel(p(style="text-align: center;",i18n$t("Find a Physician Near You!"))),

                            hr(),

                            h4(p(style="text-align: center;",i18n$t("This tab helps you find a physician near you. Start by choosing by your insurance provider and what kind of healthcare you are looking for"))),

                            br(),

                            box(title = strong(i18n$t("Search by Insurance and Type")), status = "success", width = 12,


                                fluidRow(

                                  column(4,
                                         selectInput(
                                           inputId = "insur",
                                           label = i18n$t("Choose your Insurance Provider"),
                                           choices = providers %>%
                                             count(Managed_Care_Plan) %>%
                                             pull(1),
                                           selected = "No Insurance"
                                         ),

                                         uiOutput(
                                           outputId = "insur_url"
                                         )),

                                  column(4,
                                         selectInput(
                                           inputId = "healthcare_type",
                                           label = i18n$t("Choose HealthCare Type"),
                                           choices = providers %>%
                                             count(Managed_Care_Classification) %>%
                                             pull(1),
                                           selected = "Primary Care"
                                         )),

                                  column(2,
                                         br(),
                                         actionButton(inputId = "search_providers",
                                                      label = strong(i18n$t("Search")))
                                  ),

                                  column(2,
                                         add_busy_spinner(spin = "fading-circle")
                                  )
                                )

                            ),

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

                            box(title = strong(i18n$t("Search by Child Care Type and Location")), status = "success", width = 12,


                                fluidRow(

                                  column(4,
                                         selectInput(
                                           inputId = "child_care_type",
                                           label = i18n$t("Choose a Type of Care"),
                                           choices = yolo_day_cares %>%
                                             count(facility_type) %>%
                                             pull(1)
                                         )),

                                  column(4,
                                         selectInput(
                                           inputId = "child_care_city",
                                           label = i18n$t("Choose your City"),
                                           choices = yolo_day_cares %>%
                                             count(facility_city) %>%
                                             pull(1)
                                         )),

                                  column(2,
                                         br(),
                                         actionButton(inputId = "search_child_care",
                                                      label = strong(i18n$t("Search")))
                                  ),

                                  column(2,
                                         add_busy_spinner(spin = "fading-circle")
                                  )
                                )

                            ),

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
                                     HTML(paste0("<iframe src='vendor_pop_yolo.html'> </iframe>"))
                              ),
                              column(6,
                                     HTML(paste0("<iframe src='vendor_yolo.html'> </iframe>"))
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

                            box(title = strong(i18n$t("Search by Resource")), status = "success", width = 12,


                                fluidRow(

                                  column(4,
                                         selectInput(
                                           inputId = "resource",
                                           label = i18n$t("Choose a Resource"),
                                           choices = comm_orgs %>%
                                             count(resource) %>%
                                             pull(1)
                                         )),

                                  column(2,
                                         br(),
                                         actionButton(inputId = "search_comm_org",
                                                      label = strong(i18n$t("Search")))
                                  ),

                                  column(2,
                                         add_busy_spinner(spin = "fading-circle")
                                  )
                                )

                            ),

                            fluidRow(
                              column(8,
                                     dataTableOutput(outputId = "comm_org_info")))

                    ),

                    tabItem(tabName = "other_resources")

                    # tabItem(tabName = "screening",
                    #
                    #         titlePanel(p(style="text-align: center;","Screening Questions")),
                    #
                    #         hr(),
                    #
                    #         h4(p(style="text-align: center;","This tab helps you answer questions on a variety of screenings. Start by answering the questions below.")),
                    #
                    #         br(),
                    #
                    #         fluidRow(
                    #           column(12,
                    #
                    #                  h1("1. Food Insecurity"),
                    #
                    #                  radioButtons(
                    #                    inputId = "food_insecurity",
                    #                    label = "Which of these statements best describes the food eaten in your household in the last 12 months?",
                    #                    choices = c("Enough of the kinds of food we want to eat", "Enough but not always the kinds of food we want", "Sometimes not enough to eat", "Often not enough to eat")
                    #                  ),
                    #
                    #                  br(),
                    #                  actionButton(inputId = "search_food_insecurity",
                    #                               label = strong("Submit")),
                    #
                    #                  h1("2. Depression"),
                    #
                    #                  h2("How often have you been bothered by the following over the past 2 weeks?"),
                    #
                    #                  radioButtons(
                    #                    inputId = "depress1",
                    #                    label = "Little interest or pleasure in doing things?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "depress2",
                    #                    label = "Feeling down, depressed, or hopeless?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "depress3",
                    #                    label = "Trouble falling or staying asleep, or sleeping too much?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "depress4",
                    #                    label = "Feeling tired or having little energy?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "depress5",
                    #                    label = "Poor appetite or overeating?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "depress6",
                    #                    label = "Feeling bad about yourself — or that you are a failure or have let yourself or your family down?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "depress7",
                    #                    label = "Trouble concentrating on things, such as reading the newspaper or watching television?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "depress8",
                    #                    label = "Moving or speaking so slowly that other people could have noticed? Or so fidgety or restless that you have been moving a lot more than usual?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "depress9",
                    #                    label = "Thoughts that you would be better off dead, or thoughts of hurting yourself in some way?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  br(),
                    #                  actionButton(inputId = "search_depress",
                    #                               label = strong("Submit")),
                    #
                    #                  h1("3. Anxiety"),
                    #
                    #                  h2("Over the last 2 weeks, how often have you been bothered by the following problems?"),
                    #
                    #                  radioButtons(
                    #                    inputId = "anxiety1",
                    #                    label = "Feeling nervous, anxious or on edge?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "anxiety2",
                    #                    label = "Not being able to stop or control worrying?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "anxiety3",
                    #                    label = "Worrying too much about different things?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "anxiety4",
                    #                    label = "Trouble relaxing?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "anxiety5",
                    #                    label = "Being so restless that it is hard to sit still?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "anxiety6",
                    #                    label = "Becoming easily annoyed or irritable?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  radioButtons(
                    #                    inputId = "anxiety7",
                    #                    label = "Feeling afraid as if something awful might happen?",
                    #                    choices = c("Not at all", "Several Days", "More than half the days", "Nearly every day")
                    #                  ),
                    #
                    #                  br(),
                    #                  actionButton(inputId = "search_anxiety",
                    #                               label = strong("Submit")),
                    #
                    #                  h1("4. Adverse Childhood Effects Survey (ACEs)"),
                    #
                    #                  h2("Please add up the number of the following statements that you experienced prior to being 18 years old. Please put the total at the bottom"),
                    #
                    #                  verbatimTextOutput("ACEs_questions"),
                    #
                    #                  numericInput(
                    #                    inputId = "ACEs_results",
                    #                    label = "Your ACE score is the total number of yes responses",
                    #                    value = 0,
                    #                    min = 0,
                    #                    max = 10
                    #                  ),
                    #
                    #                  br(),
                    #                  actionButton(inputId = "search_ACEs",
                    #                               label = strong("Submit")),
                    #
                    #                  )
                    #         )
                    #
                    #         )
                  )
                )
  )
)



# Define server logic required to draw a histogram
server <- function(input, output, session) {
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
    map_poverty_sex_age
  })

  output$gini_index <- renderLeaflet({
    map_gini
  })

  output$above_200k <- renderLeaflet({
    map_over_200_2015_2019
  })

  output$health_insur_yolo <- renderLeaflet({
    map_health_insurance
  })

  output$health_insur_durham <- renderLeaflet({
    map_health_insurance_durham
  })


  ## Provider Page
  # output$provider_map <- renderLeaflet({
  #   leaflet() %>%
  #     addProviderTiles("CartoDB.Positron") %>%
  #     addPolygons(data = yolo,
  #                 color = "black", # you need to use hex colors
  #                 fillColor = "white",
  #                 fillOpacity = .3,
  #                 weight = 3) %>%
  #     addMarkers(lng = providers$Longitude, lat = providers$Latitude, popup = htmlEscape(providers$Site_Name))
  # })

  provider_filtered <- eventReactive(input$search_providers, ignoreNULL=FALSE, {
    providers %>%
      filter(Managed_Care_Plan == input$insur) %>%
      # if(str_detect(input$healthcare_type, "[:alnum:]")) {
        filter(Managed_Care_Classification == input$healthcare_type)
      # }
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

# Run the application
shinyApp(ui = ui, server = server)
