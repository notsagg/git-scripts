#!/bin/bash

source $(dirname "$0")/config/config.dat
declare -i var total=0 # total all time
declare -i var today=0 # total today
declare -i var yesterday=0 # total yesterday
BASE_DIR=$(pwd)
SUBMODULES="git config --file .gitmodules --get-regexp path | awk '{ print \$2 }'"
TODAY="git log --since=12am --oneline 2>/dev/null | wc -l | sed 's/[[:blank:]]//g'"
YESTERDAY="git log --after='2 days ago' --before=12am --oneline 2>/dev/null | wc -l | sed 's/[[:blank:]]//g'"
THIS_WEEK="git log --after='7 days ago' --oneline 2>/dev/null | wc -l | sed 's/[[:blank:]]//g'"
THIS_MONTH="git log --since='$(date +'%Y-%m-01')' --oneline 2>/dev/null | wc -l | sed 's/[[:blank:]]//g'"
THIS_YEAR="git log --since='$(date +'%Y')-01-01' --oneline 2>/dev/null | wc -l | sed 's/[[:blank:]]//g'"
LAST_YEAR="git log --after='$(($(date +'%Y')-1))-01-01' --before='$(date +'%Y')-01-01' --oneline 2>/dev/null | wc -l | sed 's/[[:blank:]]//g'"
SINCE="git log --reverse --date=format:'%A %B %d %Y at %I:%M %p' --pretty=format:'%ad' 2>/dev/null | head -n1"
SINCE_RFC2822="git log --reverse --pretty='format:%aD' 2>/dev/null | rev | cut -d ' ' -f2- | rev | head -n1" # author date, RFC2822 style

function commitCount {
    local=$(eval $TODAY)
    today=$(($today + $local))
    echo " today: $local commits"

    local=$(eval $YESTERDAY)
    yesterday=$(($yesterday + $local))
    echo " yesterday: $local commits"

    thisWeek=$(eval $THIS_WEEK)
    if [ $thisWeek -gt 0 ]; then
        echo " this week: $thisWeek commits"
    fi

    thisMonth=$(eval $THIS_MONTH)
    if [ $thisMonth -gt 0 ] && [ $thisWeek -ne $thisMonth ]; then
        echo " this month: $thisMonth commits"
    fi

    thisYear=$(eval $THIS_YEAR)
    if [ $thisYear -gt 0 ] && [ $thisMonth -ne $thisYear ]; then
        echo " this year: $thisYear commits"
    fi

    lastYear=$(eval $LAST_YEAR)
    if [ $lastYear -gt 0 ] && [ $thisYear -ne $lastYear ]; then
        echo " last year: $lastYear commits"
    fi
}

# 1. check that the garbage.sh script is not being run from its own directory
if [ $(dirname "$0") == "."  ]; then
    printf "$CL_OPEN$RED\nerror: cmcount.sh run in its own directory\n$CL_CLOSING"
    exit 1
fi

# 2. get the name of the base repository
BASE_REPO=$(git remote -v | cut -d'/' -f2 | cut -d'.' -f1 | head -n1)

if [[ $BASE_REPO == '' ]]; then
    BASE_REPO=$(basename `git rev-parse --show-toplevel`)
fi

# 3. get the number of commits in the main repository
printf "$CL_OPEN$BRIGHT\n ----------------- $BASE_REPO ----------------- \n\n$CL_CLOSING"
commitCount # commit count today, yesterday, week, month, year, last year

local=$(git rev-list --all --count)
total=$(($total + $local))
date=$(eval $SINCE)

printf "\n => total: $CL_OPEN$BRIGHT$local commits $CL_CLOSING"
if [[ $date != '' ]]; then
    printf "since\n $date"
fi
printf "\n"

# 4. get the commit count for each submodule
SUB_COUNT="eval $SUBMODULES | wc -l | sed 's/[[:blank:]]//g'"

if [ $(eval $SUB_COUNT) -gt 0 ]; then
    # a. print the header
    printf "$CL_OPEN$BRIGHT\n -------------- Submodules -------------- \n$CL_CLOSING"

    # b. get the commit count for each submodule
    for path in $(eval $SUBMODULES); do
        if [ $path != 'git-scripts' ]; then
            # i. print the header
            printf "$CL_OPEN$DIM\n--- $path\n$CL_CLOSING"

            # ii. get the number of commits in the given submodule
            cd $BASE_DIR/$path

            # iii. echo the count
            commitCount # commit count today, yesterday, week, month, year, last year
            local=$(git rev-list --all --count) # get the commit count
            total=$(($total + $local)) # update the total commit count
            printf " => total: $CL_OPEN$BRIGHT$local commits $CL_CLOSING\n"
        fi
    done
fi

# 6. echo the total number of commits
printf "$CL_OPEN$BRIGHT\n ----------------- Total ----------------- \n$CL_CLOSING"
cd $BASE_DIR
printf "\n => $CL_OPEN$BRIGHT$total commits $CL_CLOSING"
printf "in \`$BASE_REPO\` at $BASE_DIR\n"
echo " => $today commits today"
echo " => $yesterday commits yesterday"
