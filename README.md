# Foundations of Quantitative Reasoning

* Tuesday, Thursday: 10:05 - 11:20
* Location LIVING/LEARN D D107

Foundations of Quantitative Reasoning (FQR) is a graduate-level class designed to provide graduate students with the knowledge and competencies needed to tackle complex problems in data analysis using first principles of evolutionary theory. As part of this process, students will work to develop a comprehensive analysis toolbox to conduct highly reproducible quantitative research in high-performance computation (HPC) environments. These topics will be pivotal to ensure success in the student’s graduate careers in data-intensive fields. This course is open to all graduate students, and may also be taken by select, highly advanced, undergraduates with permission from the instructor.

## Access to the super-computer

This course will take place mostly within the UVM's supercomputer at the Vermont Advanced Computing Center.

In order to access the supercomputer you will need to access **[UVM-OOD's site](https://vacc-ondemand.uvm.edu/)**. After providing your credentials  

## Off campus access requires using the UVM Cisco VPN

check the link here: https://www.uvm.edu/it/kb/article/sslvpn2/

## Course specific modules

### R modules
```bash
module load Rtidyverse
module load rstudio
# in VM use "rstudio"
```

### SliM modules (GUI)

```bash
module load slim
# in VM use "slimgui"
```

### Python (3.11) environments for class

```bash
## if an envriont is open do
conda deactivate

## Load most up to date version 
module load python3.11-anaconda/2023.09-0
module list
## create 
source ${ANACONDA_ROOT}/etc/profile.d/conda.sh

### load conda environmemts
conda activate /gpfs1/cl/biol6990/envs/popgensims
## This contains "pandas" "numpy" "pySlim" "scikit-allel" "msprime"
```

### Python (3.11)  jupyter 
Run just once
```bash
# Load environment
module load python3.11-anaconda/2023.09-0
source ${ANACONDA_ROOT}/etc/profile.d/conda.sh
conda activate /gpfs1/cl/biol6990/envs/popgensims

python -m ipykernel install --user --name=popgensims
```




<!--stackedit_data:
eyJoaXN0b3J5IjpbMTAwMTI1MTUyOV19
-->