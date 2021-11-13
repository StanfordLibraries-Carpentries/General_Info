# Getting Started in RStudio
print("hello world")

## Finding Files
getwd()

setwd("/Users/melissako/Desktop/Teaching/SoftwareCarpentry_W2019")
list.files()

## Session Info
sessionInfo()

# Getting Help in R
?rm
help(rm)

# Variables
## Assignment Operators
save.num <- 7
save.num = 10
save.string <- "hello"
save.bool <- TRUE

# Managing Your Local Environment
ls()
rm()

# Vectors
## Making Vectors with Combine Function
## Making Numeric Vectors
?c

first_vector <- c(38, 32, 45, 23, 6, 56,
                  234, 1239, 123, 123, 342, 1234)
second_vector <- c(1, 34, 10)
third_vector <- c(first_vector, second_vector)
fruits <- c("apples", "oranges", "bananas")

letters
LETTERS

1:4
?seq
?rep

## Indexing
second_vector[2]
fruits[3]

## Subsetting by Index
fruits[2:3]
fruits[c(1, 3)]

## Remove Elements of Vectors
fruits[-1]

# Subsetting the Alphabet
letters


## Subsetting by Name
names(fruits)

names(fruits) <- c("first", "second", "third")
fruits["first"]

# Fruit Store Prices


## Subsetting by Logicals
second_vector[second_vector < 20]

## Math Operators
## Comparison Operators
save.num + 10
save.num != 8
save.num == 8

## Operators on Vectors
## Functions on Vectors
first_vector * 2
?sin
sin(first_vector)

# Fruit Store Sale Prices
fruit.prices <- c(1, 2, 1.5, 3, 4, 2, 1)
names(fruit.prices) <- c("apples", "oranges", "grapes",
                         "clementines", "pineapple", "pear",
                         "cherries")

fruit.prices * 0.7

prices <- c(1, 2, 3)

second_vector %% 2 == 0
second_vector[second_vector %% 2 == 0]

# Fruit Store on a Budget


# Packages in R
install.packages("ggplot2")
install.packages("plyr")
install.packages("gapminder")

# Reading/Editing Files
library(gapminder)

gapminder2 <- as.data.frame(gapminder)
gapminder2.short <- head(gapminder2)

cats <- data.frame(coat = c("calico", "black", "tabby"),
                   weight = c(2.1, 5.0, 3.2),
                   likes_string = c(1, 0, 1))
write.csv(x = cats, file = "feline-data.csv", row.names = FALSE)
rm(cats)
cats

cats <- read.csv("feline-data.csv")

cats.matrix <- as.matrix(cats)

# Data Types
?class
?typeof

# Dataframe
## Dataframe Diagnostics
?dim
?ncol
?nrow
?summary

## Subsetting by Index
## Subsetting by Name

## Add Rows/Columns
cats <- cbind(cats, length = c(2, 3, 1))

## Remove Rows/Columns
cats[, -1]
cats[-1, ]

# try to add a row of cats (or countries)!

## Append Dataframes
newcats <- data.frame(coat = c("white", "gold", "silver"),
                      weight = c(3.1, 5.3, 1.9), 
                      likes_string = c(1, 0, 0),
                      length = c(4, 2, 3))

cats <- rbind(cats, newcats)

# Type Coercion
## Factors
## Fixing Factors
cats[, 1]
cats <- rbind(cats, c(coat = "spotted", weight = 2.4,
              likes_string = 0, length = 2.5))
cats

cats[, 1]
cats <- rbind(cats, c(coat = "calico", weight = 3.2,
                      likes_string = 1, length = 3))

as.character(cats[, 1])
as.numeric(cats[, 1])

# Fruit Store Inventory
# item, price, sale price, number in stock

# Loops
## for Loops
for (i in fruits) {
  print(i)
}

for (x in 1:100) {
  print(x)
  print(x %% 2)
}
rm(x)

## while Loops
x <- 10
x < 100

while (x < 100) {
  print(x)
  x <- x * 2
  # stuff
}

# Conditional Logic
## if/else

rm(x)
for (x in 1:100) {
  print(x)
  print(x %% 2)
}

test.num <- 30

if (test.num < 10) {
  print("small")
} else {
  print("big")
}
10 %% 2
9 %% 2

num.vectors <- 1:10
for (i in num.vectors) {
  if (i %% 2 == 0) {
    print("even")
  } else {
    print("odd")
  }
}

# Investigating Cats
# save newcats as csv so you have two csv
# files about cats

# remove cats and newcats from memory

# Task: Find only cats that like string. Pull them
# out and save them to a new variable.
# read.csv
# write.csv

cats.who.like.string <- c()
cat.files <- list.files(pattern = "csv")
save.col <- colnames(read.csv(cat.files[1]))

for (each.file in cat.files) {
  print(each.file)
  temp.file <- read.csv(each.file)
  temp.file <- temp.file[, save.col]
  print(temp.file[temp.file$likes_string == 1, ])
  save.cat <- temp.file[temp.file$likes_string == 1, ]
  cats.who.like.string <- rbind(cats.who.like.string,
                                save.cat)
}

cats.matrix <- cats[, -1]
cats.matrix <- as.matrix(cats.matrix)
cats.matrix <- apply(cats.matrix, MARGIN = 2, as.numeric)

