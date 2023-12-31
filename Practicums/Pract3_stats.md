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
Note that `module load Rtidyverse` already comes with a lot of packages preinstalled. Lets load them
```r
library(tidyverse)
```

## Data challenge 1. Is "this" a good use of my time?

Imagine an orchard off Mount Mansfield. In this orchard you have discovered a very rare new species of insect :beetle: that **appears** to be polyphenic at different altitudes. Studying this insect could be great for your career! One minor problem... this insect is extremely rare you only have a very small window of time to do your sampling. Is it worth even trying? 

* Local farmers report seeing 1 insect every week.
* You only have 1 hour every week to do field-work
* You need at least 30 individuals for your study. 
* What is the probability that we will get 30 insects :beetle:, or more, i.e., $Pr(X >= 30)$ during visit?
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
4. Note that this means $0.00595$ how many insects you may see in an hour.

#### The probability of observing "_exactly_ 30 insects" vs. "30 insects _or more_"... this is the crux of the difference between the `dpois` and `ppois` functions (notice that `pois` is the poisson fucntion in `R`).
 
![enter image description here](https://raw.githubusercontent.com/Jcbnunez/uvm-fqr/main/etc/Figures/prac3/Poiss.differences.ipd.png)

---
### _exactly_ 30 insects :beetle:

$$
Pr(X=i) = f(i, \lambda) =  \frac{\lambda^ie^{-\lambda}}{i!}
$$

This is the probability that the function falls in a determined range of probability space
### 30 insects _or more_ :beetle:

$$
Pr(X\ge i) =   1 - Pr(X=i-1) 
$$

This is the sum probabilities to the right of the value of interest. Note however that the entire probability distribution must add up to one. So substracting one to the value  of the function a $i-1$ solves the question!

### `dpois` -> _exactly_ 30 insects :beetle:
```r
dpois(30,lambda=0.00595)
```
Here `dpois` solves the equation $Pr(X=i)$ for us.

### `ppois` -> 30 insects _or more_ :beetle: :beetle: :beetle: ...
```r
1-ppois(29,lambda=0.00595)
```
Here `ppois` calculates the cummulative probability up to $i-1$ and we substract $1$ (the totality of the probability space) to obtain our desired probability. We can always think of `ppois` as the probability of 29 _or less_.

##### Why are we observing these low numbers? What is going on?

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
We are going to create a data frame object in order to store the output of our loop. This will allow us to plot our results.
```
library(foreach, lib.loc = "/gpfs1/cl/biol6990/R_shared")
```
To do this we are going to use **enhanced loops** from the `foreach` package in `R`. I basically never use basic loops anymore, since these `foreach` loops are so powerful!
```r
foreach(i = 0:40, .combine = "rbind")%do%{

out = dpois(i,lambda=0.00595)

data.frame(iparam = i, Prob = out)
}
```
### save it to an object

```r
mydf = foreach(i = 0:40, .combine = "rbind")%do%{
out = dpois(i,lambda=0.00595)
data.frame(iparam = i, Prob = out)
}
```
Where `mydf` is an object with colums `mydf$iparam`, `mydf$Prob`,

### Now lets use ggplot to visualize the curve.
here we are going to use the `%>%` symbol to pipe data in R. This is similar to `|` in unix. We are going to pipe the data to the `ggplot` function, a powerful visualization tool! 
```r
mydf %>% 
ggplot(aes(x=iparam ,y=Prob)) + geom_line() -> myplot
ggsave(myplot, file = "myplot.pdf", w = 4, h = 4)
```
### lets modify $\lambda$ to 10
```r
foreach(i = 0:40, .combine = "rbind")%do%{
out = dpois(i,lambda=10)
data.frame(iparam = i, Prob = out)} %>%
ggplot(aes(x=iparam ,y=Prob)) + geom_line() -> myplot
ggsave(myplot, file = "myplot.pdf", w = 4, h = 4)
```
### Lets plot a sample of  many $\lambda$ parameters
To this end we are going to use a nested foreach loop
```r
mydf_double = 
foreach(l = 0:10, .combine = "rbind")%do%{
foreach(i = 0:40, .combine = "rbind")%do%{
out = dpois(i,lambda=l)
data.frame(lambda = l, iparam = i, Prob = out)
} # i loop
} # l loop
```
Lets map $\lambda$  to color
```r
mydf_double %>% 
ggplot(aes(
x=iparam,
y=Prob,
color = as.character(lambda) 
)) + 
geom_line() -> myplot
ggsave(myplot, file = "myplot.pdf", w = 4, h = 4)
# These spacing patterns are tolerated by R ...
# (not other languages like python).
```
##### Why I am plotting $\lambda$ `as.character`? What would happen if I allow it to be a number?
##### Also, should you conduct your study in a universe where $\lambda=0.05$ vs $\lambda=10$...?

### Generalizing some things
Note that these function structure `dpois` or `ppois` also exist for all sorts of fucntions ... such as `binom` (binomial), `norm` (normal) ... This will come in handy in later parts of the class.


## Data challenge 2. Is this apples to oranges, apples to apples, or underpowered? (but it is :ocean: _sea snails_ :shell:!).

A certain species of marine snail :shell: lives in an intertidal ecosystem. A 30 year study  has shown that the diameter of shell phenotypes vary across the intertidal, and that the phenotypic variation follows a "_normal_" (or _Gaussian_) distrbution with different parameters across the low and high intertidal microhabitats.

> The formula for _Gaussian_ distribution is
> 
$$
f(i | \mu,\sigma^2) = (\sigma\sqrt {2\pi})^{-1}   e^{-\frac{1}{2} (\frac{i-\mu}{\sigma})^2 }
$$

With core parameters being $\mu$ (mean) and $\sigma$ (standard deviation). And special case 

> The _Normal_ is a special _Gaussian_ case
 
$$
f(i | 0,1) =  \frac{e^{\frac{-i^2}{2}}}{\sqrt{2\pi}}
$$

The 30 year study indicate that, in the upper tide, :shell: diameters can be described as random variables $I$ that behave as described below

| tidal habitat | :ocean::shell:  function |
| -- | -- |
|Upper Tide|$I_u \sim \mathscr N(10.2,3.8)$|
|Lower Tide|$I_l \sim \mathscr N(11.5,5.3)$|

* Note that $I_u \sim \mathscr N(10.2,3.8)$ ... **is just mathematical notation for "follow a _Gaussian_/_Normal_ dristibution with mean 1.2 and standard deviation 0.8"** (in the upper tidal zone, anyways). 

The challenge is simple, based on these known statistical properties of the populations, **how many individuals** should I sample across both microhabitats in order to show that the diameters of :shell: across these habitats is different... at a significance level of 5% (i.e. two-tailed $\alpha = 0.05$)?

### This challenge is ultimately all about (statistical) _power_!
One of the most foundational questions of quantitative analysis is whether or not two observations sampled from nature derive from the results of **the same** or **different** biological (or physical, chemical,...) processess. The common null expectation  is that observations  from a population derive from the same process. This is that, many from a **random samples** $i$ :shell:  ($I = i_1, i_2, i_3 ...$) that will be distributed as  $I \sim \mathscr N(\mu,\sigma^2)$. 

* This gives rise to the language of "Null hypothesis"
* More precisely, the null hypothesis ($H_0$) is that any two sets of observations are simply derived from the same underlying distribution (i.e., are generated by the same process).
* Producing evidence to the contrary (i.e., that two observations do not derive from the same distribution; $H_1$) suggest that the underlying biological process at play may be different. And that may be very interesting... (example: drug treatments, histories of selection, _etc._)

#### Our capacity to effectively be able to reject this null hypothesis, if the samples truly come from different distributions, is what we call statistical power. There are several types of power

||$H_0\ true$|$H_0\ false$|
|--|--|--|
|$H_0\ rejected$|$\alpha$|$1-\beta$|
|$H_0\ not\ rejected$|$1-\alpha$|$\beta$|

or

||$H_0\ true$|$H_0\ false$|
|--|--|--|
|$H_0\ rejected$|False Positive|$power$|
|$H_0\ not\ rejected$|True Negative|False Negative|

* More formally power is the probability that we will correctly reject the null hypothesis (assuming that the alternative hypothesis is in fact true):

$$
power = 1- \beta = Pr(reject\ H_0 | H_1\ is\ true)
$$

* Intuitively this may be interpreted as... if we have power = 95%.. then... if I repeat my experiment 100 times, 95 times I should correctly reject the null (i.e., get a "true positive"). Yet, logically this suggests that 5 times I will get a **"false negative"**... but I can live with that.
* _P_-value **thresholds** (e.g., 5% significance) are called $\alpha$ and corresponds to the "tolerance" for **"false positives"** that we as investigators are willing to accept.

---

### Ok... lets get to simulating Virtual  :robot: :ocean: Snails :shell:
Whereas the functions `pnorm` and `dnorm`  (recall `ppois` and `dpois`) are desgined to describe probabilties, we can do the reverse by using `rnorm`. In this context, what the function seeks to do is to **sample** or simulates samples from a distribution of known parameters.
```r
# Simulate an individual (upper tide)
rnorm(n=1, mean = 10.2, sd = 3.8)
#function (n, mean = 0, sd = 1)
```
```r
# Simulate a population (upper tide)
rnorm(n=15, mean = 10.2, sd = 3.8)
#function (n, mean = 0, sd = 1)
```
### Population mean ($\mu$) vs. sample mean ($\bar{x}$)
While we know that the upper tidal snails have :ocean::shell: $\sim \mathscr N(10.2,3.8)$, and thus the. **true** mean of the population should be $12.2$ what would happen if we calculate the mean of our sample `rnorm(n=15, mean = 10.2, sd = 3.8)`.

```r
foreach(i = 1:10, .combine = "rbind")%do%{
rnorm(n=15, mean = 10.2, sd = 3.8) %>% mean -> xbar
data.frame(trial=i, mean=xbar) 
}
```
##### Why is there noise around the mean ... when these are simulated Virtual  :robot: Snails :shell:? (hint -- sample means are strongly affected by the sample size and the variance $\sigma$ of the population )

### The impact of sample size on $\bar{x}$
```r
mean_explorer=
foreach(i = 1:500, 
.combine = "rbind")%do%{
rnorm(n=i, mean = 10.2, sd = 3.8) %>% mean -> xbar
data.frame(samplesize=i, mean=xbar)
}

mean_explorer %>%
ggplot(aes(
x=samplesize,
y=mean
)) +
geom_line() +
geom_hline(yintercept = 10.2) -> myplot

ggsave(myplot, file = "myplot.pdf", w = 6, h = 4)
```

# :mortar_board:HOMEWORK:mortar_board: : please include in your next reflection:
1. an exploration of the variance `sd` parameter. Plot it using the `color` option in ggplot. Explore at least 4 other `sd` parameters. 
2. Also include small reflection on "what evolutionary force may reduce variance in a phenotype?"

---

### Lets now compare the upper and lower intertidal populations
```r
#simulate high tide
upper_samps =
data.frame(
shell=rnorm(n=25, mean = 10.2, sd = 3.8),
habitat="upper"
)

#simulate low tide
lower_samps =
data.frame(
shell=rnorm(n=25, mean = 11.5, sd = 5.3),
habitat="lower"
)

both_samps = rbind(upper_samps, lower_samps)
```
### Visualization with box plots
```r
both_samps %>%
ggplot(aes(
x=habitat,
y=shell,
)) +
geom_boxplot()-> myplot

ggsave(myplot, file = "myplot.pdf", w = 6, h = 4)
```
# Simulation based power analysis
With all the pieces in place in place, we can finally dive into the power analysis proper. There are many ways to do a power analysis, some are off-the-shelf methods that use paramteric assumotions. Those are fine. Though, lets explore using simulations (as we have been doing it) to assess power across our tests. 

```r
power_analysis=
foreach(N = seq(from=10, to=1000, by=10), .combine = "rbind")%do%{
foreach(k=1:100, .combine = "rbind")%do%{
#simulate high tide
upper_shells_sample=rnorm(n=N, mean = 10.2, sd = 3.8)
#simulate low tide
lower_shells_sample=rnorm(n=N, mean = 11.5, sd = 5.3)
# run the test
test_result=t.test(upper_shells_sample,lower_shells_sample)
#has the null hypothesis been rejected? it should be!
true_positive=test_result$p.value < 0.05
#create an output data frame
output =
data.frame(
sample_size=N,
simulation_id=k,
true_positive=true_positive
)
#explicitly tell the loop to return the "output" into memory
message(paste("just finished", k, "of", N, sep = " "))
return(output)
} # close k
} # close N
```

### Now let's summarize the output
```r
power_analysis %>%
group_by(sample_size, true_positive) %>%
summarize(observations=n()) -> true_false_table
```
### Graph
```r
true_false_table %>%
ggplot(aes(
x=sample_size,
y=observations/100,
color=true_positive
)) + geom_line() +
ggtitle("Simulated power of alpha 5% at sample size:")-> myplot

ggsave(myplot, file = "myplot.pdf", w = 6, h = 4)
```
### So the sample size is...?
```r
true_false_table %>%
filter(true_positive == TRUE) %>%
filter(observations > 95) %>%
arrange() %>%
head(1)
```
~huzza for simulated Virtual  :robot: :ocean: Snails :shell:!
