library(sf)
library(tidyverse)
library(dplyr)

setwd("/Users/steph/Downloads/MGR")

japan_shapefiles <- read_sf(dsn = "shapefiles/jpn_adm_2019_shp")
class(japan_shapefiles)

japan_shapefiles$ADM1_EN <- c("Aichi", "Akita", "Aomori", "Chiba", "Ehime", "Fukui", "Fukuoka", "Fukushima",
                              "Gifu", "Gunma", "Hiroshima", "Hokkaido", "Hyogo", "Ibaraki", "Ishikawa", "Iwate",
                              "Kagawa", "Kagoshima", "Kanagawa", "Kochi", "Kumamoto", "Kyoto", "Mie", "Miyagi",
                              "Miyazaki", "Nagano", "Nagasaki", "Nara", "Niigata", "Oita", "Okayama", "Okinawa",
                              "Osaka", "Saga", "Saitama", "Shiga", "Shimane", "Shizuoka", "Tochigi", "Tokushima",
                              "Tokyo", "Tottori", "Toyama", "Wakayama", "Yamagata", "Yamaguchi", "Yamanashi")

jp <- Covid_Shukuhaku2020
jp

jp %>% 
  rename(ADM1_EN = Prefecture) -> jp

japan_shape <- japan_shapefiles

shape <- japan_shape %>% 
  left_join(jp)

shape %>% 
  filter(Date == "2020-12-01") -> shape_filtered

leaflet(shape) %>% 
  setView(lng = japan_lat, lat = japan_lon, zoom = 5) %>%
  addProviderTiles("Esri.WorldStreetMap") %>% 
  addPolygons(fillColor = ~pal(shape$NewlyConfirmedCases), stroke = F,
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
                                          direction = "auto"))