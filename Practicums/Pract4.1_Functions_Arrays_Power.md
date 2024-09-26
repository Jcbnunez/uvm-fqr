# Scaling up (-prac) analytical pipelines using the VACC + Null model testing!  
  

Let's learn how to deploy paralleled computations in the VACC using arrays.  
  

## Data challenge: Revisiting our power analysis

Lets re-scale and redeploy our power analysis
```r  
library(tidyverse)  
library(foreach)  

power_analysis=
foreach(N = seq(from=10, to=1000, by=10), .combine = "rbind")%do%{
foreach(k=1:100, .combine = "rbind")%do%{
#simulate high tide
upper_shells_sample=rnorm(n=N, mean = 10.2, sd = 3.8)
#simulate low tide
lower_shells_sample=rnorm(n=N, mean = 11.5, sd = 5.3)
# run the test
test_result=t.test(upper_shells_sample,lower_shells_sample)
#has the null hypothesis been rejected? it should be!
true_positive=test_result$p.value < 0.05
#create an output data frame
output =
data.frame(
sample_size=N,
simulation_id=k,
true_positive=true_positive
)
#explicitly tell the loop to return the "output" into memory
message(paste("just finished", k, "of", N, sep = " "))
return(output)
} # close k
} # close N  
```  


## Introducing user defined inputs


```r  
## ---------------------------  
## Script name: simulate.power.R  
## Purpose of script: FQR practicum... 
## Author: Dr. JCB Nunez  
## Date Created: 2024-01-07  
## Copyright (c) Joaquin C. B. Nunez, 2024 [if aplicable]  
## Email: joaquin.nunez@uvm.edu  
## ---------------------------  
## Notes: For classroom use!  
## ---------------------------  

library(tidyverse)  
library(foreach) 

# User define inputs  
args = commandArgs(trailingOnly=TRUE)
 
N=as.numeric(args[1])  


power_analysis=
#foreach(N = seq(from=10, to=1000, by=10), .combine = "rbind")%do%{
foreach(k=1:100, .combine = "rbind")%do%{
#simulate high tide
upper_shells_sample=rnorm(n=N, mean = 10.2, sd = 3.8)
#simulate low tide
lower_shells_sample=rnorm(n=N, mean = 11.5, sd = 5.3)
# run the test
test_result=t.test(upper_shells_sample,lower_shells_sample)
#has the null hypothesis been rejected? it should be!
true_positive=test_result$p.value < 0.05
#create an output data frame

output =
data.frame(
sample_size=N,
simulation_id=k,
true_positive=true_positive)

##explicitly tell the loop to return the "output" into memory
message(paste("just finished", k, "of", N, sep = " "))
return(output)
} # ----close k
#} # close N  

save(  
power_analysis ,   
file = paste("output1",N, "Rdata", sep =".")   
)  
```  

Save to your folder using OOD's capabilties as `myfile.R`  
  
## Lets test the file

```sh
#may need to fix:
sed -i $'s/\r$//' myfile.R

myfile.R 10
``` 

## What is the output?
This command will load the data that we generated into R
```R
load("output.10.Rdata")
```  


# What else can we change?

```r
library(tidyverse)  
library(foreach)  

# User define inputs  
args = commandArgs(trailingOnly=TRUE)

N=as.numeric(args[1])  
M1=as.numeric(args[2])
M2=as.numeric(args[3])

power_analysis=
#foreach(N = seq(from=10, to=1000, by=10), .combine = "rbind")%do%{
foreach(k=1:100, .combine = "rbind")%do%{
#simulate high tide
upper_shells_sample=rnorm(n=N, mean = M1, sd = 3.8)
#simulate low tide
lower_shells_sample=rnorm(n=N, mean = M2, sd = 5.3)
# run the test
test_result=t.test(upper_shells_sample,lower_shells_sample)
#has the null hypothesis been rejected? it should be!
true_positive=test_result$p.value < 0.05
#create an output data frame

output =
data.frame(
sample_size=N,
simulation_id=k,
true_positive=true_positive)

##explicitly tell the loop to return the "output" into memory
message(paste("just finished", k, "of", N, sep = " "))
return(output)
} # ----close k
#} # close N  

save(  
power_analysis ,   
file = paste("output2",N,M1,M1, "Rdata", sep =".")   
)  
```

### Lets try it out
```sh
#may need to fix:
sed -i $'s/\r$//' myfile.R

myfile.R 10 5 8
``` 

# Scaling up!!! STEP 1: A guide file

## Lets make a parameter file

```r

param = data.frame(
N=rep(10,10),
M1=rnorm(10, 10, 100),
M2=rnorm(10, 10, 100)
)


write.table(param, 
			file = "param.txt", 
			append = FALSE, quote = TRUE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")
```

### Lets take a look

```bash  
head param.txt
```  
 
# Scaling up!!! STEP 2: ARRAYS!!


```bash  
#!/usr/bin/env bash  
#  
#SBATCH -J run_array  
#SBATCH -c 1  
#SBATCH -N 1 # on one node  
#SBATCH -t 1:00:00   
#SBATCH --mem 8G   
#SBATCH -o ./slurmOutput/myarray.%A_%a.out  
#SBATCH -p bluemoon  
#SBATCH --array=1-10  

echo ${SLURM_ARRAY_TASK_ID}

date
```

### Launch it!
```sh
sed -i $'s/\r$//' myarr.sh

sbatch myarr.sh
```

### What happened?
Look at the output files

# Scaling up!!! STEP 3: ARRAYS+R

```bash  
#!/usr/bin/env bash  
#  
#SBATCH -J run_array  
#SBATCH -c 1  
#SBATCH -N 1 # on one node  
#SBATCH -t 1:00:00   
#SBATCH --mem 8G   
#SBATCH -o ./slurmOutput/myarray.%A_%a.out  
#SBATCH -p bluemoon  
#SBATCH --array=1-10  
#SBATCH --account=biol6210

echo ${SLURM_ARRAY_TASK_ID}

paramfile=param.txt

N=$(cat ${paramfile} |  sed '1d' | awk '{print $1}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )  
M1=$(cat ${paramfile} |  sed '1d' | awk '{print $2}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )  
M2=$(cat ${paramfile} |  sed '1d' | awk '{print $3}' | sed "${SLURM_ARRAY_TASK_ID}q;d" )  
  
Rscript --vanilla myfile.R ${N} ${M1} ${M2}  

date
```

  
# Processing multiple array outputs into a final analysis  
  

We are going to collate all of this data using an integrated pipeline of R and Unix... through R using the `system` command!  

```bash  
module load Rtidyverse   
```  

#### Collate and analyse the output by combining Unix and R  
  

```r  
#load important libraries  
library(tidyverse)  
  
#use a loading loop with system to read all the files  
command = paste("ls | grep 'output2' " )  
files_o = system(command, intern = TRUE )  
  
collated.files =  
foreach(i=files_o, .combine="rbind")%do%{  
message(i)  
o = get(load(i))  
}  

```  

# Crowd-challenge can we summarize and plot this?

Lets give it a try!
