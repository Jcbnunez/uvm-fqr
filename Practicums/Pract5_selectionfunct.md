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
|3300|3510|4489|

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
HW.fit(3300, 3510, 4489)
```

## the USDA wants to know: how "fast" (how many generations) will the "toxic" allele be eliminated under this strong selection?

```r
#step 1 find fitnesses of each genotype
AA=3300; Aa=3510; aa=4489
max_w = max(AA, Aa, aa)

#step 2: calculate relative fitness
wAA = AA/max_w
wAa = Aa/max_w
waa = aa/max_w

message( paste("AA w is", round(wAA, 3), "Aa w is", round(wAa, 3), "aa w is", round(waa, 3), sep = " "  ) )

#step 3 calculate allele frequency
N=AA+Aa+aa
p=(2*AA+Aa)/(2*N)
q=(1-p)

#step 4
calc_p_t1 = function( p, q, wAA, wAa, waa  ){
num=p^2*wAA + p*q*wAa
dem=p^2*wAA + 2*p*q*wAa + q^2*waa
p_t1 = num/dem
return(p_t1)
} 

calc_p_t1(p, q, wAA, wAa, waa)
```

$$
p_{t+1} = \frac{p^2\omega_{AA} + pq\omega_{Aa} }{\bar{\omega}} 
$$

### Yet, this is just a prediction after one generation. How can we get we simulate multiple generations?

```r
calc_p_t1 = function( p, q, wAA, wAa, waa  ){
num=p^2*wAA + p*q*wAa
dem=p^2*wAA + 2*p*q*wAa + q^2*waa
p_t1 = num/dem
return(p_t1)
} 

library(foreach, lib.loc = "/gpfs1/cl/biol6990/R_shared")
#lets carry over p, wAA, wAa, waa from above
message(paste(p, wAA, wAa, waa, sep = " ") )

# create an empty variable for "recursive" use
p_recur=c()
#lets simulate 100 generations

simulating.selection=
foreach(g=1:100, .combine = "rbind")%do%{
if(g==1){p_recur[g]=p}
p_recur[g+1] = calc_p_t1(p_recur[g], 
						(1-p_recur[g]),
						wAA, wAa, waa)
data.frame(gen=g, p=p_recur[g+1])
}

simulating.selection %>%
ggplot(aes(
x=gen,
y=p
)) +
geom_line() 

```


## Challenge 2:
how would you report the "dominance" coefficient from the genotype counts? Use this code snippet:
```r
## can you calculate dominance?
if(wAA == wAa){
message("A is dominant")
} else if(waa == wAa){
message("a is dominant")
} else if(wAA != wAa | waa != wAa){
if(wAA == 1){
message("?")
} else if(waa == 1){
}
message("?")
}
} ## close elseif
```
