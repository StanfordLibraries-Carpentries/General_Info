## Intermediate R workshop 2020-02-05 hosted by Stanford Libraries/ Carpentries
#Notes:
#  Data Vis wiht ggplot2 Melissa
#  Tuesday, February 11, 2020 - 2:00pm to 4:00pm
# Load in data set

library(tidyverse)
interviews <- read_csv("data/SAFI_clean.csv", na = "NULL")


## Factors ------------------------------------------------
# categorical data that you may encounter when creating plots or doing statistical analyses
# they look like strings/ characters, but there's a hidden number value associated with them
respondent_floor_type <- factor(c("earth", "cement", "cement", "earth"))

#levels()
#nlevels()

# re-ordering levels of a factor
respondent_floor_type <- factor(respondent_floor_type, levels = c("earth", "cement"))


# Converting factors
as.character(respondent_floor_type)

# Converting factors where the levels appear as numbers (such as concentration levels, or years) to a numeric vector is a little trickier.
year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
as.numeric(year_fct) #won't work

as.numeric(as.character(year_fct))

# Renaming factors

# extract the memb_assoc column from our data frame, convert it into a factor, 
# and use it to look at the number of interview respondents who were or were not members of an irrigation association:
# create a vector from the data frame column "memb_assoc"

memb_assoc <- interviews$memb_assoc

# convert it into a factor
memb_assoc <- as.factor(memb_assoc)

# let's see what it looks like
memb_assoc

plot(memb_assoc)


# Let's recreate the vector from the data frame column "memb_assoc"
memb_assoc <- interviews$memb_assoc
# replace the missing data with "undetermined"
memb_assoc[is.na(memb_assoc)] <- "undetermined"
# convert it into a factor
memb_assoc <- as.factor(memb_assoc)
# let's see what it looks like
memb_assoc
plot(memb_assoc)

## CHALLENGE
# Rename the levels of the factor to have the first letter in uppercase: “No”,”Undetermined”, and “Yes”.
# recreate the barplot such that “Undetermined” is last (after “Yes”)?
  
levels(memb_assoc) <- c("No", "Undetermined", "Yes")
memb_assoc <- factor(memb_assoc, levels = c("No", "Yes", "Undetermined"))
plot(memb_assoc)

## Aggregating and Analyzing data with dplyr -------------------------
#filter()  #choose rows which fit a criteria
#select()  # choose columns

interviews %>%
  filter(village == "God") %>%
  select(no_membrs, years_liv)

# Pipes let you take the output of one function and send it directly to the next, which is useful when you need to do many things to the same dataset

## CHALLENGE
# Using pipes, subset the interviews data to include interviews where respondents were members of an irrigation association (memb_assoc) and 
# retain only the columns affect_conflicts, liv_count, and no_meals.
interviews %>% 
  filter(memb_assoc == "yes") %>% 
  select(affect_conflicts, liv_count, no_meals)

# Making new variables with mutate()
interviews %>%
  mutate(people_per_room = no_membrs / rooms)

# to look at relationship, first remove data from our dataset where the respondent didn’t answer the question of whether they were a member of an irrigation association
interviews %>%
  filter(!is.na(memb_assoc)) %>%
  mutate(people_per_room = no_membrs / rooms)


## CHALLENGE
# Create a new data frame from the interviews data that meets the following criteria: 
# contains only the village column and a new column called total_meals containing a value that is equal to the total number of meals served in the household per day on average (no_membrs times no_meals). 
# Only the rows where total_meals is greater than 20 should be shown in the final data frame.

I_total_meals <- interviews %>% 
  mutate(total_meals = no_membrs * no_meals) %>% 
  filter(total_meals >20) %>% 
  select(village, total_meals)


# Split-apply-combine principle ---------------------------------------

# Many data analysis tasks can be approached using the split-apply-combine paradigm: 
# split the data into groups, apply some analysis to each group, and then combine the results. 

# group_by()  
# summarise()

interviews %>%
  group_by(village) %>%
  summarize(mean_no_membrs = mean(no_membrs))


## CHALLENGE
# find the mean, min, and max number of household members for each member association status
# use min(), max()
interviews %>% 
  group_by(memb_assoc) %>% 
  summarise(mean(no_membrs), min(no_membrs), max(no_membrs))

# can group by multiple factors
interviews %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs))

# counting
interviews %>% group_by(village, memb_assoc) %>%
  summarize( n = n())

interviews %>% group_by(village) %>% 
  count(memb_assoc)

interviews %>%
  filter(!is.na(memb_assoc)) %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs))


## CHALLENGE
# make a new dataframe in which you determine the average meal_per_person, average number of livestock 
# for each village for only households who are part of an irrigation association

interviews %>%
  filter(!is.na(memb_assoc)) %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs),
            mean_meals = mean(no_meals),
            mean_animals = mean(liv_count)) %>% 
  mutate(meal_per_person = mean_meals/mean_no_membrs)


## Statistical tests ---------------------------------------------------

# Pearson correlation
interviews %>% 
  ggplot(aes(x=no_membrs, y= liv_count)) +
  geom_point()

cor(interviews$no_membrs, interviews$liv_count)

interviews %>% 
  ggplot(aes(x=no_membrs, y= liv_count)) +
  geom_point() +
  facet_wrap(~village)

interviews %>% 
  group_by(village) %>% 
  summarize(correlation =  cor(no_membrs, liv_count))

# t-test
# note default variance is FALSE, so deafult is actually Welch t-test
interviews %>% 
  filter(!is.na(memb_assoc)) %>%
  t.test(no_membrs ~ memb_assoc, data = .)

interviews %>% 
  t.test(no_membrs ~ memb_assoc, data = ., na.action = na.omit)  

# use broom package to convert stat analysis object to tibbles
#install.packages("broom")
library(broom)

interviews %>% 
  filter(!is.na(memb_assoc)) %>%
  t.test(no_membrs ~ memb_assoc, data = .) %>% 
  tidy()

interviews %>% 
  filter(!is.na(memb_assoc)) %>%
  group_by( memb_assoc) %>%
  ggplot(aes(no_membrs))+
  geom_density(aes(fill = memb_assoc), alpha = 0.5) 

# ANOVA
interviews %>% group_by(respondent_wall_type) %>% 
  summarize(n= n(), avg= mean(no_membrs), v = var(no_membrs))

interviews %>%  
  ggplot(aes(respondent_wall_type, no_membrs))+
  geom_boxplot()

wall.aov <-interviews %>% 
  filter(respondent_wall_type != "cement") %>% 
  aov(no_membrs ~ respondent_wall_type , data = .) 

summary(wall.aov)

wall.aov %>% tidy()  

# Tukey's Honest significant difference
TukeyHSD(wall.aov, "respondent_wall_type")

TukeyHSD(wall.aov, "respondent_wall_type") %>% tidy()



