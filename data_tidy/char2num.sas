/* Sample SAS Program "char2num.sas" */

/* This is an example of how to change a character
variable, AGE, to numeric.

This program reliably changes character variables
to numeric variables. The INPUT function takes two
arguments: the name of a character variable and the
numeric format that will be assigned to the new variable */

data temp;
 input id $1  age $ 3-4 ;
 cards;
A 22 
B 33 
C   
D 45
E 32 
F 41
;
run;
proc contents;
run;

data new; set temp;
newage = input(age,3.0);
drop age;
rename newage=age;
run;
proc contents;
run;
