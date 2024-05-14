### Introduction to R -- part. 2.

###########################
##Part 3. Data types
###########################

### R can work with a variety of data types... tho be warned these don't always play well with each other
### here are some examples

#numerical
a = 15
print(a)
b = 10+5
print(b)
class(a)
class(b)

#strings and characters
i = "10+5"
print(i)
class(i)

# Boolean
d = TRUE
print(d)
class(d)




###########################
##Part 4. filtering data with logical variables
###########################

# a mixed vector
myvar = 100:120

#evaluate conditions
myvar > 110

which(myvar > 110)

myvar[which(myvar > 110)]

myvar[which(myvar == 110)]

myvar[which(myvar != 110)]

myvar[which(myvar < 110)]

myvar[which(myvar %in% 112:115)]

myvar[which(myvar > 109 & myvar < 115)]

myvar[which(myvar < 103 | myvar > 118)]


