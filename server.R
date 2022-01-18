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
  
  observeEvent(input$selected_column_1,
               {
                 updateSelectInput(session,
                                   "selected_column_1",
                                   selected = input$selected_column_1)
               })
  
  observeEvent(input$selected_column_2,
               {
                 updateSelectInput(session,
                                   "selected_column_2",
                                   selected = input$selected_column_2)
               })
  
  output$covid_plot <- renderPlotly({
    
    print(input$update_chart)
    
    if(input$update_chart == 0){
      return()
    }
    
    KouseiCovid2020 %>%
      filter(Prefecture == isolate(input$selected_prefecture)) %>%
      mutate(Date = as.POSIXct(Date)) %>%
      ggplot(., aes_string(x = "Date", y = input$selected_column_1), group = 1) +
      geom_line() +
      scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
      scale_y_continuous(labels = scales::comma) +
      labs(x = "Date", y = " ") +
      stat_smooth(color = "#FC4E07", fill = "#FC4E07",
                  method = "gam", se = F, size = 0.8) +
      theme_linedraw()
  })
  
  output$shukuhaku_plot <- renderPlotly({
    
    print(input$update_chart_2)
    
    if(input$update_chart_2 == 0){
      return()
    }
    
    Shukuhaku2020 %>%
      filter(Prefecture == isolate(input$selected_prefecture_2)) %>%
      mutate(Date = as.POSIXct(Date)) %>%
      ggplot(., aes_string(x = "Date", y = input$selected_column_2, group = 1)) +
      geom_line() +
      scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
      scale_y_continuous(labels = scales::comma) +
      labs(x = "Date", y = "") +
      theme_linedraw()
  })
  
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