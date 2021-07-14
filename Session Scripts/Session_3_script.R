# Header -----------------------------------------------------------------------
#
# Author: Markus Freitag
# GitHub: https://github.com/m-freitag
# Date: July 12, 2021
#
# Script Name: Session 03 Slides Script
#
# Script Description:
#
#
# Notes:
#
#

# Install Packages and Load Libraries ------------------------------------------

pacman::p_load(
  tidyverse,
  data.table,
  rio,
  patchwork,
  DT,
  modelsummary,
  collapse,
  forcats

)

# The Philosophy: Tidy Data ----------------------------------------------------

lotr <- data.frame(
  race = c("hobbits", "hobbits", "elves", "hobbits", "dwarves", "men"),
  character = c("Frodo", "Sam", "Arwen", "Golum", "Gimli", "Eowyn"),
  gender = c("male", "male", "female", "male", "male", "female"),
  `age_0-100` = c(1,1,0,0,0,1),
  `age_100-500` = c(0,0,0,0,1,0),
  `age_500-100` = c(0,0,0,1,0,0),
  `age_>1000` = c(0, 0, 1, 0, 0, 0), 
  check.names = FALSE
)
lotr

lotr <- lotr %>%
  pivot_longer(4:7, names_to = "age_cat", values_to = "classifier") %>%
  filter(classifier == 1) %>%
  select(-classifier) %>%
  mutate(age_cat = str_remove(age_cat, "age_"))

as.data.frame(lotr)



# Tibbles ----------------------------------------------------------------------

as_tibble(lotr)
# Hint: You can create tibbles just like data frames but with tibble().


# Importing/Exporting Data -----------------------------------------------------

# install.packages("rio")

# library(rio)

# Export
export(mtcars, "mtcars.csv") # R's built-in mtcars data-set.
export(mtcars, "mtcars.rds") # R serialized
export(mtcars, "mtcars.dta") # Stata
export(mtcars, "mtcars.json")

# Import
W <- import("mtcars.csv")
X <- import("mtcars.rds")
Y <- import("mtcars.dta")
Z <- import("mtcars.json")

# Exporting/importing several data frames: export_list()/import_list()

# Make a list of two built-in data sets.
# tibble::lst() automatically names the elements:
df_list <- tibble::lst(mtcars, iris)

export_list(df_list, file = paste0(names(df_list), ".csv"))
# export_file takes a character vector; hence, we build one from the names of our element
# With the paste0() we paste ".csv" to every element of the character vector
# produced by names(df_list).

Z <- import_list(dir(pattern = "csv$"))
# import_file takes achr vector holding file paths/files.
# With dir() we get all names of the files that match a specific pattern (regular expression). 
# In this case, all files that end with csv ($ matches the end of the string).[1]


# Pipes: %>% and |> ------------------------------------------------------------

x <- c(1, 2, 3, 4)

sqrt(mean(x))

x %>%
  mean() %>%
  sqrt()


"Ceci n&#37;est pas une pipe" %>% gsub("&#37;", "'", .)
# gsub() performs replacement of all matches in a chr. vector.


x |>
mean() |>
sqrt()


Sys.setenv("_R_USE_PIPEBIND_" = "true")
"Ceci n&#37;est pas une pipe" |> . => gsub("&#37;", "'", .)



# The Data ---------------------------------------------------------------------

parlgov_elec <- import("http://www.parlgov.org/static/data/development-cp1252/view_election.csv")


glimpse(parlgov_elec) # enhanced version of str()


head(parlgov_elec, 10)

# datasummary_skim(parlgov_elec) # from modelsummary package. Set 
# type = "categorical" for character vars.

# Of course, not super informative in our hierarchical data set:

datasummary_skim(parlgov_elec)


# Filtering Rows ---------------------------------------------------------------

parlgov_elec_de <- parlgov_elec %>% # add, e.g., _de if we want to keep our original df 
  filter(country_name_short == "DEU")


parlgov_elec_de %>% # add, e.g., _de if we want to keep our original df
  filter(party_name_short == "SPD", election_type == "parliament") %>%
  mean(vote_share)


# pull() -----------------------------------------------------------------------

parlgov_elec_de %>% # add, e.g., _de if we want to keep our original df
  filter(party_name_short == "SPD", election_type == "parliament") %>%
  pull(vote_share) %>% 
  mean()

# summarise() ------------------------------------------------------------------

parlgov_elec_de %>%
  filter(party_name_short == "SPD", election_type == "parliament") %>%
  summarise(mean(vote_share)) # summarise() takes summary functions such as mean(), sd(), etc.


parlgov_elec_de %>%
  filter(party_name_short == "SPD", election_type == "parliament") %>%
  summarise(mean = mean(vote_share), sd = sd(vote_share), n = n())

# Aside: you can also get the number of rows (in a group) by using the base 
# function nrow(.) with a placeholder in the above pipe.


# mutate() ---------------------------------------------------------------------

parlgov_elec_de <- parlgov_elec_de %>% # here, we "overwrite" our df
  mutate(year = lubridate::year(election_date))



# select() and arrange() -------------------------------------------------------

parlgov_elec_de %>%
  filter(year == 2017) %>%
  select(party_name_short, vote_share, left_right) %>% 
  arrange(desc(left_right)) #default is ascending; we can wrap the masked vector 
  # with desc() to sort descending



# group_by() -------------------------------------------------------------------

parlgov_elec %>%
  filter(election_type == "parliament") %>% 
  group_by(country_name_short) %>%
  summarise(share_max = max(vote_share, na.rm = T), 
            party = party_name_english[1],
            election_date = election_date[1]
            ) %>%  # note the "collapsing" I mentioned earlier
  arrange(desc(share_max))



parlgov_elec <- parlgov_elec %>%
  group_by(country_id) %>%
  mutate(max_seats = max(seats_total)) %>%
  ungroup() # to remove the grouping


parlgov_elec %>%
  filter(seats_total == max_seats) %>%
  select(country_name_short, election_date, max_seats) %>%
  distinct() # select distinct rows


# forcats ----------------------------------------------------------------------

parlgov_elec_de %>%
  mutate(election_type = fct_recode(election_type, # Coerces the type automatically from chr to fct.
    Bundestagswahl = "parliament",
    Europawahl = "ep"
  )) %>%
  count(election_type)



# if_else() and case_when() ----------------------------------------------------

parlgov_elec_de <- parlgov_elec_de %>%
  mutate(family = if_else(left_right > 5, "right", "left"))


parlgov_elec_de <- parlgov_elec_de %>%
  mutate(family = case_when(
    left_right <= 2.5 ~ "left",
    left_right > 2.5 & left_right < 5 ~ "centre-left",
    left_right > 5 & left_right < 7.5 ~ "centre-right",
    left_right >= 7.5 ~ "right"))


# pivot_wider() and pivot_longer() ---------------------------------------------

wide <- parlgov_elec_de %>%
  filter(election_type == "parliament", vote_share >= 5, year(election_date) >= 1945) %>%
  select(election_date, party_name_short, vote_share) %>%
  pivot_wider(names_from = party_name_short, values_from = vote_share)

wide


long <- wide %>%
  pivot_longer(!election_date, names_to = "party_name_short", values_to = "vote_share") %>%
  filter(is.na(vote_share) == FALSE) # alternatively, simply set values_drop_na to TRUE in pivot_longer().

head(long)


# joins ------------------------------------------------------------------------

parlgov_party <- rio::import("http://www.parlgov.org/static/data/development-utf-8/view_party.csv")

l_joined <- left_join(parlgov_elec_de, parlgov_party, by = "party_id")

head(l_joined)



l_joined <- left_join(parlgov_elec_de, parlgov_party)

head(l_joined)


# data.table -------------------------------------------------------------------

parlgov_elec_de %>% # add, e.g., _de if we want to keep our original df
  filter(party_name_short == "SPD") %>%
  summarise(mean(vote_share, na.rm = T))

setDT(parlgov_elec_de)

parlgov_elec_de[party_name_short == "SPD", mean(vote_share, na.rm = T)]
  

