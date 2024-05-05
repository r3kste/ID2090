#!/usr/bin/python3

import sys

if len(sys.argv) != 2:
    print(
        "error: invalid number of arguments\nexpected 1, Got",
        len(sys.argv) - 1,
        "\nusage: ./question_1.sh [obj.yml]",
        file=sys.stderr,
    )
    sys.exit(1)

import os

if not os.path.isfile(sys.argv[1]):
    print(
        'error: file "',
        sys.argv[1],
        '" not found',
        "\nusage: ./question_1.sh [obj.yml]",
        sep="",
        file=sys.stderr,
    )
    sys.exit(1)

with open(sys.argv[1], "r") as file:
    import yaml

    A = yaml.load(file, Loader=yaml.Loader)

import sympy as sp
from sympy import pprint

A = sp.Matrix(A)

eigenvalues, eigenvectors = [], []
for eigenvalue, multiplicity, eigenvector in A.eigenvects(sorted=False):
    eigenvalues.extend([eigenvalue] * multiplicity)
    eigenvectors.extend(eigenvector)

print("Eigenvalues:")
pprint(sp.Matrix([eigenvalues]))

eigenvectors = sp.GramSchmidt(eigenvectors)
eigenvectors = [v.normalized() for v in eigenvectors]

U = sp.Matrix([eigenvectors])
print("\nU:")
pprint(U)

D = sp.diag(*eigenvalues)
print("\nD:")
pprint(D)

P = {eigenvalue: [] for eigenvalue in eigenvalues}
for eigenvalue, eigenvector in zip(eigenvalues, eigenvectors):
    P[eigenvalue].append(eigenvector * eigenvector.transpose())
print("\nDecomposition:")
spectral_decomposition = None
for eigenvalue in list(P)[::-1]:
    e = sum(P[eigenvalue], sp.zeros(A.shape[0]))
    if spectral_decomposition is None:
        spectral_decomposition = sp.MatMul(eigenvalue, e, evaluate=False)
    else:
        spectral_decomposition = sp.MatAdd(
            spectral_decomposition,
            sp.MatMul(eigenvalue, e, evaluate=False),
            evaluate=False,
        )

pprint(spectral_decomposition)

classes = []
if A == A.adjoint():
    classes.append("Hermitian")

if A * A.adjoint() == sp.eye(*A.shape):
    classes.append("Unitary")

try:
    if all([eigenvalue >= 0 for eigenvalue in eigenvalues]):
        classes.append("Positively Semidefinite")

    if all([eigenvalue > 0 for eigenvalue in eigenvalues]):
        classes.append("Positively Definite")
except:
    pass

if A * A.adjoint() == A.adjoint() * A:
    classes.append("Normal")

print("\nClassification:\nA is ", end="")
for i, class_ in enumerate(classes):
    print(f"{', ' if i else ''}{class_}", end="")
print()
