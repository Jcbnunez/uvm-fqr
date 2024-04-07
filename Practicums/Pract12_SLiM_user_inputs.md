# Pass SLiM User  inputs

This supplementary guide will discuss how to allow for use inputs in SLiM. User provided inputs are very useful when trying to scale up simulations. For example, study the following simulation code:


```c++ 
initialize() {
initializeMutationRate(1e-7);
initializeMutationType("m1", 0.5, "f", 0.0);
initializeGenomicElementType("g1", m1, 1.0);
initializeGenomicElement(g1, 0, 999999);
initializeRecombinationRate(1e-8);
}

1 early() {
sim.addSubpop("p1", 1000);
sim.addSubpop("p2", 1000);
p1.setMigrationRates(p2, 0.001);
p2.setMigrationRates(p1, 0.001);
}

10000 late() {
fst_calc = calcFST(p1.genomes, p2.genomes);
print(fst_calc);
}
```
The code performs some basic operations such as:

* create a genomic environemnt
* create two populaitons, $p1$ and $p2$
* create allows migration to occur between these populations. This we call a "two-patch" model.
* Lets them evolve for 10000 generations
* Calculates and outputs the $F_{ST}$ for these populations

### What is  $F_{ST}$ ?
$F_{ST}$ is many things..  I recommend that folks should read this review (https://www.nature.com/articles/nrg2611) for a comprehensive undertanding of the statistic. Also notice that more nuaced discussions of these and other statistic fall in the realm of  courses such as Ecological Genomics (BIOL6200) or Populaiton Genetics (BIOL4260).... For a "simple" answer we can contextualuze that $F_{ST}$ is a metric of differentiation between populations. High $F_{ST}$ (near 1) means that populaitons are very "dis-similar", and  Low $F_{ST}$ (near 0) means that populations are highly similar. For a cartoon example, think that two set of populaitons of identical clones should show $F_{ST}  \approx 0$, whereas two populaitons that are greatly diverge and close to speciation should show  $F_{ST} \approx 1$. 

### $F_{ST}$  and migartion
There are many reasons why $F_{ST}$ may be high or low... yet in a simulaiton, there are some basic expected behaviours that we should hope to see, following the equation below ([but see Whitlock and  Mccauley 2001](https://onlinelibrary.wiley.com/doi/abs/10.1046/j.1365-2540.1999.00496.x?casa_token=YsNyu_nNY9gAAAAA:677cmfEg-gTwho_3_UrJ2Knzi2brZKyUAt3fsjUvyl4dJ2usl0y-GY6UWTdANI25qqOra5QwRVPn4_b3)):

$F_{ST}\approx \frac{1}{4N_{e}m_+1}$  

where $m$ is the migrstion rate, and we should be familiar with all other terms... For example, migration is a "homogenizing" force and thus we would expect that higher migration rates should result in lower $F_{ST}$... and we can test that using SLiM and user derived inputs.

### Create a ".slim" file
First start by taking the code we develop up top and save it to a new file called `mig.slim`.  However, we could make a modification to the file as follows:


```c++ 
initialize() {
initializeMutationRate(1e-7);
initializeMutationType("m1", 0.5, "f", 0.0);
initializeGenomicElementType("g1", m1, 1.0);
initializeGenomicElement(g1, 0, 999999);
initializeRecombinationRate(1e-8);
}

1 early() {
sim.addSubpop("p1", 1000);
sim.addSubpop("p2", 1000);
p1.setMigrationRates(p2, mig);
p2.setMigrationRates(p1, mig);
}

10000 late() {
fst_calc = calcFST(p1.genomes, p2.genomes);
print(fst_calc);
}
```

Notice that we have replace the migration rate `0.001` by the variable `mig` ... yet we have not dfined `mig` anywhere! what gives? Well, here is where running `slim` in the commnad line, using the `-d` flag comes into play.. as follows:

```
module load slim

slim -d "mig=0.001" mig.slim
```

Notice that here we are using `-d "mig=0.001"` in the code in order to tell SLiM that we want the migration rate to be 0.001 inds/generation. 

* **Note that arguments must be passed within parentehses exactly as you would whitin SLiM**

### Scaling up -- first with a loop
We can capitalize on this capability in a variety of ways, for example using a loop to explore a variety of migration rates

```
module load slim

for i in 0.001 0.01 0.1 0.5;
do;
slim -d "mig=${i}" mig.slim
done;
```
The outputs should look something like this: 

|mig| $F_{ST}$ |
|--|--|
|0.001|0.0540991|
|0.01|0.00610471|
|0.1|0.00039192|
|0.5|0.000220903|

Notice the trend?

### Scaling up -- first with a loop and a reported
We can furter scale up by adding a reporter that will write these outputs to a file:

```c++ 
initialize() {
initializeMutationRate(1e-7);
initializeMutationType("m1", 0.5, "f", 0.0);
initializeGenomicElementType("g1", m1, 1.0);
initializeGenomicElement(g1, 0, 999999);
initializeRecombinationRate(1e-8);
}

1 early() {
sim.addSubpop("p1", 1000);
sim.addSubpop("p2", 1000);
p1.setMigrationRates(p2, mig);
p2.setMigrationRates(p1, mig);
}

10000 late() {
fst_calc = calcFST(p1.genomes, p2.genomes);
reporter = + mig + "," + fst_calc;
writeFile("./mig.reporter.txt", reporter, append = T);
}
```
And we can run
```
for i in 0.001 0.01 0.1 0.5;
do;
slim -d "mig=${i}" mig.slim
done;
```
Now the output should. be stored in the file `mig.reporter.txt`

### Scaling up -- arrays
Naturally, the most efficient way to scale this up is to scale this operation is to an array job...

```
#!/usr/bin/env bash
#
#SBATCH -J run_array
#SBATCH -c 1
#SBATCH -N 1 # on one node
#SBATCH -t 6:00:00 
#SBATCH --mem 10G 
#SBATCH -o ./slurmOutput/run_array.%A_%a.out
#SBATCH -p bluemoon
#SBATCH --array=1-X

paramfile=...<some parameter file>...

migi=$(cat ${paramfile} |  sed '1d' | awk '{print $1}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )

slim -d "mig=${migi}" mig.slim
```

Give it a try! For example try to generate a reporter file using a wide range of migration rates and plot them using R (this is not a homework, but you should try it for you own benefit of practicing integrating SLiM and R)!
