
# Topic 5: Genetic Drift

## Goals
* Review a basic model of genetic drift.
* Understand how this model is a good case study for understanding  stochastic processes
* Assess how randomness shape the evolutionary process

## The Context
Up to this point  in the course we have extensively discussed the process of natural selection. This is, of course, a deterministic process, by this I mean the process behaves nicely and predictably across predictions. Think, for example, how beneficial alleles always change frequency "upwards" and deleterious alleles "downwards". Yet, baked inside these models is a simplifying assumption that population are "infinite," and that, of course, is not biologically interesting. 

## Biological populations are finite
Natural populations are composed of individuals that live in spaces with limited resources. Thus a finite number of individuals can exist at a given time at a given place. Thus even in the total absence of selection, if every possible of genotype of a species could exist at the same time, this is impossible due to space constrains. As a result some degree of randomness is introduced when predicting what genotypes will "be sampled" next generation. This phenomena is called "drift."


## M&Ms ... a case study
The colors in the famous American candy M&M are, in theory, set in the universe (see table). Yet, upon opening a bag of M&Ms (55 candies) we rarely see these exact proportions:

|Color|Proportion Universe|A bag of M&Ms (55 candies)|
|--|--|--|
|Brown|30%|17|
|Red|20%|19|
|Yellow|20%|6|
|Green|10%|6|
|Blue|10%|3|
|Orange|10%|4|

In essence, the reason why our M&M does not 100% match the universe is because of M&M bag is a "sample" of the M&M universe. In this same vein, finite populations are samples of the overall genetic variation of the species.  

## Modeling genetic drift in a finite population (as a binomial process)

We will model the process of sampling using a binomial process based on the some familiar assumptions: 

* One gene with 2 alleles model in a diploid
* No selection
* No mutation
* No migration
* No recombination
* No assortative mating

Yet, unlike Hardy–Weinberg the population is NOT infinite. Thus, alleles, as they "move" from one generation to the next they must occupy a space composed of $2N$, where $N$ is the number of individuals in the population. This modification results in a slightly different model from Hardy–Weinberg, and it is instead called the "Wright-Fisher" model. 

### The Wright-Fisher model

Strictly speaking, the Wright-Fisher model is a stochastic  model defined in "discrete time" (i.e., every generation is discrete and parents never overlap with children), and the number of "A" alleles is modeled as a markov-chain process:

$$
X_t = Number\ of\ 'A'\ alleles
$$

Here we are going to define $X_t$ as a random variable that denoted the number of the "A" alleles in a population of size $N$. The stochastic nature of this model becomes evident when we model this function over time, whereby $X_t$ changes state (from one time point to the next; or from state $i$ to state $j$) as a function of the transition probability:

$$
P_{i->j} = {2N \choose j} (\frac{i}{2N})^{j} (1 - \frac{i}{2N})^{2N - j}
$$

A close examination of this formulation reveals a simple and intuitive point. The transition probability depends, in one way or another on $\frac{i}{2N}$, and that is the current number of $A$ alleles that currently exist in the population. This formula is, of course, the binomial formula, and we can express this as:

$$
X_{t} \mid X_{t-1} = x_{t-1} \sim Binomial(n = 2N, p = \frac{x_{t-1}}{2N})
$$ 

In english, the probability of $X_t$ (X now) is dependent on $X_{t-1}$ (X in the previous generation). **Let's now explore this using code.**
  
