#### Preamble ####
# Purpose: Follow along with the examples in week 3 lecture slides
# Author: Inessa De Angelis
# Date: 21 May 2026
# Contact: inessa.deangelis@mail.utoronto.ca 
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
## Install packages (only if not done yet) ##
install.packages("tidyverse")
install.packages("canlang")
install.packages("gapminder")
install.packages("patchwork")

## Load packages ##
library(tidyverse) # Note: key packages like tidyr, dplyr, and ggplot2 are loaded as part of the tidyverse
library(canlang)
library(gapminder)
library(patchwork)

## Read in example datasets ##
mps_twitter <- read_csv("Week_3/data/mps_twitter.csv")
interjections_by_year <- read_csv("Week_3/data/interjections_by_year.csv")

#### Tidy data example ####
mps_twitter |> 
  pivot_longer(cols = c(Tweets_Jan, Tweets_Feb, Tweets_Mar),
               names_to = "Month", 
               values_to = "Tweets", 
               names_prefix = "Tweets_")

#### canlang: select() example ####
## Selecting 3 columns ##
can_lang |>
  select(category, language, mother_tongue)

## Removing 1 column ##
can_lang |>
  select(-mother_tongue)

## Removing 2 columns ##
can_lang |>
  select(-c(mother_tongue, lang_known))

## Select columns that meet a certain condition ##
can_lang |>
  select(starts_with("most"))

#### canlang: filter() example ####
## Just include 1 language ##
can_lang |>
  filter(category == "Aboriginal languages")

## By certain 2 conditions ##
can_lang |>
  filter(category == "Aboriginal languages" & language == "Cree, n.o.s.")

#### canlang: filter() & select() example ####
can_lang |>
  filter(category == "Official languages") |>
  select(category, language, mother_tongue)

#### canlang: arrange() example ####
## Arrange - ascending ##
can_lang |>
  arrange(mother_tongue) 

## Arrange - descending ##
can_lang |>
  arrange(desc(mother_tongue))

#### canlang: mutate() example ####
## Add a new "total_use" column ##
can_lang |>
  mutate(total_use = most_at_home + most_at_work) 

## Add a new column at a specific place ##
can_lang |>
  mutate(total_use = most_at_home + most_at_work, .before = "most_at_home") 

#### canlang: summarize() example ####
can_lang |>
  group_by(category) |>
  summarize(total_speakers = sum(mother_tongue))

#### canlang: rename() example ####
can_lang |>
  rename(language_known = lang_known)

#### Data types and structure #### 
## Check types of data for a whole dataset ##
str(can_lang)

## Check types of data for a specific variable in a dataset ##
class(can_lang$mother_tongue)

#### Data visualization: interruptions bar chart ####
## Make original graph ##
interjections_by_year |>
  ggplot(aes(x = year, y = n)) +
  geom_col() +
  theme_minimal() +
  labs( 
    x = "Year",
    y = "Number of interjections",
    title = "Interjections in the Australian House of Representatives from 1998-2025")

## Update x-axis and y-axis ticks ##
interjections_by_year |>
  ggplot(aes(x = year, y = n)) +
  geom_col() +
  theme_minimal() +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 16)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 6)) +
  labs( 
    x = "Year",
    y = "Number of interjections",
    title = "Interjections in the Australian House of Representatives from 1998-2025")

#### Data visualization: scatter plots ####
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) +
  labs(x = "GDP per Capita (US Dollars)", y = "Life Expectancy (Years)", 
       caption = "Data source: Gapminder")

#### Data visualization: line plots ####
gapminder |>
  filter(country == "Canada") |>
  ggplot(aes(x = year, y = lifeExp)) +
  geom_line() +
  labs(x = "Year", y = "Life Expectancy (Years)", caption = "Data source: Gapminder")

#### Data visualization: histograms ####
ggplot(gapminder, aes(x = lifeExp)) +
  geom_histogram(binwidth = 5) +
  labs(x = "Life Expectancy (Years)", y = "Number of Observations (Country-Year Cases)", 
       caption = "Data source: Gapminder")

#### Data visualization: boxplots ####
ggplot(gapminder, aes(x = continent, y = lifeExp)) +
  geom_boxplot() +
  labs(x = "Continent", y = "Life Expectancy (Years)", caption = "Data source: Gapminder")

#### Data visualization: patchwork package ####
## Make B&W theme graph ##
theme_bw <- interjections_by_year |>
  ggplot(aes(x = year, y = n)) +
  geom_col(fill = "#B0AFFF") +
  theme_bw() +
  labs(x = "Year", y = "Number of interjections", caption = "theme_bw()")

## Make classic theme graph ##
theme_classic <- interjections_by_year |>
  ggplot(aes(x = year, y = n)) +
  geom_col(fill = "#B0AFFF") +
  theme_classic() +
  labs(x = "Year", y = "Number of interjections", caption = "theme_classic()")

## Make dark theme graph ##
theme_dark <- interjections_by_year |>
  ggplot(aes(x = year, y = n)) +
  geom_col(fill = "#B0AFFF") +
  theme_dark() +
  labs(x = "Year", y = "Number of interjections", caption = "theme_dark()")

## Make minimal theme graph ##
theme_minimal <- interjections_by_year |>
  ggplot(aes(x = year, y = n)) +
  geom_col(fill = "#B0AFFF") +
  theme_minimal() +
  labs(x = "Year", y = "Number of interjections", caption = "theme_minimal()")

## Bring all graphs together into one ##
theme_minimal + theme_classic + theme_bw + theme_dark
