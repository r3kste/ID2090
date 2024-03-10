#!/bin/bash

# read -p "Enter the number of terms: " n
n=$1
m=1000000007
n=$((n % 2000000016))
# Fibonacci function
fibonacci() {
    local n=$n
    n=$((n - 1))
    local a=1
    local b=1

    for ((i = 0; i < n; i++)); do
        # echo -n "$a "
        local temp=$a
        a=$b
        b=$((temp + $b))
        a=$((a % m))
        b=$((b % m))
    done

    echo $a
    echo
}

matrix_exponentiation() {
    local n=$n
    local matx=(1 1 1 0)
    local result=(1 0 0 1)

    while [ $n -gt 0 ]; do
        local a=${matx[0]}
        local b=${matx[1]}
        local c=${matx[2]}
        local d=${matx[3]}
        if [ $(((n) % (2))) -eq 1 ]; then
            local new_result=(
                $(((a * ${result[0]} + b * ${result[2]}) % m))
                $(((a * ${result[1]} + b * ${result[3]}) % m))
                $(((c * ${result[0]} + d * ${result[2]}) % m))
                $(((c * ${result[1]} + d * ${result[3]}) % m))
            )
            result=(${new_result[@]})
        fi
        n=$((n / 2))
        matx=(
            $(((a * a + b * c) % m))
            $(((a * b + b * d) % m))
            $(((c * a + d * c) % m))
            $(((c * b + d * d) % m))
        )
    done

    echo "${result[1]}"
}

fibonacci2() {
    ans=($(matrix_exponentiation))
    echo $ans
}

fibonacci2
