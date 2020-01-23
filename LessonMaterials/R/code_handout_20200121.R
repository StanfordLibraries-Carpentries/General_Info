# Beginner R workshop 2020-01-21

# hashtags = comments, ignores everything after hashtag

3+4
# compare
3+5 *4

(3+5)*4

#variables

centimeter <- 1.0
inch <- centimeter *2.54

centimeter <- 50

# vectors & Data types
pet_num <- c(68, 24, 12, 1, 10, 11)
pet_types <- c("dog", "cat", "snake", "fish", "rabbit")

length(pet_num)
length(pet_types)

max(pet_num)
min(pet_num)
class(pet_num)
class(pet_type)
class(pet_types)

# adding items to vector
pet_types <- c(pet_types, "chicken")
pet_types

#CHALLENGE : add another animal to the beginning of the list.
pet_types <- c("new animal", "old animals", "old animals2")
pet_types <- c("lion", pet_types)
pet_types

# subsetting/ indexing vectors
# in R indexing begins at one NOT zero
pet_types[2] 
pet_types[c(4,2)]
pet_types[1:3] #the colon lets you select a range
pet_types[4:7]

# CHALLENGE add new element to the middle of vector
pet_types2 <- c(pet_types[1:4], "unicorn", pet_types[5:7])
pet_types
pet_types2

# using index to creat a vector with more elements than the original one
more_pet_types <- pet_types[c(4,2,3,4,7,5,6,2,4,1,2,4,3,6,5,3,2,4,4)]
length(more_pet_types)

# DATA types
# numeric
# characters
# integer
# complex 4+1i
# logical: TRUE, FALSE

num_char <- c(1,2,3, "a")
class(num_char)
num_char

num_logical <- c(1,2,3, TRUE)
class(num_logical)
num_logical
num_logical2 <- c(1,2,3,FALSE) 
num_logical2

char_logical <- c("a", "b", "c", TRUE)
class(char_logical)
char_logical

tricky <- c(1, FALSE, 3, "4")
class(tricky)
# characters > numeric > logical

# Conditional subsetting
# based on logical values
pet_num[c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE)]

pet_num > 4
pet_num[pet_num > 4]
pet_num 

#combine tests using Boolean operators 
# AND is the &, ampersan sign
# OR is the | , vertical bar
# NOT is the !, exclamation point
# EQUAL is ==, two equal signs, no space in between
pet_num[pet_num >4 & pet_num < 24]
pet_num[pet_num != 68]

more_pet_types[ more_pet_types == "dog"]
more_pet_types[ more_pet_types == "Dog"] #case sensitive!
more_pet_types[more_pet_types == "cats" & more_pet_types == "dog"]
more_pet_types[more_pet_types == "cat" & more_pet_types == "dog"]
more_pet_types[more_pet_types == "cat" | more_pet_types == "dog"]

# %in%
mammals <- c("cat", "dog", "rabbit" )
more_pet_types[more_pet_types %in% mammals]
more_pet_types[!(more_pet_types %in% mammals)]

install.packages("tidyverse")
library(tidyverse)


# Dataframes
# basically a bunch of vectors smoosh together

# read in data
interviews <- read_csv("data/SAFI_clean.csv", na = "NULL")

# check your working directory
getwd()

# let inspect our dataframe
# size
dim(interviews)
nrow(interviews)
ncol(interviews)

# content
head(interviews)
tail(interviews)
colnames(interviews)

#summary
str(interviews)
summary(interviews)

#indexing & subsettting dataframes
interviews[ 1, 2]
interviews[ , 2] 
interviews[3 , ]

# CHALLENGE subset the dataframe so we get rows 10 through 15 and columns 1 to 7
interviews[10:15, 1:7]
interviews[c(1, 10:15), c(1:7, 10)]

#subset by column name
interviews["village"] # output is a dataframe
interviews[["village"]] #output is a vector
interviews$village #output is a vector

# CHALLENGE
# subset dataframe to have the second half of interviews, omitting variables:
#  items_owned, months_lack_food, instance_ID
# multiple ways to do this, does not need to be in one line of code

# by indexing
interviews[ 65:131 , c(1:10, 12)] # using only indexes
interviews[65:131, -c(11,13,14)] #use the minus symbol to exclude

# by calling column names, so it'll be position independent
colnames(interviews)
interviews[65:131, c("key_ID", "village", "interview_date", "no_membrs", "years_liv", "respondent_wall_type", "rooms", "memb_assoc", "affect_conflicts", "liv_count",  "no_meals")]
# but this is too cumbersome to list out all the ones to keep

# instead make new list of items to leave out
leave_out <- c("items_owned", "months_lack_food", "instance_ID")

interviews[65:131, !(colnames(interviews) %in% leave_out)] # NOT in our vector "leave_out" 
