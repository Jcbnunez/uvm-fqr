### Loops
### Simple loops and "forloops"
library(tidyverse)

iris %>% 
  filter(Petal.Width > 1.6) %>% 
  .$Sepal.Width %>% 
  mean()

### what about 1.7...1.8 ... or 0.5 ... 0.1

myvar = seq(from= 0.2, to = 1.9, by = 0.2)

for( i in myvar){
  
  print(i)
  
}

####
for( i in myvar){
  
  iris %>% 
    filter(Petal.Width > i) %>% 
    .$Sepal.Width %>% 
    mean() %>% print()
  
}

### one output
out = c()
k = 1

for( i in myvar){
  iris %>% 
    filter(Petal.Width > i) %>% 
    .$Sepal.Width %>% 
    mean() -> tmp
  
  out[k] = tmp
  k=k+1
}

out

### multiple outputs
out = data.frame()
k = 1

for( i in myvar){
  iris %>% 
    filter(Petal.Width > i) %>% 
    .$Sepal.Width %>% 
    mean() -> tmp
  
  out[k,1] = k
  out[k,2] = tmp
  k=k+1
}

out