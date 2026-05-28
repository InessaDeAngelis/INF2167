#### Preamble ####
# Purpose: Follow along with the examples in week 4 lecture slides
# Author: Inessa De Angelis
# Date: 28 May 2026
# Contact: inessa.deangelis@mail.utoronto.ca 
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
## Install packages (only if not done yet) ##
install.packages("tidyverse")
install.packages("palmerpenguins")
install.packages("cesR")
install.packages("labelled")

## Load packages ##
library(tidyverse) 
library(palmerpenguins)
library(cesR)
library(labelled)

#### Sampling and penguins examples ####
## Get a random sample of 40 observations ##
set.seed(16)

penguin_sample <- penguins |>
  slice_sample(n = 40)

## Full dataset ##
mean(penguins$body_mass_g, na.rm = TRUE)

## Sample ##
mean(penguin_sample$body_mass_g, na.rm = TRUE)

#### Canadian Election Study (CES) example ####
## Get the dataset ##
get_ces("ces2019_web")

## Select variables of interest (referencing the codebook) ##
# Codebook: https://dimension.usherbrooke.ca/documents/CES2019Codebook.pdf
raw_ces2019_web <- ces2019_web |>
  select(cps19_ResponseId,
         cps19_gender,
         cps19_duty_choice)

## Factor dataset to convert labelled variables into factors with readable category labels ##
raw_ces2019_web <- to_factor(raw_ces2019_web)

## Save raw dataset (important!) ##
write_csv(x = raw_ces2019_web, file = "raw_ces_data.csv")

## View raw dataset ##
head(raw_ces_data)

## Rename columns and re-code variables ##
cleaned_ces_data <- raw_ces_data |>
  rename(ID = cps19_ResponseId,
         Gender = cps19_gender,
         Voting_duty_choice = cps19_duty_choice) |>
  mutate(
    Gender = case_when(
      Gender == "A man" ~ "Man",
      Gender == "A woman" ~ "Woman",
      Gender == "Other (e.g. Trans, non-binary, two-spirit, gender-queer)" ~ "Other",
      TRUE ~ Gender)) |>
  select(ID, Gender, Voting_duty_choice)

## Save cleaned dataset ##
write_csv(x = cleaned_ces_data, file = "cleaned_ces_data.csv")

## Descriptive stats: views on voting by gender ##
cleaned_ces_data |>
  group_by(Gender, Voting_duty_choice) |>
  count() |>
  ungroup() |>
  group_by(Gender) |>
  mutate(percentage = round(n / sum(n) * 100, 2)) |>
  arrange(desc(n))
