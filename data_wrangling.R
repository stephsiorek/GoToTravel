getwd()
setwd("/Users/steph/Downloads/MGR/GoToTravel")
library(dplyr)

# DATA DOWNLOAD -----------------------------------------------------------

if (!file.exists("data")){
  dir.create("data")
}

# COVID-19 data download --------------------------------------------------

# Kousei Roudou Shou; Japanese Ministry of Health, Labour and Welfare
# https://covid19.mhlw.go.jp
# fileUrl1 <- "https://covid19.mhlw.go.jp/public/opendata/number_of_deaths_daily.csv"
# download.file(fileUrl1, destfile = "./data/KouseiDeathDaily.csv", method = "curl")
# list.files("./data")
# (dateDownloaded1 <- date()) # Sun Nov 28 16:35:45 2021
KouseiDeathDaily <- read.csv("./data/KouseiDeathDaily.csv", sep = ",", header = T, fileEncoding = "utf8")
glimpse(KouseiDeathDaily)

# fileUrl2 <- "https://covid19.mhlw.go.jp/public/opendata/severe_cases_daily.csv"
# download.file(fileUrl2, destfile = "./data/KouseiSevere.csv", method = "curl")
# list.files("./data")
# (dateDownloaded2 <- date()) # Fri Aug 6 17:59:34 2021
KouseiSevere <- read.csv("./data/KouseiSevere.csv", sep = ",", header = T, fileEncoding = "utf8")
glimpse(KouseiSevere)

# fileUrl3 <- "https://covid19.mhlw.go.jp/public/opendata/newly_confirmed_cases_daily.csv"
# download.file(fileUrl3, destfile = "./data/KouseiCovid2.csv", method = "curl")
# list.files("./data")
# (dateDownloaded3 <- date()) # Fri Aug 6 18:11:46 2021 # Sat Nov 20 17:00:50 2021
KouseiCovid2 <- read.csv("./data/KouseiCovid2.csv", sep = ",", header = T, fileEncoding = "utf8")
glimpse(KouseiCovid2)

# Accommodation data download ---------------------------------------------

# Kankouchou; Japanese Ministry of Land, Infrastructure, Transport and Tourism
# Shukuhaku ryokou toukei chousa
# Reiwa 2 nen (2020)
# fileUrl4 <- "https://www.mlit.go.jp/kankocho/siryou/toukei/content/001411547.xlsx"
# download.file(fileUrl4, destfile = "./data/shukuhaku2020.xlsx", method = "curl")
# list.files("./data")
# (dateDownloaded4 <- date()) # Fri Aug 6 18:35:24 2021
library(xlsx)
Shukuhaku2020 <- read.xlsx("./data/shukuhaku2020.xlsx", sheetIndex = 2, header = T)
glimpse(Shukuhaku2020)

# COVID-19 DATA WRANGLING  ----------------------------------------------------------

# INFECTIONS
KouseiCovid2 <- read.csv("./data/KouseiCovid2.csv", sep = ",", header = T, fileEncoding = "utf8")
glimpse(KouseiCovid2)
library(lubridate)
KouseiCovid2$Date <- as.Date(KouseiCovid2$Date, format = "%Y/%m/%d")
KouseiCovid2$Year <- format(KouseiCovid2$Date, format = "%Y")
KouseiCovid2 %>% 
  filter(Year == 2020) -> KouseiCovid2
KouseiCovid2 %>% 
  filter(Prefecture != "ALL") -> KouseiCovid2
KouseiCovid2 %>% select(-Year) -> KouseiCovid2020
KouseiCovid2020 %>% 
  rename(., NewlyConfirmedCases = Newly.confirmed.cases) -> Kousei_Infections

save(KouseiInfections, file = "./Clean Data/KouseiInfections.RData")
write.csv(KouseiInfections, file = "./Clean Data/KouseiInfections.csv", row.names = F)

# DEATHS
KouseiDeathDaily <- read.csv("./data/KouseiDeathDaily.csv", sep = ",", header = T, fileEncoding = "utf8")
head(KouseiDeathDaily)
library(lubridate)
KouseiDeathDaily$Date <- as.Date(KouseiDeathDaily$Date, format = "%Y/%m/%d")
KouseiDeathDaily$Year <- format(KouseiDeathDaily$Date, format = "%Y")
KouseiDeathDaily %>% 
  filter(Year == 2020) -> KouseiDeathDaily
KouseiDeathDaily %>% 
  filter(Prefecture != "ALL") -> KouseiDeathDaily
KouseiDeathDaily %>% 
  rename(., NumberOfDeaths = Number.of.Deaths) -> KouseiDeathDaily
KouseiDeathDaily %>% select(-Year) -> KouseiDeathDaily

# SEVERE CASES
KouseiSevereDaily <- read.csv("./data/KouseiSevere.csv", sep = ",", header = T, fileEncoding = "utf8")
head(KouseiSevereDaily)
library(lubridate)
KouseiSevereDaily$Date <- as.Date(KouseiSevereDaily$Date, format = "%Y/%m/%d")
KouseiSevereDaily$Year <- format(KouseiSevereDaily$Date, format = "%Y")
KouseiSevereDaily %>% 
  filter(Year == 2020) -> KouseiSevereDaily
KouseiSevereDaily %>% 
  filter(Prefecture != "ALL") -> KouseiSevereDaily
KouseiSevereDaily %>% 
  rename(., SevereCases = Severe.cases) -> KouseiSevereDaily
glimpse(KouseiSevereDaily)
KouseiSevereDaily %>% select(-Year) -> KouseiSevereDaily

# MERGE
KouseiCovid2020 <- merge(KouseiInfections, KouseiDeathDaily, all = T)
KouseiCovid2020 <- merge(KouseiCovid2020, KouseiSevereDaily, all = T)

save(KouseiCovid2020, file = "./Clean Data/KouseiCovid2020.RData")
write.csv(KouseiCovid2020, file = "./Clean Data/KouseiCovid2020.csv", row.names = F)

# ACCOMMODATION DATA WRANGLING --------------------------------------------

getwd()
setwd("/Users/steph/Downloads/MGR/GoToTravel")
library(dplyr)
library(xlsx)
Shukuhaku2020 <- read.xlsx("./data/shukuhaku2020.xlsx", sheetIndex = 2, header = T)
head(Shukuhaku2020)

#### 第9表　2020-01 ####
library(readxl)
Shukuhaku2020_1 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 106, skip = 7)
glimpse(Shukuhaku2020_1)

Shukuhaku2020_1_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                           "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                           "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                           "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_1 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 106, skip = 7, col_names = Shukuhaku2020_1_names, n_max = 47)
glimpse(Shukuhaku2020_1)

Shukuhaku2020_1$Prefecture <- as.character(Shukuhaku2020_1$Prefecture)
Shukuhaku2020_1$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_1$Prefecture)
glimpse(Shukuhaku2020_1)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_1$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_1)

Shukuhaku2020_1 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_1
glimpse(Shukuhaku2020_1)

Shukuhaku2020_1 <- subset(Shukuhaku2020_1, select = -Prefecture)
glimpse(Shukuhaku2020_1)

Shukuhaku2020_1 <- subset(Shukuhaku2020_1, select = c(PrefectureEng, TotalNumberOfGuests,
                                                      FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_1)
save(Shukuhaku2020_1, file = "Shukuhaku2020_01.RData")
write.csv(Shukuhaku2020_1, file = "Shukuhaku2020_01.csv", row.names = F)

#### 第9表　2020-02 ####
library(readxl)
Shukuhaku2020_2 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 107, skip = 7)
glimpse(Shukuhaku2020_2)

Shukuhaku2020_2_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                           "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                           "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                           "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_2 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 107, skip = 7, col_names = Shukuhaku2020_2_names, n_max = 47)
glimpse(Shukuhaku2020_2)

Shukuhaku2020_2$Prefecture <- as.character(Shukuhaku2020_2$Prefecture)
Shukuhaku2020_2$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_2$Prefecture)
glimpse(Shukuhaku2020_2)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_2$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_2)

Shukuhaku2020_2 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_2
glimpse(Shukuhaku2020_2)

Shukuhaku2020_2 <- subset(Shukuhaku2020_2, select = -Prefecture)
glimpse(Shukuhaku2020_2)

Shukuhaku2020_2 <- subset(Shukuhaku2020_2, select = c(PrefectureEng, TotalNumberOfGuests,
                                                      FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_2)
save(Shukuhaku2020_2, file = "Shukuhaku2020_02.RData")
write.csv(Shukuhaku2020_2, file = "Shukuhaku2020_02.csv", row.names = F)

#### 第9表　2020-03 ####
library(readxl)
Shukuhaku2020_3 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 108, skip = 7)
glimpse(Shukuhaku2020_3)

Shukuhaku2020_3_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                           "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                           "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                           "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_3 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 108, skip = 7, col_names = Shukuhaku2020_3_names, n_max = 47)
glimpse(Shukuhaku2020_3)

Shukuhaku2020_3$Prefecture <- as.character(Shukuhaku2020_3$Prefecture)
Shukuhaku2020_3$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_3$Prefecture)
glimpse(Shukuhaku2020_3)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_3$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_3)

Shukuhaku2020_3 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_3
glimpse(Shukuhaku2020_3)

Shukuhaku2020_3 <- subset(Shukuhaku2020_3, select = -Prefecture)
glimpse(Shukuhaku2020_3)

Shukuhaku2020_3 <- subset(Shukuhaku2020_3, select = c(PrefectureEng, TotalNumberOfGuests,
                                                      FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_3)
save(Shukuhaku2020_3, file = "Shukuhaku2020_03.RData")
write.csv(Shukuhaku2020_3, file = "Shukuhaku2020_03.csv", row.names = F)

#### 第9表　2020-04 ####
library(readxl)
Shukuhaku2020_4 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 109, skip = 7)
glimpse(Shukuhaku2020_4)

Shukuhaku2020_4_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                           "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                           "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                           "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_4 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 109, skip = 7, col_names = Shukuhaku2020_4_names, n_max = 47)
glimpse(Shukuhaku2020_4)

Shukuhaku2020_4$Prefecture <- as.character(Shukuhaku2020_4$Prefecture)
Shukuhaku2020_4$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_4$Prefecture)
glimpse(Shukuhaku2020_4)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_4$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_4)

Shukuhaku2020_4 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_4
glimpse(Shukuhaku2020_4)

Shukuhaku2020_4 <- subset(Shukuhaku2020_4, select = -Prefecture)
glimpse(Shukuhaku2020_4)

Shukuhaku2020_4 <- subset(Shukuhaku2020_4, select = c(PrefectureEng, TotalNumberOfGuests,
                                                      FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_4)
save(Shukuhaku2020_4, file = "Shukuhaku2020_04.RData")
write.csv(Shukuhaku2020_4, file = "Shukuhaku2020_04.csv", row.names = F)

#### 第9表　2020-05 ####
library(readxl)
Shukuhaku2020_5 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 110, skip = 7)
glimpse(Shukuhaku2020_5)

Shukuhaku2020_5_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                           "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                           "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                           "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_5 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 110, skip = 7, col_names = Shukuhaku2020_5_names, n_max = 47)
glimpse(Shukuhaku2020_5)

Shukuhaku2020_5$Prefecture <- as.character(Shukuhaku2020_5$Prefecture)
Shukuhaku2020_5$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_5$Prefecture)
glimpse(Shukuhaku2020_5)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_5$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_5)

Shukuhaku2020_5 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_5
glimpse(Shukuhaku2020_5)

Shukuhaku2020_5 <- subset(Shukuhaku2020_5, select = -Prefecture)
glimpse(Shukuhaku2020_5)

Shukuhaku2020_5 <- subset(Shukuhaku2020_5, select = c(PrefectureEng, TotalNumberOfGuests,
                                                      FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_5)
save(Shukuhaku2020_5, file = "Shukuhaku2020_05.RData")
write.csv(Shukuhaku2020_5, file = "Shukuhaku2020_05.csv", row.names = F)

#### 第9表　2020-06 ####
library(readxl)
Shukuhaku2020_6 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 111, skip = 7)
glimpse(Shukuhaku2020_6)

Shukuhaku2020_6_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                           "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                           "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                           "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_6 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 111, skip = 7, col_names = Shukuhaku2020_6_names, n_max = 47)
glimpse(Shukuhaku2020_6)

Shukuhaku2020_6$Prefecture <- as.character(Shukuhaku2020_6$Prefecture)
Shukuhaku2020_6$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_6$Prefecture)
glimpse(Shukuhaku2020_6)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_6$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_6)

Shukuhaku2020_6 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_6
glimpse(Shukuhaku2020_6)

Shukuhaku2020_6 <- subset(Shukuhaku2020_6, select = -Prefecture)
glimpse(Shukuhaku2020_6)

Shukuhaku2020_6 <- subset(Shukuhaku2020_6, select = c(PrefectureEng, TotalNumberOfGuests,
                                                      FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_6)
save(Shukuhaku2020_6, file = "Shukuhaku2020_06.RData")
write.csv(Shukuhaku2020_6, file = "Shukuhaku2020_06.csv", row.names = F)

#### 第9表　2020-07 ####
library(readxl)
Shukuhaku2020_7 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 112, skip = 7)
glimpse(Shukuhaku2020_7)

Shukuhaku2020_7_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                           "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                           "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                           "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_7 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 112, skip = 7, col_names = Shukuhaku2020_7_names, n_max = 47)
glimpse(Shukuhaku2020_7)

Shukuhaku2020_7$Prefecture <- as.character(Shukuhaku2020_7$Prefecture)
Shukuhaku2020_7$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_7$Prefecture)
glimpse(Shukuhaku2020_7)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_7$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_7)

Shukuhaku2020_7 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_7
glimpse(Shukuhaku2020_7)

Shukuhaku2020_7 <- subset(Shukuhaku2020_7, select = -Prefecture)
glimpse(Shukuhaku2020_7)

Shukuhaku2020_7 <- subset(Shukuhaku2020_7, select = c(PrefectureEng, TotalNumberOfGuests,
                                                      FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_7)
save(Shukuhaku2020_7, file = "Shukuhaku2020_07.RData")
write.csv(Shukuhaku2020_7, file = "Shukuhaku2020_07.csv", row.names = F)

#### 第9表　2020-08 ####
library(readxl)
Shukuhaku2020_8 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 113, skip = 7)
glimpse(Shukuhaku2020_8)

Shukuhaku2020_8_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                           "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                           "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                           "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_8 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 113, skip = 7, col_names = Shukuhaku2020_8_names, n_max = 47)
glimpse(Shukuhaku2020_8)

Shukuhaku2020_8$Prefecture <- as.character(Shukuhaku2020_8$Prefecture)
Shukuhaku2020_8$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_8$Prefecture)
glimpse(Shukuhaku2020_8)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_8$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_8)

Shukuhaku2020_8 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_8
glimpse(Shukuhaku2020_8)

Shukuhaku2020_8 <- subset(Shukuhaku2020_8, select = -Prefecture)
glimpse(Shukuhaku2020_8)

Shukuhaku2020_8 <- subset(Shukuhaku2020_8, select = c(PrefectureEng, TotalNumberOfGuests,
                                                      FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_8)
save(Shukuhaku2020_8, file = "Shukuhaku2020_08.RData")
write.csv(Shukuhaku2020_8, file = "Shukuhaku2020_08.csv", row.names = F)

#### 第9表　2020-09 ####
library(readxl)
Shukuhaku2020_9 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 114, skip = 7)
glimpse(Shukuhaku2020_9)

Shukuhaku2020_9_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                           "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                           "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                           "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_9 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 114, skip = 7, col_names = Shukuhaku2020_9_names, n_max = 47)
glimpse(Shukuhaku2020_9)

Shukuhaku2020_9$Prefecture <- as.character(Shukuhaku2020_9$Prefecture)
Shukuhaku2020_9$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_9$Prefecture)
glimpse(Shukuhaku2020_9)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_9$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_9)

Shukuhaku2020_9 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_9
glimpse(Shukuhaku2020_9)

Shukuhaku2020_9 <- subset(Shukuhaku2020_9, select = -Prefecture)
glimpse(Shukuhaku2020_9)

Shukuhaku2020_9 <- subset(Shukuhaku2020_9, select = c(PrefectureEng, TotalNumberOfGuests,
                                                      FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_9)
save(Shukuhaku2020_9, file = "Shukuhaku2020_09.RData")
write.csv(Shukuhaku2020_9, file = "Shukuhaku2020_09.csv", row.names = F)

#### 第9表　2020-10 ####
library(readxl)
# Shukuhaku2020_10 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 115, skip = 7, range = c(J7:J20))
Shukuhaku2020_10 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 115, skip = 7)
glimpse(Shukuhaku2020_10)

Shukuhaku2020_10_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                            "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                            "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                            "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_10 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 115, skip = 7, col_names = Shukuhaku2020_10_names, n_max = 47)
glimpse(Shukuhaku2020_10)

Shukuhaku2020_10$Prefecture <- as.character(Shukuhaku2020_10$Prefecture)
Shukuhaku2020_10$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_10$Prefecture)
glimpse(Shukuhaku2020_10)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_10$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_10)

Shukuhaku2020_10 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_10
glimpse(Shukuhaku2020_10)

Shukuhaku2020_10 <- subset(Shukuhaku2020_10, select = -Prefecture)
glimpse(Shukuhaku2020_10)

Shukuhaku2020_10 <- subset(Shukuhaku2020_10, select = c(PrefectureEng, TotalNumberOfGuests,
                                                        FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_10)
save(Shukuhaku2020_10, file = "Shukuhaku2020_10.RData")
write.csv(Shukuhaku2020_10, file = "Shukuhaku2020_10.csv", row.names = F)

#### 第9表　2020-11 ####
library(readxl)
Shukuhaku2020_11 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 116, skip = 7)
glimpse(Shukuhaku2020_11)

Shukuhaku2020_11_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                            "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                            "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                            "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_11 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 116, skip = 7, col_names = Shukuhaku2020_11_names, n_max = 47)
glimpse(Shukuhaku2020_11)

Shukuhaku2020_11$Prefecture <- as.character(Shukuhaku2020_11$Prefecture)
Shukuhaku2020_11$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_11$Prefecture)
glimpse(Shukuhaku2020_11)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_11$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_11)

Shukuhaku2020_11 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_11
glimpse(Shukuhaku2020_11)

Shukuhaku2020_11 <- subset(Shukuhaku2020_11, select = -Prefecture)
glimpse(Shukuhaku2020_11)

Shukuhaku2020_11 <- subset(Shukuhaku2020_11, select = c(PrefectureEng, TotalNumberOfGuests,
                                                        FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_11)
save(Shukuhaku2020_11, file = "Shukuhaku2020_11.RData")
write.csv(Shukuhaku2020_11, file = "Shukuhaku2020_11.csv", row.names = F)

#### 第9表　2020-12 ####
library(readxl)
Shukuhaku2020_12 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 117, skip = 7)
glimpse(Shukuhaku2020_12)

Shukuhaku2020_12_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", "OutsideOfThePrefecture", 
                            "Over50ofTouristsInclUnknownPlaceOfResidence", "Over50ofTouristsFromThePrefecture",
                            "Over50ofTouristsOutsideOfThePrefecture", "LessThan50ofTouristsInclUnknownPlaceOfResidence",
                            "LessThan50ofTouristsFromThePrefecture","LessThan50ofTouristsOutsideOfThePrefecture")

Shukuhaku2020_12 <- read_excel("./data/shukuhaku2020.xlsx", sheet = 117, skip = 7, col_names = Shukuhaku2020_12_names, n_max = 47)
glimpse(Shukuhaku2020_12)

Shukuhaku2020_12$Prefecture <- as.character(Shukuhaku2020_12$Prefecture)
Shukuhaku2020_12$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_12$Prefecture)
glimpse(Shukuhaku2020_12)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_12$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_12)

Shukuhaku2020_12 %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_12
glimpse(Shukuhaku2020_12)

Shukuhaku2020_12 <- subset(Shukuhaku2020_12, select = -Prefecture)
glimpse(Shukuhaku2020_12)

Shukuhaku2020_12 <- subset(Shukuhaku2020_12, select = c(PrefectureEng, TotalNumberOfGuests,
                                                        FromThePrefecture, OutsideOfThePrefecture))
glimpse(Shukuhaku2020_12)
save(Shukuhaku2020_12, file = "Shukuhaku2020_12.RData")
write.csv(Shukuhaku2020_12, file = "Shukuhaku2020_12.csv", row.names = F)

#### 第5表　2020-01 ####
library(readxl)
Shukuhaku2020_01_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 54, skip = 7)
glimpse(Shukuhaku2020_01_Type)

Shukuhaku2020_01_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

# Simple Lodging includes also hostels and capsule hotels

Shukuhaku2020_01_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 54, skip = 7, col_names = Shukuhaku2020_01_Type_names, n_max = 47)
glimpse(Shukuhaku2020_01_Type)

Shukuhaku2020_01_Type$Prefecture <- as.character(Shukuhaku2020_01_Type$Prefecture)
Shukuhaku2020_01_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_01_Type$Prefecture)
glimpse(Shukuhaku2020_01_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_01_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_01_Type)

Shukuhaku2020_01_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_01_Type
glimpse(Shukuhaku2020_01_Type)

Shukuhaku2020_01_Type <- subset(Shukuhaku2020_01_Type, select = -Prefecture)
glimpse(Shukuhaku2020_01_Type)

save(Shukuhaku2020_01_Type, file = "Shukuhaku2020_01_Type.RData")
write.csv(Shukuhaku2020_01_Type, file = "Shukuhaku2020_01_Type.csv", row.names = F)

#### 第5表　2020-02 ####
library(readxl)
Shukuhaku2020_02_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 55, skip = 7)
glimpse(Shukuhaku2020_02_Type)

Shukuhaku2020_02_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_02_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 55, skip = 7, col_names = Shukuhaku2020_02_Type_names, n_max = 47)
glimpse(Shukuhaku2020_02_Type)

Shukuhaku2020_02_Type$Prefecture <- as.character(Shukuhaku2020_02_Type$Prefecture)
Shukuhaku2020_02_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_02_Type$Prefecture)
glimpse(Shukuhaku2020_02_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_02_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_02_Type)

Shukuhaku2020_02_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_02_Type
glimpse(Shukuhaku2020_02_Type)

Shukuhaku2020_02_Type <- subset(Shukuhaku2020_02_Type, select = -Prefecture)
glimpse(Shukuhaku2020_02_Type)

save(Shukuhaku2020_02_Type, file = "Shukuhaku2020_02_Type.RData")
write.csv(Shukuhaku2020_02_Type, file = "Shukuhaku2020_02_Type.csv", row.names = F)

#### 第5表　2020-03 ####
library(readxl)
Shukuhaku2020_03_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 56, skip = 7)
glimpse(Shukuhaku2020_03_Type)

Shukuhaku2020_03_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_03_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 56, skip = 7, col_names = Shukuhaku2020_03_Type_names, n_max = 47)
glimpse(Shukuhaku2020_03_Type)

Shukuhaku2020_03_Type$Prefecture <- as.character(Shukuhaku2020_03_Type$Prefecture)
Shukuhaku2020_03_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_03_Type$Prefecture)
glimpse(Shukuhaku2020_03_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_03_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_03_Type)

Shukuhaku2020_03_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_03_Type
glimpse(Shukuhaku2020_03_Type)

Shukuhaku2020_03_Type <- subset(Shukuhaku2020_03_Type, select = -Prefecture)
glimpse(Shukuhaku2020_03_Type)

save(Shukuhaku2020_03_Type, file = "Shukuhaku2020_03_Type.RData")
write.csv(Shukuhaku2020_03_Type, file = "Shukuhaku2020_03_Type.csv", row.names = F)

#### 第5表　2020-04 ####
library(readxl)
Shukuhaku2020_04_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 57, skip = 7)
glimpse(Shukuhaku2020_04_Type)

Shukuhaku2020_04_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_04_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 57, skip = 7, col_names = Shukuhaku2020_04_Type_names, n_max = 47)
glimpse(Shukuhaku2020_04_Type)

Shukuhaku2020_04_Type$Prefecture <- as.character(Shukuhaku2020_04_Type$Prefecture)
Shukuhaku2020_04_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_04_Type$Prefecture)
glimpse(Shukuhaku2020_04_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_04_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_04_Type)

Shukuhaku2020_04_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_04_Type
glimpse(Shukuhaku2020_04_Type)

Shukuhaku2020_04_Type <- subset(Shukuhaku2020_04_Type, select = -Prefecture)
glimpse(Shukuhaku2020_04_Type)

save(Shukuhaku2020_04_Type, file = "Shukuhaku2020_04_Type.RData")
write.csv(Shukuhaku2020_04_Type, file = "Shukuhaku2020_04_Type.csv", row.names = F)

#### 第5表　2020-05 ####
library(readxl)
Shukuhaku2020_05_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 58, skip = 7)
glimpse(Shukuhaku2020_05_Type)

Shukuhaku2020_05_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_05_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 58, skip = 7, col_names = Shukuhaku2020_05_Type_names, n_max = 47)
glimpse(Shukuhaku2020_05_Type)

Shukuhaku2020_05_Type$Prefecture <- as.character(Shukuhaku2020_05_Type$Prefecture)
Shukuhaku2020_05_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_05_Type$Prefecture)
glimpse(Shukuhaku2020_05_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_05_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_05_Type)

Shukuhaku2020_05_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_05_Type
glimpse(Shukuhaku2020_05_Type)

Shukuhaku2020_05_Type <- subset(Shukuhaku2020_05_Type, select = -Prefecture)
glimpse(Shukuhaku2020_05_Type)

save(Shukuhaku2020_05_Type, file = "Shukuhaku2020_05_Type.RData")
write.csv(Shukuhaku2020_05_Type, file = "Shukuhaku2020_05_Type.csv", row.names = F)

#### 第5表　2020-06 ####
library(readxl)
Shukuhaku2020_06_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 59, skip = 7)
glimpse(Shukuhaku2020_06_Type)

Shukuhaku2020_06_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_06_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 59, skip = 7, col_names = Shukuhaku2020_06_Type_names, n_max = 47)
glimpse(Shukuhaku2020_06_Type)

Shukuhaku2020_06_Type$Prefecture <- as.character(Shukuhaku2020_06_Type$Prefecture)
Shukuhaku2020_06_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_06_Type$Prefecture)
glimpse(Shukuhaku2020_06_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_06_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_06_Type)

Shukuhaku2020_06_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_06_Type
glimpse(Shukuhaku2020_06_Type)

Shukuhaku2020_06_Type <- subset(Shukuhaku2020_06_Type, select = -Prefecture)
glimpse(Shukuhaku2020_06_Type)

save(Shukuhaku2020_06_Type, file = "Shukuhaku2020_06_Type.RData")
write.csv(Shukuhaku2020_06_Type, file = "Shukuhaku2020_06_Type.csv", row.names = F)

#### 第5表　2020-07 ####
library(readxl)
Shukuhaku2020_07_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 60, skip = 7)
glimpse(Shukuhaku2020_07_Type)

Shukuhaku2020_07_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_07_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 60, skip = 7, col_names = Shukuhaku2020_07_Type_names, n_max = 47)
glimpse(Shukuhaku2020_07_Type)

Shukuhaku2020_07_Type$Prefecture <- as.character(Shukuhaku2020_07_Type$Prefecture)
Shukuhaku2020_07_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_07_Type$Prefecture)
glimpse(Shukuhaku2020_07_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_07_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_07_Type)

Shukuhaku2020_07_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_07_Type
glimpse(Shukuhaku2020_07_Type)

Shukuhaku2020_07_Type <- subset(Shukuhaku2020_07_Type, select = -Prefecture)
glimpse(Shukuhaku2020_07_Type)

save(Shukuhaku2020_07_Type, file = "Shukuhaku2020_07_Type.RData")
write.csv(Shukuhaku2020_07_Type, file = "Shukuhaku2020_07_Type.csv", row.names = F)

#### 第5表　2020-08 ####
library(readxl)
Shukuhaku2020_08_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 61, skip = 7)
glimpse(Shukuhaku2020_08_Type)

Shukuhaku2020_08_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_08_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 61, skip = 7, col_names = Shukuhaku2020_08_Type_names, n_max = 47)
glimpse(Shukuhaku2020_08_Type)

Shukuhaku2020_08_Type$Prefecture <- as.character(Shukuhaku2020_08_Type$Prefecture)
Shukuhaku2020_08_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_08_Type$Prefecture)
glimpse(Shukuhaku2020_08_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_08_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_08_Type)

Shukuhaku2020_08_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_08_Type
glimpse(Shukuhaku2020_08_Type)

Shukuhaku2020_08_Type <- subset(Shukuhaku2020_08_Type, select = -Prefecture)
glimpse(Shukuhaku2020_08_Type)

save(Shukuhaku2020_08_Type, file = "Shukuhaku2020_08_Type.RData")
write.csv(Shukuhaku2020_08_Type, file = "Shukuhaku2020_08_Type.csv", row.names = F)

#### 第5表　2020-09 ####
library(readxl)
Shukuhaku2020_09_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 62, skip = 7)
glimpse(Shukuhaku2020_09_Type)

Shukuhaku2020_09_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_09_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 62, skip = 7, col_names = Shukuhaku2020_09_Type_names, n_max = 47)
glimpse(Shukuhaku2020_09_Type)

Shukuhaku2020_09_Type$Prefecture <- as.character(Shukuhaku2020_09_Type$Prefecture)
Shukuhaku2020_09_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_09_Type$Prefecture)
glimpse(Shukuhaku2020_09_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_09_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_09_Type)

Shukuhaku2020_09_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_09_Type
glimpse(Shukuhaku2020_09_Type)

Shukuhaku2020_09_Type <- subset(Shukuhaku2020_09_Type, select = -Prefecture)
glimpse(Shukuhaku2020_09_Type)

save(Shukuhaku2020_09_Type, file = "Shukuhaku2020_09_Type.RData")
write.csv(Shukuhaku2020_09_Type, file = "Shukuhaku2020_09_Type.csv", row.names = F)

#### 第5表　2020-10 ####
library(readxl)
Shukuhaku2020_10_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 63, skip = 7)
glimpse(Shukuhaku2020_10_Type)

Shukuhaku2020_10_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_10_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 63, skip = 7, col_names = Shukuhaku2020_10_Type_names, n_max = 47)
glimpse(Shukuhaku2020_10_Type)

Shukuhaku2020_10_Type$Prefecture <- as.character(Shukuhaku2020_10_Type$Prefecture)
Shukuhaku2020_10_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_10_Type$Prefecture)
glimpse(Shukuhaku2020_10_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_10_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_10_Type)

Shukuhaku2020_10_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_10_Type
glimpse(Shukuhaku2020_10_Type)

Shukuhaku2020_10_Type <- subset(Shukuhaku2020_10_Type, select = -Prefecture)
glimpse(Shukuhaku2020_10_Type)

save(Shukuhaku2020_10_Type, file = "Shukuhaku2020_10_Type.RData")
write.csv(Shukuhaku2020_10_Type, file = "Shukuhaku2020_10_Type.csv", row.names = F)

#### 第5表　2020-11 ####
library(readxl)
Shukuhaku2020_11_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 64, skip = 7)
glimpse(Shukuhaku2020_11_Type)

Shukuhaku2020_11_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_11_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 64, skip = 7, col_names = Shukuhaku2020_11_Type_names, n_max = 47)
glimpse(Shukuhaku2020_11_Type)

Shukuhaku2020_11_Type$Prefecture <- as.character(Shukuhaku2020_11_Type$Prefecture)
Shukuhaku2020_11_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_11_Type$Prefecture)
glimpse(Shukuhaku2020_11_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_11_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_11_Type)

Shukuhaku2020_11_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_11_Type
glimpse(Shukuhaku2020_11_Type)

Shukuhaku2020_11_Type <- subset(Shukuhaku2020_11_Type, select = -Prefecture)
glimpse(Shukuhaku2020_11_Type)

save(Shukuhaku2020_11_Type, file = "Shukuhaku2020_11_Type.RData")
write.csv(Shukuhaku2020_11_Type, file = "Shukuhaku2020_11_Type.csv", row.names = F)

#### 第5表　2020-12 ####
library(readxl)
Shukuhaku2020_12_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 65, skip = 7)
glimpse(Shukuhaku2020_12_Type)

Shukuhaku2020_12_Type_names <- c("Prefecture", "TotalNumberOfGuests", "Ryokan", "ResortHotel", 
                                 "BusinessHotel", "CityHotel", "SimpleLodging",
                                 "AccommodationForCompaniesAndGroups",
                                 "TotalNumberOfForeignGuests","Ryokan_Foreigners", "ResortHotel_Foreigners", 
                                 "BusinessHotel_Foreigners", "CityHotel_Foreigners", "SimpleLodging_Foreigners",
                                 "AccommodationForCompaniesAndGroups_Foreigners")

Shukuhaku2020_12_Type <- read_excel("./data/shukuhaku2020.xlsx", sheet = 65, skip = 7, col_names = Shukuhaku2020_12_Type_names, n_max = 47)
glimpse(Shukuhaku2020_12_Type)

Shukuhaku2020_12_Type$Prefecture <- as.character(Shukuhaku2020_12_Type$Prefecture)
Shukuhaku2020_12_Type$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_12_Type$Prefecture)
glimpse(Shukuhaku2020_12_Type)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_12_Type$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_12_Type)

Shukuhaku2020_12_Type %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_12_Type
glimpse(Shukuhaku2020_12_Type)

Shukuhaku2020_12_Type <- subset(Shukuhaku2020_12_Type, select = -Prefecture)
glimpse(Shukuhaku2020_12_Type)

save(Shukuhaku2020_12_Type, file = "Shukuhaku2020_12_Type.RData")
write.csv(Shukuhaku2020_12_Type, file = "Shukuhaku2020_12_Type.csv", row.names = F)

#### 第6表　2020-01 ####
library(readxl)
Shukuhaku2020_01_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 67, skip = 7)
glimpse(Shukuhaku2020_01_Occupancy)

Shukuhaku2020_01_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_01_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 67, skip = 7, col_names = Shukuhaku2020_01_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_01_Occupancy)

Shukuhaku2020_01_Occupancy$Prefecture <- as.character(Shukuhaku2020_01_Occupancy$Prefecture)
Shukuhaku2020_01_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_01_Occupancy$Prefecture)
glimpse(Shukuhaku2020_01_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_01_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_01_Occupancy)

Shukuhaku2020_01_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_01_Occupancy
glimpse(Shukuhaku2020_01_Occupancy)

Shukuhaku2020_01_Occupancy <- subset(Shukuhaku2020_01_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_01_Occupancy)

save(Shukuhaku2020_01_Occupancy, file = "Shukuhaku2020_01_Occupancy.RData")
write.csv(Shukuhaku2020_01_Occupancy, file = "Shukuhaku2020_01_Occupancy.csv", row.names = F)

#### 第6表　2020-02 ####
library(readxl)
Shukuhaku2020_02_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 68, skip = 7)
glimpse(Shukuhaku2020_02_Occupancy)

Shukuhaku2020_02_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_02_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 68, skip = 7, col_names = Shukuhaku2020_02_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_02_Occupancy)

Shukuhaku2020_02_Occupancy$Prefecture <- as.character(Shukuhaku2020_02_Occupancy$Prefecture)
Shukuhaku2020_02_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_02_Occupancy$Prefecture)
glimpse(Shukuhaku2020_02_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_02_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_02_Occupancy)

Shukuhaku2020_02_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_02_Occupancy
glimpse(Shukuhaku2020_02_Occupancy)

Shukuhaku2020_02_Occupancy <- subset(Shukuhaku2020_02_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_02_Occupancy)

save(Shukuhaku2020_02_Occupancy, file = "Shukuhaku2020_02_Occupancy.RData")
write.csv(Shukuhaku2020_02_Occupancy, file = "Shukuhaku2020_02_Occupancy.csv", row.names = F)

#### 第6表　2020-03 ####
library(readxl)
Shukuhaku2020_03_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 69, skip = 7)
glimpse(Shukuhaku2020_03_Occupancy)

Shukuhaku2020_03_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_03_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 69, skip = 7, col_names = Shukuhaku2020_03_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_03_Occupancy)

Shukuhaku2020_03_Occupancy$Prefecture <- as.character(Shukuhaku2020_03_Occupancy$Prefecture)
Shukuhaku2020_03_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_03_Occupancy$Prefecture)
glimpse(Shukuhaku2020_03_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_03_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_03_Occupancy)

Shukuhaku2020_03_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_03_Occupancy
glimpse(Shukuhaku2020_03_Occupancy)

Shukuhaku2020_03_Occupancy <- subset(Shukuhaku2020_03_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_03_Occupancy)

save(Shukuhaku2020_03_Occupancy, file = "Shukuhaku2020_03_Occupancy.RData")
write.csv(Shukuhaku2020_03_Occupancy, file = "Shukuhaku2020_03_Occupancy.csv", row.names = F)

#### 第6表　2020-04 ####
library(readxl)
Shukuhaku2020_04_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 70, skip = 7)
glimpse(Shukuhaku2020_04_Occupancy)

Shukuhaku2020_04_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_04_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 70, skip = 7, col_names = Shukuhaku2020_04_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_04_Occupancy)

Shukuhaku2020_04_Occupancy$Prefecture <- as.character(Shukuhaku2020_04_Occupancy$Prefecture)
Shukuhaku2020_04_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_04_Occupancy$Prefecture)
glimpse(Shukuhaku2020_04_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_04_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_04_Occupancy)

Shukuhaku2020_04_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_04_Occupancy
glimpse(Shukuhaku2020_04_Occupancy)

Shukuhaku2020_04_Occupancy <- subset(Shukuhaku2020_04_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_04_Occupancy)

save(Shukuhaku2020_04_Occupancy, file = "Shukuhaku2020_04_Occupancy.RData")
write.csv(Shukuhaku2020_04_Occupancy, file = "Shukuhaku2020_04_Occupancy.csv", row.names = F)

#### 第6表　2020-05 ####
library(readxl)
Shukuhaku2020_05_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 71, skip = 7)
glimpse(Shukuhaku2020_05_Occupancy)

Shukuhaku2020_05_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_05_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 71, skip = 7, col_names = Shukuhaku2020_05_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_05_Occupancy)

Shukuhaku2020_05_Occupancy$Prefecture <- as.character(Shukuhaku2020_05_Occupancy$Prefecture)
Shukuhaku2020_05_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_05_Occupancy$Prefecture)
glimpse(Shukuhaku2020_05_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_05_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_05_Occupancy)

Shukuhaku2020_05_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_05_Occupancy
glimpse(Shukuhaku2020_05_Occupancy)

Shukuhaku2020_05_Occupancy <- subset(Shukuhaku2020_05_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_05_Occupancy)

save(Shukuhaku2020_05_Occupancy, file = "Shukuhaku2020_05_Occupancy.RData")
write.csv(Shukuhaku2020_05_Occupancy, file = "Shukuhaku2020_05_Occupancy.csv", row.names = F)

#### 第6表　2020-06 ####
library(readxl)
Shukuhaku2020_06_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 72, skip = 7)
glimpse(Shukuhaku2020_06_Occupancy)

Shukuhaku2020_06_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_06_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 72, skip = 7, col_names = Shukuhaku2020_06_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_06_Occupancy)

Shukuhaku2020_06_Occupancy$Prefecture <- as.character(Shukuhaku2020_06_Occupancy$Prefecture)
Shukuhaku2020_06_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_06_Occupancy$Prefecture)
glimpse(Shukuhaku2020_06_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_06_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_06_Occupancy)

Shukuhaku2020_06_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_06_Occupancy
glimpse(Shukuhaku2020_06_Occupancy)

Shukuhaku2020_06_Occupancy <- subset(Shukuhaku2020_06_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_06_Occupancy)

save(Shukuhaku2020_06_Occupancy, file = "Shukuhaku2020_06_Occupancy.RData")
write.csv(Shukuhaku2020_06_Occupancy, file = "Shukuhaku2020_06_Occupancy.csv", row.names = F)

#### 第6表　2020-07 ####
library(readxl)
Shukuhaku2020_07_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 73, skip = 7)
glimpse(Shukuhaku2020_07_Occupancy)

Shukuhaku2020_07_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_07_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 73, skip = 7, col_names = Shukuhaku2020_07_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_07_Occupancy)

Shukuhaku2020_07_Occupancy$Prefecture <- as.character(Shukuhaku2020_07_Occupancy$Prefecture)
Shukuhaku2020_07_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_07_Occupancy$Prefecture)
glimpse(Shukuhaku2020_07_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_07_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_07_Occupancy)

Shukuhaku2020_07_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_07_Occupancy
glimpse(Shukuhaku2020_07_Occupancy)

Shukuhaku2020_07_Occupancy <- subset(Shukuhaku2020_07_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_07_Occupancy)

save(Shukuhaku2020_07_Occupancy, file = "Shukuhaku2020_07_Occupancy.RData")
write.csv(Shukuhaku2020_07_Occupancy, file = "Shukuhaku2020_07_Occupancy.csv", row.names = F)

#### 第6表　2020-08 ####
library(readxl)
Shukuhaku2020_08_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 74, skip = 7)
glimpse(Shukuhaku2020_08_Occupancy)

Shukuhaku2020_08_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_08_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 74, skip = 7, col_names = Shukuhaku2020_08_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_08_Occupancy)

Shukuhaku2020_08_Occupancy$Prefecture <- as.character(Shukuhaku2020_08_Occupancy$Prefecture)
Shukuhaku2020_08_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_08_Occupancy$Prefecture)
glimpse(Shukuhaku2020_08_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_08_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_08_Occupancy)

Shukuhaku2020_08_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_08_Occupancy
glimpse(Shukuhaku2020_08_Occupancy)

Shukuhaku2020_08_Occupancy <- subset(Shukuhaku2020_08_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_08_Occupancy)

save(Shukuhaku2020_08_Occupancy, file = "Shukuhaku2020_08_Occupancy.RData")
write.csv(Shukuhaku2020_08_Occupancy, file = "Shukuhaku2020_08_Occupancy.csv", row.names = F)

#### 第6表　2020-09 ####
library(readxl)
Shukuhaku2020_09_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 75, skip = 7)
glimpse(Shukuhaku2020_09_Occupancy)

Shukuhaku2020_09_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_09_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 75, skip = 7, col_names = Shukuhaku2020_09_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_09_Occupancy)

Shukuhaku2020_09_Occupancy$Prefecture <- as.character(Shukuhaku2020_09_Occupancy$Prefecture)
Shukuhaku2020_09_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_09_Occupancy$Prefecture)
glimpse(Shukuhaku2020_09_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_09_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_09_Occupancy)

Shukuhaku2020_09_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_09_Occupancy
glimpse(Shukuhaku2020_09_Occupancy)

Shukuhaku2020_09_Occupancy <- subset(Shukuhaku2020_09_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_09_Occupancy)

save(Shukuhaku2020_09_Occupancy, file = "Shukuhaku2020_09_Occupancy.RData")
write.csv(Shukuhaku2020_09_Occupancy, file = "Shukuhaku2020_09_Occupancy.csv", row.names = F)

#### 第6表　2020-10 ####
library(readxl)
Shukuhaku2020_10_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 76, skip = 7)
glimpse(Shukuhaku2020_10_Occupancy)

Shukuhaku2020_10_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_10_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 76, skip = 7, col_names = Shukuhaku2020_10_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_10_Occupancy)

Shukuhaku2020_10_Occupancy$Prefecture <- as.character(Shukuhaku2020_10_Occupancy$Prefecture)
Shukuhaku2020_10_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_10_Occupancy$Prefecture)
glimpse(Shukuhaku2020_10_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_10_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_10_Occupancy)

Shukuhaku2020_10_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_10_Occupancy
glimpse(Shukuhaku2020_10_Occupancy)

Shukuhaku2020_10_Occupancy <- subset(Shukuhaku2020_10_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_10_Occupancy)

save(Shukuhaku2020_10_Occupancy, file = "Shukuhaku2020_10_Occupancy.RData")
write.csv(Shukuhaku2020_10_Occupancy, file = "Shukuhaku2020_10_Occupancy.csv", row.names = F)

#### 第6表　2020-11 ####
library(readxl)
Shukuhaku2020_11_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 77, skip = 7)
glimpse(Shukuhaku2020_11_Occupancy)

Shukuhaku2020_11_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_11_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 77, skip = 7, col_names = Shukuhaku2020_11_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_11_Occupancy)

Shukuhaku2020_11_Occupancy$Prefecture <- as.character(Shukuhaku2020_11_Occupancy$Prefecture)
Shukuhaku2020_11_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_11_Occupancy$Prefecture)
glimpse(Shukuhaku2020_11_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_11_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_11_Occupancy)

Shukuhaku2020_11_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_11_Occupancy
glimpse(Shukuhaku2020_11_Occupancy)

Shukuhaku2020_11_Occupancy <- subset(Shukuhaku2020_11_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_11_Occupancy)

save(Shukuhaku2020_11_Occupancy, file = "Shukuhaku2020_11_Occupancy.RData")
write.csv(Shukuhaku2020_11_Occupancy, file = "Shukuhaku2020_11_Occupancy.csv", row.names = F)

#### 第6表　2020-12 ####
library(readxl)
Shukuhaku2020_12_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 78, skip = 7)
glimpse(Shukuhaku2020_12_Occupancy)

Shukuhaku2020_12_Occupancy_names <- c("Prefecture", "CapacityOccupancyRate", "Over50TouristGuests", 
                                      "LessThan50TouristGuests", "Occupancy_0-9", "Tourists_0-9",
                                      "NonTourists_0-9", "Occupancy_10-19","Tourists_10-19", "NonTourists_10-19", 
                                      "Occupancy_30-99", "Tourists_30-99", "NonTourists_30-99",
                                      "Occupancy_over100", "Tourists_over100", "NonTourists_over100",
                                      "Ryokan", "ResortHotel", "BusinessHotel", "CityHotel", "SimpleLodging",
                                      "AccommodationForCompaniesAndGroups")

Shukuhaku2020_12_Occupancy <- read_excel("./data/shukuhaku2020.xlsx", sheet = 78, skip = 7, col_names = Shukuhaku2020_12_Occupancy_names, n_max = 47)
glimpse(Shukuhaku2020_12_Occupancy)

Shukuhaku2020_12_Occupancy$Prefecture <- as.character(Shukuhaku2020_12_Occupancy$Prefecture)
Shukuhaku2020_12_Occupancy$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_12_Occupancy$Prefecture)
glimpse(Shukuhaku2020_12_Occupancy)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_12_Occupancy$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_12_Occupancy)

Shukuhaku2020_12_Occupancy %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_12_Occupancy
glimpse(Shukuhaku2020_12_Occupancy)

Shukuhaku2020_12_Occupancy <- subset(Shukuhaku2020_12_Occupancy, select = -Prefecture)
glimpse(Shukuhaku2020_12_Occupancy)

save(Shukuhaku2020_12_Occupancy, file = "Shukuhaku2020_12_Occupancy.RData")
write.csv(Shukuhaku2020_12_Occupancy, file = "Shukuhaku2020_12_Occupancy.csv", row.names = F)


#### 第10表　2020-01 ####
library(readxl)
Shukuhaku2020_01_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 119, skip = 7)
glimpse(Shukuhaku2020_01_TypeResidence)

Shukuhaku2020_01_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_01_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 119, skip = 7, col_names = Shukuhaku2020_01_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_01_TypeResidence)

Shukuhaku2020_01_TypeResidence$Prefecture <- as.character(Shukuhaku2020_01_TypeResidence$Prefecture)
Shukuhaku2020_01_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_01_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_01_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_01_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_01_TypeResidence)

Shukuhaku2020_01_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_01_TypeResidence
glimpse(Shukuhaku2020_01_TypeResidence)

Shukuhaku2020_01_TypeResidence <- subset(Shukuhaku2020_01_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_01_TypeResidence)

save(Shukuhaku2020_01_TypeResidence, file = "Shukuhaku2020_01_TypeResidence.RData")
write.csv(Shukuhaku2020_01_TypeResidence, file = "Shukuhaku2020_01_TypeResidence.csv", row.names = F)

#### 第10表　2020-02 ####
library(readxl)
Shukuhaku2020_02_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 120, skip = 7)
glimpse(Shukuhaku2020_02_TypeResidence)

Shukuhaku2020_02_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_02_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 120, skip = 7, col_names = Shukuhaku2020_02_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_02_TypeResidence)

Shukuhaku2020_02_TypeResidence$Prefecture <- as.character(Shukuhaku2020_02_TypeResidence$Prefecture)
Shukuhaku2020_02_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_02_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_02_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_02_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_02_TypeResidence)

Shukuhaku2020_02_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_02_TypeResidence
glimpse(Shukuhaku2020_02_TypeResidence)

Shukuhaku2020_02_TypeResidence <- subset(Shukuhaku2020_02_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_02_TypeResidence)

save(Shukuhaku2020_02_TypeResidence, file = "Shukuhaku2020_02_TypeResidence.RData")
write.csv(Shukuhaku2020_02_TypeResidence, file = "Shukuhaku2020_02_TypeResidence.csv", row.names = F)

#### 第10表　2020-03 ####
library(readxl)
Shukuhaku2020_03_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 121, skip = 7)
glimpse(Shukuhaku2020_03_TypeResidence)

Shukuhaku2020_03_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_03_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 121, skip = 7, col_names = Shukuhaku2020_03_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_03_TypeResidence)

Shukuhaku2020_03_TypeResidence$Prefecture <- as.character(Shukuhaku2020_03_TypeResidence$Prefecture)
Shukuhaku2020_03_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_03_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_03_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_03_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_03_TypeResidence)

Shukuhaku2020_03_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_03_TypeResidence
glimpse(Shukuhaku2020_03_TypeResidence)

Shukuhaku2020_03_TypeResidence <- subset(Shukuhaku2020_03_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_03_TypeResidence)

save(Shukuhaku2020_03_TypeResidence, file = "Shukuhaku2020_03_TypeResidence.RData")
write.csv(Shukuhaku2020_03_TypeResidence, file = "Shukuhaku2020_03_TypeResidence.csv", row.names = F)

#### 第10表　2020-04 ####
library(readxl)
Shukuhaku2020_04_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 122, skip = 7)
glimpse(Shukuhaku2020_04_TypeResidence)

Shukuhaku2020_04_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_04_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 122, skip = 7, col_names = Shukuhaku2020_04_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_04_TypeResidence)

Shukuhaku2020_04_TypeResidence$Prefecture <- as.character(Shukuhaku2020_04_TypeResidence$Prefecture)
Shukuhaku2020_04_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_04_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_04_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_04_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_04_TypeResidence)

Shukuhaku2020_04_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_04_TypeResidence
glimpse(Shukuhaku2020_04_TypeResidence)

Shukuhaku2020_04_TypeResidence <- subset(Shukuhaku2020_04_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_04_TypeResidence)

save(Shukuhaku2020_04_TypeResidence, file = "Shukuhaku2020_04_TypeResidence.RData")
write.csv(Shukuhaku2020_04_TypeResidence, file = "Shukuhaku2020_04_TypeResidence.csv", row.names = F)

#### 第10表　2020-05 ####
library(readxl)
Shukuhaku2020_05_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 123, skip = 7)
glimpse(Shukuhaku2020_05_TypeResidence)

Shukuhaku2020_05_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_05_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 123, skip = 7, col_names = Shukuhaku2020_05_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_05_TypeResidence)

Shukuhaku2020_05_TypeResidence$Prefecture <- as.character(Shukuhaku2020_05_TypeResidence$Prefecture)
Shukuhaku2020_05_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_05_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_05_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_05_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_05_TypeResidence)

Shukuhaku2020_05_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_05_TypeResidence
glimpse(Shukuhaku2020_05_TypeResidence)

Shukuhaku2020_05_TypeResidence <- subset(Shukuhaku2020_05_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_05_TypeResidence)

save(Shukuhaku2020_05_TypeResidence, file = "Shukuhaku2020_05_TypeResidence.RData")
write.csv(Shukuhaku2020_05_TypeResidence, file = "Shukuhaku2020_05_TypeResidence.csv", row.names = F)

#### 第10表　2020-06 ####
library(readxl)
Shukuhaku2020_06_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 124, skip = 7)
glimpse(Shukuhaku2020_06_TypeResidence)

Shukuhaku2020_06_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_06_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 124, skip = 7, col_names = Shukuhaku2020_06_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_06_TypeResidence)

Shukuhaku2020_06_TypeResidence$Prefecture <- as.character(Shukuhaku2020_06_TypeResidence$Prefecture)
Shukuhaku2020_06_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_06_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_06_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_06_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_06_TypeResidence)

Shukuhaku2020_06_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_06_TypeResidence
glimpse(Shukuhaku2020_06_TypeResidence)

Shukuhaku2020_06_TypeResidence <- subset(Shukuhaku2020_06_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_06_TypeResidence)

save(Shukuhaku2020_06_TypeResidence, file = "Shukuhaku2020_06_TypeResidence.RData")
write.csv(Shukuhaku2020_06_TypeResidence, file = "Shukuhaku2020_06_TypeResidence.csv", row.names = F)

#### 第10表　2020-07 ####
library(readxl)
Shukuhaku2020_07_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 125, skip = 7)
glimpse(Shukuhaku2020_07_TypeResidence)

Shukuhaku2020_07_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_07_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 125, skip = 7, col_names = Shukuhaku2020_07_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_07_TypeResidence)

Shukuhaku2020_07_TypeResidence$Prefecture <- as.character(Shukuhaku2020_07_TypeResidence$Prefecture)
Shukuhaku2020_07_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_07_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_07_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_07_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_07_TypeResidence)

Shukuhaku2020_07_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_07_TypeResidence
glimpse(Shukuhaku2020_07_TypeResidence)

Shukuhaku2020_07_TypeResidence <- subset(Shukuhaku2020_07_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_07_TypeResidence)

save(Shukuhaku2020_07_TypeResidence, file = "Shukuhaku2020_07_TypeResidence.RData")
write.csv(Shukuhaku2020_07_TypeResidence, file = "Shukuhaku2020_07_TypeResidence.csv", row.names = F)

#### 第10表　2020-08 ####
library(readxl)
Shukuhaku2020_08_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 126, skip = 7)
glimpse(Shukuhaku2020_08_TypeResidence)

Shukuhaku2020_08_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_08_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 126, skip = 7, col_names = Shukuhaku2020_08_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_08_TypeResidence)

Shukuhaku2020_08_TypeResidence$Prefecture <- as.character(Shukuhaku2020_08_TypeResidence$Prefecture)
Shukuhaku2020_08_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_08_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_08_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_08_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_08_TypeResidence)

Shukuhaku2020_08_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_08_TypeResidence
glimpse(Shukuhaku2020_08_TypeResidence)

Shukuhaku2020_08_TypeResidence <- subset(Shukuhaku2020_08_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_08_TypeResidence)

save(Shukuhaku2020_08_TypeResidence, file = "Shukuhaku2020_08_TypeResidence.RData")
write.csv(Shukuhaku2020_08_TypeResidence, file = "Shukuhaku2020_08_TypeResidence.csv", row.names = F)

#### 第10表　2020-09 ####
library(readxl)
Shukuhaku2020_09_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 127, skip = 7)
glimpse(Shukuhaku2020_09_TypeResidence)

Shukuhaku2020_09_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_09_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 127, skip = 7, col_names = Shukuhaku2020_09_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_09_TypeResidence)

Shukuhaku2020_09_TypeResidence$Prefecture <- as.character(Shukuhaku2020_09_TypeResidence$Prefecture)
Shukuhaku2020_09_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_09_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_09_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_09_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_09_TypeResidence)

Shukuhaku2020_09_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_09_TypeResidence
glimpse(Shukuhaku2020_09_TypeResidence)

Shukuhaku2020_09_TypeResidence <- subset(Shukuhaku2020_09_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_09_TypeResidence)

save(Shukuhaku2020_09_TypeResidence, file = "Shukuhaku2020_09_TypeResidence.RData")
write.csv(Shukuhaku2020_09_TypeResidence, file = "Shukuhaku2020_09_TypeResidence.csv", row.names = F)

#### 第10表　2020-10 ####
library(readxl)
Shukuhaku2020_10_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 128, skip = 7)
glimpse(Shukuhaku2020_10_TypeResidence)

Shukuhaku2020_10_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_10_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 128, skip = 7, col_names = Shukuhaku2020_10_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_10_TypeResidence)

Shukuhaku2020_10_TypeResidence$Prefecture <- as.character(Shukuhaku2020_10_TypeResidence$Prefecture)
Shukuhaku2020_10_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_10_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_10_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_10_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_10_TypeResidence)

Shukuhaku2020_10_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_10_TypeResidence
glimpse(Shukuhaku2020_10_TypeResidence)

Shukuhaku2020_10_TypeResidence <- subset(Shukuhaku2020_10_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_10_TypeResidence)

save(Shukuhaku2020_10_TypeResidence, file = "Shukuhaku2020_10_TypeResidence.RData")
write.csv(Shukuhaku2020_10_TypeResidence, file = "Shukuhaku2020_10_TypeResidence.csv", row.names = F)

#### 第10表　2020-11 ####
library(readxl)
Shukuhaku2020_11_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 129, skip = 7)
glimpse(Shukuhaku2020_11_TypeResidence)

Shukuhaku2020_11_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_11_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 129, skip = 7, col_names = Shukuhaku2020_11_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_11_TypeResidence)

Shukuhaku2020_11_TypeResidence$Prefecture <- as.character(Shukuhaku2020_11_TypeResidence$Prefecture)
Shukuhaku2020_11_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_11_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_11_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_11_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_11_TypeResidence)

Shukuhaku2020_11_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_11_TypeResidence
glimpse(Shukuhaku2020_11_TypeResidence)

Shukuhaku2020_11_TypeResidence <- subset(Shukuhaku2020_11_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_11_TypeResidence)

save(Shukuhaku2020_11_TypeResidence, file = "Shukuhaku2020_11_TypeResidence.RData")
write.csv(Shukuhaku2020_11_TypeResidence, file = "Shukuhaku2020_11_TypeResidence.csv", row.names = F)

#### 第10表　2020-12 ####
library(readxl)
Shukuhaku2020_12_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 130, skip = 7)
glimpse(Shukuhaku2020_12_TypeResidence)

Shukuhaku2020_12_TypeResidence_names <- c("Prefecture", "TotalNumberOfGuests", "FromThePrefecture", 
                                          "OutsideOfThePrefecture", "Ryokan", "Ryokan_FromThePrefecture",
                                          "Ryokan_OutsideOfThePrefecture", "ResortHotel","ResortHotel_FromThePrefecture", 
                                          "ResortHotel_OutsideOfThePrefecture", "BusinessHotel", "BusinessHotel_FromThePrefecture",
                                          "BusinessHotel_OutsideOfThePrefecture", "CityHotel", "CityHotel_FromThePrefecture",
                                          "CityHotel_OutsideOfThePrefecture", "SimpleLodging", "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture", 
                                          "AccommodationForCompaniesAndGroups", "AccommodationForCompaniesAndGroups_FromThePrefecture",
                                          "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")

Shukuhaku2020_12_TypeResidence <- read_excel("./data/shukuhaku2020.xlsx", sheet = 130, skip = 7, col_names = Shukuhaku2020_12_TypeResidence_names, n_max = 47)
glimpse(Shukuhaku2020_12_TypeResidence)

Shukuhaku2020_12_TypeResidence$Prefecture <- as.character(Shukuhaku2020_12_TypeResidence$Prefecture)
Shukuhaku2020_12_TypeResidence$Prefecture <- gsub("^.{0,3}", "", Shukuhaku2020_12_TypeResidence$Prefecture)
glimpse(Shukuhaku2020_12_TypeResidence)

PrefNames <- c("Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima",
               "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata",
               "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
               "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane",
               "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka",
               "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa")

Shukuhaku2020_12_TypeResidence$PrefectureEng <- PrefNames
glimpse(Shukuhaku2020_12_TypeResidence)

Shukuhaku2020_12_TypeResidence %>% 
  relocate(PrefectureEng, .after = Prefecture) -> Shukuhaku2020_12_TypeResidence
glimpse(Shukuhaku2020_12_TypeResidence)

Shukuhaku2020_12_TypeResidence <- subset(Shukuhaku2020_12_TypeResidence, select = -Prefecture)
glimpse(Shukuhaku2020_12_TypeResidence)

save(Shukuhaku2020_12_TypeResidence, file = "Shukuhaku2020_12_TypeResidence.RData")
write.csv(Shukuhaku2020_12_TypeResidence, file = "Shukuhaku2020_12_TypeResidence.csv", row.names = F)


# ACCOMMODATION DATA CLEANING ---------------------------------------------
load("./Shukuhaku2020_01.RData")
load("./Shukuhaku2020_02.RData")
load("./Shukuhaku2020_03.RData")
load("./Shukuhaku2020_04.RData")
load("./Shukuhaku2020_05.RData")
load("./Shukuhaku2020_06.RData")
load("./Shukuhaku2020_07.RData")
load("./Shukuhaku2020_08.RData")
load("./Shukuhaku2020_09.RData")
load("./Shukuhaku2020_10.RData")
load("./Shukuhaku2020_11.RData")
load("./Shukuhaku2020_12.RData")

data1 <- rep(c("2020-01"), 47)
Shukuhaku2020_1 %>% 
  mutate(Date = data1) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_1
Shukuhaku2020_1$Date <- as.Date(paste0(Shukuhaku2020_1$Date, "-01"))

data2 <- rep(c("2020-02"), 47)
Shukuhaku2020_2 %>% 
  mutate(Date = data2) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_2
Shukuhaku2020_2$Date <- as.Date(paste0(Shukuhaku2020_2$Date, "-01"))

merge(Shukuhaku2020_1, Shukuhaku2020_2, all = T) -> Shukuhaku2020_1_2

data3 <- rep(c("2020-03"), 47)
Shukuhaku2020_3 %>% 
  mutate(Date = data3) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_3
Shukuhaku2020_3$Date <- as.Date(paste0(Shukuhaku2020_3$Date, "-01"))

merge(Shukuhaku2020_1_2, Shukuhaku2020_3, all = T) -> Shukuhaku2020_1_3

data4 <- rep(c("2020-04"), 47)
Shukuhaku2020_4 %>% 
  mutate(Date = data4) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_4
Shukuhaku2020_4$Date <- as.Date(paste0(Shukuhaku2020_4$Date, "-01"))

merge(Shukuhaku2020_1_3, Shukuhaku2020_4, all = T) -> Shukuhaku2020_1_4

data5 <- rep(c("2020-05"), 47)
Shukuhaku2020_5 %>% 
  mutate(Date = data5) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_5
Shukuhaku2020_5$Date <- as.Date(paste0(Shukuhaku2020_5$Date, "-01"))

merge(Shukuhaku2020_1_4, Shukuhaku2020_5, all = T) -> Shukuhaku2020_1_5

data6 <- rep(c("2020-06"), 47)
Shukuhaku2020_6 %>% 
  mutate(Date = data6) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_6
Shukuhaku2020_6$Date <- as.Date(paste0(Shukuhaku2020_6$Date, "-01"))

merge(Shukuhaku2020_1_5, Shukuhaku2020_6, all = T) -> Shukuhaku2020_1_6

data7 <- rep(c("2020-07"), 47)
Shukuhaku2020_7 %>% 
  mutate(Date = data7) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_7
Shukuhaku2020_7$Date <- as.Date(paste0(Shukuhaku2020_7$Date, "-01"))

merge(Shukuhaku2020_1_6, Shukuhaku2020_7, all = T) -> Shukuhaku2020_1_7

data8 <- rep(c("2020-08"), 47)
Shukuhaku2020_8 %>% 
  mutate(Date = data8) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_8
Shukuhaku2020_8$Date <- as.Date(paste0(Shukuhaku2020_8$Date, "-01"))

merge(Shukuhaku2020_1_7, Shukuhaku2020_8, all = T) -> Shukuhaku2020_1_8

data9 <- rep(c("2020-09"), 47)
Shukuhaku2020_9 %>% 
  mutate(Date = data9) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_9
Shukuhaku2020_9$Date <- as.Date(paste0(Shukuhaku2020_9$Date, "-01"))

merge(Shukuhaku2020_1_8, Shukuhaku2020_9, all = T) -> Shukuhaku2020_1_9

data10 <- rep(c("2020-10"), 47)
Shukuhaku2020_10 %>% 
  mutate(Date = data10) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_10
Shukuhaku2020_10$Date <- as.Date(paste0(Shukuhaku2020_10$Date, "-01"))

merge(Shukuhaku2020_1_9, Shukuhaku2020_10, all = T) -> Shukuhaku2020_1_10

data11 <- rep(c("2020-11"), 47)
Shukuhaku2020_11 %>% 
  mutate(Date = data11) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_11
Shukuhaku2020_11$Date <- as.Date(paste0(Shukuhaku2020_11$Date, "-01"))

merge(Shukuhaku2020_1_10, Shukuhaku2020_11, all = T) -> Shukuhaku2020_1_11

data12 <- rep(c("2020-12"), 47)
Shukuhaku2020_12 %>% 
  mutate(Date = data12) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_12
Shukuhaku2020_12$Date <- as.Date(paste0(Shukuhaku2020_12$Date, "-01"))

merge(Shukuhaku2020_1_11, Shukuhaku2020_12, all = T) -> Shukuhaku2020_1_12

save(Shukuhaku2020_1_12, file = "./Clean Data/Shukuhaku2020.RData")
write.csv(Shukuhaku2020_1_12, file = "./Clean Data/Shukuhaku2020.csv", row.names = F)

# library(zoo)
# as.Date(as.yearmon("2020-01"))

Shukuhaku2020_1_12 %>% 
  rename(., Guests_Total = TotalNumberOfGuests, Guests_Prefecture = FromThePrefecture,
         Guests_OutsidePrefecture = OutsideOfThePrefecture) -> Shukuhaku2020

save(Shukuhaku2020, file = "./Clean Data/Shukuhaku2020.RData")
write.csv(Shukuhaku2020, file = "./Clean Data/Shukuhaku2020.csv", row.names = F)

# ACCOMMODATION DATA CLEANING: TypeResidence ------------------------------
load("./Shukuhaku2020_01_TypeResidenceResidence.RData")
load("./Shukuhaku2020_02_TypeResidenceResidence.RData")
load("./Shukuhaku2020_03_TypeResidenceResidence.RData")
load("./Shukuhaku2020_04_TypeResidenceResidence.RData")
load("./Shukuhaku2020_05_TypeResidenceResidence.RData")
load("./Shukuhaku2020_06_TypeResidenceResidence.RData")
load("./Shukuhaku2020_07_TypeResidenceResidence.RData")
load("./Shukuhaku2020_08_TypeResidenceResidence.RData")
load("./Shukuhaku2020_09_TypeResidenceResidence.RData")
load("./Shukuhaku2020_10_TypeResidenceResidence.RData")
load("./Shukuhaku2020_11_TypeResidenceResidence.RData")
load("./Shukuhaku2020_12_TypeResidenceResidence.RData")

data1 <- rep(c("2020-01"), 47)
Shukuhaku2020_01_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data1) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_01_TypeResidence
Shukuhaku2020_01_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_01_TypeResidence$Date, "-01"))
Shukuhaku2020_01_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_01_TypeResidence$AccommodationForCompaniesAndGroups)

data2 <- rep(c("2020-02"), 47)
Shukuhaku2020_02_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>%  
  mutate(Date = data2) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_02_TypeResidence
Shukuhaku2020_02_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_02_TypeResidence$Date, "-01"))
Shukuhaku2020_02_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_02_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_01_TypeResidence, Shukuhaku2020_02_TypeResidence, all = T) -> Shukuhaku2020_1_2_TypeResidence

# Shukuhaku2020_1$newcol <- as.Date(paste0(as.character(202001), '01'), format = '%Y%m%d')
# as.Date(paste0(data1, "-01"))

data3 <- rep(c("2020-03"), 47)
Shukuhaku2020_03_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data3) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_03_TypeResidence
Shukuhaku2020_03_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_03_TypeResidence$Date, "-01"))
Shukuhaku2020_03_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_03_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_2_TypeResidence, Shukuhaku2020_03_TypeResidence, all = T) -> Shukuhaku2020_1_3_TypeResidence

data4 <- rep(c("2020-04"), 47)
Shukuhaku2020_04_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data4) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_04_TypeResidence
Shukuhaku2020_04_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_04_TypeResidence$Date, "-01"))
Shukuhaku2020_04_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_04_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_3_TypeResidence, Shukuhaku2020_04_TypeResidence, all = T) -> Shukuhaku2020_1_4_TypeResidence

data5 <- rep(c("2020-05"), 47)
Shukuhaku2020_05_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data5) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_05_TypeResidence
Shukuhaku2020_05_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_05_TypeResidence$Date, "-01"))
Shukuhaku2020_05_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_05_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_4_TypeResidence, Shukuhaku2020_05_TypeResidence, all = T) -> Shukuhaku2020_1_5_TypeResidence

data6 <- rep(c("2020-06"), 47)
Shukuhaku2020_06_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data6) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_06_TypeResidence
Shukuhaku2020_06_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_06_TypeResidence$Date, "-01"))
Shukuhaku2020_06_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_06_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_5_TypeResidence, Shukuhaku2020_06_TypeResidence, all = T) -> Shukuhaku2020_1_6_TypeResidence

data7 <- rep(c("2020-07"), 47)
Shukuhaku2020_07_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data7) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_07_TypeResidence
Shukuhaku2020_07_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_07_TypeResidence$Date, "-01"))
Shukuhaku2020_07_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_07_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_6_TypeResidence, Shukuhaku2020_07_TypeResidence, all = T) -> Shukuhaku2020_1_7_TypeResidence

data8 <- rep(c("2020-08"), 47)
Shukuhaku2020_08_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data8) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_08_TypeResidence
Shukuhaku2020_08_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_08_TypeResidence$Date, "-01"))
Shukuhaku2020_08_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_08_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_7_TypeResidence, Shukuhaku2020_08_TypeResidence, all = T) -> Shukuhaku2020_1_8_TypeResidence

data9 <- rep(c("2020-09"), 47)
Shukuhaku2020_09_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data9) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_09_TypeResidence
Shukuhaku2020_09_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_09_TypeResidence$Date, "-01"))
Shukuhaku2020_09_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_09_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_8_TypeResidence, Shukuhaku2020_09_TypeResidence, all = T) -> Shukuhaku2020_1_9_TypeResidence

data10 <- rep(c("2020-10"), 47)
Shukuhaku2020_10_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data10) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_10_TypeResidence
Shukuhaku2020_10_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_10_TypeResidence$Date, "-01"))
Shukuhaku2020_10_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_10_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_9_TypeResidence, Shukuhaku2020_10_TypeResidence, all = T) -> Shukuhaku2020_1_10_TypeResidence

data11 <- rep(c("2020-11"), 47)
Shukuhaku2020_11_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data11) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_11_TypeResidence
Shukuhaku2020_11_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_11_TypeResidence$Date, "-01"))
Shukuhaku2020_11_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_11_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_10_TypeResidence, Shukuhaku2020_11_TypeResidence, all = T) -> Shukuhaku2020_1_11_TypeResidence

data12 <- rep(c("2020-12"), 47)
Shukuhaku2020_12_TypeResidence %>% 
  select(c("PrefectureEng", "Ryokan", "ResortHotel", "BusinessHotel",
           "CityHotel", "SimpleLodging", "AccommodationForCompaniesAndGroups",
           "Ryokan_FromThePrefecture", "Ryokan_OutsideOfThePrefecture",
           "ResortHotel_FromThePrefecture", "ResortHotel_OutsideOfThePrefecture",
           "BusinessHotel_FromThePrefecture", "BusinessHotel_OutsideOfThePrefecture",
           "CityHotel_FromThePrefecture", "CityHotel_OutsideOfThePrefecture",
           "SimpleLodging_FromThePrefecture", "SimpleLodging_OutsideThePrefecture",
           "AccommodationForCompaniesAndGroups_FromThePrefecture",
           "AccommodationForCompaniesAndGroups_OutsideOfThePrefecture")) %>% 
  mutate(Date = data12) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_12_TypeResidence
Shukuhaku2020_12_TypeResidence$Date <- as.Date(paste0(Shukuhaku2020_12_TypeResidence$Date, "-01"))
Shukuhaku2020_12_TypeResidence$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_12_TypeResidence$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_11_TypeResidence, Shukuhaku2020_12_TypeResidence, all = T) -> Shukuhaku2020_1_12_TypeResidence

Shukuhaku2020_1_12_TypeResidence %>% 
  rename(., Type_Ryokan = Ryokan, Type_Resort = ResortHotel, Type_Business = BusinessHotel,
         Type_City = CityHotel, Type_Simple = SimpleLodging,
         Type_CompaniesGroups = AccommodationForCompaniesAndGroups,
         Pref_Ryokan = Ryokan_FromThePrefecture, Out_Ryokan = Ryokan_OutsideOfThePrefecture,
         Pref_Resort = ResortHotel_FromThePrefecture, Out_Resort = ResortHotel_OutsideOfThePrefecture,
         Pref_Business = BusinessHotel_FromThePrefecture, Out_Business = BusinessHotel_OutsideOfThePrefecture,
         Pref_City = CityHotel_FromThePrefecture, Out_City = CityHotel_OutsideOfThePrefecture,
         Pref_Simple = SimpleLodging_FromThePrefecture, Out_Simple = SimpleLodging_OutsideThePrefecture,
         Pref_CompaniesGroups = AccommodationForCompaniesAndGroups_FromThePrefecture,
         Out_CompaniesGroups = AccommodationForCompaniesAndGroups_OutsideOfThePrefecture) -> Shukuhaku2020_1_12_TypeResidence

Shukuhaku2020$Date <- as.Date(Shukuhaku2020$Date)
Shukuhaku2020_1_12_TypeResidence$Date <- as.Date(Shukuhaku2020_1_12_TypeResidence$Date)
merge(Shukuhaku2020, Shukuhaku2020_1_12_TypeResidence, all = T) -> Shukuhaku2020_TR

glimpse(Shukuhaku2020_TR)

Shukuhaku2020_TR$Pref_CompaniesGroups <- as.numeric(Shukuhaku2020_TR$Pref_CompaniesGroups)
Shukuhaku2020_TR$Out_CompaniesGroups <- as.numeric(Shukuhaku2020_TR$Out_CompaniesGroups)

Shukuhaku2020_TR -> Shukuhaku2020

save(Shukuhaku2020, file = "./Clean Data/Shukuhaku2020.RData")
write.csv(Shukuhaku2020, file = "./Clean Data/Shukuhaku2020.csv", row.names = F)

# ACCOMMODATION DATA CLEANING: Occupancy ----------------------------------
load("./Shukuhaku2020_01_Occupancy.RData")
load("./Shukuhaku2020_02_Occupancy.RData")
load("./Shukuhaku2020_03_Occupancy.RData")
load("./Shukuhaku2020_04_Occupancy.RData")
load("./Shukuhaku2020_05_Occupancy.RData")
load("./Shukuhaku2020_06_Occupancy.RData")
load("./Shukuhaku2020_07_Occupancy.RData")
load("./Shukuhaku2020_08_Occupancy.RData")
load("./Shukuhaku2020_09_Occupancy.RData")
load("./Shukuhaku2020_10_Occupancy.RData")
load("./Shukuhaku2020_11_Occupancy.RData")
load("./Shukuhaku2020_12_Occupancy.RData")

data1 <- rep(c("2020-01"), 47)
Shukuhaku2020_01_Occupancy %>% 
  mutate(Date = data1) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_01_Occupancy
Shukuhaku2020_01_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_01_Occupancy$Date, "-01"))
Shukuhaku2020_01_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_01_Occupancy$NonTourists_over100)
Shukuhaku2020_01_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_01_Occupancy$AccommodationForCompaniesAndGroups)

data2 <- rep(c("2020-02"), 47)
Shukuhaku2020_02_Occupancy %>% 
  mutate(Date = data2) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_02_Occupancy
Shukuhaku2020_02_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_02_Occupancy$Date, "-01"))
Shukuhaku2020_02_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_02_Occupancy$NonTourists_over100)
Shukuhaku2020_02_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_02_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_01_Occupancy, Shukuhaku2020_02_Occupancy, all = T) -> Shukuhaku2020_1_2_Occupancy

data3 <- rep(c("2020-03"), 47)
Shukuhaku2020_03_Occupancy %>% 
  mutate(Date = data3) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_03_Occupancy
Shukuhaku2020_03_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_03_Occupancy$Date, "-01"))
Shukuhaku2020_03_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_03_Occupancy$NonTourists_over100)
Shukuhaku2020_03_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_03_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_2_Occupancy, Shukuhaku2020_03_Occupancy, all = T) -> Shukuhaku2020_1_3_Occupancy

data4 <- rep(c("2020-04"), 47)
Shukuhaku2020_04_Occupancy %>% 
  mutate(Date = data4) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_04_Occupancy
Shukuhaku2020_04_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_04_Occupancy$Date, "-01"))
Shukuhaku2020_04_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_04_Occupancy$NonTourists_over100)
Shukuhaku2020_04_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_04_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_3_Occupancy, Shukuhaku2020_04_Occupancy, all = T) -> Shukuhaku2020_1_4_Occupancy

data5 <- rep(c("2020-05"), 47)
Shukuhaku2020_05_Occupancy %>% 
  mutate(Date = data5) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_05_Occupancy
Shukuhaku2020_05_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_05_Occupancy$Date, "-01"))
Shukuhaku2020_05_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_05_Occupancy$NonTourists_over100)
Shukuhaku2020_05_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_05_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_4_Occupancy, Shukuhaku2020_05_Occupancy, all = T) -> Shukuhaku2020_1_5_Occupancy

data6 <- rep(c("2020-06"), 47)
Shukuhaku2020_06_Occupancy %>% 
  mutate(Date = data6) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_06_Occupancy
Shukuhaku2020_06_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_06_Occupancy$Date, "-01"))
Shukuhaku2020_06_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_06_Occupancy$NonTourists_over100)
Shukuhaku2020_06_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_06_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_5_Occupancy, Shukuhaku2020_06_Occupancy, all = T) -> Shukuhaku2020_1_6_Occupancy

data7 <- rep(c("2020-07"), 47)
Shukuhaku2020_07_Occupancy %>% 
  mutate(Date = data7) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_07_Occupancy
Shukuhaku2020_07_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_07_Occupancy$Date, "-01"))
Shukuhaku2020_07_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_07_Occupancy$NonTourists_over100)
Shukuhaku2020_07_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_07_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_6_Occupancy, Shukuhaku2020_07_Occupancy, all = T) -> Shukuhaku2020_1_7_Occupancy

data8 <- rep(c("2020-08"), 47)
Shukuhaku2020_08_Occupancy %>% 
  mutate(Date = data8) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_08_Occupancy
Shukuhaku2020_08_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_08_Occupancy$Date, "-01"))
Shukuhaku2020_08_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_08_Occupancy$NonTourists_over100)
Shukuhaku2020_08_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_08_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_7_Occupancy, Shukuhaku2020_08_Occupancy, all = T) -> Shukuhaku2020_1_8_Occupancy

data9 <- rep(c("2020-09"), 47)
Shukuhaku2020_09_Occupancy %>% 
  mutate(Date = data9) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_09_Occupancy
Shukuhaku2020_09_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_09_Occupancy$Date, "-01"))
Shukuhaku2020_09_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_09_Occupancy$NonTourists_over100)
Shukuhaku2020_09_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_09_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_8_Occupancy, Shukuhaku2020_09_Occupancy, all = T) -> Shukuhaku2020_1_9_Occupancy

data10 <- rep(c("2020-10"), 47)
Shukuhaku2020_10_Occupancy %>% 
  mutate(Date = data10) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_10_Occupancy
Shukuhaku2020_10_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_10_Occupancy$Date, "-01"))
Shukuhaku2020_10_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_10_Occupancy$NonTourists_over100)
Shukuhaku2020_10_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_10_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_9_Occupancy, Shukuhaku2020_10_Occupancy, all = T) -> Shukuhaku2020_1_10_Occupancy

data11 <- rep(c("2020-11"), 47)
Shukuhaku2020_11_Occupancy %>% 
  mutate(Date = data11) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_11_Occupancy
Shukuhaku2020_11_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_11_Occupancy$Date, "-01"))
Shukuhaku2020_11_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_11_Occupancy$NonTourists_over100)
Shukuhaku2020_11_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_11_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_10_Occupancy, Shukuhaku2020_11_Occupancy, all = T) -> Shukuhaku2020_1_11_Occupancy

data12 <- rep(c("2020-12"), 47)
Shukuhaku2020_12_Occupancy %>% 
  mutate(Date = data12) %>% 
  relocate(Date, .before = PrefectureEng) %>% 
  rename(., Prefecture = PrefectureEng) -> Shukuhaku2020_12_Occupancy
Shukuhaku2020_12_Occupancy$Date <- as.Date(paste0(Shukuhaku2020_12_Occupancy$Date, "-01"))
Shukuhaku2020_12_Occupancy$NonTourists_over100 <- as.numeric(Shukuhaku2020_12_Occupancy$NonTourists_over100)
Shukuhaku2020_12_Occupancy$AccommodationForCompaniesAndGroups <- as.numeric(Shukuhaku2020_12_Occupancy$AccommodationForCompaniesAndGroups)

merge(Shukuhaku2020_1_11_Occupancy, Shukuhaku2020_12_Occupancy, all = T) -> Shukuhaku2020_1_12_Occupancy

Shukuhaku2020_1_12_Occupancy %>% 
  rename(., Occupancy_Rate = CapacityOccupancyRate, Occupancy_Tourists = Over50TouristGuests,
         Occupancy_NonTourists = LessThan50TouristGuests, Occupancy_0to9 = `Occupancy_0-9`,
         Occupancy_Tourists_0to9 = `Tourists_0-9`, Occupancy_NonTourists_0to9 = `NonTourists_0-9`,
         Occupancy_10to19 = `Occupancy_10-19`, Occupancy_Tourists_10to19 = `Tourists_10-19`,
         Occupancy_NonTourists_10to19 = `NonTourists_10-19`, Occupancy_30to99 = `Occupancy_30-99`,
         Occupancy_Tourists_30to99 = `Tourists_30-99`, Occupancy_Tourists_over100 = Tourists_over100,
         Occupancy_NonTourists_over100 = NonTourists_over100,
         Occupancy_Ryokan = Ryokan, Occupancy_Resort = ResortHotel,
         Occupancy_Business = BusinessHotel, Occupancy_City = CityHotel,
         Occupancy_Simple = SimpleLodging,
         Occupancy_CompaniesGroups = AccommodationForCompaniesAndGroups) -> Shukuhaku2020_1_12_Occupancy

Shukuhaku2020_1_12_Occupancy %>%
  rename(., Occupancy_NonTourists_30to99 =  `NonTourists_30-99`) -> Shukuhaku2020_1_12_Occupancy

merge(Shukuhaku2020, Shukuhaku2020_1_12_Occupancy, all = T) -> Shukuhaku2020_OC

glimpse(Shukuhaku2020_OC)

Shukuhaku2020_OC -> Shukuhaku2020

save(Shukuhaku2020, file = "./Clean Data/Shukuhaku2020.RData")
write.csv(Shukuhaku2020, file = "./Clean Data/Shukuhaku2020.csv", row.names = F)

# DATA CLEANING FOR COMPARISON PLOTS --------------------------------------
library(dplyr)
library(ggplot2)
library(plotly)
library(lubridate)
getwd()
setwd("/Users/steph/Downloads/MGR")
load("./Clean Data/KouseiCovid2020.RData")
load("./Clean Data/Shukuhaku2020.RData")

KouseiCovid2020 %>% 
  mutate(Date = as.POSIXct(Date)) %>% 
  group_by(Prefecture, Date = lubridate::floor_date(Date, "month")) %>% 
  summarize(NewlyConfirmedCases = sum(NewlyConfirmedCases), NumberOfDeaths = sum(NumberOfDeaths),
            SevereCases = sum(SevereCases)) -> data1

Shukuhaku2020 %>% 
  mutate(Date = as.POSIXct(Date)) -> data2

data1 %>% mutate(Date = as_date(Date)) -> data1_2

data2 %>% mutate(Date = as_date(Date)) -> data2_2

merge(data1_2, data2_2, all = T) -> Covid_Shukuhaku2020

as.double(Covid_Shukuhaku2020$NewlyConfirmedCases) -> Covid_Shukuhaku2020$NewlyConfirmedCases
as.double(Covid_Shukuhaku2020$SevereCases) -> Covid_Shukuhaku2020$SevereCases
as.double(Covid_Shukuhaku2020$NumberOfDeaths) -> Covid_Shukuhaku2020$NumberOfDeaths

glimpse(Covid_Shukuhaku2020)

save(Covid_Shukuhaku2020, file = "./Clean Data/Covid_Shukuhaku2020.RData")
write.csv(Covid_Shukuhaku2020, file = "./Clean Data/Covid_Shukuhaku2020.csv", row.names = F)

# LOAD DATA ---------------------------------------------------------------
getwd()
setwd("/Users/steph/Downloads/MGR/GoToTravel")

library(dplyr)

# COVID-19 data
KouseiCovid2020 <- read.csv("./KouseiCovid2020.csv", sep = ",", header = T, fileEncoding = "utf8")
load("./KouseiCovid2020.RData")

# Accommodation data
Shukuhaku2020 <- read.csv("./Shukuhaku2020.csv", sep = ",", header = T, fileEncoding = "utf8")
load("./Shukuhaku2020.RData")

# COVID-19 + Accommodation data for comparison plots
Covid_Shukuhaku2020 <- read.csv("./Covid_Shukuhaku2020.csv", sep = ",", header = T, fileEncoding = "utf8")
load("./Clean Data/Covid_Shukuhaku2020.RData")
