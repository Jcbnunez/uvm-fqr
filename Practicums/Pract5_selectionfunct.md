# Creating functions to simulate selection

```bash
cd ~/scratch
mkdir practicum_5
cd practicum_5
```

The goal of this practicum are:
* To create a function that can simulate determistic patterns of selection 
* To generare a script with said function that can take user inputs
* To deploy the script using arrays to simulate various scenarious
* To analyze the outputs

## Part 1: creating a function for natural selection

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

|Blue|Purple|Red|
|--|--|--|
|2500|2500|2500|

* Pesticide site

|Blue|Purple|Red|
|--|--|--|
|2500|2500|2100|

For the purposes of simplicity lets just assume that these counts are a proxy for fitness. And that the blue bugs have lower fecundity is the "selection effect"... i.e., red bugs are investing ATP in detoxifying and not investing it in eggs... just entretain this thought experiment for a second...

### How can we quantify selection with this data? 

Clearly there appears to be something going on in these data. Pesticides are usually a very strong source of selection. Lets build some funky simulations so aspects of the data:


## the agency wants to know: how "fast" (how many generations) will the "toxic" allele be eliminated under this selection regime that reduces fecundity?

```r
#step 1 find the relative fitnesses of each genotype
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
### how long would it take?

---

## Data challenge 2: Assessing the statistical robustness of the test statistic using permutation analyses

**Parametric vs Non-Parametric testing** is a core concept of this challenge. As we have discussed in the course, many of the P-values that we have seen derive from tests that make some rather "stringent" assumptions about the data and the model being tested. Yet, herein lies the challenge, what if we are unsure that our data fits the parameters of the test well? Or, alternatively, what if we wanted to test our data free of assumptions tied to distributions? Enter *permutation* tests. 

Data IS your best friend and the same time data IS its own worst enemy. Let me explain. Under the classical parametric methods that we have been discussing in class so far, the P-values, and other metrics of significance and power, have relied on assumptions of the model itself. Yet, there are different ways to assess the statistical robustness of test statistics: asking the question **" is the statistical signal of my data"** better than what I would expect under pure **random chance?** 

#### Let's first create a data frame that has an internal structure:
To do this, let's simulate an adaptive cline of allele frequencies. 

|State|Latitude|wAA|wAa|waa|
|--|--|--|--|--|
|Maine|43.8|2000|2000|1700|
|Rhode_Island|41.7|2000|2000|1600|
|New_York|40.7|2000|2000|1500|
|Pennsylvania|39.9|2000|2000|1400|
|Virginia|37.8|2000|2000|1300|
|N_Carolina|35.4|2000|2000|1200|
|S_Carolina|34.2|2000|2000|1100|
|Georgia|31.9|2000|2000|1000|
|Florida|29.0|2000|2000|900|

This table of allele frequencies suggests that there is an "adaptive cline" up and down the East Coast. Let's go ahead and simulate this scenario.

```r
pop <- c("Maine","Rhode_Island", "New_York", "Pennsylvania","Virginia", "N_Carolina","S_Carolina", "Georgia", "Florida")
waa <- c(1700, 1600, 1500, 1400, 1300, 1200, 1100, 1000, 900)
lat <- c(43.8, 41.7, 40.7, 39.9, 37.8, 35.4, 34.2, 31.9, 29.0)

Pop_selection =
foreach(k=1:length(pop), .combine = "rbind")%do%{
waa_k=waa[k]
pop_k=pop[k]

p=0.001
wAA=2000
wAa=2000

foreach(waa)
simulating.selection=
  foreach(g=1:25, .combine = "rbind")%do%{
    if(g==1){p_recur[g]=p}
    p_recur[g+1] = calc_p_t1(p_recur[g], 
                             (1-p_recur[g]),
                             wAA, wAa, waa_k)
    data.frame(gen=g, p=p_recur[g+1],
               population = pop_k, wAA=wAA, wAa=wAa, waa=waa_k, pinit=p)
  } # close sel
  } # close k

Pop_selection %>%
ggplot(aes(
x=gen,
y=p,
color=population
)) +
geom_line() +
geom_hline(yintercept = 1) ->
selection_pops_plot

ggsave(selection_pops_plot, file = "selection_pops_plot.pdf")

```

#### Does the speed of selection correlated with latitude?
```r
Pop_selection %>%
filter(gen == 25) %>%
mutate(latitude = lat) ->
final_dat_lat

final_dat_lat %>%
ggplot(aes(
x=latitude,
y=p,
color=population
)) +
geom_point() ->
selection_lat

ggsave(selection_lat, file = "selection_lat.pdf")

cor.test(~latitude+p, data = final_dat_lat)
```
## Non-parametric assessment: Permutation test!
How to test the "robustness" of the test?

```r
data.frame(
real_lat=final_dat_lat$latitude,
p=final_dat_lat$p
)

data.frame(
real_lat=final_dat_lat$latitude,
randomzied_lat=sample(final_dat_lat$latitude),
p=final_dat_lat$p
)

cor.test(~sample(latitude)+p, data = final_dat_lat)

```

### Replication is key!

```r
real=cor.test(~latitude+p, data = final_dat_lat)$p.value

perms=
foreach(j=1:1000, .combine = "rbind")%do%{
perm=cor.test(~sample(latitude)+p, data = final_dat_lat)$p.value
}

###
rbind(
data.frame(type="real", p_val=real),
data.frame(type="perms", p_val=perms)
) -> results


###
ggplot() +
geom_density(
data=filter(results, type == "perms"),
aes(x=-log10(p_val)), fill = "grey"
) +
geom_vline(
data=filter(results, type == "real"),
aes(xintercept=-log10(p_val)), color = "red"
) ->
permutation_test

ggsave(permutation_test, file = "permutation_test.pdf")
```

### Empirical statistic
We can always calculate an empirical P-value of our real value relative to the permuted distribution!
```r
length(filter(results, type == "perms")$p_val) -> total_perms

sum(filter(results, type == "real")$p_val > sorted_perms) -> Number_that_beat_perms

#"Empirical P"
(Number_that_beat_perms/total_perms)
```


---
# Extra stuff ...


Exit `R` for a moment and let's adquire a file of starting conditions

```bash
cp /gpfs1/cl/biol6990/prac5/selection_array_conditions.txt ./
```

Let's explore it

```bash
head -n 10 selection_array_conditions.txt
```

### Create exploratory code

name it `simulate.selection.R`

```r
library(foreach)


args = commandArgs(trailingOnly=TRUE)
gens= as.numeric(args[1])
p= as.numeric(args[2])
wAA= as.numeric(args[3])
wAa= as.numeric(args[4])
waa= as.numeric(args[5])
#gens=1000; p=0.5; wAA=1; wAa=1; waa=0.5

#define function
calc_p_t1 = function( p, q, wAA, wAa, waa ){
num=p^2*wAA + p*q*wAa
dem=p^2*wAA + 2*p*q*wAa + q^2*waa
p_t1 = num/dem
return(p_t1)
} 

p_recur=c()
simulating.selection=
foreach(g=1:gens, .combine = "rbind")%do%{
if(g==1){p_recur[g]=p}
p_recur[g+1] = calc_p_t1(p_recur[g], 
						(1-p_recur[g]),
						wAA, wAa, waa)
data.frame(gen=g, p=p_recur[g+1],
wAA=wAA, wAa=wAa, waa=waa, pinit=p)
}

system("mkdir sel_sim_output")
save(simulating.selection, 
file = paste("sel_sim_output/simout",p,wAA,wAa,waa,"Rdata", sep = "."))
```

### Lets run the array

save as `launch_sel_sim.sh`

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
#SBATCH --array=1-48

module load Rtidyverse

paramfile=selection_array_conditions.txt

p=$(cat ${paramfile} |  sed '1d' | awk '{print $1}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )

wAA=$(cat ${paramfile} |  sed '1d' | awk '{print $2}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )

wAa=$(cat ${paramfile} |  sed '1d' | awk '{print $3}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )

waa=$(cat ${paramfile} |  sed '1d' | awk '{print $4}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )

echo $p $wAA $wAa $waa


#gens= as.numeric(args[1])
#p= as.numeric(args[2])
#wAA= as.numeric(args[3])
#wAa= as.numeric(args[4])
#waa= as.numeric(args[5])
Rscript --vanilla simulate.selection.R 1000 $p $wAA $wAa $waa

echo "done"
```
run it!
```bash
sbatch --account=biol6990 launch_sel_sim.sh
```

Lets look at job statisitcs
```
my_job_statistics <id>
```




