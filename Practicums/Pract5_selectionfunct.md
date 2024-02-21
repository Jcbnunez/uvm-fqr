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
### how long woult it take?

---

# Let's explore parameter space a bit ...

## Challenge 1 (Lets create an array job to explore parameters):

Exit `R` for a moment and lets adquire a file of starting conditions

```bash
cp /gpfs1/cl/biol6990/prac5/selection_array_conditions.txt ./
```

Lets explore it

```bash
head -n 10 selection_array_conditions.txt
```

### Create exploratory code

name it `simulate.selection.R`

```r
library(foreach, lib.loc = "/gpfs1/cl/biol6990/R_shared")


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

## Challenge: Collate and analyse.. using our code from preacticum 4

What can we infer from this simulation analysis?
