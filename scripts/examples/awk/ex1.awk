#!usr/bin/gawk -f
BEGIN {
}
/Mozilla/ {
    ipcount[$1]++
}
/CrystalOnto.owl/ {
    ipcount[$1]++
}
END {
    for (j in ipcount) {
        print j " " ipcount[j]
    }
    for (j in ipcount) {
        print j " " ipcount[j]
    }
}