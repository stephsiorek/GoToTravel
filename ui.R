library("leaflet")
library("shinycustomloader")
library("plotly")
library("shinycustomloader")

navbarPage(
  "The impact of the 'Go to Travel' subsidy program on the increase in overall disease transmission in Japan during the 2020 COVID-19 pandemic",
  
  tabPanel("Data Description",
           fluidPage(
             #titlePanel(""),
             mainPanel(
                div("Go To Travel is a Japanese government subsidy program launched in 2020 to revive the pandemic-hit tourism industry.
                    The government offered Japanese residents reimbursement of part of their accommodation and travel costs,
                    and an additional part of the total travel cost in vouchers to be used for other travel expenses. The program
                    has received strong criticism from most Japanese prefectures, mainly due to concerns about the spread of the
                    pandemic and the inconsistency in the fight against COVID-19. The aim of this paper is to analyze
                    the relationship between data on COVID-19 cases in Japan and accommodation data from 2020."),
                br(),
                strong("COVID-19 data:"),
                tags$div("Data was downloaded from the Japanese Ministry of Health, Labour and Welfare",
                       tags$a(href = "https://www.mhlw.go.jp/stf/covid-19/open-data.html", "website"),
                       "in a .csv format. After data wrangling, the dataset consists of 5 columns
                       (Date, Prefecture, NewlyConfirmedCases, NumberOfDeaths, SevereCases) and 16,027 rows of daily data
                       regarding COVID-19 on Japanese territory since January 26th 2020 until December 31st 2020."),
                br(),
                strong("Accommodation data:"),
                tags$div("Data was downloaded from the Japanese Ministry of Land, Infrastructure, Transport and Tourism",
                         tags$a(href = "https://www.mlit.go.jp/kankocho/siryou/toukei/shukuhakutoukei.html", "website"),
                         "in an .xlsx format. After data wrangling, it contains 44 columns and 564 rows of monthly accommodation
                         data since January until December 2020.")
           ))),
  
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
               selectInput("selected_column_1",
                           "Selected data:",
                           choices = c("New COVID-19 Cases" = "NewlyConfirmedCases",
                                       "Number of Deaths" = "NumberOfDeaths",
                                       "Severe Cases" = "SevereCases")),
               style = "position:relative;z-index:10000;"
             ),
             actionButton("update_chart", label = "Update chart", width = "100%"),
             withLoader(plotlyOutput("covid_plot"), type = "html", loader = "loader4")
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
               selectInput("selected_column_2",
                           "Selected data:",
                           choices = c("Total Guests" = "Guests_Total",
                                       "Guests From the Prefecture" = "Guests_Prefecture",
                                       "Guests From Outside of the Prefecture" = "Guests_OutsidePrefecture",
                                       "Accommodation Type: Ryokan" = "Type_Ryokan",
                                       "Accommodation Type: Resort Hotel" = "Type_Resort",
                                       "Accommodation Type: Business Hotel" = "Type_Business",
                                       "Accommodation Type: City Hotel" = "Type_City",
                                       "Accommodation Type: Simple Lodging" = "Type_Simple",
                                       "Accommodation Type: Accommodation for Companies and Groups" = "Type_CompaniesGroups",
                                       "Guests from the Prefecture: Ryokan" = "Pref_Ryokan",
                                       "Guests from the Prefecture: Resort Hotel" = "Pref_Resort",
                                       "Guests from the Prefecture: Business Hotel" = "Pref_Business",
                                       "Guests from the Prefecture: City Hotel" = "Pref_City",
                                       "Guests from the Prefecture: Simple Lodging" = "Pref_Simple",
                                       "Guests from the Prefecture: Accommodation for Companies and Groups" = "Pref_CompaniesGroups",
                                       "Guests from Outside of the Prefecture: Ryokan" = "Out_Ryokan",
                                       "Guests from Outside of the Prefecture: Resort Hotel" = "Out_Resort",
                                       "Guests from Outside of the Prefecture: Business Hotel" = "Out_Business",
                                       "Guests from Outside of the Prefecture: City Hotel" = "Out_City",
                                       "Guests from Outside of the Prefecture: Simple Lodging" = "Out_Simple",
                                       "Guests from Outside of the Prefecture: Accommodation for Companies and Groups" = "Out_CompaniesGroups",
                                       "Occupancy Rate" = "Occupancy_Rate",
                                       "Tourist Occupancy Rate" = "Occupancy_Tourists",
                                       "Non Tourist Occupancy Rate" = "Occupancy_NonTourists",
                                       "Occupancy Rate: Accommodation with 0-9 employees" = "Occupancy_0to9",
                                       "Tourist Occupancy Rate: Accommodation with 0-9 employees" = "Occupancy_Tourists_0to9",
                                       "Non Tourist Occupancy Rate: Accommodation with 0-9 employees" = "Occupancy_NonTourists_0to9",
                                       "Occupancy Rate: Accommodation with 10-19 employees" = "Occupancy_10to19",
                                       "Tourist Occupancy Rate: Accommodation with 10-19 employees" = "Occupancy_Tourists_10to19",
                                       "Non Tourist Occupancy Rate: Accommodation with 10-19 employees" = "Occupancy_NonTourists_10to19",
                                       "Occupancy Rate: Accommodation with 30-99 employees" = "Occupancy_30to99",
                                       "Tourist Occupancy Rate: Accommodation with 30-99 employees" = "Occupancy_Tourists_30to99",
                                       "Non Tourist Occupancy Rate: Accommodation with 30-99 employees" = "Occupancy_NonTourists_30to99",
                                       "Occupancy Rate: Accommodation with over 100 employees" = "Occupancy_over100",
                                       "Tourist Occupancy Rate: Accommodation with over 100 employees" = "Occupancy_Tourists_over100",
                                       "Non Tourist Occupancy Rate: Accommodation with over 100 employees" = "Occupancy_NonTourists_oevr100",
                                       "Occupancy Rate: Ryokan" = "Occupancy_Ryokan",
                                       "Occupancy Rate: Resort Hotel" = "Occupancy_Resort",
                                       "Occupancy Rate: Business Hotel" = "Occupancy_Business",
                                       "Occupancy Rate: City Hotel" = "Occupancy_City",
                                       "Occupancy Rate: Simple Lodging" = "Occupancy_Simple",
                                       "Occupancy Rate: Accommodation for Companies and Groups" = "Occupancy_CompaniesGroups"
                           )),
               style = "position:relative;z-index:10000;"
             ),
             actionButton("update_chart_2", label = "Update chart", width = "100%"),
             withLoader(plotlyOutput("shukuhaku_plot"), type = "html", loader = "loader4")
           )),
  
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
                            choices = c("Total Guests",
                                        "Guests From the Prefecture",
                                        "Guests From Outside of the Prefecture",
                                        "Accommodation Type: Ryokan",
                                        "Accommodation Type: Resort Hotel",
                                        "Accommodation Type: Business Hotel",
                                        "Accommodation Type: City Hotel",
                                        "Accommodation Type: Simple Lodging",
                                        "Accommodation Type: Accommodation for Companies and Groups",
                                        "Guests from the Prefecture: Ryokan",
                                        "Guests from the Prefecture: Resort Hotel",
                                        "Guests from the Prefecture: Business Hotel",
                                        "Guests from the Prefecture: City Hotel",
                                        "Guests from the Prefecture: Simple Lodging",
                                        "Guests from the Prefecture: Accommodation for Companies and Groups",
                                        "Guests from Outside of the Prefecture: Ryokan",
                                        "Guests from Outside of the Prefecture: Resort Hotel",
                                        "Guests from Outside of the Prefecture: Business Hotel",
                                        "Guests from Outside of the Prefecture: City Hotel",
                                        "Guests from Outside of the Prefecture: Simple Lodging",
                                        "Guests from Outside of the Prefecture: Accommodation for Companies and Groups",
                                        "Occupancy Rate",
                                        "Tourist Occupancy Rate",
                                        "Non Tourist Occupancy Rate",
                                        "Occupancy Rate: Accommodation with 0-9 employees",
                                        "Tourist Occupancy Rate: Accommodation with 0-9 employees",
                                        "Non Tourist Occupancy Rate: Accommodation with 0-9 employees",
                                        "Occupancy Rate: Accommodation with 10-19 employees",
                                        "Tourist Occupancy Rate: Accommodation with 10-19 employees",
                                        "Non Tourist Occupancy Rate: Accommodation with 10-19 employees",
                                        "Occupancy Rate: Accommodation with 30-99 employees",
                                        "Tourist Occupancy Rate: Accommodation with 30-99 employees",
                                        "Non Tourist Occupancy Rate: Accommodation with 30-99 employees",
                                        "Occupancy Rate: Accommodation with over 100 employees",
                                        "Tourist Occupancy Rate: Accommodation with over 100 employees",
                                        "Non Tourist Occupancy Rate: Accommodation with over 100 employees",
                                        "Occupancy Rate: Ryokan",
                                        "Occupancy Rate: Resort Hotel",
                                        "Occupancy Rate: Business Hotel",
                                        "Occupancy Rate: City Hotel",
                                        "Occupancy Rate: Simple Lodging",
                                        "Occupancy Rate: Accommodation for Companies and Groups"
                            )
                ),
               DT::DTOutput("shukuhaku_data")
             ))),
  
  collapsible = TRUE
)