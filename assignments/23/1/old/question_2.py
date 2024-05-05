#!/usr/bin/python3

import sys
import os

from decimal import Decimal, getcontext

getcontext().prec = 500000

if len(sys.argv) != 3:
    print("Invalid number of arguments!")
    sys.exit()

if not os.path.exists(sys.argv[1]):
    print("File in argument 1 (initial.txt) doesn't exist!")
    sys.exit()

if not os.path.exists(sys.argv[2]):
    print("File in argument 2 (testcases.txt) doesn't exist!")
    sys.exit()

with open(sys.argv[1], "r") as initial:
    params = list(map(Decimal, initial.readline().strip().split(",")))

if len(params) != 5:
    print(
        f"Invalid number of parameters found in {sys.argv[1]}\nExpected 5, Got {len(params)}"
    )
    sys.exit()

a, b, c, f1, f2 = params

import subprocess


def bc_calculation(expression):
    return subprocess.check_output(["bc", "-l"], input=f"scale=4; {expression}", text=True).strip()


def matrix_exponentiation(n):
    matrix = [bc_calculation(f"{b} / {a}"), bc_calculation(f"{c} / {a}"), "1", "0"]
    result = ["1", "0", "0", "1"]

    while n > 0:
        ma, mb, mc, md = matrix
        if n % 2 == 1:
            new_result = [
                bc_calculation(f"{ma} * {result[0]} + {mb} * {result[2]}"),
                bc_calculation(f"{ma} * {result[1]} + {mb} * {result[3]}"),
                bc_calculation(f"{mc} * {result[0]} + {md} * {result[2]}"),
                bc_calculation(f"{mc} * {result[1]} + {md} * {result[3]}"),
            ]
            result = new_result
        n = n // 2
        matrix = [
            bc_calculation(f"{ma} * {ma} + {mb} * {mc}"),
            bc_calculation(f"{ma} * {mb} + {mb} * {md}"),
            bc_calculation(f"{mc} * {ma} + {md} * {mc}"),
            bc_calculation(f"{mc} * {mb} + {md} * {md}"),
        ]

    return bc_calculation(f"{result[0]} * {f2} + {result[1]} * {f1}")


def matrix_exponentiation2(n):
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


def fibonacci2(n):
    if n == 1:
        return f1
    elif n == 2:
        return f2
    else:
        n -= 2
        return matrix_exponentiation(n)


with open(sys.argv[2], "r") as initial:
    t = int(initial.readline().strip())
    for _ in range(t):
        n = int(initial.readline().strip())
        result = fibonacci2(n)
        print("{:.4f}".format(result))
