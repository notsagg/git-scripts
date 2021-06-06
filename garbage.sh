#!/bin/bash

source $(dirname "$0")/config/config.dat
YES="Y"
NO="n"

# 1. check that the garbage.sh script is not being run from its own directory
if [ $(dirname "$0") == "."  ]; then
    printf "$CL_OPEN$RED\nerror: garbage.sh run in its own directory\n$CL_CLOSING"
    exit 1
fi

# 2. from where garbage will be collected
printf "Collecting garbage in $CL_OPEN$YELLOW$(pwd)$CL_CLOSING recursively\n\n"

# 3. prompt to see garbage to be removed
read -p "Do you wish to see the garbage that will be deleted? [Y/n] " verbose

if [ "$verbose" == "$YES" ]; then
    find . -type d \( -name ".git" \) -prune -false -o \( -name "._*" -o -name ".DS_Store" \)
    printf "\n"
    read -p "Continue? [Y\n] " forward

    if [ "$forward" == "$NO" ]; then
        exit 0
    elif [ "$forward" != "$YES" ]; then
        printf "$CL_OPEN$RED\nerror: unrecognized answer\n$CL_CLOSING"
        exit 1
    fi

elif [ "$verbose" != "$NO" ]; then
    printf "$CL_OPEN$RED\nerror: unrecognized answer\n$CL_CLOSING"
    exit 1
fi

# 4. delete garbage
find . -type d \( -name ".git" \) -prune -false -o \( -name "._*" -o -name ".DS_Store" \) -delete

# 5. exit
printf "$CL_OPEN$GREEN\nDone\n$CL_CLOSING"
