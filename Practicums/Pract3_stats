# Refresher of statistics (-Pract) & R refresher/introduction

In this practicum, we will review some basic concepts of probability and statistics. We will do this while also covering basic functionalities of the R programming langauge.

## Logging into VACC to work with R

We have two avenues of working in R inside the VACC. Both are acceptable in this class. For either option you must first Log into [UVM OOD's](https://www.uvm.edu/vacc/kb/knowledge-base/ondemand/) system to iterface with the VACC.

1. Option 1: Use two browser tabs. one for the command line and the second to see outputs and visualizations.
2. Option 2: Use the VM of Rstudio inside the VACC.

## Activating R in the VACC

While in the VACC bash (either in OOD-direct or in the VM). 
> Use directly in the OOD shell
```bash
module load Rtidyverse
R
```
> Use in the VM shell 
```bash
module load Rtidyverse
module load rstudio
rstudio
```
## Loading packages needed inside R
Note that `module load Rtidyverse` already comes with a lot of packages preinstalled.
```r
library()
```

## Data challenge 2. Is this apples to oranges, apples to apples, _or_ is my experiment underpowered?

Imagine an orchard off Mount Mansfield. The orchard spand from the base of the mountain to high elevation (as high as it can support crops). In this orchard you have discovered a very rare new species of insect that **appears** to be polyphenic at different altitudes. Studying this insect could be great for your career! One minor problem... this insect is extremely rare you only have a very small window of time to do your sampling. Is it worth even trying? 

* Local farmers report seeing 1 insect every week.
* You only have 1 hour every week to do field-work
* You need at least 30 individuals for your study. 
* What is the probability that we will get 30 insects, or more, i.e., $Pr(X >= 30)$ during visit?
* What is the probability that we will get exactly 30 insects $Pr(X = 30)$ during your visit? (interestingly, these are two different questions). 

### This is a Poission distribution issue! (yay!)
$$
Pr(X=i) =  \frac{\lambda^ie^{-\lambda}}{i!}
$$
The function describes probability of an event happening a certain number of times, $i$, within a given interval of time or space (e.g., 1 hour, _etc._). Contingent on the fact that this event occurs at rate $\lambda$.

### Lets find the $\lambda$ _per hour_ parameter for our insect
1. Farmers see it every week
2. A week has 168 hours
3. Thus, $\lambda = 1/168 = 0.00595$  
4. Note that this means $0.00595$ how many insect you may see in an hour.

#### The probability of observing "_exactly_ 30 insects" vs. "30 insects _or more_"... this is the crux of the difference between the `dpois` and `ppois` functions (notice that `pois` is the poisson fucntion in `R`).
 
![enter image description here](https://raw.githubusercontent.com/Jcbnunez/uvm-fqr/main/etc/Figures/prac3/Poiss.differences.ipd.png)

---
### _exactly_ 30 insects
$$
Pr(X=i) = f(i, \lambda) =  \frac{\lambda^ie^{-\lambda}}{i!}
$$
This is the probability that the function falls in a determined range of probability space
### 30 insects _or more_
$$
Pr(X\ge i) =   1 - Pr(X=i-1) 
$$
This is the sum probabilities to the right of the value of interest. Note however that the entire probability distribution must add up to one. So substracting one to the value  of the function a $i-1$ solves the question!

### `dpois` -> _exactly_ 30 insects
```r
dpois(30,lambda=0.00595)
```
Here `dpois` solves the equation $Pr(X=i)$ for us.

### `ppois` -> 30 insects _or more_ 
```r
1-ppois(29,lambda=0.00595)
```
Here `ppois` calculates the cummulative probability up to $i-1$ and we substract $1$ (the totality of the probability space) to obtain our desired probability. We can always think of `ppois` as the probability of 29 _or less_.

### Let's investigate what is going on here ...
```r
for(i in 0:40){
out = dpois(i,lambda=0.00595)
print(out)
}
```
Here we are introducing our first loop in `R`. Notice how it is very similar to our loops in `unix`... yet they are different. For examples the variable `i` is recalled with `i` (i.e., itself) as opposed to `${i}` like in unix. 
### Let's make it more human friendly
```r
for(i in 0:40){
out = dpois(i,lambda=0.00595)
print(paste("when i=", i, "Pr =", out, sep = " ") )
}
```
### Let's visualize it
We are going to create a data frame object in order to store the output of our loop. This will allow us to plot our results





### Let's visualize the probability with `rpois`
Whereas `ppois` and `rpois` return respectively, the probility of $Pr(X=i)$ as well as 
```

```
