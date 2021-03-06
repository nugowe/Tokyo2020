library(gt)
library(countrycode)
library(ggflags)
library(rvest)
library(polite)
library(dplyr)
library(magrittr)
library(purrr)
library(kableExtra)
library(bbplot)
library(magick)
library(hrbrthemes)

url <- "https://olympics.com/tokyo-2020/olympic-games/en/results/all-sports/medal-standings.htm"


session = bow(user_agent = "Linkedin Olympic Webscrape", url)

Tokyo2020 <- scrape(session) %>% html_nodes("div#medal_standing") %>% html_table()

Tokyo2020 <- as.data.frame(Tokyo2020)

Tokyo2020 <- Tokyo2020 %>% slice(1:12)

names(Tokyo2020)[2] <- "Teams"
names(Tokyo2020)[3] <- "Gold"
names(Tokyo2020)[4] <- "Silver"
names(Tokyo2020)[5] <- "Bronze"
Tokyo2020$Flags <- ""

Tokyo2020 <- Tokyo2020 %>% select(c(1,2,9,3:8))

Tokyo <- data.frame(Tokyo2020$Total, y = Tokyo2020$Rank, country = c("cn", "us", "jp", "ru", "gb", "au", "de", "nl", "it", "fr", "nz", "br", "hu", "ca", "kp", "cu", "pl", "cz", "no", "jm"))

names(Tokyo)[1] <- "TotalMedals"
names(Tokyo)[2] <- "MedalRank"



ggplot(Tokyo, aes(x = Tokyo$country, y = Tokyo$TotalMedals, country=country, fill = "green")) + geom_col(fill = Tokyo$MedalRank) + geom_flag()  + scale_country()  + scale_y_discrete(limits = rev) + theme_bw(base_family = 12, base_size = 12) + xlab("Country codes | iso-2") + ylab("Total Medals earned per Country") + ggtitle("Tokyo2020 | Total Medals Earned per Country") + coord_flip() + labs(caption = "datasource:olympics.com")

uefalogo <- image_read_svg("https://upload.wikimedia.org/wikipedia/en/1/1d/2020_Summer_Olympics_logo_new.svg")

grid::grid.raster(uefalogo, x = 1, y = 0.07, just = c('right', 'bottom'), width = unit(1, 'inches'))
