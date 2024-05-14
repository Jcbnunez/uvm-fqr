## Data structures in R

# one dimensional data structure
a = 10




#multidimensional data structures
number_of_petals = 1:100
## same as number_of_petals = c(1,2,3,...,100)

rotation = rep(c("left","right"), 50)

lenght_of_stem = 100:199



##
data.frame(number_of_petals,rotation,lenght_of_stem)



### Assumes that i has the size as j... and as k
length(number_of_petals)

length(rotation)

length(lenght_of_stem)

## lets see an example of 99 items vs 100, 100
wrong_length = 100:198
length(wrong_length)

data.frame(number_of_petals,rotation,wrong_length)

###
mydf = data.frame(number_of_petals,rotation,lenght_of_stem)

# exploring the properties of this new object
class(mydf)

dim(mydf)

head(mydf) # first 6 lines

tail(mydf) # last 6 lines

names(mydf)

names(mydf) = c("petals", "rotat", "len")

# extracting entire columns with "$"

mydf$petals

mydf$rotat

## using square brackets 

# ----> mydf[row,column]

mydf[1,1]
mydf[1,]
mydf[,1]


mydf[c(4,7),c(1,2)]


