# Output VCF files in SLiM + asymmetrical migration + selection

This supplementary guide will discuss how to combine multiple skills into a single SLiM script while generating an output that can be use in a different software. In this case, the output of this code will be a [VCF](https://en.wikipedia.org/wiki/Variant_Call_Format) file. These files are very versatile and can be used in other applications or courses, such as ecological genomics, or in your research.

## The complete code
Below I am showing the complete code for this activity. We will break it down chunk by chunk next.

```c++
initialize() {
defineConstant("COUNT", 3);
defineConstant("Mij", 0.1);
defineConstant("Mji", 0.2);
initializeMutationRate(1e-7);
initializeMutationType("m1", 0.5, "f", 0.0); //Neutral
initializeMutationType("m2", 0.5, "n", 0.0, 0.2); //QTN
initializeGenomicElementType("g1", c(m1,m2), c(1.0,0.1));
initializeGenomicElement(g1, 0, 99999);
initializeRecombinationRate(1e-8);
}

mutationEffect(m2) { return 1.0; } // make QTN neutral

1 early() {
m1.color = "yellow";
m2.color = "blue";

for (i in 0:(COUNT-1))
sim.addSubpop(i, 500);
subpops = sim.subpopulations;
for (i in 1:(COUNT-1)) subpops[i].setMigrationRates(i-1, Mij);
for (i in 0:(COUNT-2)) subpops[i].setMigrationRates(i+1, Mji);
}

1:12000 late() {

k=0;
OPTs = c(5.0,0.0,-5.0);

for (subpop in sim.subpopulations){
k=k+1;
inds = subpop.individuals;
phenotypes = inds.sumOfMutationsOfType(m2);
OPT=OPTs[k-1];
scale = dnorm(OPT, OPT, 2.0);
inds.fitnessScaling = 1 + dnorm(phenotypes, OPT, 2.0) / scale;

if (sim.cycle % 10 == 0)
cat(sim.cycle + ": Mean phenotype == " + k + "=" + mean(phenotypes) + "\n");

}
}

12000 late(){
f=0;

for (subpop in sim.subpopulations){
f=f+1;
j = subpop.sampleIndividuals(100).genomes;
j.outputVCF(filePath = paste("/somewhere_in_your_computer/",f,".vcf", sep = "") , simplifyNucleotides=T);
}
}
```

## Code break down

### The initialize callback
```c++
initialize() {
defineConstant("COUNT", 3);
defineConstant("Mij", 0.1);
defineConstant("Mji", 0.2);
initializeMutationRate(1e-7);
initializeMutationType("m1", 0.5, "f", 0.0); //Neutral
initializeMutationType("m2", 0.5, "n", 0.0, 0.2); //QTN
initializeGenomicElementType("g1", c(m1,m2), c(1.0,0.1));
initializeGenomicElement(g1, 0, 99999);
initializeRecombinationRate(1e-8);
}
```
As before, the initialize callback sets up the genetic backgroud of the simulation. 
* Count, this is a constant used to tell the simulator how many populations to simulate
* Mij, this is migration rate from popualtion i to j; i.e., the left to right migration rate
* Mji, this is migration rate from popualtion j to i; i.e., the right to left migration rate
* Mutation rate -- set by default 
* Mutation Types
	* $m1$ --> neutral mutations
	* $m2$ --> the QTN mutations that we will use to alter the phenotype
* Genomic element: 1 genome of 99999 size
* recombination rate -- set by default

### The mutationEffect callback
```c++
mutationEffect(m2) { return 1.0; } // make QTN neutral
```
This command makes all $m2$ effectively neutral, yet, the selection coefficient is retaines as the "effect size" of the mutation (for polygenic selection).

 ### Creating populations
 ```c++
1 early() {
m1.color = "yellow";
m2.color = "blue";

for (i in 0:(COUNT-1))
sim.addSubpop(i, 500);
subpops = sim.subpopulations;
for (i in 1:(COUNT-1)) subpops[i].setMigrationRates(i-1, Mij);
for (i in 0:(COUNT-2)) subpops[i].setMigrationRates(i+1, Mji);
}
```
The first bit of the code (`m1.color`, etc) is merely aestetics and affects the colors of the mutation in the GUI.  The second bit of code adds populations to the simulation and then sets up migration rates among them. This occurs by creating a set of loops, first for `i` that operates from 0 to `COUNT-1` (this is done sinc SLiM is zero centered). We will simulate 3 populations. Then there are tow internal, and staggered, loops `i in 1:(COUNT-1)` and `0:(COUNT-2)`. These loops operate by setting bi-rectional migration rates Mij and Mji.

### The simulation -- 12K generations
```c++
1:12000 late() {

k=0;
OPTs = c(5.0,0.0,-5.0);

for (subpop in sim.subpopulations){
k=k+1;
inds = subpop.individuals;
phenotypes = inds.sumOfMutationsOfType(m2);
OPT=OPTs[k-1];
scale = dnorm(OPT, OPT, 2.0);
inds.fitnessScaling = 1 + dnorm(phenotypes, OPT, 2.0) / scale;

if (sim.cycle % 10 == 0)
cat(sim.cycle + ": Mean phenotype == " + k + "=" + mean(phenotypes) + "\n");

}
}
```
Next we will simulate 12,000 generations based on a quantitative selection model with different optima across the three simulated populations. Setting the optima across these three populaitons uses a combinaiton of a counter and a loop. First, we create a vector with three values `OPTs = c(5.0,0.0,-5.0);` these values represent the optima across the three populations.  Then we create a loop to evaluate a polygenic selection model that uses a $k$ iterator to vary the optima in the model. The math underlying the quantitative model is a rescaled normal distribution using the `dnorm` function.  Finally, notice that we have a reporter at the end that prints the mean phenotype of the populaitons every 10 generations.

### Output a VCF file
```c+
12000 late(){
f=0;

for (subpop in sim.subpopulations){
f=f+1;
j = subpop.sampleIndividuals(100).genomes;
j.outputVCF(filePath = paste("/somewhere_in_your_computer/",f,".vcf", sep = "") , simplifyNucleotides=T);
}
}
```
Finally, at generation 12000, we can output VCF files that sample 100 individuals per population using the `outputVCF` command. To do this, we will also use a loop over the `subpopulations` of the simulation (i.e., `sim.subpopulations`). 
