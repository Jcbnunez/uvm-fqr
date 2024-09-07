
# A grand tour of UNIX
A master cheatsheet for Biol6210

## Keyboard commands

|Command|info|Flags|
|--|--|--|
|control $and$ C|stop any code that is executing||

## Understanding the Environment

|Command|info|Flags|
|--|--|--|
|uname|Show the Unix system info| -a (details), -r (kernel)|
|uptime|how long has the system been running||
|who|show who is logged in||
|w|who is online and what are they doing||
|users|show a list of users||
|whoami|your system identity||
|cal|calendar information||
|date|print date||
|man|shows the manual for a given COMMAND||
|echo|prints text or the context of a variable||
|ls|list files|-l (details), -a (hidden), -t (sort); can be combined "-lta"|
|cd|change directory||
|pwd|print working directory||


## file manipulation
|Command|info|Flags|
|--|--|--|
|wc|count words|-l count lines|
|cmp|compare files (X, Y) for sameness (No output if X and Y are identical), line number otherwise||
|diff|compare files (X, Y) for differences (No output if X and Y are identical), line number otherwise||
|mkdir|make directory||
|cp| copy file |-r (recursively)|
|cat| open and/or concatenate files ||
|mv|move file||
|>|save to (overwrites)||
|>>|save to (appends)||
|<|read into||
|rm|delete|-r (recurrsively), -f (forced)|
|rmdir|delete directory (must be empty)||
|head|show the fisrt n lines of a file| -n number|
|tail|show the last n lines of a file| -n number|

## file and account space management
|Command|info|Flags|
|--|--|--|
|my_accounts|show VACC accounts||
|my_job_statistics|show information of a SLURM job||
|squeue -u yy|show running jobs for user yy||
|scancel yyy|cancel job yyy||
|du|show file sizes|-ah (human readable units)|
|df|show space usage  on disk||
|groupquota|show VACC space allowance||
