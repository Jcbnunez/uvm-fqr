# Notes on python (in the VACC)

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
Launch the jupyter notebook via **[UVM-OOD's site](https://vacc-ondemand.uvm.edu/)** "interactive apps".

More info: https://www.uvm.edu/vacc/kb/knowledge-base/virtual-environments-in-jupyter-notebook/
