#!/usr/bin/awk -f


# Consider this
# These are the first six values corresponding to A, B, C, D, E, F

# 13130 13464 13802 14144 14490

# Now, I am going to "differentiate" it. And by that I am going to take the dfference between two consecutive terms
# So it becomes

# 13130 13464 13802 14144 14490
#     334   338   342   345

# Now, there is a pattern emerging... We ca go a step further and differentiate it once again
# So, now it becomes

# 13130 13464 13802 14144 14490
#     334   338   342   345
#         4     4     4

# Now, the pattern is clear. I am going to differentiate it once more now.

# 13130 13464 13802 14144 14490 ...
#     334   338   342   345   ...
#         4     4     4    ...
#            0     0    ... 

# Therefore, our function is such that 
# The first derivative is linearly varying
# The second derivative is constant
# And the third and higher order derivatives are zero

# Therefore, I can confidently say that the function is a quadratic function
# Now, to find the coefficients of the quadratic function...
# f(65) = 13130
# f(66) = 13464
# f(67) = 13802

# Solving for these equations, we get that 
# a = 2, b = 72, c = 0
# f(x) = 2x^2 + 72x = 2x(x + 36)

# Now, to make the translations easier, I am going to use a data structure similar to std::map in C++, dictionaries in Python and HashMap in Rust.
# It seems that that Associative Arrays is the default kind of arrays in awk

# References:
# https://stackoverflow.com/questions/64906461/how-to-run-curl-from-awk-statement
# https://www.howtogeek.com/447033/how-to-use-curl-to-download-files-from-the-linux-command-line/
# https://www.thegeekstuff.com/2010/03/awk-arrays-explained-with-5-practical-examples/
# https://stackoverflow.com/questions/41352630/about-awk-and-integer-to-ascii-character-conversion
# https://stackoverflow.com/questions/7373752/how-do-i-get-curl-to-not-show-the-progress-bar

# Usage:
# Link: https://id2090assignment1.s3.ap-south-1.amazonaws.com/Q3.txt

BEGIN {
    if (ARGC == 1) {
        print "error: no URL specified!" > "/dev/stderr"
        print "usage: ./question3.sh https://id2090assignment1.s3.ap-south-1.amazonaws.com/Q3.txt" > "/dev/stderr"
        exit 1
    }
    if (ARGC > 2) {
        print "error: Invalid number of arguments" > "/dev/stderr"
        print "usage: ./question3.sh https://id2090assignment1.s3.ap-south-1.amazonaws.com/Q3.txt" > "/dev/stderr"
        exit 1
    }
    for (i=65;i<=90;i++) {
        encoding = 2*i*(i+36)
        decode[encoding] = char(i)
    }
    for (i=97;i<=122;i++) {
        encoding = 2*i*(i+36)
        decode[encoding] = char(i)
    }
    decode["0"]=""
    c=0
    outputfile = "output.txt"
    while (("curl -s " ARGV[1]| getline line) > 0) {
        c+=1
        if (c<=52) {
            continue
        }
        split(line, words, " ")

        for (i in words) {
            if (words[i] in decode) {
                words[i] = decode[words[i]]
            }
        }
        for (i in words) {
            printf words[i] > outputfile
            if (i==1) {
                printf "," > outputfile
            }
        }
        print "" > outputfile
    } 
    system("cat " outputfile) 
}

# Custom function to convert ASCII value to corresponding character
function char(c) {
    return sprintf("%c",c)
}