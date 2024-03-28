# Natural selection in SLiM

The first part of the code in SLiM scripts usually define all important stuff about the genome. These commands are included within the initialize call:

# Part 1: Basic population genetic models

## Introduce a new adaptive mutation with `addNewDrawnMutation`
Explore how often mutations fix or go extinct? Why?
```c++
initialize() {
initializeMutationRate(1e-7);
initializeMutationType("m1", 0.5, "f", 0.0);
initializeGenomicElementType("g1", m1, 1.0);
initializeGenomicElement(g1, 0, 99999);
initializeRecombinationRate(1e-8);

/// way 1 to introduce an adaptive mutation
initializeMutationType("m2", 1.0, "f", 0.5); // introduced mutation
/// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ///
}

1 early() { sim.addSubpop("p1", 500); }
1000 late() {
target = sample(p1.genomes, 1);
target.addNewDrawnMutation(m2, 10000);
}

1000:100000 late() {
if (sim.countOfMutationsOfType(m2) == 0)
{
fixed = (sum(sim.substitutions.mutationType == m2) == 1);
cat(ifelse(fixed, "FIXED\n", "LOST\n"));
sim.simulationFinished();
}}
```

## Modify an adaptive mutation with `mutationEffect`
Change the selection coefficient midway
```c++
initialize() {
initializeMutationRate(1e-7);
initializeMutationType("m1", 0.5, "f", 0.0); // neutral
initializeMutationType("m2", 0.5, "f", 0.1); // beneficial
initializeGenomicElementType("g1", c(m1,m2), c(0.995,0.005));
initializeGenomicElement(g1, 0, 99999);
initializeRecombinationRate(1e-8);
}

// follow m2 mutations...
1 early() { sim.addSubpop("p1", 500); }
5000:10000 mutationEffect(m2) { return 1.0; } // make mutations neutral again
10000 early() { sim.simulationFinished(); }
```

# Part 2: Polygenic adaptation and Quantitative genetic models

Selection does not act on the genetic variants themselves... it acts on phenotypes encoded by genetic variants. How may we capture this nuance in our models?  -- by allowing population to evolve a continuous trait.

## Simulaing a trait that has some optimun in a given environment.

Lets imagine that a species has some tolerance to salinity that follows some kind of optima. At that point survival of individuals is 100%, and outside of that optimun... there is a cost to survival.. as follows:

$$
Phenotype = (\frac{x-\gamma}{\omega})^2 + 1
$$

Where $x$= is the environment experienced by organisms. $\gamma$= is the optimal environment for a given genotype. And $\omega$= is a width mofidier.

And that:

$$
fitness =
\begin{cases}
Phenotype> 0,  & fitness = Phenotype \\
Phenotype <= 0, & fitness = 0
\end{cases}
$$

### $x$= -2 to 2, $\gamma$=0, $\omega$=1
![enter image description here](https://raw.githubusercontent.com/Jcbnunez/uvm-fqr/main/etc/Figures/prac11/function.quadrat.png)

### Now lets allow for $\gamma$ to be genetically controlled
![enter image description here](https://raw.githubusercontent.com/Jcbnunez/uvm-fqr/main/etc/Figures/prac11/multiple_gammas.png)

## Polygenic adaptation using QTNs

```c+
initialize() {
initializeMutationRate(1e-7);
initializeMutationType("m1", 0.5, "f", 0.0); // neutral
initializeMutationType("m2", 0.5, "f", 0.0); // QTLs -- also neutral
m2.convertToSubstitution = F;
m2.color = "green";
initializeGenomicElementType("g1", m1, 1);
initializeGenomicElement(g1, 0, 99000);
initializeRecombinationRate(1e-7);
}

1 early() { sim.addSubpop("p1", 1500); }

1:10000 late() {
if (sim.cycle % 100 == 0 | sim.cycle == 1) {
het = calcHeterozygosity(p1.genomes);
catn( "t=" + sim.cycle + ", Het=" + het);
}} 

10001 early() {
res_muts = sample(sim.mutationsOfType(m1), 30);
for (m in res_muts){
sc = rnorm(1, 0, 1/loc);
m.setSelectionCoeff(sc);
} 
}

fitnessEffect() {
phenotype = sum(individual.genomes.countOfMutationsOfType(m2));
return 1.5 - (phenotype - 10.0)^2 * 0.005;
}

```
