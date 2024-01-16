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

* $a$ is a null allele, yet $A$ fully compensates (dominant, recessive)
* $a$ is a null allele, yet $A$ **cannot** fully compensate (incomplete dominance or co-dominance)

![enter image description here](https://raw.githubusercontent.com/Jcbnunez/uvm-fqr/main/etc/Figures/prac4/dosages.png)

### The simplest possible case --> one "null" allele
One that produces "nothing", or no product in relationship to the other allele. In this case, having two copies of $a$ would imply a null genotype. Yet, any genotype with at least one copy of $A$ will have suffient gene dossage regardless of the number of copies: $AA$ or $Aa$. We call this a case where $a$ is recessive. For example:

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

### Why does this occur?
For the "universe" to add up to 1, some individuals must be selected againt and some must be selected for. That is the individuals who fail to reproduce open up space for more offspring of individuals that don't have the $aa$ genotype. To fix this we must standarize our equation. This is done by dividing by the "mean fitness" of the population, or:

$$
1 = \frac{p^2\omega_{AA} +2pq\omega_{Aa}+q^2\omega_{aa}}{\bar{\omega}}
$$

### Population mean fitness
This is a parameter that takes into account the sum of the expected selection coefficients of all genotypes in the population, contingent on their frequency. Sound complicated... but it is simply:

$$
\bar{\omega} = p^2\omega_{AA} +2pq\omega_{Aa}+q^2\omega_{aa}
$$

$$
\bar{\omega} = p^2(1-s_{AA}) +2pq(1-s_{Aa})+q^2(1-s_{aa})
$$
fold out parentheses
$$
\bar{\omega} = p^2-p^2s_{AA} + 2pq- 2pqs_{Aa} +q^2-q^2s_{aa}
$$
reorganize
$$
\bar{\omega} = p^2+ 2pq+q^2-p^2s_{AA} - 2pqs_{Aa} -q^2s_{aa}
$$
replace the Hardy-Weinberg expectation
$$
\bar{\omega} = 1-p^2s_{AA} - 2pqs_{Aa} -q^2s_{aa}
$$

### For the simplest case of recessive $a$

We know that $s_{AA}  = s_{Aa} = 0$, then:

$$
\bar{\omega} = 1-p^2(0) - 2pq(0)-q^2s_{aa}
$$

Solving for the special case **(for an allele $a$ that is recessive)**:

$$
\bar{\omega} = 1-q^2s_{aa}
$$

Lets revisit the original case:

$$
1 = \frac{0.5^2 + 2(0.5)(0.5)+0.5^2(0.8)}{1-q^2s_{aa}}
$$

$$
1 = \frac{0.5^2 + 2(0.5)(0.5)+0.5^2(0.8)}{1-(0.5)^2(0.2)}
$$ 

$$
1 = \frac{0.95}{0.95} = 1
$$ 

But this is a bit too esoteric... lets actually look at the genotype frequencies (for the simplest case):  

|param|No evolution|selection|
|--|--|--|
|$f_{AA}$|$p^2$|$\frac{p^2\omega_{AA}}{1-q^2s_{aa}}$|
|$f_{Aa}$|$2pq$|$\frac{2pq\omega_{Aa}}{1-q^2s_{aa}}$|
|$f_{aa}$|$q^2$|$\frac{q^2\omega_{aa}}{1-q^2s_{aa}}$|

### What happens to $aa$

$$f_{aa}=\frac{q^2\omega_{aa}}{1-q^2s_{aa}}$$

$$f_{aa}=\frac{0.5^2(0.8)}{1-(0.5)^2(0.2)} = \frac{0.2}{0.95} = 0.21 $$

recall in the HW model, the expected $q^2$ is $0.5^2 = 0.25$

### What happens to $AA$ and $Aa$ since they have the same fitness

$$
f_{AA}=\frac{p^2\omega_{aa}}{1-q^2s_{aa}}\ ;\ f_{Aa}=\frac{2pq\omega_{Aa}}{1-q^2s_{aa}}
$$

$$
f_{AA}=\frac{0.5^2}{1-(0.5)^2(0.2)} = \frac{0.25}{0.95} = 0.263 
$$

recall in the HW model, the expected $p^2$ is $0.5^2 = 0.25$

$$
f_{Aa}=\frac{2x0.5x0.5}{1-(0.5)^2(0.2)} = \frac{0.50}{0.95} = 0.526 
$$

recall in the HW model, the expected $2pq$ is $2x0.5x0.5 = 0.50$

|param|No evolution|selection ($\Delta$)|
|--|--|--|
|$f_{AA}$| 0.25 | 0.263 (+)|
|$f_{Aa}$| 0.50 | 0.526 (+)|
|$f_{aa}$| 0.25 | 0.210 (-)|

### That is selection in a nutshell! how can we derive allele frequencies
recall that, in general

$$
p = f(Ho_{AA}) + \frac{f(Het)}{2} 
$$

under selection

$$
p = \frac{p^2\omega_{AA}}{\bar{\omega}}  + \frac{pq\omega_{Aa}}{\bar{\omega}}
$$

simplifying to

$$
p = \frac{p^2\omega_{AA} + pq\omega_{Aa} }{\bar{\omega}}
$$

and in the simpest case (selection againt recessive $a$):


$$
p = \frac{p^2\omega_{AA} + pq\omega_{Aa} }{1-q^2s_{aa}}
$$

## A more complex scenario... What if the allele is not null?

Lets entrain a different scenrario. Instead of assuming that $a$ is a "null" allele of some sort. Let's imagine that the phenotype is sensitive to the allele dosage.  In this cases $AA$ will have a phenotype, $Aa$ a different phenotype, and $aa$ yet a diferent phenotype.

### Coefficient of dominance accounts for different phenotypes (due to allele contribution)


|parameter|$AA$|$Aa$|$aa$|
|--|--|--|--| 
|Abs. Fitness ($W$)|100|90|80| 
|Max. Fitness ($W_{max}$)|100|100|100| 
|Rel. Fitness ($\omega$) |1|0.9|0.8| 

### The selection coefficient for hereozygous can be expressed as: 

$$
 hs = 1- (\omega)
$$ 

where $h$ is the coefficient of dominance, and $h$ will denote the "dominance" relationship between $A$ and $a$. Such that the fitness of a heterozygous is $1-hs$. In the most common cases when $h=0$ it means that $A$ is dominant over $a$.  Else, if $h=1$ it means that $a$ is dominant over $A$.  If $h=0.5$ the heterozygote is exactly intermediate. Notably, If $h < 0$ the heterozygote will have higher fitness than either homozygote (i.e., true overdominance).


|parameter|$AA$|$Aa$|$aa$|
|--|--|--|--| 
|General case |$1-s_{AA}$|$1-hs_{Aa}$|$1-s_{aa}$| 


## How do we incorporate this into our math?

Since we often want to predict allele frequencies, we will pay attention to the $\bar{\omega}$ function. This becomes visible if we transform everything into selection coefficients:

$$
p = \frac{p^2\omega_{AA} + pq\omega_{Aa} }{\bar{\omega}}
$$

### Numerator

$$
p^2\omega_{AA} + pq\omega_{Aa}  = p^2(1-s_{AA}) + pq (1-hs_{Aa})
$$

### Denominator

$$
\bar{\omega} = p^2\omega_{AA} +2pq\omega_{Aa}+q^2\omega_{aa}
$$

$$
\bar{\omega} = p^2(1-s_{AA}) +2pq(1-hs_{Aa})+q^2(1-s_{aa})
$$

fold out parentheses

$$
\bar{\omega} = p^2-p^2s_{AA} + 2pq- 2pqhs_{Aa} +q^2-q^2s_{aa}
$$

reorganize

$$
\bar{\omega} = 1-p^2s_{AA} - 2pqhs_{Aa} -q^2s_{aa}
$$

### Then it becomes: 

$$
p = \frac{p^2\omega_{AA} + pq\omega_{Aa} }{\bar{\omega}} = \frac{p^2(1-s_{AA}) + pq (1-hs_{Aa})}{1-p^2s_{AA} - 2pqhs_{Aa} -q^2s_{aa}}
$$

---

### In the special case when $s_{AA} = 0$

$$
p = \frac{p^2 + pq (1-hs_{Aa})}{1- 2pqhs_{Aa} -q^2s_{aa}}
$$

---
