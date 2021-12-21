# navbarPage(
#   "My first app",
#   tabPanel("About"),
#   tabPanel("Contact")
# )

# fluidPage(
#   sliderInput("exponent",
#               label = "Choose an exponent",
#               min = 1,
#               max = 5,
#               value = 2),
#   plotOutput("curve_plot")
# )

library("leaflet")

navbarPage(
  "The impact of the 'Go to Travel' subsidy program on the increase in overall disease transmission in Japan during the 2020 COVID-19 pandemic",
  tabPanel("COVID-19 Infections",
           fluidPage(
             div(
               selectInput("selected_prefecture",
                           "Selected prefecture:",
                           choices = c("Aichi", "Akita", "Aomori", "Chiba",
                                       "Ehime", "Fukui", "Fukuoka", "Fukushima",
                                       "Gifu", "Gunma", "Hiroshima", "Hokkaido",
                                       "Hyogo", "Ibaraki", "Ishikawa", "Iwate",
                                       "Kagawa", "Kagoshima", "Kanagawa", "Kochi",
                                       "Kumamoto", "Kyoto", "Mie", "Miyagi",
                                       "Miyazaki", "Nagano", "Nagasaki", "Nara",
                                       "Niigata", "Oita", "Okayama", "Okinawa",
                                       "Osaka", "Saga", "Saitama", "Shiga",
                                       "Shimane", "Shizuoka", "Tochigi", "Tokushima",
                                       "Tokyo", "Tottori", "Toyama", "Wakayama",
                                       "Yamagata", "Yamaguchi", "Yamanashi"
                           )),
               style = "position:relative;z-index:10000;"
             ),
             plotOutput("covid_plot")
           )),
  
  tabPanel("Accommodation",
           fluidPage(
             div(
               selectInput("selected_prefecture_2",
                           "Selected prefecture:",
                           choices = c("Aichi", "Akita", "Aomori", "Chiba",
                                       "Ehime", "Fukui", "Fukuoka", "Fukushima",
                                       "Gifu", "Gunma", "Hiroshima", "Hokkaido",
                                       "Hyogo", "Ibaraki", "Ishikawa", "Iwate",
                                       "Kagawa", "Kagoshima", "Kanagawa", "Kochi",
                                       "Kumamoto", "Kyoto", "Mie", "Miyagi",
                                       "Miyazaki", "Nagano", "Nagasaki", "Nara",
                                       "Niigata", "Oita", "Okayama", "Okinawa",
                                       "Osaka", "Saga", "Saitama", "Shiga",
                                       "Shimane", "Shizuoka", "Tochigi", "Tokushima",
                                       "Tokyo", "Tottori", "Toyama", "Wakayama",
                                       "Yamagata", "Yamaguchi", "Yamanashi"
                           )),
              # selectInput("selected_column",
              #             "Selected column:",
              #             choices = c("Guests_Total", "Guests_Prefecture",
              #                         "Guests_OutsidePrefecture")
              # ),
               style = "position:relative;z-index:10000;"
             ),
             plotOutput("shukuhaku_plot")
           )),
  
  # tabPanel("Covid Data",
  #          fluidPage(
  #            div(
  #              selectInput("selected_prefecture_3",
  #                          "Selected prefecture:",
  #                          choices = c("Aichi", "Akita", "Aomori", "Chiba",
  #                                      "Ehime", "Fukui", "Fukuoka", "Fukushima",
  #                                      "Gifu", "Gunma", "Hiroshima", "Hokkaido",
  #                                      "Hyogo", "Ibaraki", "Ishikawa", "Iwate",
  #                                      "Kagawa", "Kagoshima", "Kanagawa", "Kochi",
  #                                      "Kumamoto", "Kyoto", "Mie", "Miyagi",
  #                                      "Miyazaki", "Nagano", "Nagasaki", "Nara",
  #                                      "Niigata", "Oita", "Okayama", "Okinawa",
  #                                      "Osaka", "Saga", "Saitama", "Shiga",
  #                                      "Shimane", "Shizuoka", "Tochigi", "Tokushima",
  #                                      "Tokyo", "Tottori", "Toyama", "Wakayama",
  #                                      "Yamagata", "Yamaguchi", "Yamanashi"
  #                          )),
  #            tableOutput("covid_data")
  #            ))),
  
  tabPanel("Covid Data",
           fluidPage(
             div(
               selectInput("selected_prefecture_3",
                           "Selected prefecture:",
                           choices = c("Aichi", "Akita", "Aomori", "Chiba",
                                       "Ehime", "Fukui", "Fukuoka", "Fukushima",
                                       "Gifu", "Gunma", "Hiroshima", "Hokkaido",
                                       "Hyogo", "Ibaraki", "Ishikawa", "Iwate",
                                       "Kagawa", "Kagoshima", "Kanagawa", "Kochi",
                                       "Kumamoto", "Kyoto", "Mie", "Miyagi",
                                       "Miyazaki", "Nagano", "Nagasaki", "Nara",
                                       "Niigata", "Oita", "Okayama", "Okinawa",
                                       "Osaka", "Saga", "Saitama", "Shiga",
                                       "Shimane", "Shizuoka", "Tochigi", "Tokushima",
                                       "Tokyo", "Tottori", "Toyama", "Wakayama",
                                       "Yamagata", "Yamaguchi", "Yamanashi"
                           )),
               DT::DTOutput("covid_data")
             ))),
  
  tabPanel("Accommodation Data",
           fluidPage(
             div(
               selectInput("selected_prefecture_4",
                           "Selected prefecture:",
                           choices = c("Aichi", "Akita", "Aomori", "Chiba",
                                       "Ehime", "Fukui", "Fukuoka", "Fukushima",
                                       "Gifu", "Gunma", "Hiroshima", "Hokkaido",
                                       "Hyogo", "Ibaraki", "Ishikawa", "Iwate",
                                       "Kagawa", "Kagoshima", "Kanagawa", "Kochi",
                                       "Kumamoto", "Kyoto", "Mie", "Miyagi",
                                       "Miyazaki", "Nagano", "Nagasaki", "Nara",
                                       "Niigata", "Oita", "Okayama", "Okinawa",
                                       "Osaka", "Saga", "Saitama", "Shiga",
                                       "Shimane", "Shizuoka", "Tochigi", "Tokushima",
                                       "Tokyo", "Tottori", "Toyama", "Wakayama",
                                       "Yamagata", "Yamaguchi", "Yamanashi"
                           )),
                selectInput("selected_column2",
                            "Selected data:",
                            choices = c("Total Guests",
                                        "Guests From the Prefecture",
                                        "Guests From Outside of the Prefecture")
                ),
               DT::DTOutput("shukuhaku_data")
             ))),
  
  collapsible = TRUE
)