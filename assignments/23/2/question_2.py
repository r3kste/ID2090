#!/usr/bin/python3

# References:
# https://www.geeksforgeeks.org/python-regex/

import sys
import os
import re

if len(sys.argv) != 2:
    print(
        "error: invalid number of arguments\nexpected 1, Got",
        len(sys.argv) - 1,
        "\nusage: ./question_2.py [final_dataset.txt]",
        file=sys.stderr,
    )
    sys.exit(1)

if not os.path.isfile(sys.argv[1]):
    print(
        'error: file "',
        sys.argv[1],
        '" not found',
        "\nusage: ./question_2.py [final_dataset.txt]",
        sep="",
        file=sys.stderr,
    )
    sys.exit(1)

with open(sys.argv[1], "r") as file:
    line = next(file)
    w = line.split()
    print(
        re.sub(
            ",+",
            ",",
            f"{w[0]} {w[1]}, {w[2]}, {w[3]} {w[4]}, {w[5]} {w[6]} {w[7]}, {w[8]}, {w[9]} {w[10]}, Flag",
        ),
    )

    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    mirror = dict(zip(alphabet, alphabet[::-1]))

    for line in file:
        w = line.split()
        if len(w) == 6:
            vehicle_number, soc, mileage, charging_time, soh, driver_name = w
            driver_name = "".join(mirror[letter] for letter in driver_name)
            flag = ""

            if vehicle_number[:2] == "AG":
                soh, soc = soc, soh

            if soc == "0" and mileage != "0":
                flag = ", Fake"

            res = f"{vehicle_number}, {soc}, {mileage}, {charging_time}, {soh}, {driver_name}{flag}"
            print(res)
