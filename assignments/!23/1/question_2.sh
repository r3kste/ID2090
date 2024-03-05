#!/usr/bin/bash

# Here, I tried two different methods to calculate the sequence
# The first method is a naive approach, which is very slow for large N
# The second method is a matrix exponentiation method, which is much faster for large N
# This method works in O(log N) time for each N, rather than O(N) with dp, or even worse... a O(2^N)  with normal recursion
# The script however, uses the second, slower method and I have explained why in the comments below

# References:
# https://linuxize.com/post/bash-check-if-file-exists/
# https://www.geeksforgeeks.org/matrix-exponentiation/
# https://cp-algorithms.com/algebra/binary-exp.html

# To prevent wrapping of the output, I have set the BC_LINE_LENGTH to 0
export BC_LINE_LENGTH=0

# Check if the inputs are valid

if [ "$#" -ne 2 ]; then
    echo "error: Invalid number of arguments!"
    echo "usage: $0 initial.txt testcases.txt"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "error: File in argument 1 (initial.txt) doesn't exist!"
    exit 1
fi

if [ ! -f "$2" ]; then
    echo "error: File in argument 2 (testcases.txt) doesn't exist!"
    exit 1
fi

IFS=',' read -a params <<<"$(sed 's/ *//g' "$1")"

if [ "${#params[@]}" -ne 5 ]; then
    echo "error: Invalid number of parameters found in $1"
    echo "Expected 5, Got ${#params[@]}"
    exit 1
fi

a=${params[0]}
b=${params[1]}
c=${params[2]}
f1=${params[3]}
f2=${params[4]}

# Matrix exponentiation for calculating the sequence:
# This is not used in the final code, but is kept here for speed comparison
# It is not used becuase we are forced to use a very specific method (with dynamic programming and scale = 4),
#    as that is the only way to match the output with the tester, as it looks for exact matches.
# This is much faster for large N, and it uses a much better precision.
# It is still limited by the speed and precision of bc, and the sheer size of the numbers just like the naive approach
# Setting a low scale value will result in a lot of precision errors.
# Setting a high scale value will give a much better answer, and is still quite fast for large N

# fibonacci2() {
#     # a random but large scale value
#     scale=2090
#     local n=$1
#     if [ $n -eq 1 ]; then
#         echo $f1
#     elif [ $n -eq 2 ]; then
#         echo $f2
#     else
#         matrix_exponentiation() {
#             local n=$1
#             local a1=$(echo "scale=$scale; $b/$a" | bc)
#             local a2=$(echo "scale=$scale; $c/$a" | bc)
#             local matrix=($a1 $a2 1 0)
#             local result=(1 0 0 1)

#             while [ $n -gt 0 ]; do
#                 local ma=${matrix[0]}
#                 local mb=${matrix[1]}
#                 local mc=${matrix[2]}
#                 local md=${matrix[3]}
#                 if [ $(((n) % (2))) -eq 1 ]; then
#                     local new_result=(
#                         $(echo "scale=$scale; ($ma * ${result[0]} + $mb * ${result[2]})" | bc)
#                         $(echo "scale=$scale; ($ma * ${result[1]} + $mb * ${result[3]})" | bc)
#                         $(echo "scale=$scale; ($mc * ${result[0]} + $md * ${result[2]})" | bc)
#                         $(echo "scale=$scale; ($mc * ${result[1]} + $md * ${result[3]})" | bc)
#                     )
#                     result=(${new_result[@]})
#                 fi
#                 n=$((n / 2))
#                 matrix=(
#                     $(echo "scale=$scale; ($ma * $ma + $mb * $mc)" | bc)
#                     $(echo "scale=$scale; ($ma * $mb + $mb * $md)" | bc)
#                     $(echo "scale=$scale; ($mc * $ma + $md * $mc)" | bc)
#                     $(echo "scale=$scale; ($mc * $mb + $md * $md)" | bc)
#                 )
#             done

#             echo ${result[@]}
#         }
#         n=$((n - 2))
#         ans=($(matrix_exponentiation $n))
#         value=$(echo "scale=$scale; ${ans[0]} * $f2 + ${ans[1]} * $f1" | bc)
#         echo $value
#     fi
# }

# Naive approach for calculating the sequence
# This is the function used for calculating the sequence
# This is one of the slower methods, but is the only way to match the output of the tester
# It is also not possible to use a better arbitrary precision library, because of the tester.
# This is very very slow for large N (even for N = 20000, it took around 1 minute)
fibonacci() {
    local scale=4
    local n=$1
    local one=$f1
    local two=$f2

    for ((i = 3; i <= n; i++)); do
        local three=$(echo "scale=$scale; $two * $b + $one * $c" | bc)
        local three=$(echo "scale=$scale; $three / $a" | bc)
        one=$two
        two=$three
    done

    echo $two
}

testcases="$2"
t=($(head -n 1 "$testcases"))

for ((i = 0; i <= t; i++)); do
    read -r line

    # Check if the line is empty
    if [ -z "$line" ]; then
        i=$((i - 1))
        continue
    fi

    # Ignore the first line (as it is the number of testcases)
    if [ $i -eq 0 ]; then
        continue
    fi

    # This line is for the naive approach
    ans=($(fibonacci $line))

    # The following line is for the matrix exponentiation method
    # Uncomment to use this method
    # ans=($(fibonacci2 $line))

    ans=($(echo "scale=4; $ans / 1" | bc))
    ans=($(echo $ans | sed 's/\.0000$//g')) # Remove trailing zeros if it is an integer
    echo $ans
done <"$2"
