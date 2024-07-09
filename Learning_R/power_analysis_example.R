library(tidyverse)

#### Normal distribution

rnorm(n=1 , mean=0, sd=1)

rnorm(n=10 , mean=0, sd=1)

rnorm(n=10 , mean=0, sd=1) %>% 
  as.data.frame() %>%
  ggplot(aes(x=.)) + geom_histogram()

rnorm(n=100 , mean=0, sd=1) %>% 
  as.data.frame() %>%
  ggplot(aes(x=.)) + geom_histogram()

rnorm(n=1000 , mean=0, sd=1) %>% 
  as.data.frame() %>%
  ggplot(aes(x=.)) + geom_histogram()

rnorm(n=10000 , mean=0, sd=1) %>% 
  as.data.frame() %>%
  ggplot(aes(x=.)) + geom_histogram()

##### simulations of power analysis
##### First try n = 15

rnorm(n=15 , mean=1.2, sd=2.5) -> lower
rnorm(n=15 , mean=1.0, sd=2.3) -> upper

t.test(lower, upper)

##### Lets run 100 iterations of this test, by repeting the sampling process
out=c()
for(i in 1:100){
  
  rnorm(n=30 , mean=1.2, sd=2.5) -> lower
  rnorm(n=30 , mean=1.0, sd=2.3) -> upper
  
  t.test(lower, upper) -> tmp.out

  out[i] = tmp.out$p.value
}

sum(out < 0.05)/100

#####
##### A power analyses 

n=seq(from=10, to = 10000, by = 100)

out.N=c()
for(k in 1:length(n)){
  out=c()
for(i in 1:100){
  
  rnorm(n=n[k] , mean=1.2, sd=2.5) -> lower
  rnorm(n=n[k] , mean=1.0, sd=2.3) -> upper
  
  t.test(lower, upper) -> tmp.out
  
  out[i] = tmp.out$p.value
}
  
  out.N[k] = sum(out < 0.05)/100
}

data.frame(n=n,
           power=out.N) %>%
ggplot(aes(
  x=n,
  y=power
)) + geom_line() + geom_point()

