Default action is to print the line being processed.
The following command is same as cat sample.txt
sed -e "" sample.txt 

To suppress default action of printing
sed -n -e "" sample.txt 

To print line numbers:
sed -e '=' sample.txt

Print a particular line only:
sed -n -e '5p' sample.txt

Print all lines except a particular line:
sed -n -e '5!p' sample.txt

Print all lines except the last one:
sed -n -e '$!p' sample.txt

To print a particular set of lines:
sed -n -e "5,8p" sample.txt

To print all line numbers and a set of lines:
sed -n -e '=; 5,8p' sample.txt

Print every second line from the first one:
sed -n -e '1~2p' sample.txt

To print lines containing a pattern:
sed -n -e '/microsoft/p' sample.txt

Print only those lines that contain the pattern:
sed -n -e "/in place of/p" sample.txt

To print lines that do not contain a pattern:
sed -n -e '/microsoft/!p' sample.txt

From the line that matches a patter, print 2 lines further:
sed -n -e '/adobe/,+2p' sample.txt

------------ deleting lines --------------

Delete a range of lines:
sed -e '1d' sample.txt
sed -e '$d' sample.txt

Delete a range of lines:
sed -e '3,5d' sample.txt

Delete the lines containing a pattern and print the rest:
sed -e "/microsoft/d" sample.txt

--------- substitution ------------------

Act on a specific line:
sed -e "1s/linux/LinuX/g" sample.txt

To substitute a string and print:
sed -e 's/in place of.*//g' sample.txt
sed -e 's/in place of/in lieu of/g' sample.txt

Instruct sed to use ERE using -E option:
Remove the line indicator at the beginning
sed -E -e 's/^L[[:digit:]]+ //g' sample.txt

Do the above processing only for specific lines:
sed -E -e '3,6s/^L[[:digit:]]+ //g' sample.txt

GNU extended feature, second part of address range can be a pattern:
sed -E -e '3,/symbolic/s/^L[[:digit:]]+ //g' sample.txt

Address range can be both patterns:
sed -E -e '/text/,/video/s/^L[[:digit:]]+ //g' sample.txt

Using stepping in address, to transform only every third line
sed -E -e '1~3s/^L[[:digit:]]+ //g' sample.txt

Or the reverse of that address:
sed -E -e '1~3!s/^L[[:digit:]]+ //g' sample.txt

-------- insert / appending ----------------

Insert a header before and append a footer after the records:
sed -e '1i ---- header -----' -e '$a --- footer -------' sample.txt

Insert above or append below a line at every fifth record:
sed -e '1~5i ----- Five line break ------' sample.txt
sed -e '1~5a ----- Five line break ------' sample.txt

Insert / Append a line for every occurance of a pattern:
sed -e '/microsoft/i ----- break ------' sample.txt
sed -e '/microsoft/a ----- break ------' sample.txt

-------- change text -----------------------

Change every 5th line from the 2nd one to something else:
sed -e '2~5c ---- censored -----' sample.txt

Change every line that matches a pattern to something else:
sed -e '/microsoft/c ---- censored -----' sample.txt 

------- script files --------------

multiple sed commands can be placed in a script file and executed
sed -f hf.sed sample.txt

We can use this concept to pre-process garbled input to awk:
Refer to the block-ex-6.input as shown in the awk session
sed -E -f clean.sed block-ex-6.input

-------- joining text ------------

Join lines broked by backslash at the end of the line:
sed -e ':x /\\$/ {N; s/\\\n//g; bx}' sample-split.txt

This can be seen as a script with branching condition:
sed -e join.sed sample-split.txt

---------------------------------------
