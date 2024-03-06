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

## Creating object properties (very "pythonesque")

```c
object.age = 10
```
