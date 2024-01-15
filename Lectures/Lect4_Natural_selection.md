# Topic 4: Natural selection

## Goals
* Review basic models of natural selection 

One of the core assumtions of the null model we have reviewed so far makes the assumtion that there are no fitness consequences to certain mutations or allelic states. Fitness, in this context, is the ability of an individual to survive and reproduce, compared to other individuals. A phenomenon that, over time, leads to evolutionary change in the population.

## The base model
Imagine our classical system of one gene, lets call it "gene $\alpha$" that the gene has two _alleles_ called $A$ and $a$. Diploid individuals that can be born in a popualtio with this properities are" $AA$, $Aa$, or $aa$.

In a condition where $A$ and $a$ are "neutral" the changes in allele frequency over time is:

|param|t|t+1|t+n|
|--|--|--|--|
|$p$|$p_t$|$p_t$|$p_t$|
|$q$|$q_t$|$q_t$|$q_t$|
|$f_{AA}$|$p_t^2$|$p_t^2$|$p_t^2$|
|$f_{Aa}$|$2pq_t$|$2pq_t$|$2pq_t$|
|$f_{aa}$|$q_t^2$|$q_t^2$|$q_t^2$|

## Darwinian fitness (A basic review)

What if one of the two alleles, say $a$, is not neutral? For example, makes a less efficient or less thermally stable protein. As a result individuals being born with this copy of the allele may experience a fitness cost. But what cost? it depends...

### What is the functional relationship between $A$ and $a$ (examples)

* $a$ is a null allele (when $A$ by itself if suffient)
* $a$ is a complementary allele
* $a$ is a lower yield allele

### The basic case --> one "null" allele
One that produces "nothing", or no product in relationship to the other allele. In this case, having two copies of $a$ would imply a null genotype. Yet, any genotype with at least one copy of $A$ will have suffient gene dossage regardless of the number of copies: $AA$ or $Aa$. For example:

|parameter|$AA$|$Aa$|$aa$|
|--|--|--|--| 
|Abs. Fitness ($W$)|100|100|80| 
|Max. Fitness ($W_{max}$)|100|100|100| 
|Rel. Fitness ($\omega$) |1|1|0.8| 

#### From the relative fitness we can infeer the rate of selection:

$$
s = 1- (\omega)
$$ 

or

$$
s = 1- (\omega)
$$ 
