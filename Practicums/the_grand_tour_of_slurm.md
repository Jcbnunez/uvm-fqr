# A grand tour of SLURM
A master cheatsheet for the VACC in Biol6210

## SLURM flags
For the SLURM header

|Command|info|
|--|--|
|-A or --account=|the account to be charged, e.g. "biol6210"|
|-a or --array=|allows to run a job in the array settting -- we will learn about this later.|
|-b or --begin=| start the job at a delayed time ... --begin=now+1hour|
|-D or --chdir=|run "cd" on the script|
|--comment=|add a human readible comment|
|-c or --cpus-per-task=|if, and only if, the program can paralelize, how may CPUs should be assigned to each task|
|-J or --job-name=|Name of the job|
|--mem=|Amount of memory requested for the job e.g., "60G"|
|-w or --nodelist=|provide a list of desired notes for your job to be assingned to|
|-N, --nodes=|Request that a **minimum** of nodes be allocated to this job.|
|-o or --output=|save all messages produced by the code here... "file.out" or "file.txt"|
|-p or --partition=|VACC partition, "bluemoon"|
|--reservation=|if you have a special reservation with the VACC, they will provide you a reservation name|
|-t or --time=|Wall time allocated for the job|


## Propagation patterns (within SBATCH)

|Command|info|
|--|--|
|%A|Job array's master job allocation number|
|%a|Job array ID (index) number|
|%u|User name|
|%x|Job name|

## Environmental Variables

|Command|info|
|--|--|
|SLURM_ARRAY_TASK_ID|Job array's iterator|
|SLURM_CPUS_PER_TASK|Number of CPUs requested|
|SLURM_JOB_ID|Job id|
