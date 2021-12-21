getwd()
setwd("/Users/steph/Downloads/MGR")
load("./Clean Data/KouseiCovid2020.RData")
load("./Clean Data/Shukuhaku2020.RData")
library(dplyr)
library(ggplot2)

KouseiCovid2020 %>%
  filter(Prefecture == "Tokyo") %>% 
  mutate(Date = as.POSIXct(Date)) %>% 
  ggplot(., aes(x = Date, y = NewlyConfirmedCases, group = 1)) +
  geom_line() +
  scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
  labs(x = "Date", y = "Newly Confirmed Cases", title = "Tokyo") +
  theme_linedraw()

Shukuhaku2020 %>% 
  filter(Prefecture == "Tokyo") %>% 
  mutate(Date = as.POSIXct(Date)) %>% 
  ggplot(., aes(x = Date, y = Guests_Total, group = 1)) +
  geom_line() +
  scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
  scale_y_continuous(labels = scales::comma) +
  labs(x = "Date", y = "Total Guests", title = "Tokyo") +
  theme_linedraw()

Shukuhaku2020 %>% 
  filter(Prefecture == "Tokyo") %>% 
  mutate(Date = as.POSIXct(Date)) %>% 
  ggplot(., aes(x = Date, y = Guests_Total, group = 1)) +
  geom_line() +
  scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
  scale_y_continuous(labels = scales::comma) +
  labs(x = "Date", y = "Total Guests", title = "Tokyo") +
  theme_linedraw()
