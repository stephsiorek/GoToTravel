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
  
  observeEvent(input$selected_column,
               {
                 updateSelectInput(session,
                                   "selected_column",
                                   selected = input$selected_column)
               })
  
  observeEvent(input$selected_column2,
               {
                 updateSelectInput(session,
                                   "selected_column2",
                                   selected = input$selected_column2)
               })
  
  output$covid_plot <- renderPlot({
    
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
  
  output$shukuhaku_plot <- renderPlot({
    Shukuhaku2020 %>%
      filter(Prefecture == input$selected_prefecture_2) %>%
      mutate(Date = as.POSIXct(Date)) %>%
      ggplot(., aes(x = Date, y = Guests_Total, group = 1)) +
      geom_line() +
      scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
      scale_y_continuous(labels = scales::comma) +
      labs(x = "Date", y = "Total Guests",
           title = paste("Total Number of Guests in", input$selected_prefecture_2)) +
      #, title = paste(input$selected_column,
                                                       #  "in",
                                                        # input$selected_prefecture_2)) +
      theme_linedraw()
  })
  
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
  #     #, title = paste(input$selected_column,
  #     #  "in",
  #     # input$selected_prefecture_2)) +
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
                 buttons = c("excel", "pdf"),
                 dom = "Bftip"))
  
  output$shukuhaku_data <- DT::renderDT({
    Shukuhaku2020 %>% 
      filter(Prefecture == input$selected_prefecture_4) %>%
     # rename(., "Total Guests" = Guests_Total, "Guests From the Prefecture" = Guests_Prefecture,
    #         "Guests From Outside of the Prefecture" = Guests_OutsidePrefecture) %>% 
      select(Date, Prefecture, input$selected_column2)
  },
  rownames = F,
  extensions = c('Responsive', 'Buttons'), 
  options = list(responsive = TRUE,
                 buttons = c("excel", "pdf"),
                 dom = "Bftip"))
  
}