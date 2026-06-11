#### Preamble ####
# Purpose: Follow along with the examples in week 6 lecture slides
# Author: Inessa De Angelis
# Date: 11 June 2026
# Contact: inessa.deangelis@mail.utoronto.ca 
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
## Load packages ##
library(tidyverse) 

## Load datasets ##
# Bluesky datasets were downloaded from: https://github.com/InessaDeAngelis/Cdn_MPs_Bluesky

# MP dataset #
mps_bluesky <- read_csv("Week_6/lecture_data/cdn_mps_bluesky.csv")

# Post dataset #
bluesky_posts <- read_csv("Week_6/lecture_data/bluesky_posts.csv")

# Simulated subway delays dataset #
delays <- read_csv("Week_6/lecture_data/delays.csv")

#### EDA of subway delays ####
## Generate descriptive statistics ##
delays |>
  summarize(
    mean_delay = mean(delay_min),
    median_delay = median(delay_min),
    sd_delay = sd(delay_min),
    max_delay = max(delay_min))

## Plot! ##
ggplot(delays, aes(x = delay_min)) +
  geom_histogram(bins = 40, fill = "tomato") +
  labs(x = "Delays (minutes)", y = "Number of delays")

## Plot with a log scale ##
delays |>
  filter(delay_min > 0) |>
  ggplot(aes(x = delay_min)) +
  geom_histogram(bins = 40, fill = "tomato") +
  scale_x_log10() +
  labs(x = "Delays (minutes)", y = "Number of delays")

#### Join together MP and post datasets using "left_join()" ####
both <- bluesky_posts |> 
  left_join(mps_bluesky, by = join_by(author_handle==username))

## View first six rows of the joined dataset using "head()" ##
head(both)

## Using "select()" in conjunction with "left_join()" ##
both2 <- bluesky_posts |>  
  left_join(mps_bluesky |> select(username, gender, political_affiliation),
            join_by(author_handle==username))

#### EDA of Bluesky data ####
## Check that the "date" variable is the correct class ##
class(both$date_posted)

## Posts over time ##
both |>
  count(date_posted) |>
  ggplot(aes(x = date_posted, y = n)) +
  scale_x_date(date_breaks = "2 day", date_labels = "%b %d") +
  geom_line()

## Posts by classification over time ##
both |>
  count(date_posted, classification) |>
  ggplot(aes(x = date_posted, y = n, fill = classification)) +
  geom_col(position = "stack") +
  scale_x_date(date_breaks = "2 day", date_labels = "%b %d") +
  labs(x = "Date", y = "Number of posts")

## Posts by MP gender over time ##
both |>
  count(date_posted, gender) |>
  ggplot(aes(x = date_posted, y = n, fill = gender)) +
  geom_col(position = "dodge") +
  scale_x_date(date_breaks = "2 day", date_labels = "%b %d") +
  labs(x = "Date", y = "Number of posts", fill = "Gender")

## Posts by MP political affiliation over time ##
both |>
  count(date_posted, political_affiliation) |>
  ggplot(aes(x = date_posted, y = n, color = political_affiliation)) +
  scale_x_date(date_breaks = "2 day", date_labels = "%b %d") +
  geom_line()

## Posts by the province/territory that MPs' ridings are in over time ##
both |>
  count(province_territory) |>
  ggplot(aes(x = reorder(province_territory, n), y = n)) +
  geom_col() +
  coord_flip() + # flips the y and x axes
  labs(y = "Number of posts", x = "Province/territory")
