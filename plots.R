KouseiCovid2020 %>%
  filter(Prefecture == "Tokyo") %>% 
  mutate(Date = as.POSIXct(Date)) -> data1

Shukuhaku2020 %>% 
  filter(Prefecture == "Tokyo") %>% 
  mutate(Date = as.POSIXct(Date)) -> data2

library(lubridate)

KouseiCovid2020 %>% 
  mutate(Date = as.POSIXct(Date)) %>% 
  group_by(Prefecture, Date = lubridate::floor_date(Date, "month")) %>% 
  summarize(NewCases = sum(NewlyConfirmedCases)) -> data1_2

Shukuhaku2020 %>% 
  mutate(Date = as.POSIXct(Date)) -> data2_2

data1_2 %>%
  filter(Prefecture == "Tokyo") %>% 
  mutate(Date = as.POSIXct(Date)) %>% 
  ggplot(., aes(x = Date, y = NewCases, group = 1)) +
  geom_line() +
  scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
  labs(x = "Date", y = "Newly Confirmed Cases", title = "Tokyo") +
  theme_linedraw()

data1_2 %>% filter(Prefecture == "Tokyo") -> data1_3
data2_2 %>% filter(Prefecture == "Tokyo") -> data2_3
ggplot() +
  geom_line(data = data2_3, aes(x = Date, y = Guests_Total), color = "red") +
  geom_point(data = data1_3, aes(x = Date, y = NewCases), color = "blue") +
  geom_smooth(method = "lm", se = F) +
  scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
  scale_y_continuous(labels = scales::comma)

ggplot() +
  geom_line(data = data2_2, aes(x = Date, y = Guests_Total), color = "red") +
  geom_line(data = data1_2, aes(x = Date, y = NewCases), color = "blue") +
  scale_y_continuous(labels = scales::comma) +
  scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month")
  
merge(data1_2, data2_2) -> data_both

data_both %>% 
  group_by(Date, Prefecture) %>% 
  filter(Prefecture == "Tokyo") %>% 
  ggplot() +
  geom_line(data = data_both, aes(x = Date, y = NewCases), color = "red") +
  geom_line(data = data_both, aes(x = Date, y = Guests_Total), color = "blue") +
  scale_y_continuous(labels = scales::comma) +
  scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month")
  
  # ggplot(mpg, aes(displ, hwy)) + 
  #   geom_point() + 
  #   scale_y_continuous(
  #     "mpg (US)", 
  #     sec.axis = sec_axis(~ . * 1.20, name = "mpg (UK)")
  #   )
  
# data_both %>% 
#   group_by(Date, Prefecture) %>% 
#   filter(Prefecture == "Tokyo") %>% 
#   ggplot(., aes(x = Date, group = 1)) +
#   geom_bar(aes(y = NewCases, group = 1), color = "red") +
#   geom_line(aes(y = Guests_Total, group = 1), color = "blue") +
#   scale_y_continuous(labels = scales::comma, sec.axis = sec_axis(~./1000, name = "Guests"))

#### ####

library(hrbrthemes)
coeff <- 0.1
covidcolor <- "#69b3a2"
guestcolor <- rgb(0.2, 0.6, 0.9, 1)
data_both %>% 
  group_by(Date, Prefecture) %>% 
  filter(Prefecture == "Tokyo") %>% 
  ggplot(., aes(x = Date, group = 1)) +
  geom_bar(aes(y = NewCases, group = 1), stat = 'identity', size = .1, fill = covidcolor,
           color = "black", alpha = .4) +
  geom_line(aes(y = Guests_OutsidePrefecture, group = 1), color = guestcolor) +
  scale_y_continuous(labels = scales::comma, name = "New Cases",
                     sec.axis = sec_axis(~ . *coeff, name = "Guests from outside of the prefecture",
                                         labels = scales::comma)) +
  scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
  theme_ipsum() +
  theme(axis.title.y = element_text(color = covidcolor, size = 13),
        axis.title.y.right = element_text(color = guestcolor, size = 13)) +
  ggtitle("New COVID-19 cases vs Total hotel guests")

library(hrbrthemes)
coeff <- 0.001
covidcolor <- "#69b3a2"
guestcolor <- rgb(0.2, 0.6, 0.9, 1)
data_both %>% 
  group_by(Date, Prefecture) %>% 
  filter(Prefecture == "Tokyo") %>% 
  ggplot(., aes(x = Date, group = 1)) +
  geom_bar(aes(y = NewCases, group = 1), stat = 'identity', size = .1, fill = covidcolor,
           color = "black", alpha = .4) +
  geom_line(aes(y = Occupancy_Rate, group = 1), color = guestcolor) +
  scale_y_continuous(labels = scales::comma, name = "New Cases",
                     sec.axis = sec_axis(~ . *coeff, name = "Occupancy Rate")) +
  scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 month") +
  theme_ipsum() +
  theme(axis.title.y = element_text(color = covidcolor, size = 13),
        axis.title.y.right = element_text(color = guestcolor, size = 13)) +
  ggtitle("New COVID-19 cases vs Total hotel guests")

library(latticeExtra)
data_both %>% 
  group_by(Date, Prefecture) %>% 
  filter(Prefecture == "Osaka") -> data_mix
obj1 <- xyplot(NewCases ~ Date, data_mix, type = "l", lwd = 2,
               ylab = "New Cases") # main = "New Cases vs Occupancy Rate"
obj2 <- xyplot(Occupancy_Rate ~ Date, data_mix, type = "l", lwd = 2,
               ylab = "Occupancy Rate")
doubleYScale(obj1, obj2, text = c("New Cases", "Occupancy Rate"), add.ylab2 = TRUE)

update(doubleYScale(obj1, obj2, text = c("New Cases", "Occupancy Rate"), add.ylab2 = TRUE),
       par.settings = simpleTheme(col = c('red', 'black'), lty = 1:2))

# plot(x1,y1,axes=F,ann=F)+ title(xlab=“”,ylab=“”)+ 
#   axis(1,at=seq(min,max,interval)+ 
#   axis(2,at=seq(min,max,interval) par(new=T) plot(x2,y2,axes=F,ann=F)+
#   axis(4,at=seq(min,max,interval)+
#   mtext(“y axis 2 title”, side=4,padj=3)
