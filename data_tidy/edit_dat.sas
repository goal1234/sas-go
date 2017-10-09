* Sample SAS Program  "edit_dat.sas" ;


/* Reading a SAS data set */
/* Creating new modified data sets.   */
   /* Creating new variables  */
   /* Modifying existing variables */
   /* Using the length statement for character variables */
   /* Deleting observations */


libname sas2 'U:\';
options ls=80;


/* Creating a new variable */
/* adding the same information to all observations */

data newair;
   set sas2.travel;
   newacost=aircost+10;
run;

proc print data=newair;
   var country aircost newacost;
   title 'Increasing the Air Fare by $10 in All Observations';
run;


/* Creating a new variable */
/* adding information to some observations but not others */

data bonus;
   set sas2.travel;
   if vendor='Hispania' then bonuspts='For 10+ people';
   else if vendor='Mundial' then bonuspts='Yes';
run;
proc print data=bonus;
   var country vendor bonuspts;
   title 'The SAS System Creates a Variable for All Observations';
run;


/* Add a new variable */
/* Modifying existing variable */

data newair2;
   set sas2.travel;
   newacost=aircost+10;
   aircost=aircost+10;
run;
proc print data=newair2 ;
   var country aircost newacost;
   title "Adding a new var and changing the info in a var";
run;


/* using variables efficiently */

data newinfo;
   set sas2.travel;
   if vendor='Hispania' then remarks='Bonus for 10+ people';
   else if vendor='Mundial' then remarks='Bonus points';
   else if vendor='Major' then remarks='Discount: 30+ people';
run;
proc print data=newinfo;
   var country vendor remarks;
   title 'Using Variables Efficiently';
run;


/* using the length statement for character variables */
/* note: character variables are case sensitive */

data newstmt;
   set sas2.travel;
   length remarks $ 30; /* NOTE TRUNCATION IF THIS IS OMITTED */
   if vendor='Hispania' then remarks='Bonus for 10+ people';
   else if vendor='Mundial' then remarks='Bonus points';
   else if vendor='Major' then remarks='Discount for 30+ people';
run;
proc print data=newstmt;
   var country vendor remarks;
   title 'Using a LENGTH Statement';
run;


/* deleting observations */

data subset;
   set sas2.travel;
   if country='Peru' then delete;
run;
proc print data=subset;
   title 'Omitting a Discontinued Tour';
run;
