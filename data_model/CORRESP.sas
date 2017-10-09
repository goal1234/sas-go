

/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CRSPGS                                              */
/*   TITLE: Getting Started Example for PROC CORRESP            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: marketing research, categorical data analysis       */
/*   PROCS: CORRESP                                             */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2010         */
/*     REF: PROC CORRESP, GETTING STARTED EXAMPLE               */
/*    MISC:                                                     */
/****************************************************************/

title "Number of Ph.D.'s Awarded from 1973 to 1978";

data PhD;
   input Science $ 1-19 y1973-y1978;
   label y1973 = '1973'
         y1974 = '1974'
         y1975 = '1975'
         y1976 = '1976'
         y1977 = '1977'
         y1978 = '1978';
   datalines;
Life Sciences       4489 4303 4402 4350 4266 4361
Physical Sciences   4101 3800 3749 3572 3410 3234
Social Sciences     3354 3286 3344 3278 3137 3008
Behavioral Sciences 2444 2587 2749 2878 2960 3049
Engineering         3338 3144 2959 2791 2641 2432
Mathematics         1222 1196 1149 1003  959  959
;

ods graphics on;

proc corresp data=PhD out=Results short chi2p;
   var y1973-y1978;
   id Science;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CRSPEX1                                             */
/*   TITLE: Documentation Example 1 for PROC CORRESP            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: marketing research, categorical data analysis       */
/*   PROCS: CORRESP                                             */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2010         */
/*     REF: PROC CORRESP, EXAMPLE 1                             */
/*    MISC:                                                     */
/****************************************************************/

title1 'Automobile Owners and Auto Attributes';
title2 'Simple Correspondence Analysis';

proc format;
   value Origin  1 = 'American' 2 = 'Japanese' 3 = 'European';
   value Size    1 = 'Small'    2 = 'Medium'   3 = 'Large';
   value Type    1 = 'Family'   2 = 'Sporty'   3 = 'Work';
   value Home    1 = 'Own'      2 = 'Rent';
   value Sex     1 = 'Male'     2 = 'Female';
   value Income  1 = '1 Income' 2 = '2 Incomes';
   value Marital 1 = 'Single with Kids' 2 = 'Married with Kids'
                 3 = 'Single'           4 = 'Married';
run;

data Cars;
   missing a;
   input (Origin Size Type Home Income Marital Kids Sex) (1.) @@;
   * Check for End of Line;
   if n(of Origin -- Sex) eq 0 then do; input; return; end;
   marital = 2 * (kids le 0) + marital;
   format Origin Origin. Size Size. Type Type. Home Home.
          Sex Sex. Income Income. Marital Marital.;
   output;
   datalines;
131112212121110121112201131211011211221122112121131122123211222212212201
121122023121221232211101122122022121110122112102131112211121110112311101
211112113211223121122202221122111311123131211102321122223221220221221101
122122022121220211212201221122021122110132112202213112111331226122221101
1212110231AA220232112212113112112121220212212202112111022222110212121221
211211012211222212211101313112113121220121112212121112212211222221112211
221111011112220122212201131211013121220113112222131112012131110221112211
121112212211121121112201321122311311221113112212213211013121220221221101
133211011212220233311102213111023211122121312222212212111111222121112211
133112011212112212112212212222022131222222121101111122022211220113112212
211112012232220121221102213211011131220121212201211122112331220233312202
222122012111220212112201221122112212220222212211311122012111110112212212
112222011131112221212202322211021222110121221101333211012232110132212101
223222013111220112211101211211022112110212211102221122021111220112111211
111122022121110113311122322111122221210222211101212122021211221232112202
1331110113112211213222012131221211112212221122021331220212121112121.2212
121122.22121210233112212222121011311122121211102211122112121110121212101
311212022231221112112211211211312221221213112212221122022222110131212202
213122211311221212112222113122221221220213111221121211221211221221221102
131122211211220221222101223112012111221212111102223122111311222121111102
2121110121112202133122222311122121312212112.2101312122012111122112112202
111212023121110111112221212111012211220221321101221211122121220112111112
212211022111110122221101121112112122110122122232221122212211221212112202
213122112211110212121201113211012221110232111102212211012112220121212202
221112011211220121221101211211022211221112121101111112212121221111221201
211122122122111212112221111122312132110113121101121122222111220222121102
221211012122110221221102312111012122220121121101121122221111222212221102
212122021222120113112202121122212121110113111101123112212111220113111101
221112211321210131212211121211011222110122112222123122023121223112212202
311211012131110131221102112211021131220213122201222111022121221221312202
131.22523221110122212221131112412211220221121112131222022122220122122201
212111011311220221312202221122123221210121222202223122121211221221111112
211111121211221221212201113122122131220222112222211122011311110112312211
211222013221220121211211312122122221220122112201111222011211110122311112
312111021231220122121101211112112.22110222112212121122122211110121112101
121211013211222121112222321112112112110121321101113111012221220121312201
213211012212220221211101321122121111220221121101122211021122110213112212
212122011211122131221101121211022212220212121101
;

ods graphics on;

* Perform Simple Correspondence Analysis;
proc corresp data=Cars all chi2p;
   tables Marital, Origin;
run;

title2 'Multiple Correspondence Analysis';

* Perform Multiple Correspondence Analysis;
proc corresp mca observed data=Cars;
   tables Origin Size Type Income Home Marital Sex;
run;

title2 'Binary Table';

* Perform Multiple Correspondence Analysis;
proc corresp data=Cars binary;
   ods select RowCoors;
   tables Origin Size Type Income Home Marital Sex;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CRSPEX2                                             */
/*   TITLE: Documentation Example 2 for PROC CORRESP            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: marketing research, categorical data analysis       */
/*   PROCS: CORRESP                                             */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2010         */
/*     REF: PROC CORRESP, EXAMPLE 2                             */
/*    MISC:                                                     */
/****************************************************************/

title 'United States Population, 1920-1970';

data USPop;

   * Regions:
   * New England     - ME, NH, VT, MA, RI, CT.
   * Great Lakes     - OH, IN, IL, MI, WI.
   * South Atlantic  - DE, MD, DC, VA, WV, NC, SC, GA, FL.
   * Mountain        - MT, ID, WY, CO, NM, AZ, UT, NV.
   * Pacific         - WA, OR, CA.
   *
   * Note: Multiply data values by 1000 to get populations.;

   input Region $14. y1920 y1930 y1940 y1950 y1960 y1970;

   label y1920 = '1920'    y1930 = '1930'    y1940 = '1940'
         y1950 = '1950'    y1960 = '1960'    y1970 = '1970';

   if region = 'Hawaii' or region = 'Alaska'
      then w = -1000;       /* Flag Supplementary Observations */
      else w =  1000;

   datalines;
New England        7401  8166  8437  9314 10509 11842
NY, NJ, PA        22261 26261 27539 30146 34168 37199
Great Lakes       21476 25297 26626 30399 36225 40252
Midwest           12544 13297 13517 14061 15394 16319
South Atlantic    13990 15794 17823 21182 25972 30671
KY, TN, AL, MS     8893  9887 10778 11447 12050 12803
AR, LA, OK, TX    10242 12177 13065 14538 16951 19321
Mountain           3336  3702  4150  5075  6855  8282
Pacific            5567  8195  9733 14486 20339 25454
Alaska               55    59    73   129   226   300
Hawaii              256   368   423   500   633   769
;

ods graphics on;

* Perform Simple Correspondence Analysis;
proc corresp data=uspop print=percent observed cellchi2 rp cp chi2p
     short plot(flip);
   var y1920 -- y1970;
   id Region;
   weight w;
run;

