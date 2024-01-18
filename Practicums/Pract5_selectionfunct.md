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

Imagine a populaiton of insects of the same species. This species has a polyphenism: Red insects are toxic. Purple insects and Blue insects dont have toxins. The USDA has approved the use of a hyper specialzied pesticide that only targets some aspect of the toxin pathway. Insects witouth the toxins will process the chemical with no effects. The USDA has hired you as a genetics consultant to ascertain the impact of natural selection driven by this pesticide in the insect. Yet, they also want you to create a computer function that a farmer can use to do long term monitoring.

#### Here is what we know about this bug:

The toxin gene is mendelian and the protein produced naturally changes the color of the bug's carapace. Hence the color is a "true" (v.s. linked) indicator of the toxin genotype/phenotype.

|Blue|Purple|Red|
|--|--|--|
|AA|Aa|aa|

After a generation of selection, the farmer puts out a trap in two sites,  observes the average fecundity of each female in the trap, per genotype, after applying pesticide in a given site, and collects insect counts.

* Control site

|Red|Purple|Blue|
|--|--|--|
|2500|2500|2500|

* Pesticide site

|Red|Purple|Blue|
|--|--|--|
|2500|2500|2100|

For the purposes of simplicity lets just assume that these counts are a proxy for fitness. And that the blue bugs have lower fecundity is the "selection effect"... i.e., red bugs are investing ATP in detoxifying and not investing it in eggs... just entretain this thought experiment for a second...

### How can we infer selection with this data? 

Clearly there appears to be something going on in these data. Pesticides are usually a very strong source of selection. Lets build some funky simulations so aspects of the data:


## the USDA wants to know: how "fast" (how many generations) will the "toxic" allele be eliminated under this strong selection?

```r
#step 1 find fitnesses of each genotype
AA=2500; Aa=2500; aa=2100
max_w = max(AA, Aa, aa)

#step 2: calculate relative fitness
wAA = AA/max_w
wAa = Aa/max_w
waa = aa/max_w

message( paste("AA w is", round(wAA, 3), "Aa w is", round(wAa, 3), "aa w is", round(waa, 3), sep = " "  ) )

#step 3 assume, for simplicity that the true allele frequencies in the population before selection are p = 0.5 and that q = 0.5
p=0.5
q=0.5

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
calc_p_t1 = function( p, q, wAA, wAa, waa ){
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
#lets simulate 1000 generations

simulating.selection=
foreach(g=1:1000, .combine = "rbind")%do%{
if(g==1){p_recur[g]=p}
p_recur[g+1] = calc_p_t1(p_recur[g], 
						(1-p_recur[g]),
						wAA, wAa, waa)
data.frame(gen=g, p=p_recur[g+1],
wAA=wAA, wAa=wAa, waa=waa, pinit=p)
}

simulating.selection %>%
ggplot(aes(
x=gen,
y=p
)) +
geom_line() +
geom_hline(yintercept = 1, color = "red")

```
### how long woult it take?

---

# Let's explore parameter space a bit ...

## Challenge 1 (Lets create an array job to explore parameters):
```r
simulating.selection=
foreach(g=1:100, .combine = "rbind")%do%{
if(g==1){p_recur[g]=p}
p_recur[g+1] = calc_p_t1(p_recur[g], 
						(1-p_recur[g]),
						wAA, wAa, waa)
data.frame(gen=g, p=p_recur[g+1],
wAA=wAA, wAa=wAa, waa=waa, pinit=p)
}

```


---

## Challenge 2 (Homework):
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
