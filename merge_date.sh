#!/bin/bash

#query earliest start date and latest end date
function merge_time()
{
    result=$(sqlite3 data_events.sqlite "select min(data_since), max(data_until) from data_events where data_source_account_id = $account and data_since >= '$start'")
    #output format
    if [ -z "$result" -o "$result" = "|" ] ; then
        echo "Nothing found."
    else
        echo "Time interval is from ${result//|/ to }"
    fi
}

read -t 15 -p "input your account ID and start date (e.g. 2017-01-21): " account start
#validate input
flag=1
for (( i = 0; i < 3; i++))
do
if [ $i -lt 1 ]; then
    attempt="attempts"
else
    attempt="attempt"
fi

if [[ $account =~ ^[0-9]+$ ]] && [[ $start =~ [0-9]{4}-[0-9]{2}-[0-9]{2} ]] && [ $i -ne 3 ]; then
    merge_time $account $start
    flag=0
    break
fi
if [ $i -eq 2 ]; then
    break
fi
echo "Account ID is not an integer nor Start date is not in correct format."
echo "You have `expr 2 - $i` $attempt left." 
read -p "input your account ID and start date (e.g. 2017-01-21): " account start
done
if [ $flag -eq 1 ]; then
    echo "Too many attempts."
fi


