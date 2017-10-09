* Sample SAS Program   "char_var.sas" ;

/* Working with character variables  */
/* Dealing with MIXED case character values */
/* Using the LENGTH statement when creating new character variables  */
/* Aligning values in character variables */
/* Handling missing values when creating new character variables */



libname sas2 'U:\';
options ls=80;

/* Working with character variables. 
Character variables are case sensitive.
Dealing with MIXED case character values  */

data showchar;
   set sas2.depart;
   schedule='3-4 tours per season';
   remarks="See last year's schedule";
   if usgate='San Francisco' then usairpt='SFO';
   else if usgate='Honolulu' then usairpt='HNL';

/*  if upcase(usgate)='SAN FRANCISCO' then usairpt='SFO';
    else if upcase(usgate)='HONOLULU' then usairpt='HNL'; */

run;

proc print data=showchar;
   var country schedule remarks usgate usairpt;
   title 'Examples of Some Character Variables';
run;

/* Using the legnth statement for character variables */

data aircode2;
   length usairpt $ 10; /* Note- truncation if this is omitted */
   set sas2.depart;
   if usgate='San Francisco' then usairpt='SFO';
   else if usgate='Honolulu' then usairpt='HNL';
   else if usgate='New York' then usairpt='JFK or EWR';
run;

proc print data=aircode2;
   var country usgate usairpt;
   title 'Using the Complete Character Value';
run;


/* Aligning values in character variables */

data aircode3;
   set sas2.depart;
   length usairpt $ 10;
   if usgate='San Francisco' then usairpt='SFO';
   else if usgate='Honolulu' then usairpt='HNL';
   else if usgate='New York' then usairpt='JFK or EWR';
   else if usgate='Miami' then usairpt='   MIA    ';
run;

proc print data=aircode3;
   var country usgate usairpt;
   title 'Alignment of Character Values';
run;


/* Handling missing values when creating new character variables */

data aircode4;
   set sas2.depart;
   length usairpt $ 10;
   if usgate='San Francisco' then usairpt='SFO';
   else if usgate='Honolulu' then usairpt='HNL';
   else if usgate='New York' then usairpt='JFK or EWR';
   else if usgate='Miami' then usairpt='MIA';
   else if usgate=' ' then usairpt=' ';
run;

proc print data=aircode4;
   var country usgate usairpt;
   title 'Assigning Missing Character Values';
run;
