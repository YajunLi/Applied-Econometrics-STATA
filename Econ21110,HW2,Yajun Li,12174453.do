* (a)
reg price sqrft bdrms lotsize

* (d)

ssc install estout, replace
eststo: reg price sqrft bdrms lotsize, noheader notable
eststo: reg price sqrft bdrms lotsize colonial, noheader notable
esttab
reg price sqrft bdrms lotsize colonial, noheader notable
test colonial

* (e)(g)(f)this may not be important because we haven't drop lotsize anormaly yet.
* we simply add interactive terms here.\

gen sqco=sqrft*colonial
gen bdco=bdrms*colonial
gen loco=lotsize*colonial
eststo: reg price sqrft bdrms lotsize colonial sqco bdco loco, noheader notable
esttab

* (e)(g)(f)
reg price sqrft bdrms lotsize colonial sqco bdco loco, noheader notable
predict pricehat
scatter price lotsize || lfit price lotsize if colonial=1 || lfit price lotsize if colonial=0
* We drop anormaly of lotsize, and do the regression again. 

drop if lotsize >80000
eststo: reg price sqrft bdrms lotsize, noheader notable
eststo: reg price sqrft bdrms lotsize colonial, noheader notable
esttab
* (g) again we want to draw a scatter plot and fitted lines
reg price sqrft bdrms lotsize colonial, noheader notable
predict pricehat
scatter price lotsize if colonial==0 || lfit price lotsize if colonial==0
scatter price lotsize if colonial==1 || lfit price lotsize if colonial==1

scatter price bdrms if colonial==0 || lfit price bdrms if colonial==0
scatter price bdrms if colonial==1 || lfit price bdrms if colonial==1

scatter price sqrft if colonial==0 || lfit price sqrft if colonial==0
scatter price sqrft if colonial==1 || lfit price sqrft if colonial==1

*create dummies for number of bedrooms

gen bedroom5=(5<=bdrms)
gen bedroom3=(bdrms==3)
gen bedroom4=(bdrms==4)

eststo: reg price sqrft lotsize colonial loco bedroom3 bedroom4 bedroom5,noheader notable
esttab

gen bedroom6=(bdrms==5)

* (h) with only log price, 
 reg lprice sqrft bdrms lotsize
 predict resid, residual
scatter resid sqrft
scatter resid lotsize
* we run heteroskedasticity test
hettest

reg price sqrft bdrms lotsize
hettest

* or we can use another method, 
predict m, residual
gen m2=m^2
reg m2 sqrft bdrms lotsize


* we improve the model using log form of sqrft and lotsize both
reg lprice lsqrft bdrms llotsize
predict resid2, residual
scatter resid2 lsqrft
scatter resid2 llotsize

* (i)
eststo: reg price sqrft bdrms lotsize
eststo:  reg price sqrft bdrms lotsize, robust
esttab

* (j)
reg lprice sqrft bdrms lotsize
* (l)
eststo: reg lprice sqrft bdrms lotsize ,noheader notable
eststo: reg lprice bdrms lotsize, noheader notable
estout , cells((b se t p))
reg bdrms sqrft

* problem 2 (a)
reg colgpa female
* (b)
egen meanmale=mean(colgpa)  if female==0
egen meanfemale=mean(colgpa)  if female==1
tab meanmale
tab meanfemale
egen varmale=sd(colgpa) if female==0
tab varmale
egen varfemale=sd(colgpa) if female==1
tab varfemale
hettest

tab female, sum(colgpa)

* (c)
eststo clear
eststo: reg colgpa female
eststo: reg colgpa female sat
esttab

* (d)
predict l, residual
gen l2=l^2
reg l2 female sat
test female sat

* (e)
eststo: reg colgpa female sat , robust
esttab

* (f)
scatter colgpa sat
correlate colgpa sat

eststo clear
eststo: reg colgpa sat
gen sat2=sat^2
eststo: reg colgpa sat*
esttab

* (g)
eststo: reg colgpa sat female black
esttab























