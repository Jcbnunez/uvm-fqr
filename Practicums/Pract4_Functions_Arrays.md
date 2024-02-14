# Scaling up (-prac) analytical pipelines using the VACC + Null model testing!

A common practice in evolutionary biology is to test whether real, or simulated data (under a set of conditions), fit the mathematical expectations of the   [Hardy & Weinberg](https://www.nature.com/scitable/definition/hardy-weinberg-equilibrium-122/) model. As part of this exercise we will also practice two important tools for scaling up research. These are **functions** and **arrays**.

## Data challenge 1: Building functions to explore Hardy & Weinberg, and sampling
Lets start by creating a fundtion in R to explore whether user provided values of $f_{AA}$ , $f_{aa}$, $f_{Aa}$ of a simulated population, fit with the expectations of Hardy & Weinberg. 

```r
HW.fit = function( AA, Aa, aa ){

# First sanity check
# Helping the user by providing error messages in case of bad input
for(i in c(AA, Aa, aa)){
if(is.numeric(i)){}else(stop("Genotypes are not numeric!"))
}

# First estimate sample size
N=AA+Aa+aa
# Second calculate allele frequencues
p=(2*AA+Aa)/(2*N)
q=(1-p)

## If the data made it this far the it means that it must be look like population genetic data..
# Now lets calculate the expected frequencies of genotypes we should see:
Exp_AA = p^2
Exp_Aa = 2*p*q
Exp_aa = q^2

## Now lets calculate a statistic of goodness of fit.
## First create two "vectors (these are R objects)," one for the observed counts and the second for the expected counts. 
expected_freq = c(Exp_AA, Exp_Aa, Exp_aa)
observed = c(AA, Aa, aa)

#conduct the test
test = chisq.test(observed, p = expected_freq)

#output
output = data.frame( p.value = test$p.value)
return(output)

}## end function HW.fit

```
## Lets break down this code bit-by-bit

### The function's architecture
```r
HW.fit = function( AA, Aa, aa ){
}
```
Where  `AA`, `Aa`, and `aa` are the inputs to the function. They are expected to be provided by the user. Alternatively you can **set**  default parameters

```r
HW.fit = function( AA=720, Aa=160, aa=120 ){
}
```
The assumtion is that these arguments will be passed down into the function.

### Communicating with the user .. you or otherwise
```r
for(i in c(AA, Aa, aa)){
if(is.numeric(i)){}else(stop("Genotypes are not numeric!"))
}
```
This code checks for the data properties and outputs an error if conditions are not met

### Create internal variables from user inputs
```r
# First estimate sample size
N=AA+Aa+aa
# Second calculate allele frequencues
p=(2*AA+Aa)/(2*N)
q=(1-p)
```
Parses the input data into other types of data to be used in down stream analyses. Here are are creating variables for `N` sample size, as well as `p` and `q`. 

### Create test statistic
Here we have to do a quick review of math one more time.  Basically what we seek to do here is to ask a simple question. Are the observed values for `AA`, `Aa`, `aa` what we would expect based on the Hardy & Weinberg expectation? Recall:

$$
Pr(Ho_{AA}) = p^2
$$

$$
Pr(Ho_{aa}) = q^2
$$

$$
Pr(He) = 2pq
$$ 

We can calculate these expectations as follows: 
```r
Exp_AA = p^2
Exp_Aa = 2*p*q
Exp_aa = q^2
```

### Fitting a $\chi^2$ test for observed vs. expected.
We can use the built in $\chi^2$  test in `R` to test whether the expected frequencies and the observe frequencies match. More formally the test looks for the association between two variables that the dimentions of an contingency table influence each other or are independent of each other. 

> use  $\chi^2$ for large sample sizes, and Fisher's Exact test for smaller sample sizes (single digits).
> 
```
expected_freq = c(Exp_AA, Exp_Aa, Exp_aa)
observed = c(AA, Aa, aa)

#conduct the test
test = chisq.test(observed, p = expected_freq)
```
To be prescise here, our null hypothesis is that the observed values are derived from, or consistent with, the expectations of Hardy & Weinberg. Simply put a $P-value < 0.05$ indicates a deviation from Hardy & Weinberg.

### Report the output
Finally we are creating an output, a data frame, that will save the $P-value$ and some information provided by the user, a `testid`. Notice, that we are telling the function to `return` the `output` object... this is key for functions, otherwise nothing will be saved to memory.
```r
#output
output = data.frame(p.value = test$p.value)
return(output)
```
## Some values to try it out

|case|AA|Aa|aa|
|--|--|--|--|
|ex.1|720|160|120|
|ex.2|10|180|810|

```r
HW.fit(720,160,120)
HW.fit(10,180,810)
```

# Data challenge 2: Producing large simulations using arrays 

Lets say that you wanted to conduct a simulation experiment trying to determine the number of Hardy & Weinberg **false positives** that you observe as a function of _sample size_,  _allele frequency_, as well as a function of statistical stringency, i.e,. $\alpha$ across 1000 simulated loci. 

This is sort of tricky because we have to simulate 1000 mutations (each with 3 genotypes), across various levels of base $p$,  with several sample sizes $N$, and evaluate them at various levels of $\alpha$ ... like so

|param.set|$p$|$N$|$\alpha$|
|--|--|--|--|
|1|0.1|10|0.1|
|2|0.4|10|0.1|
|3|0.6|10|0.1|
|4|0.8|10|0.1|
|5|0.9|10|0.1|
|6|0.1|100|0.1|
|7|0.4|100|0.1|
|8|0.6|100|0.1|
|9|0.8|100|0.1|
|10|0.9|100|0.1|
|11|0.1|500|0.1|
|12|0.4|500|0.1|
|13|0.6|500|0.1|
|14|0.8|500|0.1|
|15|0.9|500|0.1|
|16|0.1|1000|0.1|
|17|0.4|1000|0.1|
|18|0.6|1000|0.1|
|19|0.8|1000|0.1|
|20|0.9|1000|0.1|
|21|0.1|10|0.05|
|22|0.4|10|0.05|
|23|0.6|10|0.05|
|24|0.8|10|0.05|
|25|0.9|10|0.05|
|26|0.1|100|0.05|
|27|0.4|100|0.05|
|28|0.6|100|0.05|
|29|0.8|100|0.05|
|30|0.9|100|0.05|
|31|0.1|500|0.05|
|32|0.4|500|0.05|
|33|0.6|500|0.05|
|34|0.8|500|0.05|
|35|0.9|500|0.05|
|36|0.1|1000|0.05|
|37|0.4|1000|0.05|
|38|0.6|1000|0.05|
|39|0.8|1000|0.05|
|40|0.9|1000|0.05|
|41|0.1|10|0.01|
|42|0.4|10|0.01|
|43|0.6|10|0.01|
|44|0.8|10|0.01|
|45|0.9|10|0.01|
|46|0.1|100|0.01|
|47|0.4|100|0.01|
|48|0.6|100|0.01|
|49|0.8|100|0.01|
|50|0.9|100|0.01|
|51|0.1|500|0.01|
|52|0.4|500|0.01|
|53|0.6|500|0.01|
|54|0.8|500|0.01|
|55|0.9|500|0.01|
|56|0.1|1000|0.01|
|57|0.4|1000|0.01|
|58|0.6|1000|0.01|
|59|0.8|1000|0.01|
|60|0.9|1000|0.01|

### So what should we do? 

* Run a multilayered nested loop?
* Use HPC arrays to paralelize this analysis? (<-- Lets try this)

Array jobs are a tool available in HPC clusters that allow launching the same job across multiple independent cores. Most notably, each iteration of the array can take in a set of different values hence allowing us to parallelize analyses easily.  

### First lets import a copy of our script

```bash
#go to scratch
mkdir pract_4
cd pract_4
module load Rtidyverse 
cp /gpfs1/cl/biol6990/prac4/hw.test.R ./
```

## Lets create a script to paralelize our simulation
Try it out... make sure to exit and re-eneter R... use `q("n")` to exit.

### Part 1. R portion

```r
## ---------------------------
## Script name: simulate.HW.R
## Purpose of script: FQR practicum 4
## Author: Dr. JCB Nunez
## Date Created: 2024-01-07
## Copyright (c) Joaquin C. B. Nunez, 2024 [if aplicable]
## Email: joaquin.nunez@uvm.edu
## ---------------------------
## Notes: For classroom use!
## ---------------------------

# User define inputs
args = commandArgs(trailingOnly=TRUE)
N=as.numeric(args[1])
init_p=as.numeric(args[2])
alpha=as.numeric(args[3])

### Load libraries
library(foreach, lib.loc = "/gpfs1/cl/biol6990/R_shared")
#this will allow us to import our function (that we previously made) into R.
source("hw.test.R")
#HW.fit(720,160,120, "ex.1")

### USER PROVIDED INPUT

###

## Some dummy examples
#N=1000; init_p=0.6; alpha=0.01
simulation.output =
foreach(i=1:1000, .combine="rbind")%do%{

############ ########## ########### ####### ###########
### WE WILL COVER THIS IN LATER LECTURES! DO NOT WORRY!!!
AA_sim=rbinom(1, N, p=init_p^2)
aa_sim=rbinom(1, N, p=(1-init_p)^2)
Aa_sim=rbinom(1, N, p=2*((1-init_p)*init_p))
############ ########## ########### ####### ###########

message( paste("sampled AA is", AA_sim,
"| sampled aa is", aa_sim,
"| sampled Aa is", Aa_sim, sep =" "))

HW.fit(AA_sim,Aa_sim,aa_sim)
}

logical.vec = table(simulation.output < alpha)

final.output =
data.frame(
sample_size=N,
simulations=1000,
initial_freq=init_p,
significance_tresh=alpha,
test=logical.vec
)

save(
final.output , 
file = paste("chunk_pra4",N,init_p,alpha, "Rdata", sep =".") 
)
```
Save to your folder using OOD's capabilties as `myfile.R`


## Lets look at our a parameter file
Lets copy and explore our premade file:
```bash
cp /gpfs1/cl/biol6990/prac4/parameter.file.txt ./
head parameter.file.txt
```

### Part 1. VACC (Unix) portion
```bash
#!/usr/bin/env bash
#
#SBATCH -J run_array
#SBATCH -c 1
#SBATCH -N 1 # on one node
#SBATCH -t 6:00:00 
#SBATCH --mem 10G 
#SBATCH -o ./slurmOutput/run_array.%A_%a.out
#SBATCH -p bluemoon
#SBATCH --array=1-60

module load Rtidyverse

paramfile=parameter.file.txt

# Recall in R
#N=as.numeric(args[1])
#init_p=as.numeric(args[2])
#alpha=as.numeric(args[3])
#jobnum  p       n       a

init_p=$(cat ${paramfile} |  sed '1d' | awk '{print $2}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )
N=$(cat ${paramfile} |  sed '1d' | awk '{print $3}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )
alpha=$(cat ${paramfile} |  sed '1d' | awk '{print $4}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )

Rscript --vanilla myfile.R ${N} ${init_p} ${alpha}

```

Save to your folder using OOD's capabilties as `launch.myfile.sh`

#### Launch with:

```bash
sbatch --account=biol6990 launch.myfile.sh
```
Lets check on the status of the job.. they should run pretty quickly.... also Lets look at job statisitcs
```
my_job_statistics <id>
```

# Data challenge 3: Processing multiple array outputs into a final analysis

We are going to collate all of this data using an integrated pipeline of R and Unix... through R using the `system` command!
```bash
module load Rtidyverse 
```
#### Collate and analyse the output by combining Unix and R

```r
#load important libraries
library(foreach, lib.loc = "/gpfs1/cl/biol6990/R_shared")
library(tidyverse)

#use a loading loop with system to read all the files
command = paste("ls | grep 'chunk_pra4' " )
files_o = system(command, intern = TRUE )

collated.files =
foreach(i=files_o, .combine="rbind")%do%{
message(i)
o = get(load(i))
}

## Lets graph our results
collated.files %>%
ggplot(aes(
x=sample_size,
y=test.Freq,
color=as.character(significance_tresh)
)) + 
geom_line() +
geom_point() +
facet_grid(test.Var1~initial_freq, scales = "free_y") ->
hw.falsenegs

ggsave(hw.falsenegs, file = "myplot.pdf", w = 9, h = 4)
```
What can we infer from this simulation analysis?
