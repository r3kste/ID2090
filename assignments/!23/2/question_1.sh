#!/usr/bin/python3

# References:
# https://serpapi.com/blog/python-curl-and-alternative/

import subprocess

scrape = r'curl -s "https://apod.nasa.gov/apod/archivepixFull.html" | grep -E -I "^\w+ \w+ \w+:"'
file = subprocess.check_output(scrape, shell=True)
file = file.decode("utf-8")

months = {
    "January": "01",
    "February": "02",
    "March": "03",
    "April": "04",
    "May": "05",
    "June": "06",
    "July": "07",
    "August": "08",
    "September": "09",
    "October": "10",
    "November": "11",
    "December": "12",
}

with open("answer_1a.csv", "w") as answer_1a, open("answer_1b.csv", "w") as answer_1b:
    answer_1a.write("Date, Title\n")
    answer_1b.write("Date, Title\n")

    for line in file.splitlines():
        date, title = line.split(":", 1)

        date = date.split()
        a, b, c = date[0], date[1], date[2]

        start = title.find(">") + 1
        end = title.find("<", start)
        title = title[start:end]

        year = a
        month = b
        day = c
        if a.isalpha():  # Before year 2000, the html page has a different format
            month = a
            day = b
            year = c

        month = months[month]
        year = int(year)

        res = "{}/{}/{}, {}\n".format(day, month, year, title)
        if year % int(day) == 0:
            answer_1a.write(res)
        if year % int(month) == 0:
            answer_1b.write(res)
