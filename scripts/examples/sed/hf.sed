#!/usr/bin/sed -f
1i ---- header ------
$a ----- footer -----
1,5s/in place of/in lieu of/g
6i ----- simpler stuff here onward -----
6,$s/in place of.*//g
