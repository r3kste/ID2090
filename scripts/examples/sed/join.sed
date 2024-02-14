#!/usr/bin/sed -f
:x /\\$/N
/\\/s/\\\n//g
/\\$/bx
