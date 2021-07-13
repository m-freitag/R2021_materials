# HEADER -----------------------------------------------------------------------
#
# Author: Your Name
# GitHub: https://github.com/yourname
# Date: 
#
# Script Name: Script for Session 2
#
# Script Description: This is a blank script for session 2.
#
#
# Notes: I added some (useful) comments.

# -------------------------------- SOME TIPPS ----------------------------------

# In R-Studio you can hack a little color into your comments by using (depends
# on your theme settings):

#' [Some]

#' @color

#'* for comments.*

# Some exemplary sections one would usually include after a header:

# Install Packages & Load Libraries --------------------------------------------

# (Helper) Functions -----------------------------------------------------------
# If you source any functions from outside the script, put them at the top!

# NOTE: You can define snippets (global options > code > edit snippets) such
# that you can create a standardized header (e.g. including your favorite
# packages) by simply typing, e.g., "header" and hitting enter.

# To structure a Script I use ctrl+shift+r (and some custom shortkeys):

# --------------------------------- SECTION X ----------------------------------

## Subsection Z ----------------------------------------------------------------

# ------------------------------------------------------------------------------

# NOTE: KEEPING A GOOD STRUCTURE IS IMPORTANT! You can also display the document
# outline in R-Studio.

# Shortcuts --------------------------------------------------------------------

# New document: ctrl+shift+n
# To comment/uncomment lines: ctrl+shift+c
# To run one or multiple lines of code: ctrl+enter
# To run the whole file: ctrl+shift+enter

# NOTE: RStudio supports automatic code completion using the Tab key.
# NOTE: Always comment your code. Future you will thank you!

# -------------------------- START YOUR SCRIPT BELOW ---------------------------


# CalculatoR -------------------------------------------------------------------

7 + 5 + 1 # [n] stands for the nth element printed to the console.

4 * 5 + 2 / 3^3 # Multiplication and division first, then addition and subtraction

# Modulo Operators:

10 %/% 3 # Integer division

10 %% 3 # Remainder ("Rest")

3 < 4

2 == 1 & 4 > 2 # == "equal to"; & "element wise logical AND"

2 == 1 | 4 > 2 # | "element wise logical or"

3 != 4 # != "not equal"

7 %in% 300:500 # %in% can be used to evaluate matches in objects

# Floating Points

0.1 + 0.2

0.1 + 0.2 == 0.3


# Functions --------------------------------------------------------------------

f <- function(x) {
    (2 * x + 3) / sqrt(3)
}

f(3)


## # help(help)
## # Or for short:

?help


# Making Objects: Assignment (Operators) ---------------------------------------

a <- 3 # Or a = 3; under the hood, assignment works more like a -> 3

class(a)
mode(a)

# Vectors ----------------------------------------------------------------------

chr_var <- c("a", "b", "c", "d") # A 4-element atomic vector of type character

# Indexing:

chr_var[3] # Returns the third element of object "chr_var".
chr_var[1:3] # Returns the 1st three.

# Lists ------------------------------------------------------------------------

list_a <- list(
    5:7,
    "I'm a string",
    c(TRUE, TRUE),
    c(1.23, 4.20)
)


list_a[3] # This returns a list with element three.


list_a[[4]] # We need double brackets to index a list element.


# Index within a list element:

list_a[[4]][2]

# For named lists, we can index with $:

names(list_a) <- c("a", "b", "c", "d")
# Note: We can also name elements directly: list(x = 1, y = 2)

list_a$b


list_a$d[1]

# Adding a new object-reference,
# i.e. an element, to a list:

list_a$e <- c("R", "is fun")



# Factors ----------------------------------------------------------------------

backgrounds_char <- c("none", "Stata", "Stata", "Stata", "R") # Student's prog. backgrounds

backgrounds_fac <- factor(backgrounds_char, levels = c("none", "Stata", "R"))

# Or:
# backgrounds_fac <- factor(c("none", "Stata", "Stata", "Stata", "R"))

class(backgrounds_fac)

typeof(backgrounds_fac)

table(backgrounds_fac)

# Data Frames ------------------------------------------------------------------

set.seed(666)
df_langs <- data.frame(
    background = factor(c(
        "Python",
        "Stata", "Stata", "Stata",
        "R"
    )),
    skill = rnorm(5) # draw 5 random numbers from a normal dist.
)

View(df_langs)

head(df_langs) # print first few lines of an object (6 by default)

# Indexing

df_langs[2, 2] # Second row of second column

df_langs$background[1]

# Combined with the operators we learned, we can also filter:

df_langs[df_langs$skill < 0, ]

dim(df_langs)

lm(skill ~ background) # the lm object is of type list

m1 <- lm(df_langs$skill ~ df_langs$background) # Or: lm(skill ~ background, data = df_langs)
summary(m1) # generic function used to produce result summaries of the results of various model fitting functions


df_langs_m <- as.matrix(df_langs) # convert data.frame to matrix
print(df_langs_m)

typeof(df_langs_m[2, 1])

# Installing Packages ----------------------------------------------------------

install.packages("tidyverse")
library(tidyverse)


install.packages("pacman")

pacman::p_load(
    tidyverse,
    patchwork,
    rio,
    data.table
)