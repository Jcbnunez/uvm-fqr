# Creating functions to simulate selection

The goal of this practicum are:
* To create a function that can simulate determistic patterns of selection 
* To generare a script with said function that can take user inputs
* To deploy the script using arrays to simulate various scenarious
* To analyze the outputs

## Part 1: creating a fucntion for natural selection

The first challenge is to assess what are the variables that we may request from the user in order to generate a final product. This is an important consderation for us as "coders" that we must think about before jumping to coding. -- _Coding begins at the white board._

### What variables may we want to consider?

* allele frequencies?
* fitnesses? 
* Dominance coefficients?
* Population sizes?
* etc... etc..

### challenge.. allow the user to input the raw genotype counts.

Imagine a populaiton of insects of the same species. This species has a polyphenism: Red insects are toxic. Purple insects are mildly toxic. Blue insects dont have toxins. The USDA has approved the use of a pesticide that targets some aspect of the toxin pathway. The USDA has hired you as a genetics consultant to ascertain the impact of natural selection driven by this pesticide in the insect. Yet, they also want you to create a computer function that a farmer can use to do long term monitoring.

#### Here is what we know about this bug:

The toxin gene is mendelian and the protein produced naturally changes the color of the bug's carapace. Hence the color is a "true" (v.s. linked) indicator of the toxin genotype/phenotype.

|Red|Purple|Blue|
|--|--|--|
|AA|Aa|aa|

After a generation of selection, the farmer puts out a trap in two sites, one with pestice and one withouth, and collects insect counts.

* Control site

|Red|Purple|Blue|
|--|--|--|
|2489|4985|2541|

* Pesticide site

|Red|Purple|Blue|
|--|--|--|
|1745|3510|4489|

### How can we infer selection with this data? 

Clearly there appears to be something going on in these data. Pesticides are usually a very strong source of selection. Lets build some funky simulations so aspects of the data:

#### recall our old friend "HW.fit"?
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
output = data.frame(p.value = test$p.value)
return(output)

}## end function HW.fit
```

#### Fit our HW function!
```R
HW.fit(2489,4985,2541)
HW.fit(1745,3510,4489)
```
