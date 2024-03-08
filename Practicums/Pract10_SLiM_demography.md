# Demography in SLiM

Genomic information
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
```c
1 early() { sim.addSubpop("p1", 1000); }
1000 early() { p1.setSubpopulationSize(100); }
2000 early() { p1.setSubpopulationSize(1000); }
3000 early() { p1.setSubpopulationSize(500); }
```


### report heterozygocity
```c
late(){
het = calcHeterozygosity(p1.genomes);
catn( sim.cycle + "," + het);
}
```

### report heterozygocity -- reduced reporter
```c
late(){
if (sim.cycle % 1000 == 0 | sim.cycle == 1) {
het = calcHeterozygosity(p1.genomes);
catn( sim.cycle + "," + het);
} // if
} // late
```

## Cyclical Change
```c
1 early() { sim.addSubpop("p1", 1500); }
early() {
newSize = cos((sim.cycle - 1) / 100) * 500 + 1000;
p1.setSubpopulationSize(asInteger(newSize));
}
```

## Migration
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
