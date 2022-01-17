# function(input, output, session){
#   
#   output$curve_plot <- renderPlot({
#     curve(x ^ input$exponent, from = -5, to = 5)
#   })
#   
# }


library("tidyverse")
library("leaflet")
library("leaflet.extras")
library("rnaturalearthdata")
library("sf")
library("kableExtra")
library("DT")
library("plotly")
library("dplyr")
library("ggplot2")

setwd("/Users/steph/Downloads/MGR")
load("./Clean Data/KouseiCovid2020.RData")
load("./Clean Data/Shukuhaku2020.RData")

function(input, output, session) {
  
  observeEvent(input$selected_prefecture,
               {
                 updateSelectInput(session,
                                   "selected_prefecture",
                                   selected = input$selected_prefecture)
               })
  
  observeEvent(input$selected_prefecture_2,
               {
                 updateSelectInput(session,
                                   "selected_prefecture_2",
                                   selected = input$selected_prefecture_2)
               })
  
  observeEvent(input$selected_prefecture_3,
               {
                 updateSelectInput(session,
                                   "selected_prefecture_3",
                                   selected = input$selected_prefecture_3)
               })
  
  observeEvent(input$selected_prefecture_4,
               {
                 updateSelectInput(session,
                                   "selected_prefecture_4",
                                   selected = input$selected_prefecture_4)
               })
  
  observeEvent(input$selected_column1,
               {
                 updateSelectInput(session,
                                   "selected_column1",
                                   selected = input$selected_column1)
               })
  
  observeEvent(input$selected_column2,
               {
                 updateSelectInput(session,
                                   "selected_column2",
                                   selected = input$selected_column2)
               })
  
  output$covid_plot <- renderPlotly({
    
    print(input$update_chart)
    
    if(input$update_chart == 0){
      return()
    }
    
    KouseiCovid2020 %>%
      filter(Prefecture == isolate(input$selected_prefecture)) %>% 
      mutate(Date = as.POSIXct(Date)) %>% 
      ggplot(., aes(x = Date, y = NewlyConfirmedCases, group = 1)) +
      geom_line() +
      scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
      scale_y_continuous(labels = scales::comma) +
      labs(x = "Date", y = "Newly Confirmed Cases",
           title = paste("Total New COVID-19 Infections in", isolate(input$selected_prefecture))) +
      stat_smooth(color = "#FC4E07", fill = "#FC4E07",
                  method = "gam", se = F) +
      theme_linedraw()
  })
  
  # output$shukuhaku_plot <- renderPlotly({
  #   Shukuhaku2020 %>%
  #     filter(Prefecture == input$selected_prefecture_2) %>%
  #     mutate(Date = as.POSIXct(Date)) %>%
  #     ggplot(., aes(x = Date, y = Guests_Total, group = 1)) +
  #     geom_line() +
  #     scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
  #     scale_y_continuous(labels = scales::comma) +
  #     labs(x = "Date", y = "Total Guests",
  #          title = paste("Total Number of Guests in", input$selected_prefecture_2)) +
  #     #, title = paste(input$selected_column,
  #                                                      #  "in",
  #                                                       # input$selected_prefecture_2)) +
  #     theme_linedraw()
  # })
  
  output$shukuhaku_plot <- renderPlotly({
    Shukuhaku2020 %>%
      filter(Prefecture == input$selected_prefecture_2) %>%
      mutate(Date = as.POSIXct(Date)) %>%
      ggplot(data = ., aes_string(x = "Date", y = "Guests_Total", group = 1)) +
      geom_line() +
      scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
      scale_y_continuous(labels = scales::comma) +
      labs(x = "Date", y = "",
           title = paste("Total Number of Guests in", input$selected_prefecture_2)) +
      theme_linedraw()
  })
  
  # Shukuhaku2020 %>%
  #   reactive(filter(., Prefecture == input$selected_prefecture_2)) %>%
  #   mutate(Date = as.POSIXct(Date)) %>% 
  #   mutate(Column = input$selected_column1) -> Shukuhaku2020_1
  # output$shukuhaku_plot <- renderPlotly({
  #   Shukuhaku2020_1 %>%
  #     ggplot(data = ., aes_string(x = "Date", y = "Column", group = 1)) +
  #     geom_line() +
  #     scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
  #     scale_y_continuous(labels = scales::comma) +
  #     labs(x = "Date", y = input$selected_column1,
  #          title = paste("... in", input$selected_prefecture_2)) +
  #     theme_linedraw()
  # })
  
  # output$shukuhaku_plot <- renderPlot({
  #   Shukuhaku2020 %>% 
  #     filter(Prefecture == input$selected_prefecture_2) %>% 
  #     mutate(Date = as.POSIXct(Date)) %>% 
  #     ggplot(., aes(x = Date, y = input$selected_column, group = 1)) +
  #     geom_line() +
  #     scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
  #     scale_y_continuous(labels = scales::comma) +
  #     labs(x = "Date", y = "input$selected_column",
  #          title = paste(input$selected_column, "in", input$selected_prefecture_2)) +
  #     theme_linedraw()
  # })
  
  # output$covid_data <- function(){
  #   KouseiCovid2020 %>% 
  #     filter(Prefecture == input$selected_prefecture_3) %>% 
  #     kable() %>% 
  #     kable_styling(bootstrap_options = c("striped", "hover")) %>% 
  #     htmltools::HTML()
  # }
  
  output$covid_data <- DT::renderDT({
    KouseiCovid2020 %>% 
      filter(Prefecture == input$selected_prefecture_3) %>%
      rename(., "New Cases" = NewlyConfirmedCases, Deaths = NumberOfDeaths,
             "Severe Cases" = SevereCases)
  },
  rownames = F,
  extensions = c('Responsive', 'Buttons'), 
  options = list(responsive = TRUE,
                 buttons = c("csv", "excel", "pdf"),
                 dom = "Bftip"))
  
  output$shukuhaku_data <- DT::renderDT({
    Shukuhaku2020 %>% 
      filter(Prefecture == input$selected_prefecture_4) %>%
      rename(., "Total Guests" = Guests_Total,
             "Guests From the Prefecture" = Guests_Prefecture,
             "Guests From Outside of the Prefecture" = Guests_OutsidePrefecture,
             "Accommodation Type: Ryokan" = Type_Ryokan,
             "Accommodation Type: Resort Hotel" = Type_Resort,
             "Accommodation Type: Business Hotel" = Type_Business,
             "Accommodation Type: City Hotel" = Type_City,
             "Accommodation Type: Simple Lodging" = Type_Simple,
             "Accommodation Type: Accommodation for Companies and Groups" = Type_CompaniesGroups,
             "Guests from the Prefecture: Ryokan" = Pref_Ryokan,
             "Guests from the Prefecture: Resort Hotel" = Pref_Resort,
             "Guests from the Prefecture: Business Hotel" = Pref_Business,
             "Guests from the Prefecture: City Hotel" = Pref_City,
             "Guests from the Prefecture: Simple Lodging" = Pref_Simple,
             "Guests from the Prefecture: Accommodation for Companies and Groups" = Pref_CompaniesGroups,
             "Guests from Outside of the Prefecture: Ryokan" = Out_Ryokan,
             "Guests from Outside of the Prefecture: Resort Hotel" = Out_Resort,
             "Guests from Outside of the Prefecture: Business Hotel" = Out_Business,
             "Guests from Outside of the Prefecture: City Hotel" = Out_City,
             "Guests from Outside of the Prefecture: Simple Lodging" = Out_Simple,
             "Guests from Outside of the Prefecture: Accommodation for Companies and Groups" = Out_CompaniesGroups,
             "Occupancy Rate" = Occupancy_Rate,
             "Tourist Occupancy Rate" = Occupancy_Tourists,
             "Non Tourist Occupancy Rate" = Occupancy_NonTourists,
             "Occupancy Rate: Accommodation with 0-9 employees" = Occupancy_0to9,
             "Tourist Occupancy Rate: Accommodation with 0-9 employees" = Occupancy_Tourists_0to9,
             "Non Tourist Occupancy Rate: Accommodation with 0-9 employees" = Occupancy_NonTourists_0to9,
             "Occupancy Rate: Accommodation with 10-19 employees" = Occupancy_10to19,
             "Tourist Occupancy Rate: Accommodation with 10-19 employees" = Occupancy_Tourists_10to19,
             "Non Tourist Occupancy Rate: Accommodation with 10-19 employees" = Occupancy_NonTourists_10to19,
             "Occupancy Rate: Accommodation with 30-99 employees" = Occupancy_30to99,
             "Tourist Occupancy Rate: Accommodation with 30-99 employees" = Occupancy_Tourists_30to99,
             "Non Tourist Occupancy Rate: Accommodation with 30-99 employees" = Occupancy_NonTourists_30to99,
             "Occupancy Rate: Accommodation with over 100 employees" = Occupancy_over100,
             "Tourist Occupancy Rate: Accommodation with over 100 employees" = Occupancy_Tourists_over100,
             "Non Tourist Occupancy Rate: Accommodation with over 100 employees" = Occupancy_NonTourists_over100,
             "Occupancy Rate: Ryokan" = Occupancy_Ryokan,
             "Occupancy Rate: Resort Hotel" = Occupancy_Resort,
             "Occupancy Rate: Business Hotel" = Occupancy_Business,
             "Occupancy Rate: City Hotel" = Occupancy_City,
             "Occupancy Rate: Simple Lodging" = Occupancy_Simple,
             "Occupancy Rate: Accommodation for Companies and Groups" = Occupancy_CompaniesGroups
             ) %>% 
      select(Date, Prefecture, input$selected_column2)
  },
  rownames = F,
  extensions = c('Responsive', 'Buttons'), 
  options = list(responsive = TRUE,
                 buttons = c("csv", "excel", "pdf"),
                 dom = "Bftip"))
  
}