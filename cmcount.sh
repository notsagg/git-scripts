#!/bin/bash

source $(dirname "$0")/config/config.dat
declare -i var total=0
BASE_DIR=$(pwd)

# 1. check that the garbage.sh script is not being run from its own directory
if [ $(dirname "$0") == "."  ]; then
    printf "$CL_OPEN$RED\nerror: cmcount.sh run in its own directory\n$CL_CLOSING"
    exit 1
fi

# 2. get the number of commits in the main repository
total=$(($total + $(git rev-list --all --count)))

# 3. get the commit count for each submodule
for path in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do
    if [ $path != 'git-scripts' ]; then
        # a. get the number of commits in the given submodule
        cd $BASE_DIR/$path
        local=$(git rev-list --all --count)
        total=$(($total + $local))

        # b. echo the count
        echo "$local commits in $path"
    fi
done

# 4. echo the total number of commits
cd $BASE_DIR
printf "\n => $total commits in \`$(git remote -v | cut -d'/' -f2 | cut -d'.' -f1 | head -n1)\` at $BASE_DIR\n"
