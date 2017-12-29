* (h) rectify age variable 
replace AGEQ=1980-AGEQ if CENSUS==80
gen AGESQ=AGEQ^2
gen QOBYOB=QOB*10000+YOB
gen REGION = 1*NEWENG + 2*MIDATL + 3*ENOCENT + 4*WNOCENT + 5*SOATL + 6*ESOCENT + 7*WSOCENT + 8*MT

* (i) fist do table 5
keep if YOB >= 1930 & YOB < 1940

* set QOB=4 as base group:
replace QOB=0 if QOB==4

* same logic, set YOB=1939 as base dummy
replace YOB=0 if YOB==1939

* in case of multicollinearity, we set some interaction dummies to be the base groups:
replace QOBYOB=0 if QOBYOB>=41930
replace QOBYOB=0 if QOBYOB==11939
replace QOBYOB=0 if QOBYOB==21939
replace QOBYOB=0 if QOBYOB==31939

* we set base groups as those have value 0
fvset base 0 QOB
fvset base 0 YOB
fvset base 0 QOBYOB


* we first do OLS regression in column (1)
 reg LWKLYWGE EDUC i.YOB,robust 

* 2SLS in column (2)
ivregress 2sls LWKLYWGE i.YOB (EDUC= i.QOB i.QOBYOB),robust 

* OLS in column (3)
reg LWKLYWGE EDUC i.YOB AGEQ AGESQ,robust 

* 2SLS in column (4)
ivregress 2sls LWKLYWGE i.YOB AGEQ AGESQ (EDUC= i.QOB i.QOBYOB),robust noheader 

* OLS in column (5)
reg LWKLYWGE EDUC RACE SMSA MARRIED i.YOB i.REGION, robust noheader 

* 2SLS in column (6)
ivregress 2sls LWKLYWGE RACE SMSA MARRIED i.YOB i.REGION (EDUC= i.QOB i.QOBYOB),robust noheader 

* OLS in column (7)
reg LWKLYWGE EDUC RACE SMSA MARRIED i.YOB i.REGION AGEQ AGESQ, robust noheader 

* 2SLS in column (8)
ivregress 2sls LWKLYWGE RACE SMSA MARRIED i.YOB i.REGION AGEQ AGESQ (EDUC= i.QOB i.QOBYOB),robust noheader


* in outreg2 framework
ssc install outreg2,replace
* (1)
reg LWKLYWGE EDUC i.YOB,robust
outreg2 using Table5.doc,replace keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) title("TABLE V", "OLS and TSLS Estimates of the Return to Education for Men Born 1930-1939: 1980 census") ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) addnote("Notes: standard errors are in parentheses. Sample size is 329,509. Instruments are full sets of QOB and YOB interactions.Sample consists of men born in U.S.Data from 5% census in 1980. Dependent variable is log weekly wages. AGEQ and AGESQ are measured in quarters of years.")   
* (2)
ivregress 2sls LWKLYWGE i.YOB (EDUC= i.QOB i.QOBYOB),robust
outreg2 using Table5.doc,append keep(EDUC) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) 
* (3)
reg LWKLYWGE EDUC i.YOB AGEQ AGESQ,robust 
outreg2 using Table5.doc,append keep(EDUC AGEQ AGESQ) ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) 
* (4)
ivregress 2sls LWKLYWGE i.YOB AGEQ AGESQ (EDUC= i.QOB i.QOBYOB),robust noheader 
outreg2 using Table5.doc,append keep(EDUC AGEQ AGESQ) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) 
* (5)
reg LWKLYWGE EDUC RACE SMSA MARRIED i.YOB i.REGION, robust 
outreg2 using Table5.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 

* (6)
ivregress 2sls LWKLYWGE RACE SMSA MARRIED i.YOB i.REGION (EDUC= i.QOB i.QOBYOB),robust 
outreg2 using Table5.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 
* (7)
reg LWKLYWGE EDUC RACE SMSA MARRIED i.YOB i.REGION AGEQ AGESQ, robust 
outreg2 using Table5.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 
* (8)
ivregress 2sls LWKLYWGE RACE SMSA MARRIED i.YOB i.REGION AGEQ AGESQ (EDUC= i.QOB i.QOBYOB),robust noheader
outreg2 using Table5.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 


* for test joint significance
reg EDUC i.QOB i.QOBYOB i.YOB
testparm i.QOB i.QOBYOB 

* generate table 6
keep if CENSUS==80
replace AGEQ=1980-AGEQ
gen AGESQ=AGEQ^2
gen QOBYOB=QOB*10000+YOB
gen REGION = 1*NEWENG + 2*MIDATL + 3*ENOCENT + 4*WNOCENT + 5*SOATL + 6*ESOCENT + 7*WSOCENT + 8*MT
keep if YOB>=1940 & YOB<1950
* (1)
reg LWKLYWGE EDUC i.YOB,robust
outreg2 using Table6.doc,replace keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) title("TABLE VI", "OLS and TSLS Estimates of the Return to Education for Men Born 1940-1949: 1980 census") ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) addnote("Notes: standard errors are in parentheses. Sample size is 486,926. Instruments are full sets of QOB and YOB interactions.Sample consists of men born in U.S.Data from 5% census in 1980. Dependent variable is log weekly wages. AGEQ and AGESQ are measured in quarters of years.")   
* (2)
ivregress 2sls LWKLYWGE i.YOB (EDUC=i.QOB##i.YOB),robust
outreg2 using Table6.doc,append keep(EDUC) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) 
* (3)
reg LWKLYWGE EDUC i.YOB AGEQ AGESQ,robust 
outreg2 using Table6.doc,append keep(EDUC AGEQ AGESQ) ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) 
* (4)
ivregress 2sls LWKLYWGE i.YOB AGEQ AGESQ (EDUC=i.QOB##i.YOB),robust noheader 
outreg2 using Table6.doc,append keep(EDUC AGEQ AGESQ) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) 
* (5)
reg LWKLYWGE EDUC RACE SMSA MARRIED i.YOB i.REGION, robust 
outreg2 using Table6.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 

* (6)
ivregress 2sls LWKLYWGE RACE SMSA MARRIED i.YOB i.REGION (EDUC=i.QOB##i.YOB),robust 
outreg2 using Table6.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 
* (7)
reg LWKLYWGE EDUC RACE SMSA MARRIED i.YOB i.REGION AGEQ AGESQ, robust 
outreg2 using Table6.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 
* (8)
ivregress 2sls LWKLYWGE RACE SMSA MARRIED i.YOB i.REGION AGEQ AGESQ (EDUC=i.QOB##i.YOB),robust 
outreg2 using Table6.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 


* generate table 4
keep if CENSUS==70

gen AGESQ=AGEQ^2
gen REGION = 1*NEWENG + 2*MIDATL + 3*ENOCENT + 4*WNOCENT + 5*SOATL + 6*ESOCENT + 7*WSOCENT + 8*MT

* (1)
reg LWKLYWGE EDUC i.YOB,robust
outreg2 using Table4.doc,replace keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) title("TABLE IV", "OLS and TSLS Estimates of the Return to Education for Men Born 1920-1929: 1970 census") ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) addnote("Notes: standard errors are in parentheses. Sample size is 247,199. Instruments are full sets of QOB and YOB interactions.Sample consists of men born in U.S.Data from 5% census in 1980. Dependent variable is log weekly wages. AGEQ and AGESQ are measured in quarters of years.")   
* (2)
ivregress 2sls LWKLYWGE i.YOB (EDUC=i.QOB##i.YOB),robust
outreg2 using Table4.doc,append keep(EDUC) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) 
* (3)
reg LWKLYWGE EDUC i.YOB AGEQ AGESQ,robust 
outreg2 using Table4.doc,append keep(EDUC AGEQ AGESQ) ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) 
* (4)
ivregress 2sls LWKLYWGE i.YOB AGEQ AGESQ (EDUC=i.QOB##i.YOB),robust noheader 
outreg2 using Table4.doc,append keep(EDUC AGEQ AGESQ) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) 
* (5)
reg LWKLYWGE EDUC RACE SMSA MARRIED i.YOB i.REGION, robust 
outreg2 using Table4.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 

* (6)
ivregress 2sls LWKLYWGE RACE SMSA MARRIED i.YOB i.REGION (EDUC=i.QOB##i.YOB),robust 
outreg2 using Table4.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 
* (7)
reg LWKLYWGE EDUC RACE SMSA MARRIED i.YOB i.REGION AGEQ AGESQ, robust 
outreg2 using Table4.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(OLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 
* (8)
ivregress 2sls LWKLYWGE RACE SMSA MARRIED i.YOB i.REGION AGEQ AGESQ (EDUC=i.QOB##i.YOB),robust 
outreg2 using Table4.doc,append keep(EDUC RACE SMSA MARRIED AGEQ AGESQ) ctitle(TSLS) noaster nocons addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, YES) 

* test significance
ivregress 2sls LWKLYWGE i.YOB (EDUC=i.YOB##i.QOB),robust first

* test significance for table 6
keep if CENSUS==80
replace AGEQ=1980-AGEQ
gen AGESQ=AGEQ^2
gen QOBYOB=QOB*10000+YOB
gen REGION = 1*NEWENG + 2*MIDATL + 3*ENOCENT + 4*WNOCENT + 5*SOATL + 6*ESOCENT + 7*WSOCENT + 8*MT
keep if YOB>=1940 & YOB<1950
ivregress 2sls LWKLYWGE i.YOB (EDUC=i.YOB##i.QOB),robust first
replace QOB=0 if QOB==4

* same logic, set YOB=1949 as base dummy
replace YOB=0 if YOB==1949

* in case of multicollinearity, we set some interaction dummies to be the base groups:
replace QOBYOB=0 if QOBYOB>=41940
replace QOBYOB=0 if QOBYOB==11949
replace QOBYOB=0 if QOBYOB==21949
replace QOBYOB=0 if QOBYOB==31949

* we set base groups as those have value 0
fvset base 0 QOB
fvset base 0 YOB
fvset base 0 QOBYOB

reg EDUC i.YOB i.QOB i.QOBYOB
testparm i.QOB i.QOBYOB







