#!/usr/bin/awk -f

BEGIN {
    if (ARGC != 2) {
        print "error: invalid number of arguments\nexpected 1, Got " ARGC-1 > "/dev/stderr"
        print "usage: ./question_2.sh [final_dataset.txt]" >"/dev/stderr"
        exit 1
    }
    
    if (system("[ -f " ARGV[1] " ]") != 0) {
        print "error: file \"" ARGV[1] "\" not found" > "/dev/stderr"
        print "usage: ./question_2.sh [final_dataset.txt]" >"/dev/stderr"
        exit 1
    }
    
    split("A B C D E F G H I J K L M N O P Q R S T U V W X Y Z", from, " ")
    split("Z Y X W V U T S R Q P O N M L K J I H G F E D C B A", to, " ")
    for (i = 1; i <= 26; i++) {
        mirror[from[i]] = to[i]
    }
}   
NR == 1 {
    # Vehicle Number, SoC, Mileage(in m), Charging Time(in min), SoH, Driver Name
    print $1 " " $2 ", " $3 ", " $4 " " $5 ", " $6 " " $7 " " $8 ", " $9 ", " $10 " " $11 ", Flag"
}
NF == 6 {
    number = $1
    soc = $2
    mileage = $3
    charging_time = $4
    soh = $5
    
    split($6, letters, "")
    driver = ""
    for (i = 1; i <= length(letters); i++) {
        driver = driver mirror[letters[i]]
    }
    flag = ""
    
    if (substr(number, 1, 2) == "AG") {
        soh = $2
        soc = $5
    }
    if (soc == 0 && mileage != 0) {
        flag = "Fake"
    }
    
    spacing = ""
    if (mileage < 10000) {
        spacing = "   "
    }
    print number "\t" soc "\t" mileage spacing "\t" charging_time "\t" soh "\t" driver "\t" flag
}