# Topic 1: Introduction to FQR + Evolutionary first principles

# Goals
1. Introduce ourselves 
2. Understand the structure of the course + syllabus
3. Review of evolutionary principles
* Deterministic Processess
* Stochastic Processes
* Evolutionary Systems through the lenses of Deterministic and Stochastic Processes
4. (If time permits), a tour of the VACC
---
# Evolutionary Theory... as fundamentals
... posits that living things are systems that change over space and time.

## These changes are driven by processes that can be measured and predicted (to some degree)
1.Some processes are deterministic: Have predictable outcomes that are repeatable and devoid of randomness

* Useful sometimes to think of point estimates as predictive outcomes

2.Some processes are stochastic: Have outcomes, that can be described, yet they governed by randomness

* Useful to think of distributions as “predictive” outcomes 

## Example of Deterministic processes 

```mermaid
graph LR
A[X] -- process --> B[Y]
```
### examples

$$
a = F/m 
$$
> Newton's classic formula of accelation. $a$ is acceleration, $F$ is force, and $m$ is mass.
> 
$$
y =x(1+r/m)^{Ym}
$$
> Formula for compound interest. $x$ is the current value, $y$ is future value. $r$ is the interest rate, $m$ is months, $Y$ is years.

## Example of Stochastic processes 

```mermaid
graph LR
A[X] -- process --> B[Y1]
A[X] -- process --> C[Y2]
A[X] -- process --> D[Y3]
```
### examples

$$
P(x = i) = ...
$$
>Any equation that attempts to predict "states".. for example the weather...

### A Bernoulli process
$$
P(Success) = P(X=1) = p
$$

> Where 1 is "heads"

$$
P(Failure) = P(X=0) = p
$$

>Where 0 is "tails"