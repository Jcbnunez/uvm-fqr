
# A grand tour of UNIX

## Understanding the Environment

|Command|info|Flags|
|--|--|--|
|uname|Show the Unix system info| -a (details), -r (kernel)|
|uptime|how long has the system been running||
|who|show who is logged in||
|who|show who is logged in||
|w|who is online and what are they doing||
|users|show a list of users||
|whoami|your system identity||
|cal|calendar information||
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
|move file|||
|>|save to (overwrites)||
|>>|save to (appends)||
|<|read into||
|rm|delete|-r (recurrsively), -f (forced)|
|rmdir|delete directory (must be empty)||

