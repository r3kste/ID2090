#!/usr/bin/bash

# References:
# https://www.geeksforgeeks.org/sql-join-set-1-inner-left-right-and-full-joins/
# https://stackoverflow.com/questions/42814380/how-to-pass-bash-shell-variables-into-awk-statement
# https://stackoverflow.com/questions/34809444/how-do-i-sort-a-csv-file-by-a-specific-column

if [[ $# != 3 ]]; then
    echo "error: invalid number of arguments" >/dev/stderr
    echo "expected 3, but got "$# >/dev/stderr
    echo "usage:" >/dev/stderr
    echo "./question_4.sh [-I | -R | -L | -F] [left.csv] [right.csv]" >/dev/stderr
    exit 1
fi

flag=$1

if [[ $flag != "-I" && $flag != "-R" && $flag != "-L" && $flag != "-F" ]]; then
    echo "error: invalid flag!" >/dev/stderr
    echo "usage:" >/dev/stderr
    echo "./question_4.sh [-I | -R | -L | -F] [left.csv] [right.csv]" >/dev/stderr
    exit 1
fi

from=$2
to=$3

if [ ! -f "$from" ]; then
    echo "error: file $from not found" >/dev/stderr
    echo "usage:" >/dev/stderr
    echo "./question_4.sh [-I | -R | -L | -F] [left.csv] [right.csv]" >/dev/stderr
    exit 1
fi

if [ ! -f "$to" ]; then
    echo "error: file $to not found" >/dev/stderr
    echo "usage:" >/dev/stderr
    echo "./question_4.sh [-I | -R | -L | -F] [left.csv] [right.csv]" >/dev/stderr
    exit 1
fi

from_temp=$(mktemp)
to_temp=$(mktemp)
sed 's/,\s*/,/g' $from >$from_temp
sed 's/,\s*/,/g' $to >$to_temp

IFS=','
read -ra from_columns <<<"$(head -n 1 $from_temp)"
read -ra to_columns <<<"$(head -n 1 $to_temp)"

declare -A columns

for i in ${from_columns[@]}; do
    columns[$i]+=1
done

for i in ${to_columns[@]}; do
    columns[$i]+=1
done

# I am finding the common column between the two files, which is the key
for i in ${!columns[@]}; do
    if [ ${columns[$i]} -eq 11 ]; then
        key=$i
        break
    fi
done

idx=1
for i in ${from_columns[@]}; do
    if [ $i == $key ]; then
        from_key_index=$idx
        break
    fi
    idx=$((idx + 1))
done

awk -v key="$key" -v flag="$flag" -F ',' '
    BEGIN {
        left_key_index=0;
        left_columns=0;
        right_key_index=0;
        right_columns=0;
    }
    NR==FNR {

        # Here I am storing the left file in an associative array with the key as the respective key in the key column

        if ($0 ~ /^ *$/) {
            next
        }
        
        if (FNR==1) {
            left_columns=NF;
            for (i=1; i<=NF; i++) {
                if ($i==key) {
                    left_key_index=i;
                    break
                }
            }
        }
        left[$left_key_index]=$0;
        left_order[FNR]=$left_key_index;
        next
    }
    NR!=FNR {

        # Here I am storing the right file in an associative array with the key as the respective key in the key column
        if ($0 ~ /^ *$/) {
            next
        }

        if (FNR==1) {
            right_columns=NF;
            for (i=1; i<=NF; i++) {
                if ($i==key) {
                    right_key_index=i;
                    break
                }
            }
        }
        right[$right_key_index]=$0;
        right_order[FNR]=$right_key_index;
        next
    }

    function right_join() {
        # I am doing a right join by iterating over the right file and checking if the key does not exist in the left file

        for (i=1; i<=length(right); i++) {
            key=right_order[i];
            if (!(key in left)) {
                for (j=1; j<left_key_index; j++) {
                    printf "%s, ", null
                }
                printf "%s", key;
                for (j=left_key_index+1; j<=left_columns; j++) {
                    printf ", %s", null
                }

                split(right[key], right_values, ",");
                for (j=1; j<=right_columns; j++) {
                    if (j==right_key_index) {
                        continue
                    }
                    printf ", %s", right_values[j]
                }

                print ""
            }
        }
    }

    function left_join() {
        # I am doing a left join by iterating over the left file and checking if the key does not exist in the right file

        for (i=1; i<=length(left); i++) {
            key=left_order[i];
            if (!(key in right)) {
                printf "%s", left[key];

                for (j=1; j<right_columns; j++) {
                    printf ", %s", null
                }

                print ""
            }
        }
    }
    
    END {
        null="NULL";

        # I do an inner join by iterating over the left file and checking if the key exists in the right file
        # An inner join is done for any type of join, so I am doing it here

        for (i=1; i<=length(left); i++) {
            key=left_order[i];
            if (key in right) {
                printf "%s", left[key];
                split(right[key], right_values, ",");
                for (j=1; j<=right_columns; j++) {
                    if (j==right_key_index) {
                        continue
                    }
                    printf ", %s", right_values[j]
                }
                print ""
            }
        }

        switch (flag) {
            case "-R":
                right_join();
                break
            case "-L":
                left_join();
                break
            case "-F":
                right_join();
                left_join();
                break
            default:
                break
        }
    }
' $from_temp $to_temp | sed 's/,\s*/, /g' | awk -v fki=$from_key_index '
    NR==1 {
        print $0;
        next
    }
    {
        print $0 | "sort -t, -k" fki
    }
'

trap 'rm -f "$from_temp" "$to_temp"' EXIT
