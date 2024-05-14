### Functions

## built-in functions (revisiting....)
c

###
?c

### what if we need to create our own function
### I want to create a function that is going to take a number ...
### add 10 and divide by 10 --> (x + 10)/2
### is there a way to automate this?

myfunc =  function(arg1){
  
  #operations
  (arg1 + 10)/2 -> out
  
  return(out)
}

myfunc(12)

########

myfunc =  function(arg1, arg2){
  
  #operations
  (arg1 + 10)/arg2 -> out
  
  return(out)
}

myfunc(12, 2)

### defining defaults
myfunc()

myfunc =  function(arg1=10, arg2=2){
  
  #operations
  (arg1 + 10)/arg2 -> out
  
  return(out)
}

myfunc()
myfunc(1)
myfunc(,1)

#####################################
### combining a function with a loop

for(x in 1:100){
  
  print(myfunc(x))
  
}




