library(rnaturalearth)
library(dplyr)

japan_map <- ne_states(country = "Japan", returnclass = "sf")
str(japan_map)

japan_map %>% 
  select(name, geometry) -> japan_map
head(japan_map)

japan_map_pref <- japan_map %>% 
  group_by(name) %>% 
  summarize(n = n())
head(japan_map_pref)

japan_map %>% 
  arrange(., name) -> japan_map

japan_map %>% 
  select(-covid01) -> japan_map

japan_map$January_2020 <- KouseiCovid2_01$NewlyConfirmedCases
japan_map$February_2020 <- KouseiCovid2_02$NewlyConfirmedCases 
japan_map$March_2020 <- KouseiCovid2_03$NewlyConfirmedCases 
japan_map$April_2020 <- KouseiCovid2_04$NewlyConfirmedCases 
japan_map$May_2020 <- KouseiCovid2_05$NewlyConfirmedCases 
japan_map$June_2020 <- KouseiCovid2_06$NewlyConfirmedCases 
japan_map$July_2020 <- KouseiCovid2_07$NewlyConfirmedCases 
japan_map$August_2020 <- KouseiCovid2_08$NewlyConfirmedCases 
japan_map$September_2020 <- KouseiCovid2_09$NewlyConfirmedCases 
japan_map$October_2020 <- KouseiCovid2_10$NewlyConfirmedCases 
japan_map$November_2020 <- KouseiCovid2_11$NewlyConfirmedCases 
japan_map$December_2020 <- KouseiCovid2_12$NewlyConfirmedCases 

library(mapview)

japan_map %>% 
  mapview(zcol = "January_2020")

japan_map %>% 
  mapview(zcol = "February_2020")

japan_map %>% 
  mapview(zcol = "March_2020")

japan_map %>% 
  mapview(zcol = "April_2020")

japan_map %>% 
  mapview(zcol = "May_2020")

japan_map %>% 
  mapview(zcol = "June_2020")

japan_map %>% 
  mapview(zcol = "July_2020")

japan_map %>% 
  mapview(zcol = "August_2020")

japan_map %>% 
  mapview(zcol = "September_2020")

japan_map %>% 
  mapview(zcol = "October_2020")

japan_map %>% 
  mapview(zcol = "November_2020", col.regions = viridisLite::viridis)

japan_map %>% 
  mapview(zcol = "December_2020", col.regions = viridisLite::plasma)

library(ggplot2)
ggplot(data = japan_map, aes(fill = `December_2020`)) + 
  geom_sf() + 
  scale_fill_viridis_b() +
  theme_void() + guides(fill = guide_legend("2020-12"))
