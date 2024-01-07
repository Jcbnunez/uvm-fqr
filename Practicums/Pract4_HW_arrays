# Scaling up (-prac) analytical pipelines using the VACC + Null model testing!

A common practice in evolutionary biology is to test whether real, or simulated data (under a set of conditions), fit the mathematical expectations of the   [Hardy & Weinberg](https://www.nature.com/scitable/definition/hardy-weinberg-equilibrium-122/) model. As part of this exercise we will also practice two important tools for scaling up research. These are **functions** and **arrays**.

## Data challenge 1: Building functions to explore Hardy & Weinberg, and sampling
Lets start by creating a fundtion in R to explore whether user provided values of $f_{AA}$ , $f_{aa}$, $f_{Aa}$ of a simulated population, fit with the expectations of Hardy & Weinberg. 

```r
HW.fit = function( AA, Aa, aa, testid ){

# First sanity check
# Helping the user by providing error messages in case of bad input
for(i in c(AA, Aa, aa)){
if(is.numeric(i)){}else(stop("Genotypes are not numeric!"))
}

# First estimate sample size
N=AA+Aa+aa
# Second calculate allele frequencues
p=(2*AA+Aa)/(2*N)
q=(2*aa+Aa)/(2*N)

# second sanity check
if(p+q == 1){message("p+q=1; ok!")}else(stop("Genotypes do not add up to 1!"))

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
output = data.frame(testid = testid, p.value = test$p.value)
return(output)

}## end function HW.fit

```
## Lets break down this code bit-by-bit

### The function's architecture
```r
HW.fit = function( AA, Aa, aa, testid ){
}
```
Where  `AA`, `Aa`, `aa`, and `testid` are the inputs to the function. They are expected to be provided by the user. Alternatively you can **set**  default parameters

```r
HW.fit = function( AA=720, Aa=160, aa=120, testid="ex.1" ){
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
q=(2*aa+Aa)/(2*N)

# second sanity check
if(p+q == 1){message("p+q=1; ok!")}else(stop("Genotypes do not add up to 1!"))
```
Parses the input data into other types of data to be used in down stream analyses. Here are are creating variables for `N` sample size, as well as `p` and `q`. This is also accompanied by a secondary sanity check for allele frequencies having to add to 1.

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
output = data.frame(testid = testid, p.value = test$p.value)
return(output)
```
## Some values to try it out

|case|AA|Aa|aa|
|--|--|--|--|
|ex.1|720|160|120|
|ex.2|10|180|810|

```r
HW.fit(720,160,120, "ex.1")
HW.fit(10,180,810, "ex.2")
```

# Processing large simulations (or user inputs) using arrays (Data challenge 2)

Lets say that you wanted to conduct a simulation experiment trying to determine the number of Hardy & Weinberg **false positives** that you observe as a function of sample size as well as a function of statistical stringency, i.e,. $\alpha$ across 1000 simulated loci. 

To do this 
