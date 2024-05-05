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

points = []

with open(sys.argv[1], "r") as file:
    for line in file.read().strip().split("\n")[1:]:
        points.append(tuple(map(float, line.strip().split(","))))

points = tuple(points)
N = len(points)
a, b, c = 0, 0, 0

print(f"Initialised: {a} {b} {c}")

import sympy as sp

# theta1: a, theta2: b, theta3: c
t1, t2, t3, x, y, z = sp.symbols("t1 t2 t3 x y z")

L = 0.5 * (t1 * x + t2 * y + t3 * z - 1) ** 2
g = sp.Matrix([L.diff(f"t{_+1}") for _ in range(3)])
H = sp.hessian(L, (t1, t2, t3))
# H = sp.Matrix([[g[_].diff(f"t{__+1}") for __ in range(3)] for _ in range(3)])

max_iterations = 15
epsilon = 1e-6
epochs = 0
losses = []
early_stop = True

for epoch in range(max_iterations):
    sub_theta = {t1: a, t2: b, t3: c}

    L_ = L.evalf(subs=sub_theta)
    g_ = g.evalf(subs=sub_theta)
    H_ = H.evalf(subs=sub_theta)
    tL = 0
    tg = sp.zeros(3, 1)
    tH = sp.zeros(3)

    for x1, y1, z1 in points:
        sub_point = {x: x1, y: y1, z: z1}
        tL += L_.evalf(subs=sub_point)
        tg += g_.evalf(subs=sub_point)
        tH += H_.evalf(subs=sub_point)

    losses.append(tL)
    if early_stop and tL < epsilon:
        break

    steps = tH.inv() @ tg

    if early_stop and all(abs(step) < epsilon for step in steps):
        break

    epochs += 1
    a, b, c = (theta - step for theta, step in zip((a, b, c), steps))

a, b, c = (round(float(theta), 4) for theta in (a, b, c))
print(f"Optimal: {a} {b} {c}")
print(f"Epochs: {epochs}")
