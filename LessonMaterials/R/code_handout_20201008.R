## R statistics workshop hosted by Carpentries @ Stanford Libraries
## 2020-10-08
## Instructors: Lori Ling loriling (at) stanford.edu , 
#               Zac Painter zwp (at) stanford.edu

## Announcements: 
## Oct 30th 13:00-16:00 R Introduction
## Nov 19th 14:00-17:00 R Visualization
## Did you download the example data set "SAFI_clean.csv"? 
## https://ndownloader.figshare.com/files/11492171

## Set up environment----
library("tidyverse") #loading libraries , do this for each time you start Rstudio
#install.packages(tidyverse) #installing packages, only one time per computer

## Read in the data set----
#SAFI (Studying African Farmer-Led Irrigation) is a study looking at farming 
#and irrigation methods in Tanzania and Mozambique

input_file <- "data/SAFI_clean.csv"
interviews <- read_csv(input_file, na = "NULL")

class(interviews)
interviews

#Q. What type of data is present in interviews object?
#A.The types of data are numeric, date time, character (strings)

## Factors----
#categorical data that you may encounter when creating plots or doing 
#statistical analyses they look like strings/ characters, but there's a hidden
#number value associated with them

medals <-factor(c("gold", "silver", "bronze", "silver", "gold"))
levels(medals)
nlevels(medals)

#Reorder levels
medals <-factor(medals, levels = c("gold", "silver", "bronze"))
medals

#Coverting factors
as.character(medals)
medals 

#need to assign back to variable
medals <-as.character(medals)
medals
class(medals)

# converting factors where levels appear as numbers
year_fct <-factor(c(1990, 1983, 1977, 1998, 1990, 1983))
class(year_fct)
as.numeric(year_fct) #THIS IS NOT GOING TO WORK

as.numeric(as.character(year_fct)) 

#Make a plot in base R of distribution of member association
memb_assoc <- interviews$memb_assoc
plot(memb_assoc) #error; expecting factors

memb_assoc <-as.factor(memb_assoc)
plot(memb_assoc)

#replace missing data with value "undetermined"
memb_assoc <-interviews$memb_assoc
memb_assoc[is.na(memb_assoc)] <- "undetermined"
memb_assoc<-as.factor(memb_assoc)
plot(memb_assoc)

## Aggregating and analyzing data with dplyr----
# select() #choose columns
# filter() #choose rows base on criteria
# mutate() #create new variables
# group_by()
# summarize()

#Pipes let you take the output of one function and send it directly to 
#the next, which is useful when you need to do many things to the same dataset
#this is a pipe: %>%
#on Mac, shift +cmd +M
#on PC, shift+ctrl +M

#make a new variable with mutate
interviews %>% 
  mutate(people_per_room = no_membrs/rooms) #%>% 
  #select(key_ID, people_per_room)

interviews %>% 
  mutate(people_per_room = no_membrs/rooms) %>%
  filter(!is.na(memb_assoc)) #exclamation point negates the function ie does the opposite

#Q. how else could you filter df to get only people who responded to memb_assoc?
#hint you want to use Booleans 
# AND &
# OR |
#Answer
interviews2 <- interviews %>% 
  mutate(people_per_room = no_membrs/rooms) %>%
  filter(memb_assoc == "yes" | memb_assoc == "no")

#Exercise
#Create a new df from the interviews data that meets the following criteria: 
#contains only the village column and a new column called total_meals 
#containing a value that is equal to the total number of meals served in the 
#household per day on average (no_membrs times no_meals). Only the rows where 
#total_meals is greater than 20 should be shown in the final dataframe

interviews %>% 
  mutate(total_meals = no_membrs * no_meals) %>% 
  filter(total_meals > 20) %>% 
  select(village, total_meals)

#break, be back by 2:24pm

## Split-apply-combine principle----
#Many data analysis tasks can be approached using the split-apply-combine 
#paradigm: split the data into groups, apply some analysis to each group, 
#and then combine the results. 

interviews %>% 
  group_by(village) %>% 
  summarize( avg_no_membrs = mean(no_membrs))

interviews %>% 
  group_by(village) %>% 
  summarize( avg_no_membrs = mean(no_membrs),
             min_membr = min(no_membrs),
             max_membr = max(no_membrs))

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
  group_by(village) %>% 
  count(no_meals)

#Exercise
# Q: Does being a member of a irrigation association enhance average meals per person?
# make a new df, in which you determine the average meal_per_person
# for ONLY households who are apart of an irrigation association and by village
interviews %>% 
  filter(!is.na(memb_assoc)) %>% 
  group_by(village, memb_assoc) %>% 
  summarize( mean_no_meals = mean(no_meals), 
             mean_no_membr = mean(no_membrs)) %>% 
  mutate(avg_mpp = mean_no_meals/ mean_no_membr) %>%  #make new variable
  select(village, memb_assoc, avg_mpp)

## Statistics----

#first make new df for meals per person
mealspp <- interviews %>% 
  filter(!is.na(memb_assoc)) %>% 
  group_by(village, memb_assoc) %>%
  mutate(mpp = no_meals/no_membrs) %>% 
  mutate(memb_assoc = as.factor(memb_assoc),
         village = as.factor(village))

plot(mealspp$memb_assoc, mealspp$mpp)

#Student's t-test
#Q.Does being a member of irrigation association affect average meals per person?
#first check for normality
wilcox.test(mpp ~ memb_assoc, data = mealspp) #yes, normal

t.test(mpp ~ memb_assoc, data = mealspp) #p-value = 0.32 , not statistically diff.


# ONE WAY ANOVA
#Q does the number of people per household differ by wall type? 

interviews %>% 
  group_by(respondent_wall_type) %>% 
  summarise(mean_no_membr = mean(no_membrs),
            var_membr = var(no_membrs),
            n=n())

interviews %>%
  filter(respondent_wall_type != "cement") %>% 
  aov(no_membrs ~ respondent_wall_type, data = .) %>% #the period acts as a pronoun to refer to this left of the pipe
  summary()

#Same analysis without pipes
walltype <- interviews %>%
  filter(respondent_wall_type != "cement")
wallaov<-aov(no_membrs ~ respondent_wall_type, data = walltype)  
summary(wallaov)

#Tukey's Honest Significant difference test aka Tukey HSD
TukeyHSD(wallaov, "respondent_wall_type")

#visualize in plot
interviews %>% 
  ggplot(aes(respondent_wall_type, no_membrs)) +
  geom_boxplot()

#Another one-way ANOVA example
#Q.Does where you live affect average meals per person?
plot(mealspp$village, mealspp$mpp)

#check for normality in grouped data
shapiro.test(mealspp$mpp)

#since data is NOT normal, use Kruskal-Wallis rank sum test
res.kw <- kruskal.test(mpp ~ village, data = mealspp)
res.kw

#Two-way ANOVA
#check for normality
shapiro.test(mealspp$mpp) #not normal

#if the data WERE normal
res2.aov<-aov(mpp ~ village + memb_assoc, data= mealspp)
summary(res2.aov)
#plus sign assumes the two variables are independent

res3.aov<- aov(mpp ~ village * memb_assoc, data= mealspp)
summary(res3.aov)
#the asterisk in formula includes the possibility that the two factors might 
#interact to create a synergistic effect