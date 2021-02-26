##Magdalena Matusiak
#mmatusia@stanford.edu
#24.02.21

#simple T test
#comparing means of 1 categorical variable with 2 groups
install.packages("ggpubr")
library(ggpubr)
library(ggplot2)

cars = mtcars

cars$vs = factor(cars$vs)

ggplot(cars, aes(vs, mpg, color = vs)) + 
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(position=position_jitter(0.2))

#check for normalicy
shapiro.test(cars$mpg[cars$vs == "0"]) # p.value is 0.1 > 0.05 means data is not significantly different from normal distribution
shapiro.test(cars$mpg[cars$vs == "1"]) # p.value is 0.1 > 0.05 means data is not significantly different from normal distribution

#check if variances of the two groups are different with F test
var.test(mpg ~ vs, data = cars) #p.value is 0.1 > 0.05 means that the varances of the two compared groups are not significantly different

#SO WE CAN COMPUTE THE t.test!

#copute t-test
ttest = t.test(mpg ~ vs, data = cars, var.equal = TRUE) #normaly distributed data and with equel variance

#In case data were not normaly distributed and/or their variance was different
#copute wilcoxon rank sum test
wtest = wilcox.test(mpg ~ vs, data = cars, exact = FALSE) #Wilcoxon rank sum test or Mann-Whitney test, not normaly distributed data

##add p.value to your plot
#plot pvalue on the plot, default method is wilcoxon test
ggplot(cars, aes(vs, mpg, color = vs)) + 
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(position=position_jitter(0.2)) +
  stat_compare_means()

ggplot(cars, aes(vs, mpg, color = vs)) + 
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(position=position_jitter(0.2)) +
  stat_compare_means(method = "t.test")

#indicate comparison
ggplot(cars, aes(vs, mpg, color = vs)) + 
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(position=position_jitter(0.2)) +
  stat_compare_means(comparisons = list(c("0","1")))

#anova
#comparing more than 2 groups
cars$cyl = factor(cars$cyl) 

ggplot(cars, aes(cyl, mpg, color = cyl)) + 
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(position=position_jitter(0.2))

res.aov <- aov(mpg ~ cyl, data = cars)
summary(res.aov)
res.kru = kruskal.test(mpg ~ cyl, data = cars)
res.kru

#this gives us only 1 p.vlaue suggesting there is significant differne between the groups
ggplot(cars, aes(cyl, mpg, color = cyl)) + 
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(position=position_jitter(0.2)) +
  stat_compare_means()

ggplot(cars, aes(cyl, mpg, color = cyl)) + 
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(position=position_jitter(0.2)) +
  stat_compare_means(method = "anova")

ggplot(cars, aes(cyl, mpg, color = cyl)) + 
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(position=position_jitter(0.2)) +
  stat_compare_means(comparisons = list(c("4","6"),
                                        c("4","8"),
                                        c("6","8")))

#it shows p.values of pairwise comparisons but the p.values are not corrected

pairwise.t.test(cars$mpg, cars$cyl,
                p.adjust.method = "BH")

pairwise.wilcox.test(cars$mpg, cars$cyl,
                     p.adjust.method = "BH")


pair_pval = compare_means(mpg ~ cyl,  data = cars)

ggplot(cars, aes(cyl, mpg, color = cyl)) + 
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(position=position_jitter(0.2))+
  stat_pvalue_manual(
    pair_pval, 
    y.position = 35,
    label = "p.adj", 
    step.increase = 0.1)

#################################################
##DATA VISUALISATION and DIMENTIONALITY REDUCTION
#################################################

#heatmap with heatmpa2
library(gplots)
library(RColorBrewer)
iris = iris

table(iris$Species)

heatmap.2(as.matrix(iris[,1:4]),
          Colv = F, 
          Rowv = F,
          scale = "col",
          trace = "none",
          RowSideColors = sideRow,
          col = colorRampPalette(rev(brewer.pal(11,"Spectral")))(100),
          density.info = 'none',
          cexRow = 1,
          labRow = FALSE,
          margins = c(5,10))

cols = brewer.pal(n = 8, name = "Set1")[1:3]
sideRow = cols[iris$Species]
heatmap.2(as.matrix(iris[,1:4]),
          Colv = T, Rowv = T,
          RowSideColors = sideRow,
          scale = "col",
          trace = "none",
          col = colorRampPalette(rev(brewer.pal(11,"Spectral")))(100),
          density.info = 'none',
          cexRow = 1,
          labRow = FALSE,
          margins = c(5,10))

#add legend
legend("topright",      
       legend = unique(iris$Species),
       col = cols, 
       lty= 1,             
       lwd = 5,           
       cex=.7
)

#PCA

to_PCA = iris[,1:4] #your data
PCA = prcomp(to_PCA,scale. = T) #you don't need to center and scale before this cause this function does this for you, center is T by default and you set scale. = T
PCs = PCA$x #extracting PC scores
to_plot = data.frame(PC1 = PCs[,1],
                     PC2 = PCs[,2],
                     type = as.factor(iris$Species)) #put your groups here as type
ggplot(to_plot, aes(PC1, PC2, color = type)) +
  geom_point()

#UMAP
library(ggplot2)
library(uwot)
set.seed(666) # set seed so you get the same coordinates
# n_neighbors and min_dist are tuning parameters that you can adjust to change the umap
?umap
umap_out <- umap(iris[,1:4], n_neighbors=20, min_dist=0.01)
umap_to_plot = data.frame(UMAP1 = umap_out[,1],
                     UMAP2 = umap_out[,2],
                     type = as.factor(iris$Species))

ggplot(umap_to_plot, aes(UMAP1, UMAP2, color=type))  + geom_point() + 
  theme_bw()
