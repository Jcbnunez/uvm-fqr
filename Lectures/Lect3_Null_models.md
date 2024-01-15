# Topic 3: Null models in Evolution

## Goals
* Review null models of evolution 

Given that evolution is the study of _change_, as a function of time or space in biological systems, **lack of change** is an intuitive **null model**, proposed by [Hardy & Weinberg](https://www.nature.com/scitable/definition/hardy-weinberg-equilibrium-122/ ).  In this context,  we often imagine an **idealized population** such that it:

1. Is composed of a very large amount of individuals (effectively infinite)
2. Genetic replication is 100% perfect (there is no mutation to introduce new variation)
3. No other population is around, so there is no chance of gene-flow
4. If sexual repriduction occurs, every individual has equal chance of mating with any other individual (random mating)
5. All phenotypes (and genotypes) are effectively neutral (no selection)

## Estimating allele frequencies
 
Lets ignore sexual reproduction for one second, and imagine that the genomes of the organisms in this population have only one gene, lets call it "gene $\alpha$", and that the gene has two _alleles_ called $A$ and $a$ (sounds familiar?).

The question then is, if we agree that the proportion of organisms with allele $A$ or $a$, say the allele frequency, is a good measurement of evolution, then if I where to measure  allele frequency, today, tomorrow, and in 100 years in this population... what should we expect?  

Tacking this question requires establishing some basic notation. First we need a summary statistic... the thing we actually want to measure. For example

$$
p_a =  \frac{n_i}{N}
$$

where $N$ is the number of individuals in the population, and $n_i$ is the number of times an allele is observed. In this context the alleles are either $a$ or $A$. In other words, $p_a$ is simply the frequency of " $a$ " in the population (i.e., the sum of all $A$ and $a$). Now, **becuase in our idealized population** only $A$ and $a$ exist, hence it must be true that:

$$
p_a =1-p_A  
$$

or

$$
p_A + p_a = 1
$$

This is just a logical necessity since the two frequencies all *must* add up to 1, or **the totality of the universe**... (so to speak).  Also note that, in population genetics, it is customary to call these complementary frequencies $p$ and $q$ such that

$$
p_a  = q\ \ and\ \ p_A = p
$$

and

$$
p + q = 1
$$


### So what will be the frequencies of these alleles over times
Becuase in our ideallized population _nothing_ changes, then:

$$
p_{t+1} =   p_{t}
$$

Furthermore, becuase in our ideallized population _nothing_ **ever** changes, then:

$$
p_{t+n} =   p_{t}
$$

### :crystal_ball: Thus, our null, higly idealized, model would predict no change in allele frequencies over time in the population.

## Case 2: Adding diploidy and sexual reproduction
Lets say, we pose the same question as we did above, yet we now consider that individuals are **diploids** (i.e., $2N$) and that sexual reproduction occurs (random mating). This means that each individual in the population now carries 2 copies of gene $\alpha$ and individuals may carry any allele combination of alleles. As such individuals may now be found carrying either $AA$, $aa$, $Aa$ or $aA$ combination of alleles! We often call these combination of alleles, "a genotype".

#### Now we must be able to predict, not just the allele frequency, but also the genotype frequency over time. Lets do it!

* Lets simplify our math a bit by modeling the probability of observing an individual that has two identical states, either $AA$ or $aa$ (we call these homozygous states), as well as different by allelic state ($Aa$, $aA$; regarding of order) these we call heterozygous states. 

#### Probability of observing a homozygous $AA$

Assuming that the probability of sampling any $A$ is $p$ (using classical nomemclature, we could also call this $p_A$), then:

$$
Pr(Ho_{AA}) = p\ x\ p = p^2
$$

it is the multiplication of two independent events. That is sampling an $A$ once ($p_A$) and then a second time.. i.e., another $p_a$

#### Probability of observing a homozygous $aa$
Assuming that the probability of sampling any $a$ is $q$ (using classical nomemclature, we could also call this $p_a$), then:

$$
Pr(Ho_{aa}) = q\ x\ q = q^2
$$

#### Probability of observing a heterozygous of _any kind_
Now here we are dealing with two dependent probability staments. That is the probability of sampling and $A$ and then and $a$ ... or ... sampling and $a$ and then and $A$.

* Probability of sampling and $A$ and then and $a$

$$
Pr(A\ and\ a) = p\ x\ q = pq
$$

* Probability of sampling and $a$ and then and $A$

$$
Pr(a\ and\ A) = q\ x\ p = qp = pq
$$

* Thus, the total probability is the sum of the two mutually exclusive events or:

$$
Pr(He) = f(Aa\ and\ aA ) = pq + pq = 2pq
$$

### Recall because these are the only genotypes that exist, then it must be true that (i.e., _the "universe" must add up to 1_). This is the most commonly recognized statement of the Hardy-Weinberg principle.

$$
p^2 + 2pq + q^2 = 1
$$

#### Thus, in an idealized population, the expected frequencies of genotypes are:

|Class|Expected frequency|
|--|--|
| $f(Ho_{AA})$ | $p^2$ |
| $f(Ho_{aa})$ | $q^2$ |
| $f(Het)$ | $2pq$ |

### But what about allele frequencies? We can describe this from the genotype frequencies 

$$
p = 2f(Ho_{AA}) + f(Het)
$$

and

$$
q = 2f(Ho_{aa}) + f(Het)
$$

## :mega: Notably, while the math has (somewhat) increased in complexity, the overall pattern remains the same

|param|t|t+1|t+n|
|--|--|--|--|
|$p$|$p_t$|$p_t$|$p_t$|
|$q$|$q_t$|$q_t$|$q_t$|
|$f_{AA}$|$p_t^2$|$p_t^2$|$p_t^2$|
|$f_{Aa}$|$2pq_t$|$2pq_t$|$2pq_t$|
|$f_{aa}$|$q_t^2$|$q_t^2$|$q_t^2$|

#### A model of "no evolution," indeed. Lets work on some code!
