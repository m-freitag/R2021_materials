# Header -----------------------------------------------------------------------
#
# Author: Markus Freitag
# GitHub: https://github.com/m-freitag
# Date: July 19, 2021
#
# Script Name: Session 5: Slides Script
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
  rio,
  patchwork,
  hrbrthemes,
  extrafont,
  RColorBrewer,
  palmerpenguins,
  gghalves,
  ggdist,
  here,
  lubridate,
  sf
)



# Building a Plot from Scratch -------------------------------------------------

unvotes <- import(here("Data", "UNVotes2.parquet"))

sessions <- unvotes %>%
  select(session, date) %>%
  group_by(session) %>%
  summarise(year = year(min(date)))

ideal <- import(here("Data", "ideal.csv"))
ideal <- left_join(ideal, sessions, by = "session")
ideal <- filter(ideal, iso3c %in% c("USA", "GBR", "FRA", "CHN", "RUS", "DEU"))


# Step 1: Specify aesthetic mapping --------------------------------------------

ggplot(data = ideal, 
       mapping = aes(x = year, 
                     y = IdealPointAll, 
                     color = iso3c)) 


# Step 2: Choose a geometry ----------------------------------------------------

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_point() 


# Step 3: Adding a line geom ---------------------------------------------------

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_point() +
  geom_line() 


# Step 4: Resize lines and points ----------------------------------------------

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_point(size = 2) + 
  geom_line(size = 1) 


# Step 5: Change color scale ---------------------------------------------------

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  scale_colour_brewer(palette = "Dark2")


# Step 6: x scale --------------------------------------------------------------

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(breaks = seq(1950, 2020, 10))


# Step 7: (optional) Facets ----------------------------------------------------

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(breaks = seq(1950, 2020, 10)) +
  facet_wrap(vars(iso3c), ncol = 1)


# Step 8: Labels ---------------------------------------------------------------

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(breaks = seq(1950, 2020, 10)) +
  labs(x = "Year", 
       y = "Ideal Point", 
       color = "Country", 
       title = "State foreign policy ideal points from 1946 to 2020", 
       subtitle = "Estimates based on votes in the UN General Assembly (Bailey et al. 2017)", 
       caption = "Higher values indicate more 'Western' ideal points.") 


# Step 9: Themes ---------------------------------------------------------------


ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(breaks = seq(1950, 2020, 10)) +
  labs(x = "Year",
       y = "Ideal Point",
       color = "Country",
       title = "State foreign policy ideal points from 1946 to 2020",
       subtitle = "Estimates based on votes in the UN General Assembly (Bailey et al. 2017)",
       caption = "Higher values indicate more 'Western' ideal points.") +
  hrbrthemes::theme_ipsum() # There are many ggplot themes, but I like this one atm.


# Step 10: Going wild - theme tuning -------------------------------------------

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(breaks = seq(1950, 2020, 10)) +
  labs(x = "\nYear",
       y = "Ideal Point",
       color = "Country",
       title = "State foreign policy ideal points from 1946 to 2020",
       subtitle = "Estimates based on votes in the UN General Assembly (Bailey et al. 2017)",
       caption = "Higher values indicate more 'Western' ideal points.") +
  hrbrthemes::theme_ipsum() +
  theme(text = element_text(colour = "#415564"), 
        plot.title = element_text(colour = "#415564"), 
        plot.subtitle = element_text(colour = "#415564"), 
        plot.background = element_rect(fill = "#f6f3f2", color = "#f6f3f2"), 
        panel.border = element_blank(), #<<
        axis.text = element_text(colour = "#415564"), 
        axis.title = element_text(colour = "#415564")) 


# Step 11: Going wild - Annotations --------------------------------------------

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(breaks = seq(1950, 2020, 10)) +
  labs(x = "\nYear",
       y = "Ideal Point",
       color = "Country",
       title = "State foreign policy ideal points from 1946 to 2020",
       subtitle = "Estimates based on votes in the UN General Assembly (Bailey et al. 2017)",
       caption = "Higher values indicate more 'Western' ideal points.") +
  hrbrthemes::theme_ipsum() +
  theme(text = element_text(colour = "#415564"),
        plot.title = element_text(colour = "#415564"),
        plot.subtitle = element_text(colour = "#415564"),
        plot.background = element_rect(fill = "#f6f3f2", color = "#f6f3f2"),
        panel.border = element_blank(),
        axis.text = element_text(colour = "#415564"),
        axis.title = element_text(colour = "#415564")) +
  annotate(geom = "curve", xend = 1990, yend = 0.7, x = 1983, y = 0.5, 
           curvature = -.3, arrow = arrow(length = unit(2, "mm")), color = "#415564") + 
  annotate(geom = "text", x = 1971, y = 0.37, label = "End of Cold War", hjust = "left", color = "#415564") + 
  annotate(geom = "curve", xend = 1994, yend = -1.7, x = 2003, y = -2.1, 
           curvature = -.4, arrow = arrow(length = unit(2, "mm")), color = "#415564") + 
  annotate(geom = "text", x = 2004, y = -2.1, label = "Post-Tianmen \nSquare", hjust = "left", color = "#415564") 


# Step 12: Fine tuning the legend and shapes -----------------------------------

ideal <- ideal %>% #<<
  mutate(iso3c = fct_relevel(iso3c, c("USA", "GBR", "FRA", "DEU", "RUS", "CHN"))) #<<

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c,
                     shape = iso3c)) + #<<
  geom_point(size = 2) +
  geom_line(size = 1) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(breaks = seq(1950, 2020, 10)) +
  labs(x = "\nYear",
       y = "Ideal Point",
       color = "Country",
       shape = "Country", #<<
       title = "State foreign policy ideal points from 1946 to 2020",
       subtitle = "Estimates based on votes in the UN General Assembly (Bailey et al. 2017)",
       caption = "Higher values indicate more 'Western' ideal points.") +
  hrbrthemes::theme_ipsum() +
  theme(text = element_text(colour = "#415564"),
        plot.title = element_text(colour = "#415564"),
        plot.subtitle = element_text(colour = "#415564"),
        plot.background = element_rect(fill = "#f6f3f2", color = "#f6f3f2"),
        panel.border = element_blank(),
        axis.text = element_text(colour = "#415564"),
        axis.title = element_text(colour = "#415564")) +
  annotate(geom = "curve", xend = 1990, yend = 0.7, x = 1983, y = 0.5,
           curvature = -.3, arrow = arrow(length = unit(2, "mm")), color = "#415564") +
  annotate(geom = "text", x = 1971, y = 0.37, label = "End of Cold War", hjust = "left", color = "#415564") +
  annotate(geom = "curve", xend = 1994, yend = -1.7, x = 2003, y = -2.1,
           curvature = -.4, arrow = arrow(length = unit(2, "mm")), color = "#415564") +
  annotate(geom = "text", x = 2004, y = -2.1, label = "Post-Tianmen \nSquare", hjust = "left", color = "#415564")



# Alternative "Legend" ---------------------------------------------------------

ideal_fin <- filter(ideal, year == 2020) #<<

ggplot(data = ideal,
       mapping = aes(x = year,
                     y = IdealPointAll,
                     color = iso3c)) +
  geom_line(size = 1) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(breaks = seq(1950, 2020, 10)) +
  labs(x = "\nYear",
       y = "Ideal Point",
       color = "Country",
       title = "State foreign policy ideal points from 1946 to 2020",
       subtitle = "Estimates based on votes in the UN General Assembly (Bailey et al. 2017)",
       caption = "Higher values indicate more 'Western' ideal points.") +
  hrbrthemes::theme_ipsum() +
  theme(text = element_text(colour = "#415564"),
        plot.title = element_text(colour = "#415564"),
        plot.subtitle = element_text(colour = "#415564"),
        plot.background = element_rect(fill = "#f6f3f2", color = "#f6f3f2"),
        panel.border = element_blank(),
        axis.text = element_text(colour = "#415564"),
        axis.title = element_text(colour = "#415564"),
        legend.position = "none", #<<
        axis.text.y.right = element_text(margin = margin(0, 0, 0, -20))) + #<<
  annotate(geom = "curve", xend = 1990, yend = 0.7, x = 1983, y = 0.5,
           curvature = -.3, arrow = arrow(length = unit(2, "mm")), color = "#415564") +
  annotate(geom = "text", x = 1971, y = 0.37, label = "End of Cold War", hjust = "left", color = "#415564") +
  annotate(geom = "curve", xend = 1994, yend = -1.7, x = 2003, y = -2.1,
           curvature = -.4, arrow = arrow(length = unit(2, "mm")), color = "#415564") +
  annotate(geom = "text", x = 2004, y = -2.1, label = "Post-Tianmen \nSquare", hjust = "left", color = "#415564") +
  scale_y_continuous(sec.axis = dup_axis(breaks = ideal_fin$IdealPointAll, labels = c("USA", "GBR", "FRA", "DEU", "RUS", "CHN"), name = NULL)) #<<


theme_set(hrbrthemes::theme_ipsum())


# ggsave("ideal_points.png", width = 9, height = 7)


# More examples: Amounts, Props and Distributions ------------------------------

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(alpha = 0.8) +
  scale_fill_brewer(palette = "Dark2")


ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(alpha = 0.8) +
  scale_fill_brewer(palette = "Dark2") +
  facet_wrap(~species, ncol = 1) + #<<
  coord_flip() + #<<
  theme(legend.position = "none") #<<


ggplot(penguins, aes(x = species, y = flipper_length_mm)) +
  geom_point(alpha = 0.6,
             aes(color = species),
             show.legend = FALSE) +
  scale_color_brewer(palette = "Dark2")


set.seed(213)
ggplot(penguins, aes(x = species, y = flipper_length_mm, color = species)) + #<<
  geom_point(alpha = 0.6, #<<
             show.legend = FALSE,
             position = position_jitter(seed = 213, width = .1)) + #<<
  scale_color_brewer(palette = "Dark2")


set.seed(213)
penguins2 <- filter(penguins, flipper_length_mm != is.na(flipper_length_mm))
ggplot(penguins2, aes(x = species, y = flipper_length_mm, color = species)) +
  ggdist::stat_halfeye(adjust = .5, #<<
                       width = .6, #<<
                       .width = 0, #<<
                       justification = -.3, #<<
                       point_colour = NA, #<<
                       aes(fill = species)) + #<<
  geom_boxplot(width = .2, #<<
               outlier.shape = NA, fill = "#f6f3f2") + #<<
  geom_point(alpha = 0.3, #<<
             position = position_jitter(seed = 213, width = .1)) +
  scale_color_brewer(palette = "Dark2") +
  scale_fill_brewer(palette = "Dark2") + #<<
  theme(legend.position = "none") + #<<
  coord_flip() #<<



set.seed(213)
penguins2 <- filter(penguins, flipper_length_mm != is.na(flipper_length_mm))

penguins2 <- penguins2 %>% #<<
  group_by(species) %>% #<<
  mutate(n = n()) %>% #<<
  ungroup() %>% #<<
  mutate(spec_n = paste0(species, " \n(n = ", n, ")")) #<<

ggplot(penguins2, aes(x = spec_n, y = flipper_length_mm, color = spec_n)) +
  ggdist::stat_halfeye(adjust = .7,
                       width = .6,
                       .width = 0,
                       justification = -.3,
                       point_colour = NA,
                       alpha = 0.6,
                       aes(fill = spec_n)) +
  geom_boxplot(width = .2,
               outlier.shape = NA, fill = "#f6f3f2") +
  geom_point(alpha = 0.3, #<<
             position = position_jitter(seed = 213, width = .1)) +
  scale_color_brewer(palette = "Dark2") +
  scale_fill_brewer(palette = "Dark2") +
  theme(legend.position = "none") +
  coord_flip() +
  labs(title = "Flipper Length of Brush-Tailed Penguins", #<<
       x = "", #<<
       y = "\nFlipper Length (mm)") #<<



ggplot(penguins, aes(x = flipper_length_mm, fill = species, color = species)) +
  geom_density(alpha = 0.3, adjust = .7) +
  labs(title = "Flipper Length of Brush-Tailed Penguins", #<<
       x = "\nFlipper Length (mm)") + #<<
  scale_fill_brewer(palette = "Dark2") +
  scale_color_brewer(palette = "Dark2")


# Maps -------------------------------------------------------------------------

ger_map <- sf::read_sf(here("Data", ".shapes", "VG250_GEM.shp"))
elec_res <- rio::import(here("Data", "bundeswahlleiter_17.rds"))
afd_plot <- dplyr::left_join(ger_map, elec_res, by = c("AGS" = "ags"))


ggplot(afd_plot) +
  geom_sf(aes(fill = afd_share),
          size = 0.1,
          color = "#415564") +
  scale_fill_gradient(low = "#f6f4f2",
                      high = "#014980") +
  labs(title = "AfD Vote Share: 2017 Federal Elections",
       subtitle = "Municipal-Level Data",
       fill = "AfD Vote Share (%)",
       caption = "Source: Bundeswahlleiter; Shapefiles: https://www.govdata.de/.")




# Patchwork --------------------------------------------------------------------

p1 <- ggplot(data = penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(aes(color = species, shape = species), size = 2)

p2 <- ggplot(data = penguins, aes(x = flipper_length_mm)) +
  geom_histogram(aes(fill = species), alpha = 0.5, position = "identity")

p1 / p2




