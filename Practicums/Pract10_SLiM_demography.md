# Demography in SLiM

The first part of the code in SLiM scripts usually define all important stuff about the genome. These commands are included within the initialize call:

```c
initialize() {
initializeMutationRate(1e-7);
initializeMutationType("m1", 0.5, "f", 0.0);
initializeGenomicElementType("g1", m1, 1.0);
initializeGenomicElement(g1, 0, 99999);
initializeRecombinationRate(1e-8);
}
```

## Instantaneous change in size

Now lets looks at demographic changes of our species. We will create a populaion and the change its population size instantaniously:

```c
1 early() { sim.addSubpop("p1", 1000); }
1000 early() { p1.setSubpopulationSize(100); }
2000 early() { p1.setSubpopulationSize(1000); }
3000 early() { p1.setSubpopulationSize(500); }
```


### report heterozygocity
Lets write a little reportted code to tells us about heterozygocity:
```c
late(){
het = calcHeterozygosity(p1.genomes);
catn( sim.cycle + "," + het);
}
```

### report heterozygocity -- reduced reporter
Lets create some control over the rate at which information is printed: 
```c
late(){
if (sim.cycle % 1000 == 0 | sim.cycle == 1) {
het = calcHeterozygosity(p1.genomes);
catn( sim.cycle + "," + het);
} // if
} // late
```

## Cyclical Change
We can incorporate math functions to control behaviors in our simulation
```c
1 early() { sim.addSubpop("p1", 1500); }
early() {
newSize = cos((sim.cycle - 1) / 100) * 500 + 1000;
p1.setSubpopulationSize(asInteger(newSize));
}
```

## Migration
Create many populations and include migration. This takes advantge of loops:

```c
1 early() {

subpopCount = 10;

for (i in 1:subpopCount)
sim.addSubpop(i, 500);

for (i in 2:subpopCount)
sim.subpopulations[i-1].setMigrationRates(i-1, 0.2);

for (i in 1:(subpopCount-1))
sim.subpopulations[i-1].setMigrationRates(i+1, 0.05);

}
10000 late() { sim.outputFixedMutations(); }

```
