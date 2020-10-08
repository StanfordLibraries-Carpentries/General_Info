## R statistics workshop hosted by Carpentries @ Stanford Libraries
## 2020-10-08

## Announcements: 
## Oct 30th 13:00-16:00 R Introduction
## Nov 19th 14:00-17:00 R Visualization
## Downloaded the example dataset "SAFI_clean.csv"? 
## https://ndownloader.figshare.com/files/11492171


# Set up environment ------------------------------------------------------

#install.packages("tidyverse")
library(tidyverse)
#the packages below are all part of "tidyverse"
#library(readr)
#library(dplyr)
#library(ggplot2)


# Presentation of the SAFI Data -------------------------------------------

#SAFI (Studying African Farmer-Led Irrigation) is a study looking at farming 
#and irrigation methods in Tanzania and Mozambique

# read in data set
input_file <- "../data/SAFI_clean.csv"

interviews <- read_csv(input_file, na = "NULL")

class(interviews)
# What type of data is present in interviews object?



# Factors -----------------------------------------------------------------

#categorical data that you may encounter when creating plots or doing 
#statistical analyses they look like strings/ characters, but there's a hidden
#number value associated with them

medals <- factor(c("gold", "bronze", "silver", "bronze"))
levels(medals)
nlevels(medals)

#Sometimes you might want to specify the order because it is meaningful. 
#Maybe improve your visualization or required by a particular type of analysis

#Re-order levels
medals <- factor(medals, levels = c("gold", "silver", "bronze"))
medals


# Converting factors ------------------------------------------------------

as.character(medals)
class(medals)
#what went wrong?

medals<- as.character(medals)

# converting factors where the levels appear as numbers
year_fct <- factor(c(1990, 1983, 1977, 1998, 1990, 1983))
as.numeric(year_fct) #this will fail

as.numeric(as.character(year_fct))

View(interviews)
memb_assoc <- interviews$memb_assoc
memb_assoc <- as.factor(memb_assoc)
memb_assoc
plot(memb_assoc) #missing data in the plot

# replace missing data with a value "undetermined"
memb_assoc<-interviews$memb_assoc
memb_assoc[is.na(memb_assoc)] <- "undetermined"
memb_assoc <- as.factor(memb_assoc)
plot(memb_assoc)

## Aggregating and Analyzing data with dplyr -------------------------
# select() # choose columns
# filter() # choose rows base on criteria
# mutate() # create new variables
# group_by()
# summarize()

# Pipes %>%
# on Mac, shift + cmd + M 
# on Windows, shift + ctrl + M
# Pipes let you take the output of one function and send it directly to 
#the next, which is useful when you need to do many things to the same dataset

# make new variables with mutate
interviews %>% 
  mutate(people_per_room = no_membrs/ rooms)

interviews %>% 
  mutate(people_per_room = no_membrs/rooms) %>%
  filter(!is.na(memb_assoc))

#Exercise 1
#Create a new df from the interviews data that meets the following criteria: 
#contains only the village column and a new column called total_meals 
#containing a value that is equal to the total number of meals served in the 
#household per day on average (no_membrs times no_meals). Only the rows where 
#total_meals is greater than 20 should be shown in the final dataframe.

interviews %>% 
  mutate(total_meals = no_membrs * no_meals) %>% 
  filter(total_meals > 20) %>% 
  select(village, total_meals)


# Split-apply-combine principle ---------------------------------------

# Many data analysis tasks can be approached using the split-apply-combine paradigm: 
# split the data into groups, apply some analysis to each group, and then combine the results. 
interviews %>% 
  group_by(village) %>% 
  summarize( mean_no_membrs = mean(no_membrs))

# group by multiple factors
interviews %>% 
  group_by(village, memb_assoc) %>% 
  summarize(avg_membr=mean(no_membrs), 
            min_membr=min(no_membrs), 
            max_membr=max(no_membrs)) 

#rearrange the result of a query to inspect the values
interviews %>%
  filter(!is.na(memb_assoc)) %>%
  group_by(village, memb_assoc) %>%
  summarize(avg_membr = mean(no_membrs),
            min_membr = min(no_membrs)) %>%
  arrange(min_membr)

#counting
interviews %>%
  count(village, sort = TRUE)

#Exercise 2
#How many households for each village in the survey have an average of two meals per day? 
#Three meals per day? Are there any other numbers of meals represented?
interviews %>%
  group_by(village) %>%
  count(no_meals)

#Exercise 3
# Q: Does being a member of a irrigation association enhance average meals per person?
# make a new df, in which you determine the average meal_per_person
# for ONLY households who are apart of an irrigation association and by village

interviews %>% 
  filter(!is.na(memb_assoc)) %>% 
  group_by(village, memb_assoc) %>% 
  summarize(mean_no_membr = mean(no_membrs),
            mean_no_meals = mean(no_meals)) %>% 
  mutate(avg_mpp = mean_no_meals/mean_no_membr) %>% 
  select(village, memb_assoc, avg_mpp)


# Statistics --------------------------------------------------------------

#first lets make a useful df
mealspp<-interviews %>%
  filter(!is.na(memb_assoc)) %>% 
  #group_by(village, memb_assoc) %>% 
  mutate(mpp = no_meals/no_membrs) %>%
  select(key_ID, village, memb_assoc, mpp) %>%
  mutate(memb_assoc =as.factor(memb_assoc),
         village = as.factor(village))

plot(mealspp$memb_assoc, mealspp$mpp)

# STUDENT'S T-TEST
#Does being a member of irrigation association affect average meals per person?
#first check assumption that data is normal
wilcox.test(mpp ~ memb_assoc, data = mealspp) #yes

t.test(mpp ~ memb_assoc, data = mealspp)

# ONE-WAY ANOVA
#Q does the number of people  in household differ by wall type? 
interviews %>% 
  ggplot(aes(respondent_wall_type, no_membrs)) +
  geom_boxplot()

interviews %>% 
  group_by(respondent_wall_type) %>% 
  summarize(n=n(), mean(no_membrs), var(no_membrs)) ## there's only one obs for cement

wallaov <- interviews %>% 
  filter(respondent_wall_type != "cement") %>% 
  aov(no_membrs ~ respondent_wall_type, data = .)

summary(wallaov)

# Tukeys Honest significant difference
TukeyHSD(wallaov, "respondent_wall_type")


#Q.Does where you live affect average meals per person?
plot(mealspp$village, mealspp$mpp)

#check for normality in grouped data
shapiro.test(mealspp$mpp)

#since data is NOT normal, use Kruskal-Wallis rank sum test
res.kw <- kruskal.test(mpp ~ village, data = mealspp)
res.kw


#TWO-WAY ANOVA
#Q. what if we looked within each village whether member association mattered?
res2.aov <-aov(mpp ~ village + memb_assoc, data = mealspp)
summary(res2.aov)
#note this formula assumes the two factors are independent

res3.aov <-aov(mpp ~ village * memb_assoc, data = mealspp)
summary(res3.aov)
# tihs formula includes the possibility that the two factors might interact to create an synergistic effect