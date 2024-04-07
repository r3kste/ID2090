#!/usr/bin/python3

import sys

if len(sys.argv) != 2:
    print(
        "error: invalid number of arguments\nexpected 1, Got",
        len(sys.argv) - 1,
        "\nusage: ./question_2.sh [points.csv]",
        file=sys.stderr,
    )
    sys.exit(1)

import os

if not os.path.isfile(sys.argv[1]):
    print(
        'error: file "',
        sys.argv[1],
        '" not found',
        "\nusage: ./question_2.sh [points.csv]",
        sep="",
        file=sys.stderr,
    )
    sys.exit(1)

import sympy

points = []

with open(sys.argv[1], "r") as file:
    for line in file.readlines()[1:]:
        points.append(tuple(map(float, line.strip().split(","))))

points = tuple(points)
N = len(points)
n = 3
a, b, c = 1, 1, 1

print(f"Initialised: {a} {b} {c}")

# theta1: a, theta2: b, theta3: c
t1, t2, t3, x, y, z = sympy.symbols("t1 t2 t3 x y z")

L = 0.5 * (t1 * x + t2 * y + t3 * z - 1) ** 2
g = sympy.Matrix([L.diff(f"t{_+1}") for _ in range(n)])
H = sympy.Matrix([[g[_].diff(f"t{__+1}") for __ in range(n)] for _ in range(n)])

max_iterations = 15
epsilon = 1e-3
epochs = 0
for _ in range(max_iterations):
    sub_theta = {t1: a, t2: b, t3: c}

    L_ = L.evalf(subs=sub_theta)
    tL = 0

    for x1, y1, z1 in points:
        sub_point = {x: x1, y: y1, z: z1}
        tL += L_.evalf(subs=sub_point) / N
        if tL > epsilon:
            break

    if tL < epsilon:
        break

    g_ = g.evalf(subs=sub_theta)
    H_ = H.evalf(subs=sub_theta)
    tg = sympy.zeros(g.shape[0], g.shape[1])
    tH = sympy.zeros(H.shape[0], H.shape[1])

    for x1, y1, z1 in points:
        sub_point = {x: x1, y: y1, z: z1}
        tg += g_.evalf(subs=sub_point)
        tH += H_.evalf(subs=sub_point)

    if tH.det() == 0:
        steps = tH.pinv() @ tg
    else:
        steps = tH.inv() @ tg

    if all(abs(step) < epsilon for step in steps):
        break

    epochs += 1
    a, b, c = [theta - step for theta, step in zip([a, b, c], steps)]

a, b, c = (
    round(float(a), 4),
    round(float(b), 4),
    round(float(c), 4),
)
print(f"Optimal: {a} {b} {c}")
print(f"Epochs: {epochs}")
