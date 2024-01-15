# Topic 4: Natural selection

## Goals
* Review basic models of natural selection 

One of the core assumtions of the null model we have reviewed so far makes the assumtion that there are no fitness consequences to certain mutations or allelic states. Fitness, in this context, is the ability of an individual to survive and reproduce, compared to other individuals. A phenomenon that, over time, leads to evolutionary change in the population.

## The base model
Imagine our classical system of one gene, lets call it "gene $\alpha$" that the gene has two _alleles_ called $A$ and $a$. Diploid individuals that can be born in a popualtio with this properities are" $AA$, $Aa$, or $aa$. This is otherwise a Hardy-Weingberg population: 

In a condition where $A$ and $a$ are "neutral" the changes in allele frequency over time is:

|param|t|t+1|t+n|
|--|--|--|--|
|$p$|$p_t$|$p_t$|$p_t$|
|$q$|$q_t$|$q_t$|$q_t$|
|$f_{AA}$|$p_t^2$|$p_t^2$|$p_t^2$|
|$f_{Aa}$|$2pq_t$|$2pq_t$|$2pq_t$|
|$f_{aa}$|$q_t^2$|$q_t^2$|$q_t^2$|

## Darwinian fitness (A basic review)

What if one of the two alleles, say $a$, is not neutral? For example, makes a less efficient or less thermally stable protein. As a result individuals being born with this copy of the allele may experience a fitness ($\omega$) cost. This cost is often interpreted through the lenses of either $fecundity$ or $survival$:

$$
\omega = fecundity\ x\ survival
$$

or

$$
\omega = m\ x\ \ell
$$


### What is the functional relationship between $A$ and $a$ (examples)

* $a$ is a null allele (when $A$ by itself if suffient)
* $a$ is a complementary allele
* $a$ is a lower yield allele

### The simplest possible case --> one "null" allele
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
s = 1- 0.8 = 0.2
$$ 

In other others individuals carrying 2 copies of $a$ have an 80% chance of not surviving and **will be removed from the population at a _rate of 20%_ from one generation to the next.**

## The basic formula for selection

Since the assumptions of Hardy-Weinberg are no longer being met, the expecationa that allele frequencies will not change is no longer realistic. The question now becomes, how can we model the change in allele frequency over time?

> One intuition is to simply apply a "uniform cost" to the expectation

$$
1 = p^2 +2pq+1^2
$$ 

becomes

$$
1 = p^2\omega_{AA} +2pq\omega_{Aa}+q^2\omega_{aa}
$$ 

Recall...

|parameter|$AA$|$Aa$|$aa$|
|--|--|--|--| 
|Rel. Fitness ($\omega$) |1|1|0.8| 

For a simple numerical solution... assume $p=0.5$ and $q=0.5$

$$
1 = 0.5^2 + 2(0.5)(0.5)+0.5^2(0.8)
$$ 

$$
1 \neq 0.25 + 0.5 + 0.2 \ (problem!)
$$ 

$$
1 \neq 0.95
$$ 
