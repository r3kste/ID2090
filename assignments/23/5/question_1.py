#!/usr/bin/python3

import sys

if len(sys.argv) != 2:
    print(
        "error: invalid number of arguments\nexpected 1, Got",
        len(sys.argv) - 1,
        "\nusage: ./question_1.sh [functions.txt]",
        file=sys.stderr,
    )
    sys.exit(1)

import os

if not os.path.isfile(sys.argv[1]):
    print(
        'error: file "',
        sys.argv[1],
        '" not found',
        "\nusage: ./question_1.sh [functions.txt]",
        sep="",
        file=sys.stderr,
    )
    sys.exit(1)

import sympy as sp
from latex2sympy2 import latex2sympy as l2s

with open(sys.argv[1], "r") as file:
    f1, f2 = (l2s(line) for line in file.readlines())

x, k = sp.symbols("x k")

F1 = sp.fourier_transform(f1, x, k)
F2 = sp.fourier_transform(f2, x, k)

F = sp.inverse_fourier_transform(F1 * F2, k, x)

# Traditional convolution
# F = sp.integrate(f1.subs(x, k) * f2.subs(x, x - k), (k, -sp.oo, sp.oo))

print(sp.latex(F))
