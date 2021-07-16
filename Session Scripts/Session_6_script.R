# Header -----------------------------------------------------------------------
#
# Author: Markus Freitag
# GitHub: https://github.com/m-freitag
# Date: July 19, 2021
#
# Script Name: Session 6: Slides Script
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
  modelsummary,
  collapse,
  forcats,
  hrbrthemes,
  palmerpenguins,
  purrr
)


# Function Example -------------------------------------------------------------

fun <- function(x = 3) { # we can specify a default value
  intermediate <- (2 * x + 3) / sqrt(3)
  output <- data.frame(input = x, output = intermediate)
  return(output) # good practice
}

fun()

fun(2)

# Scoping ----------------------------------------------------------------------

x = 7

fun()


# Control Flow -----------------------------------------------------------------

fun("hello")

fun <- function(x = 3) { 

  if (is.numeric(x)) {
  
  intermediate <- (2 * x + 3) / sqrt(3)
  output <- data.frame(input = x, output = intermediate)
  return(output)
  
  } else {

  stop("The input you provide has to be numeric.")   

  }
}

fun("hello")


set.seed(666)

x <- rnorm(10)

if (x < 0) {
  "negative"
} else {
  "positive"
}


nested <- function(z = NULL) { # setting default to NULL
  
  y <- vector(mode = "character", length = 10) # initialise, e.g., an empty vector; preallocate memory
# y <- NULL This works too, but R has to grow, copy, paste and allocate memory at each step. This is slow. 

  for (i in 1:length(z)) { # We can reference the element with whatever name, i is just convention.

    if (z[i] < 0) {
      y[i] <- "negative"
    } else {
      y[i] <- "positive"
    }
  }
  
  return(y)

}

nested(z = x)


vectorized <- function(z = NULL) { 

  ifelse(x < 0, "negative", "positive")

}

vectorized(z = x)



# Vectorization ----------------------------------------------------------------

fun <- function(x = 3) { 
  intermediate <- (2 * x + 3) / sqrt(3)
  output <- data.frame(input = x, output = intermediate)
  return(output) 
}

fun(c(1,2,3))



# Functionals ------------------------------------------------------------------

is_positive <- function(z) {
    if (z < 0) {
      "negative"
    } else {
      "positive"
    }
}

purrr::map_chr(x, is_positive)


purrr::map_df(penguins, mean, na.rm = TRUE)

penguins %>%
  summarise(across(.cols = everything(), mean, na.rm = TRUE))


purrr::map_df(penguins, function(x) is.numeric(x))


penguins %>%
  select(function(x) is.numeric(x)) %>%
  head(1)


purrr::map_df(penguins, ~ is.numeric(..1))


# Example: Functionals and Plotting --------------------------------------------

penguin_scatter <- function(df, x, y, color = NULL, shape = NULL) {

  ggplot(df, aes_string(x = x, y = y, color = color, shape = shape)) +
    geom_point(size = 2, alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE) +
    scale_colour_brewer(palette = "Dark2") +
    theme_ipsum()

}

penguin_scatter(penguins,
  x = "flipper_length_mm",
  y = "body_mass_g",
  color = "species",
  shape = "species"
)


combs <- penguins %>%
  select(function(x) is.numeric(x), -year) %>% # get only numeric cols, except year
  names() %>% # get a character vector of column names
  tibble(y = ., x = .) %>%  # put it into two tibble columns
  tidyr::expand(x, y) %>% # all combinations of a variable in a data set
  transmute(y = pmin(y, x), x = pmax(y, x)) %>% # some "sorting" shenanigans to get distinct combs
  distinct() %>% # cleaning stuff that did not get picked up in the step above
  filter(y != x) # "
combs


plots <- pmap(combs, function(x,y) penguin_scatter(penguins,
  x = x,
  y = y,
  color = "species",
  shape = "species"
))


patchwork::wrap_plots(plots) # wrap_plots makes it easy to take a list of plots and add them into one composition, along with layout specifications.
