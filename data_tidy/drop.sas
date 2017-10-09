/* Sample SAS Program "deltemp.sas" */

/* excerpt from a SAS program -- this is an example of how to delete a 
temporary sas dataset during the course of your program.  The temporary 
datasets "temp1" and "temp2" were created earlier in the program */

* create a new merged dataset from temp1 and temp2;

data merged;
   merge temp1 temp2;
    by fips;
	rwid = input(fips,5.0);
run;


* delete the temporary datasets "temp1" and "temp2";
proc datasets library=work;
     delete temp1 temp2;
run;

/* create another data set in which variables from "merged" are renamed
  RENAME OLDNAME1=NEWNAME1 OLDNAME2=NEWNAME2 ... ;  */

data renamed;
   set merged;
	rename 
                rwid=id
                d020002=tosa92
                d060002=acrs92
                f020002=xtosa92
                f060002=xacrs92;
drop _name_; /* To drop variable "_name_" from the output dataset */
run;

