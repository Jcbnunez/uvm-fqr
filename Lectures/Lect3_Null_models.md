# Topic 3: Null models in Evolution

Given that evolution is the study of _change_, as a function of time or space in biological systems, **lack of change** is an intuitive **null model.** What does that even mean? In this context,  we often imagine an **idealized population** such that it:

1. Is composed of a very large amount of individuals (effectively infinite)
2. Genetic replication is 100% perfect (there is no mutation to introduce new variation)
3. No other population is around, so there is no chance of gene-flow
4. Every individual has equal chance of mating with any other individual (random mating)
5. All phenotypes (and genotypes) are effectively neutral (no selection)

Now, lets imagine that the genomes of the organisms in this population have only one gene, lets call it "gene $\alpha$", and that the gene has two _alleles_ called $A$ and $a$ (sounds familiar?).

The question then is, if we agree that the proportion of organisms with allele $A$ or $a$, say the allele frequency ($AF$), is a good measurement of evolution, then if I where to measure  $AF$ today, tomorrow, and in 100 years in this population... what should we expect?  

Tacking this question requires establishing some basic notation. First we need a summary statistic... the thing we actually want to measure. For example
$$
p_a = \frac{\#a}{\#A+\#a}
$$
In other words, $p_a$ is simply the frequency of "$a$" in the population (i.e., the sum of all $A$ and $a$). Now, **becuase in our idealize population** only $A$ and $a$ exist, hence it must be true that:
$$
p_a =1-p_A  
$$

or

$$
p_A + p_a = 1
$$

This is just a logical necessity since the two frequencies all *must* add up to 1, or **the totality of the universe**... (so to speak). 

### So what will be the frequencies of these alleles over times
Becuase in our ideallized _nothing_ changes, then:

$$
p_{a,\ t+1} =   p_{a,\ t}
$$

Furthermore, becuase in our ideallized population _nothing_ **ever** changes, then:

$$
p_{a,\ t+n} =   p_{a,\ t}
$$
