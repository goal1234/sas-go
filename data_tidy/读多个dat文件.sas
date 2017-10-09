/* Sample SAS Program "multfile.sas" */

/* An example of how to read multiple text files in a single 
 data step to create a SAS data set. 
Note: All the input text files must have the same data layout. 
For example, some of the census data sets have a separate raw 
data file for each state and one wants to create a combined SAS 
data set for US. 
*/

filename myfiles ("c:\mydir\one.dat", "c:\mydir\two.dat");
data temp1;
infile myfiles lrecl=331;
input var1 10-15 var2 22-30 var3 98-100;
run; 

/* With SAS 8.2 you can also use wildcards like this.
filename myfles ("c:\mydir\*.csv");
        or
filename myfiles ("c:\mydir\test*.csv");
         or
filename myfiles ("c:\mydir\*.*");
*/
