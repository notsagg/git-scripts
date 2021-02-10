# Git-Scripts: recurrent git workflow automation

## ffbranch.sh
The ffbranch script takes the name of a branch as a parameter. The script then loops over all of the other branches, fast-forwarding them if possible to the argument branch.

### Known bugs
1. When looping through all the branches, part of the files and directory present in the repository are considered by the scripts as branches. This issue does not alter the functionality of the script, but does output unnecessary logs.
