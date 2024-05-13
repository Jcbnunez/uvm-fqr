### Introduction to R

###########################
## Part 1. Operations in R
###########################

# R can understand number
10
print(10)

# R can understand mathematical operations. It is useful to do math and statistics
11+12

###########################
##Part 2. Creating vectors in R
###########################

# you can save data to R by creating vectors
a = 10

# you can recall these vectors
a

# vectors can have multiple items

b = c(10, 11, 12, 13, 14, 15)

# you can recall the whole vector
b

# you can recall only some elements
b[4]

b[c(2,5)]

# non existent elements will be appear as "NA" (i.e., missing data)
b[c(2,5,15)]

###########################
##Part 3. Data types
###########################

### R can work with a variety of data types... tho be warned these dont always play well with each other
### here are some examples

#numerical
a= 15
print(a)
#mathematical -> numerical
b = 10+5
print(b)
#strings and characters
i = "10+5"
print(i)
# boolean
d = TRUE
print(d)

