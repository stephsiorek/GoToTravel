library("leaflet")
library("shinycustomloader")

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
             actionButton("update_chart", label = "Update chart", width = "100%"),
             withLoader(plotOutput("covid_plot"))
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
              # selectInput("selected_column",
              #             "Selected data:",
              #             choices = c("Total Guests" = "Guests_Total",
              #                         "Guests From the Prefecture" = "Guests_Prefecture",
              #                         "Guests From Outside of the Prefecture" = "Guests_OutsidePrefecture",
              #                         "Accommodation Type: Ryokan" = "Type_Ryokan",
              #                         "Accommodation Type: Resort Hotel" = "Type_Resort",
              #                         "Accommodation Type: Business Hotel" = "Type_Business",
              #                         "Accommodation Type: City Hotel" = "Type_City",
              #                         "Accommodation Type: Simple Lodging" = "Type_Simple",
              #                         "Accommodation Type: Accommodation for Companies and Groups" = "Type_CompaniesGroups"
              #                         
              #             ),
               style = "position:relative;z-index:10000;"
             ),
             withLoader(plotOutput("shukuhaku_plot"))
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
  
  tabPanel("COVID-19 Data",
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
                            choices = c("Total Guests" = "Guests_Total",
                                        "Guests From the Prefecture" = "Guests_Prefecture",
                                        "Guests From Outside of the Prefecture" = "Guests_OutsidePrefecture",
                                        "Accommodation Type: Ryokan" = "Type_Ryokan",
                                        "Accommodation Type: Resort Hotel" = "Type_Resort",
                                        "Accommodation Type: Business Hotel" = "Type_Business",
                                        "Accommodation Type: City Hotel" = "Type_City",
                                        "Accommodation Type: Simple Lodging" = "Type_Simple",
                                        "Accommodation Type: Accommodation for Companies and Groups" = "Type_CompaniesGroups"
                                        
                            )
                ),
               DT::DTOutput("shukuhaku_data")
             ))),
  
  collapsible = TRUE
)