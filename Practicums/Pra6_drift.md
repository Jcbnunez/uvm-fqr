# Exploring genetic drift in R

This practicum is both a lecture as well as a hands on activity to explore the concept of genetic drif as well as to generate a simulaiton framework of genetic drift.

```bash
cd ~/scratch
mkdir practicum_6
cd practicum_6

module load Rtidyverse
```

## The basis of drift and simulating it

The process of genetic drift is going to emerges as a result of removing one of the core simplying assumtions of the HW model, "infinite population size." Whenever populaitons go from being "effectively infinite" to "finite" some interesting statistical effect start taking place. Namely, not every individual gets to contribute the gene pool of the next generation due to *stoichastic* reasons (i.e., no fitness effects). This implies the chance that even a high fitness allele may fail to be sampled in the next generation!

### The binomial process

In essense, we can model the process of genetic drift using a binomial distribution as follows: 


$$
P(X = k) = \binom{n}{k}p^k(1-p)^{n-k}
$$

Where $P(X = k)$ is the probablity that $k$ individuals of a given alleles will be sampled. Also, $n$ is the size of gene pool and $p$ is the current value of the allele frequency function. 

## Creating a simple drift simulation

The elegnce of the model allows to simulate one generation of reproduction using the `rbinom` function in R.

```r
p0=0.5
n=2*10

Sampler = rbinom(1,n,p0)

p1= Sampler/n
message( paste("at t0, p =", p0, "at t1, p =", p1, "delta=", p1-p0) )
```

## How to incorporate time into the mix?

Being able to simulate one generation is all well and good, but when it comes to drift, we want to be able to make predictions abot the fate of an allele over time. As such, our code needs to incorporate time, in the form of a recursion:

```R
library(foreach, lib.loc =  "/gpfs1/cl/biol6990/R_shared")
library(tidyverse)

t=100
p0=0.5

#run recursion
time_series=
foreach(n = c(2*10, 2*30, 2*100), .combine = "rbind")%do%{
  foreach( i = 1:t, .combine = "rbind" )%do%{
    Sampler=rbinom(1,n, p0)
    p1=Sampler/n
    return(data.frame(gen=i, size = n, p = p1))
  }}
  
time_series %>% 
ggplot(aes(
x=gen,
y=p,
color=as.factor(size)
)) +
geom_line() +
facet_wrap(~size, ncol = 3) ->
my_time_plot

ggsave(my_time_plot, file = "my_time_plot.pdf", w = 4, h = 4)

```

## In-class code challenge! -- form groups

While in class, create, deploy, and graph the outcome of a simulaiton to answer the question: What is the probability of extinction of a **brand new** allele that appears in a population of size (i.e., $n$ ) = 10, 50, 100, 1000... simulate 100 instances of evolution for each parameter.

To tackle this. challenge realize that the frequency of a new allele in a diploid population at the moment of introduction is:

$$
p_{init} = \frac{1}{2N} = \frac{1}{n}
$$ 

Also take full advantange of array jobs!

## Homework code challenge (EC)! 

How would the above simulation look like if we were to include selection in the mix? Assume that the fitness of the $x_{ii}$ genotype is 1.1 (i.e., produces 10% more offspring) and that the same is true for the $x_{ij}$ genotypes.

