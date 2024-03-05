#!/usr/bin/awk -f


BEGIN {
    # If the number of given arguments dont match the expected number of arguments
    if (ARGC != 3) {
        print "Invalid number of arguments!"
        exit
    }

    # Checking if the files given in the argumments exists or not
    if (system("ls " ARGV[1] " > /dev/null") != 0) {
        print "File in argument 1 (initial.txt) doesn't exist!"
        exit
    }
    if (system("ls " ARGV[2] " > /dev/null") != 0) {
        print "File in argument 2 (testcases.txt) doesn't exist!"
        exit
    }
    
    getline line < ARGV[1]
    n=split(line,params,",")
    if (n!=5) {
        print "Invalid number of parameters found in " ARGV[1] "\nExpected " 5 ", Got " n
        exit
    }
    a = params[1]
    b = params[2]
    c = params[3]
    f1 = params[4]
    f2 = params[5]

    getline < ARGV[2]
    t = $1
    while (t > 0) {
        getline < ARGV[2]
        n=$1
        t-=1
        ans = fibonacci2(n)
        printf "%f\n", ans
        # print ("echo " ans " / 1 | bc")
    }
}

function matrix_exponentiation(n) {
    a1 = b / a
    a2 = c / a

    matrix[0] = a1
    matrix[1] = a2
    matrix[2] = 1.0
    matrix[3] = 0.0

    result[0] = 1.0
    result[1] = 0.0
    result[2] = 0.0
    result[3] = 1.0

    while (n > 0) {
        ma = matrix[0]
        mb = matrix[1]
        mc = matrix[2]
        md = matrix[3]
        if (n % 2 == 1) {
            new_result[0] = ma * result[0] + mb * result[2]
            new_result[1] = ma * result[1] + mb * result[3]
            new_result[2] = mc * result[0] + md * result[2]
            new_result[3] = mc * result[1] + md * result[3]
            for (i in new_result) {
                result[i] = new_result[i]
            }
        }
        n = int(n / 2)
        matrix[0] = ma * ma + mb * mc
        matrix[1] = ma * mb + mb * md
        matrix[2] = mc * ma + md * mc
        matrix[3] = mc * mb + md * md
    }

    return result[0] * f2 + result[1] * f1
}

function fibonacci2(n) {
    if (n == 1) {
        return f1
    } else if (n == 2) {
        return f2
    } else {
        n -= 2
        return matrix_exponentiation(n)
    }
}

function fibonacci(n) {
    one = f1
    two = f2

    for (i = 3; i <= n; i++) {
        cmd = "export BC_LINE_LENGTH=0 && echo 'scale=4; (" two " * " b " + " one " * " c ") / " a "' | bc"
        cmd | getline temp
        close(cmd)
        one = two
        two = temp
    }

    return two
}