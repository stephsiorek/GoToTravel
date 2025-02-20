library("dplyr")
library("DT")
library("ggplot2")
library("htmltools")
library("kableExtra")
library("leaflet")
library("plotly")
library("sf")
library("thematic")
library("tidyverse")
# library("leaflet.extras")
# library("rnaturalearthdata")

# for running the app locally:
# setwd("/Users/steph/Downloads/MGR")
# load("./Clean Data/KouseiCovid2020.RData")
# load("./Clean Data/Shukuhaku2020.RData")
# load("./Clean Data/Covid_Shukuhaku2020.RData")
# load("./GoToTravel/shape.RData")

# for deploying the app on the server:
# rsconnect::deployApp('/Users/steph/Downloads/MGR/GoToTravel')
load("KouseiCovid2020.RData")
load("Shukuhaku2020.RData")
load("Covid_Shukuhaku2020.RData")
load("shape.RData")

function(input, output, session) {
  
  thematic::thematic_shiny()
  
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
  
  observeEvent(input$selected_prefecture_5,
               {
                 updateSelectInput(session,
                                   "selected_prefecture_5",
                                   selected = input$selected_prefecture_5)
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
  
  observeEvent(input$selected_date_maps,
               {
                 updateSelectInput(session,
                                   "selected_date_maps",
                                   selected = input$selected_date_maps)
               })
  
  output$covid_plot <- renderPlotly({
    
    # print(input$update_chart)
    # 
    # if(input$update_chart == 0){
    #   return()
    # }
    
    mytitle <- if(input$selected_column_1 == "NewlyConfirmedCases"){
      print("Number of Newly Confirmed COVID-19 Cases in")
    } else if(input$selected_column_1 == "NumberOfDeaths"){
      print("Number of COVID-19 Related Deaths in")
    } else if(input$selected_column_1 == "SevereCases"){
      print("Number of Severe COVID-19 Cases in")
    }
    
    KouseiCovid2020 %>%
      filter(Prefecture == isolate(input$selected_prefecture)) %>%
      mutate(Date = as.POSIXct(Date)) %>%
      ggplot(., aes_string(x = "Date", y = input$selected_column_1), group = 1) +
      geom_line() +
      scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
      scale_y_continuous(labels = scales::comma) +
      labs(x = "Date", y = " ", title = paste(mytitle, input$selected_prefecture)) +
      stat_smooth(aes(color = "Moving Average"),
                  method = "gam", se = F, size = 0.8) +
      scale_color_manual(name = "Legend", values = "red") +
      theme_minimal()
  })
  
  output$shukuhaku_plot <- renderPlotly({
    
    # print(input$update_chart_2)
    # 
    # if(input$update_chart_2 == 0){
    #   return()
    # }
    
    mytitle_2 <- if(input$selected_column_2 == "Guests_Total"){
      print("Total Number of Guests in")
    } else if(input$selected_column_2 == "Guests_Prefecture"){
      print("Total Number of Guests from")
    } else if(input$selected_column_2 == "Guests_OutsidePrefecture"){
      print("Total Number of Guests from Outside of")
    } else if(input$selected_column_2 == "Type_Ryokan"){
      print("Total Number of Guests Staying in a Ryokan in")
    } else if(input$selected_column_2 == "Type_Resort"){
      print("Total Number of Guests Staying in a Resort Hotel in")
    } else if(input$selected_column_2 == "Type_Business"){
      print("Total Number of Guests Staying in a Business Hotel in")
    } else if(input$selected_column_2 == "Type_City"){
      print("Total Number of Guests Staying in a City Hotel in")
    } else if(input$selected_column_2 == "Type_Simple"){
      print("Total Number of Guests Staying in a Simple Lodging Facility in")
    } else if(input$selected_column_2 == "Type_CompaniesGroups"){
      print("Total Number of Guests Staying in an Accommodation for Companies and Groups in")
    } else if(input$selected_column_2 == "Pref_Ryokan"){
      print(paste("Total Number of Guests from", input$selected_prefecture_2, "Staying in a Ryokan in"))
    } else if(input$selected_column_2 == "Pref_Resort"){
      print(paste("Total Number of Guests from", input$selected_prefecture_2, "Staying in a Resort Hotel in"))
    } else if(input$selected_column_2 == "Pref_Business"){
      print(paste("Total Number of Guests from", input$selected_prefecture_2, "Staying in a Business Hotel in"))
    } else if(input$selected_column_2 == "Pref_City"){
      print(paste("Total Number of Guests from", input$selected_prefecture_2, "Staying in a City Hotell in"))
    } else if(input$selected_column_2 == "Pref_Simple"){
      print(paste("Total Number of Guests from", input$selected_prefecture_2, "Staying in a Simple Lodging Facility in"))
    } else if(input$selected_column_2 == "Pref_CompaniesGroups"){
      print(paste("Total Number of Guests from", input$selected_prefecture_2, "Staying in an Accommodation for Companies and Groups in"))
    } else if(input$selected_column_2 == "Out_Ryokan"){
      print(paste("Total Number of Guests from Outside of", input$selected_prefecture_2, "Staying in a Ryokan in"))
    } else if(input$selected_column_2 == "Out_Resort"){
      print(paste("Total Number of Guests from Outside of", input$selected_prefecture_2, "Staying in a Resort Hotel in"))
    } else if(input$selected_column_2 == "Out_Business"){
      print(paste("Total Number of Guests from Outside of", input$selected_prefecture_2, "Staying in a Business Hotel in"))
    } else if(input$selected_column_2 == "Out_City"){
      print(paste("Total Number of Guests from Outside of", input$selected_prefecture_2, "Staying in a City Hotell in"))
    } else if(input$selected_column_2 == "Out_Simple"){
      print(paste("Total Number of Guests from Outside of", input$selected_prefecture_2, "Staying in a Simple Lodging Facility in"))
    } else if(input$selected_column_2 == "Out_CompaniesGroups"){
      print(paste("Total Number of Guests from Outside of", input$selected_prefecture_2, "Staying in an Accommodation for Companies and Groups in"))
    } else if(input$selected_column_2 == "Occupancy_Rate"){
      print(paste("Occupancy Rate in"))
    } else if(input$selected_column_2 == "Occupancy_Tourists"){
      print(paste("Tourist Occupancy Rate in"))
    } else if(input$selected_column_2 == "Occupancy_NonTourists"){
      print(paste("Non-tourist Occupancy Rate in"))
    } else if(input$selected_column_2 == "Occupancy_0to9"){
      print(paste("Occupancy Rate of Accommodation with 0-9 employees in"))
    } else if(input$selected_column_2 == "Occupancy_Tourists_0to9"){
      print(paste("Tourist Occupancy Rate of Accommodation with 0-9 employees in"))
    } else if(input$selected_column_2 == "Occupancy_NonTourists_0to9"){
      print(paste("Non-tourist Occupancy Rate of Accommodation with 0-9 employees in"))
    } else if(input$selected_column_2 == "Occupancy_10to19"){
      print(paste("Occupancy Rate of Accommodation with 10-19 employees in"))
    } else if(input$selected_column_2 == "Occupancy_Tourists_10to19"){
      print(paste("Tourist Occupancy Rate of Accommodation with 10-19 employees in"))
    } else if(input$selected_column_2 == "Occupancy_NonTourists_10to19"){
      print(paste("Non-tourist Occupancy Rate of Accommodation with 10-19 employees in"))
    } else if(input$selected_column_2 == "Occupancy_30to99"){
      print(paste("Occupancy Rate of Accommodation with 30-99 employees in"))
    } else if(input$selected_column_2 == "Occupancy_Tourists_30to99"){
      print(paste("Tourist Occupancy Rate of Accommodation with 30-99 employees in"))
    } else if(input$selected_column_2 == "Occupancy_NonTourists_30to99"){
      print(paste("Non-tourist Occupancy Rate of Accommodation with 30-99 employees in"))
    } else if(input$selected_column_2 == "Occupancy_over100"){
      print(paste("Occupancy Rate of Accommodation with over 100 employees in"))
    } else if(input$selected_column_2 == "Occupancy_Tourists_over100"){
      print(paste("Tourist Occupancy Rate of Accommodation with over 100 employees in"))
    } else if(input$selected_column_2 == "Occupancy_NonTourists_over100"){
      print(paste("Non-tourist Occupancy Rate of Accommodation with over 100 employees in"))
    } else if(input$selected_column_2 == "Occupancy_Ryokan"){
      print(paste("Occupancy Rate of Ryokans in"))
    } else if(input$selected_column_2 == "Occupancy_Resort"){
      print(paste("Occupancy Rate of Resort Hotels in"))
    } else if(input$selected_column_2 == "Occupancy_Business"){
      print(paste("Occupancy Rate of Business Hotels in"))
    } else if(input$selected_column_2 == "Occupancy_City"){
      print(paste("Occupancy Rate of City Hotels in"))
    } else if(input$selected_column_2 == "Occupancy_Simple"){
      print(paste("Occupancy Rate of Simple Lodging Facilities in"))
    } else if(input$selected_column_2 == "Occupancy_CompaniesGroups"){
      print(paste("Occupancy Rate of Accommodation for Companies and Groups in"))
    }
    
    Shukuhaku2020 %>%
      filter(Prefecture == isolate(input$selected_prefecture_2)) %>%
      mutate(Date = as.POSIXct(Date)) %>%
      ggplot(., aes_string(x = "Date", y = input$selected_column_2, group = 1)) +
      geom_line() +
      scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
      scale_y_continuous(labels = scales::comma) +
      labs(x = "Date", y = "", title = paste(mytitle_2, input$selected_prefecture_2)) +
      theme_minimal()
  })
  
  output$comparison_plot <- renderPlot({
    Covid_Shukuhaku2020 %>%
      filter(Prefecture == input$selected_prefecture_5) %>%
      mutate(Date = as.POSIXct(Date)) %>%
      ggplot(., aes(x = Date), group = 1) +
      geom_line(aes(y = NewlyConfirmedCases, color = "Newly Confirmed Cases")) +
      geom_line(aes(y = Guests_Total/300, color = "Total Guests")) +
      scale_y_continuous(name = "Newly Confirmed Cases", sec.axis = sec_axis(trans = ~./10, name = "Total Guests")) +
      scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
      labs(x = "Date", y = " ", color = " ", title = paste("Newly Confirmed COVID-19 Cases vs Total Guests in", input$selected_prefecture_5)) +
      theme_minimal()
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
                 dom = "Bftip",
                 pageLength = -1,
                 paging = F))
  
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
             "Occupancy Rate: Accommodation for Companies and Groups" = Occupancy_CompaniesGroups) %>% 
      select(Date, Prefecture, input$selected_column2)
  },
  rownames = F,
  extensions = c('Responsive', 'Buttons'), 
  options = list(responsive = TRUE,
                 buttons = c("csv", "excel", "pdf"),
                 dom = "Bftip",
                 pageLength = -1,
                 paging = F))
  
  data <- reactive({
    x <- shape %>%
      filter(Date == input$selected_date_maps)
    x
  })
  
  output$maps <- renderLeaflet({
    shape_filtered <- data()
    
    bins <- c(0, 100, 200, 500, 1000, 2000, 5000, 10000, 20000)
    pal <- colorBin("YlOrRd", domain = shape_filtered$NewlyConfirmedCases, bins = bins)
    
    labels <- sprintf("<strong>%s</strong><br/>%s new COVID-19 cases",
                      shape_filtered$ADM1_EN, shape_filtered$NewlyConfirmedCases) %>% lapply(htmltools::HTML)
    
    out <- leaflet(shape_filtered) %>%
      setView(lng = 138.129731, lat = 38.0615855, zoom = 5) %>%
      addProviderTiles("Esri.WorldStreetMap") %>%
      addPolygons(fillColor = ~pal(shape_filtered$NewlyConfirmedCases), stroke = F,
                  weight = 2, opacity = 1, color = "white", dashArray = 3,
                  fillOpacity = 0.7,
                  highlightOptions = highlightOptions(weight = 5,
                                                      color = "#666",
                                                      dashArray = "",
                                                      fillOpacity = 0.7,
                                                      bringToFront = T),
                  label = labels,
                  labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"),
                                              textsize = "15px",
                                              direction = "auto")) %>% 
      addLegend(pal = pal,
                values = ~shape_filtered$NewlyConfirmedCases,
                opacity = 0.7,
                title = NULL,
                position = "bottomright")
    out
  })
  
  output$mapsguests <- renderLeaflet({
    shape_filtered <- data()
    
    bins <- c(0, 100000, 200000, 500000, 1000000, 2000000, 5000000, 7000000, 10000000)
    pal <- colorBin("YlOrRd", domain = shape_filtered$Guests_Total, bins = bins)
    
    labels <- sprintf("<strong>%s</strong><br/>%s total guests",
                      shape_filtered$ADM1_EN, shape_filtered$Guests_Total) %>% lapply(htmltools::HTML)
    
    out <- leaflet(shape_filtered) %>%
      setView(lng = 138.129731, lat = 38.0615855, zoom = 5) %>%
      addProviderTiles("Esri.WorldStreetMap") %>%
      addPolygons(fillColor = ~pal(shape_filtered$Guests_Total), stroke = F,
                  weight = 2, opacity = 1, color = "white", dashArray = 3,
                  fillOpacity = 0.7,
                  highlightOptions = highlightOptions(weight = 5,
                                                      color = "#666",
                                                      dashArray = "",
                                                      fillOpacity = 0.7,
                                                      bringToFront = T),
                  label = labels,
                  labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"),
                                              textsize = "15px",
                                              direction = "auto")) %>% 
      addLegend(pal = pal,
                values = ~shape_filtered$Guests_Total,
                opacity = 0.7,
                title = NULL,
                position = "bottomright")
    out
  })
  
  output$textmaps <- renderText({
    paste("Number of New COVID-19 cases")
  })
  
  output$textmapsguests <- renderText({
    paste("Number of Guests")
  })
  
}