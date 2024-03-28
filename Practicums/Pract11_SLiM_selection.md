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

## Polygenic adaptation using QTNs

```c+
initialize() {
initializeMutationRate(1e-7);
initializeMutationType("m1", 0.5, "f", 0.0); // neutral
initializeMutationType("m2", 0.5, "f", 0.0); // QTLs
m2.convertToSubstitution = F;
m2.color = "red";
initializeGenomicElementType("g1", m1, 1);
initializeGenomicElementType("g2", m2, 1);
initializeGenomicElement(g1, 0, 20000);
initializeGenomicElement(g2, 20001, 30000);
initializeGenomicElement(g1, 30001, 99999);
initializeRecombinationRate(1e-8);
}

1 early() { sim.addSubpop("p1", 500); }

fitnessEffect() {
phenotype = sum(individual.genomes.countOfMutationsOfType(m2));
return 1.5 - (phenotype - 10.0)^2 * 0.005;
}

5000 late() {
print(sim.mutationFrequencies(NULL, sim.mutationsOfType(m2)));
}
```
