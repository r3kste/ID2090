#!/usr/bin/python3

import sys

if len(sys.argv) != 2:
    print(
        "error: invalid number of arguments\nexpected 1, Got",
        len(sys.argv) - 1,
        "\nusage: ./question_2.sh [press.txt]",
        file=sys.stderr,
    )
    sys.exit(1)

import os

if not os.path.isfile(sys.argv[1]):
    print(
        'error: file "',
        sys.argv[1],
        '" not found',
        "\nusage: ./question_2.sh [press.txt]",
        sep="",
        file=sys.stderr,
    )
    sys.exit(1)

import sympy as sp
from latex2sympy2 import latex2sympy as l2s

rho, r, gz, mu, R, z = sp.symbols("rho r g_z mu R z")
mu, R = sp.symbols("mu R")
vz = sp.Function("v_z")(r)


with open(sys.argv[1], "r") as file:
    P = l2s(file.readline())

navier_stokes = sp.Eq(
    sp.Derivative(rho * vz, z) + vz * sp.Derivative(vz, z),
    rho * gz
    - sp.Derivative(P, z)
    + mu * (sp.Derivative((r * sp.Derivative(vz, r)), r)) / r,
)

solution = sp.dsolve(navier_stokes, vz)

general_solution = solution.rhs
C1, C2 = sp.symbols("C1 C2")

boundary_conditions = [
    sp.Eq(general_solution.subs(r, 0), C1),
    sp.Eq(general_solution.subs(r, R), 0),
]

constants = sp.solve(boundary_conditions, (C1, C2))
particular_solution = general_solution.subs(constants)

assumptions = {
    "g_z": 0,
    "mu": 1,
    "R": 1,
}

final_solution = particular_solution.subs(assumptions)

# CPP code generation
print(
    """#include <iostream>
#include <cmath>
int main(int argc, char *argv[]) {{
    double r = std::stod(argv[1]);
    std::cout << std::abs({}) << "\\n";
}}""".format(
        str(sp.ccode(final_solution))
    ),
    file=open("vel.cpp", "w"),
)

import subprocess

subprocess.run(["g++", "-O2", "vel.cpp", "-o", "vel.out"])
