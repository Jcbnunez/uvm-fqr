### Basic statistical operations

#arithmetic mean
mean(iris$Sepal.Length)

#standard deviation
sd(iris$Sepal.Length)

#median
median(iris$Sepal.Length)

####

cor.test(iris$Sepal.Length, iris$Sepal.Width)

iris %>%
ggplot(aes(
  x=Sepal.Length,
  y=Sepal.Width
)) + geom_point() + geom_smooth(method = "lm")

###
cor.test(~Petal.Length+Petal.Width, data = iris)

iris %>%
  ggplot(aes(
    x=Petal.Length,
    y=Petal.Width
  )) + geom_point() + geom_smooth(method = "lm")

iris %>%
  ggplot(aes(
    x=Petal.Length,
    y=Petal.Width,
    color = Species
  )) + geom_point() + geom_smooth(method = "lm")

### species effect
library(tidyverse)

sps = unique(iris$Species)

out = data.frame()
k=1

for(i in sps){
  
  iris %>% filter(Species == i) -> tmp
  ## notice that "->" is also a form or "="
  cor.tmp = cor.test(~Petal.Length+Petal.Width, data = tmp)
  
  out[k,1] = i
  out[k,2] = cor.tmp$estimate
  out[k,3] = cor.tmp$p.value
  
  k = k +1
}

out 

names(out) = c("species", "correlation", "Pvalue")

out

out %>%
  mutate(sign = case_when(Pvalue < 0.05 ~ "Sig",
                          TRUE ~ "NotSig"))

out %>%
  mutate(sign = case_when(Pvalue < 0.01 ~ "Sig",
                          TRUE ~ "NotSig"))


