## command + enter to run script
install.packages("ggplot2")
library(ggplot2)

## load diamonds dataset
data(diamonds)

## inspect dataset
diamonds

## scatter plot
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + geom_point(size = 1, shape = 17)

ggplot(diamonds, aes(x = carat, y = price)) + geom_point(size = 1, shape = 17)


## boxplot
## check categorical column distribution

table(diamonds$clarity)

ggplot(diamonds, aes(x = clarity, y = price)) + geom_boxplot(outlier.size = -1)

?geom_boxplot

## violin plot

ggplot(diamonds, aes(x = clarity, y = price)) + geom_violin(scale = "width") + geom_jitter(alpha = 0.2, size = 0.2, color = "red")


## histogram
ggplot(diamonds, aes(x = price)) + geom_histogram(binwidth = 50)

## density plot
ggplot(diamonds, aes(x = price)) + geom_density()



## line graph

ggplot(diamonds, aes(x = carat, y = price)) + geom_point() + geom_smooth()
?geom_smooth


## grouping data

ggplot(diamonds, aes(x = carat, y = price)) + geom_point() + geom_line()

install.packages("tidyverse")
library(tidyverse)

filter(diamonds, carat > 2.5 & carat < 3) %>% ggplot(mapping = aes(x = carat, y = price, group = cut, color = cut)) + geom_line() 
## shorcut: command+shift+M for %>%


## faceting

filter(diamonds, carat > 2.5 & carat < 3) %>% ggplot(mapping = aes(x = carat, y = price, group = cut, color = cut)) + geom_line() + facet_wrap(~ cut)

ggplot(data = diamonds, mapping = aes(x = carat, y = price, color = color)) + geom_line() + facet_grid(color ~ cut)


## aesthetics

ggplot(diamonds, aes(x = carat, y = price, color = cut)) + geom_point(size = 0.5)

table(diamonds$cut)

my_palettes = c("Fair"="blue", "Good"="red", "Very Good"="purple", "Premium"="pink", "Ideal"="green")

my_palettes

## coloring by categorial variable
ggplot(diamonds, aes(x = carat, y = price, color = cut)) + geom_point(size = 0.5) + scale_color_manual(values = my_palettes)

## coloring by continuous variable (~ heatmap)
ggplot(diamonds, aes(x = carat, y = price, color = depth)) + geom_point(size = 0.5) + scale_color_gradient(low="black", high="red") + theme(panel.background = element_blank(), panel.border = element_rect(color = "pink", fill=NA), axis.text = element_text(color = "black"), axis.title = element_blank()) + ggtitle("scatter plot")

ggsave("test.pdf", height = 6, width = 5)









