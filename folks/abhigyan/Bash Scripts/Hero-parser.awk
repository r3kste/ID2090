#/usr/bin/gawk -f
BEGIN{
	print "MCU Stats";
	heros=0;
	villains=0;
	complicated=0;
	antiheros=0;
	FS=",";
}
# Counting the heros, Antiheros, Villains and People with complicated loyalties in the given csv file
{
	name=$1;
	aka=$2;
	type=$3;
	if(type ~ /^Hero/) heros++;
	if(type ~ /^Antihero/) antiheros++;
	if(type ~ /^Villain/) villains++;
	if(type ~ /^Complicated/) complicated++;
	types[name]=type;
	akas[name]=aka;
}
# Writing one line about each character.
END{
	print ("Number of heroes are: ",heros);
	print ("Number of villains are", villains);
	print ("Number of antiheroes are", antiheros);
	print ("Number of complicated characters are", complicated);
	for(name in types){
		print(name, ", also known as ", akas[name], " is a ", types[name]);}
	print "end";
}
