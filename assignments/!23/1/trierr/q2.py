#!/usr/bin/python3

import sys
import os
import math

sys.set_int_max_str_digits(20000000)

from decimal import *

getcontext().prec = 1000

with open("/home/h3kste12/code/ID2090/scripts/initial.txt", "r") as initial:
    params = list(map(Decimal, initial.readline().strip().split(",")))

if len(params) != 5:
    print(
        f"Invalid number of parameters found in {sys.argv[1]}\nExpected 5, Got {len(params)}"
    )
    sys.exit()

a, b, c, f1, f2 = params


def matrix_exponentiation(n):
    matrix = [Decimal(b / a), Decimal(c / a), Decimal(1), Decimal(0)]
    result = [Decimal(1), Decimal(0), Decimal(0), Decimal(1)]

    while n > 0:
        ma, mb, mc, md = matrix
        if n % 2 == 1:
            new_result = [
                ma * result[0] + mb * result[2],
                ma * result[1] + mb * result[3],
                mc * result[0] + md * result[2],
                mc * result[1] + md * result[3],
            ]
            result = new_result
        n = n // 2
        matrix = [
            ma * ma + mb * mc,
            ma * mb + mb * md,
            mc * ma + md * mc,
            mc * mb + md * md,
        ]

    return result[0] * f2 + result[1] * f1


def fibonacci(n):
    if n == 1:
        return f1
    elif n == 2:
        return f2
    else:
        n -= 2
        return matrix_exponentiation(n)


with open("/home/h3kste12/code/ID2090/scripts/testcases.txt", "r") as testcases:
    t = int(testcases.readline().strip())
    for _ in range(t):
        n = int(testcases.readline().strip())
        result = fibonacci(n)
        print(result)
