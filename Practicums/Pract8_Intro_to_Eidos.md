# Introduction to Eidos

The backbone of the SLiM simulator. Please note that the makers of SLiM have very comprehensive tutorials that are freely available at: https://messerlab.org/slim/

## Load SLiM
```bash
module load slim/4.1 
SLiMgui
```

## Eidos is like R, but not quite

```c
a = 10;
// comments in Eidos are "//"
// using the ";" at the end of every line is key in Eidos
a;
```

## Data types in Eidos

* logical: a Boolean true/false value (T/F)
```c
a == 10;
a == 20;
```
* Example command
```c
print(paste("whereby", a == 10, "is not", a == 20) );
```
* integer: 
```c
a=10;
```
* float: 
```c
a=10.0;
```
* string:
```c
a="hello";
```

## Operations in Eidos

* Arithmetic: +, -, *, /, %, ^, :
```c
a=10; b = 30;
a+b;
```
* Logical: &, |, !
```c
if(a > 50 | b > 50) print("yes"); else print("no");
```
* Eidos Logical "ternary conditional"
```c
x = 1:10

x[5] == 6 ? "yes" else "no"

// we can evaluate nested conditionals
x[5] == 8 ? "yes" else x[5] == 6 ? "second time yes" else "no"
```
* Comparison: <, >, <=, >=, ==, !=
```c
a == b;
```
* Assignment: =
```c
c = c(1:100);
```
* Vectorized operations
```c
c * -1
```
* Subset: []
```c
c[50]
c[0]
```

## Loops

```c++
for (element in 1:10) {
print("negative space of " + element + " is " + element*-1);
}
// one interesting peculiarity of Eidos is that the ";" symbol is not needed when closing loops or curly brackets in general, just at the end of the line of actual commands
```

## objects
**note from the Eidos manual:** "In Eidos you cannot define your own object classes; you work only with the predefined object classes supplied by SLiM or whatever other Context you might be using Eidos within. These predefined object classes generally define Context-dependent objectelements related to the task performed by the Context; in SLiM, the classes are things such as mutations, genomic elements, and mutation types" ... see page 35

## Functions in Eidos

```c
x=1:10;
size(x);
```

## Matrices and arrays

```c
y = matrix(1:6, nrow=2);
y;
dim(y);
```
or ...
```c
z = array(1:12, c(2,2,3));
z;
```

## Built in function in Eidos
starting in page 52 of the manual of Eidos (http://benhaller.com/slim/Eidos_Manual.pdf) all of the pre-built functions are defined. Please take a second to explore them... 
