#!/bin/bash

# ANSI color escape codes
CL_OPEN="\e[1;" # opening color espace code
CL_CLOSING="\e[0m\n" # closing color espace code
RED="31m" # the red color

# check for argument
if [ $# -ne 1 ]; then
    printf "$CL_OPEN$RED Fast-forward branch argument required $CL_CLOSING" 1>&2
    exit 1
fi

# check that argument is a branch
isbranch=0 # whether $1 is an existing branch
for branch in $(git branch); do
    if [ $branch == $1 ]; then
        isbranch=1 # $1 is an existing branch part of the repository

        # checkout $1
        git checkout $1 > /dev/null 2>&1

        # pull for changes
        git pull > /dev/null 2>&1
    fi
done

if [ $isbranch -ne 1 ]; then
    printf "$CL_OPEN$RED'$1' is not a branch $CL_CLOSING" 1>&2
    exit 1
fi

# get current branch
obranch=$(git branch | grep "*" | sed -n -e 's/^\* \(.*\)/\1/p')

# fast-forward every branches to $1
for branch in $(git branch); do
    if [ $branch != $1 ]; then
        echo " -- 1. Checking out branch '$branch'"
        git checkout $branch > /dev/null 2>&1

        echo " -- 2. Update '$branch' from origin"
        git pull > /dev/null 2>&1

        echo " -- 3. Merging '$1' into '$branch'"
        git merge --ff-only $1 > /dev/null 2>&1

        echo -e " -- 4. Pushing '$branch' to 'origin/$branch' \n"
        git push origin $branch > /dev/null 2>&1
    fi
done

# checkout out the branch from where the script was first launched
git checkout $obranch > /dev/null 2>&1
