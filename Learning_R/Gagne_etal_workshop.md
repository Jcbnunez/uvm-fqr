# Welcome to IRES

### Log into VACC and R

### Navigate to scratch

### Locality
Set up working directory

### Set up libraries
library(tidyverse)

### Obtain data
system("curl https://raw.githubusercontent.com/Jcbnunez/uvm-fqr/main/LearningeeeR/Gagne_etal_data.txt > Gagne_data.txt")
 list.files()

### Load data
Gdata = read.table("Gagne_data.txt")
Gdata

### check for headers <<
Gdata = read.table("Gagne_data.txt", header = TRUE)
Gdata

### Describe headers
Gdata %>% head

### Describe obsevations with DIM

### summary statistics -- mean, standard deviation, median
apply(Gdata[,-1], 2, mean)

apply(Gdata[,-1], 2, sd)

apply(Gdata[,-1], 2, median)

### how can we plot these?
Gdata %>%
ggplot(aes(
x=LowFreq_Hz
)) + geom_histogram()

### add fill to divide by year
Gdata %>%
ggplot(aes(
x=LowFreq_Hz,
fill=Year
)) + geom_histogram(position = "dodge") 

### box plot
Gdata %>%
ggplot(aes(
y=LowFreq_Hz,
x=Year
)) + geom_boxplot()

### Test differences
t.test(LowFreq_Hz~Year, data = Gdata)

### Randomization
t.test(LowFreq_Hz~sample(Year), data = Gdata)

Gdata %>%
ggplot(aes(
x=LowFreq_Hz,
fill=sample(Year)
)) + geom_histogram(position = "dodge")

### Randomization as a loop
out = data.frame()
k = 1

for( i in myvar){
  
t.test(LowFreq_Hz~Year, data = Gdata) ...
  
  k=k+1
}

out
names(out) = c("k", "mean_Value", "filter")
