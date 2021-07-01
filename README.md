# Git-Scripts: recurrent git workflow automation

## ffbranch.sh
The ffbranch script takes the name of a branch as a parameter. The script then loops over all of the other branches, fast-forwarding them if possible to the argument branch.

## Known bugs
1. When looping through all the branches, part of the files and directory present in the repository are considered by the scripts as branches. This issue does not alter the functionality of the script, but does output unnecessary logs.

## Todo
- [x] Write a commit counter script
- [x] Enhance the commit counter script to display more about the submodules
- [x] Update the cmcount script to include multiple versions of the same submodule
- [ ] Write an Angular source code to project recovery script
- [ ] Update this README.md with an explanation of the scripts in this repository
