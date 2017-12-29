* (a)
egen c=group(schoolid std)
eststo: quietly reg pre_totnorm bal male , cluster(c)
eststo: quietly reg post_totnorm bal male, cluster(c)
esttab
* (c)
tab bal, sum(pre_math)
gen pre_mathnorm=(pre_math- 17.94517)/12.422844
tab bal, sum(pre_mathnorm)
gen post_mathnorm1=(post_math-17.94517)/12.422844
tab bal, sum(post_mathnorm1)
tab bal, sum(pre_verb)
gen pre_verbnorm=(pre_verb-14.351878)/10.743209
tab bal, sum(pre_verbnorm)
gen post_verbnorm1=(post_verb-14.351878)/10.743209
tab bal, sum(post_verbnorm1)
* (d)
foreach grade in 3 4 {
  quietly sum pre_math if bal == 0 & std == `grade'
  gen pre_mathMean`grade' = r(mean)
  gen pre_mathSD`grade' = r(sd)
  gen pre_mathnorm`grade' = (std == `grade') * (pre_math - pre_mathMean`grade')/pre_mathSD`grade'
}
gen pre_mathnorm5 = pre_mathnorm3 + pre_mathnorm4
* the same for verb
foreach grade in 3 4 {
  quietly sum pre_verb if bal == 0 & std == `grade'
  gen pre_verbMean`grade' = r(mean)
  gen pre_verbSD`grade' = r(sd)
  gen pre_verbnorm`grade' = (std == `grade') * (pre_verb - pre_verbMean`grade')/pre_verbSD`grade'
}
gen pre_verbnorm5 = pre_verbnorm3 + pre_verbnorm4
* take difference as explained variables
gen mathdi=post_mathnorm-pre_mathnorm5
gen verbdi=post_verbnorm-pre_verbnorm5

reg mathdi pre_mathnorm5 bal
reg verbdi pre_verbnorm5 bal

*(e)
use "Y2.dta", clear
drop pre_verb pre_math
merge 1:1 studentid using "Y1.dta", keepusing(pre_verb pre_math) force 
keep if _merge==3
drop _merge
* we want to normalize tests in math and verb, using pre score of control group
tab bal, sum(pre_math)
gen pre_mathnorm=(pre_math-13.294913)/11.163353
tab bal, sum(pre_verb)
gen pre_verbnorm=(pre_verb-11.15454)/9.5126378
gen post_mathnorm2=(post_math-13.294913)/11.163353
gen post_verbnorm2=(post_verb-11.15454)/9.5126378
 
 * we want the difference below
gen verbdi=post_verbnorm2-pre_verbnorm 
gen mathdi=post_mathnorm2-pre_mathnorm

reg mathdi pre_mathnorm bal
reg verbdi pre_verbnorm bal

* (g)
use "D:\Econ21110\HW3\case1.dta", clear
sum
tab treated, sum(male)
tab treated, sum(numstud)
tab treated, sum(income)
tab treated, sum(pre_totnorm)
tab treated, sum(std)

* (h)
eststo: quietly reg Finalscore treated pre_totnorm
eststo: quietly reg Finalscore treated pre_totnorm income
esttab

* (i)
reg Finalscore treated pre_totnorm male std income
eststo quietly reg Finalscore treated pre_totnorm male std income
esttab

* (j)
gen tm=treated*male
reg Finalscore treated tm pre_totnorm
gen ts=treated*std
reg Finalscore treated std pre_totnorm

gen ti= treated*income
gen tp=treated*pre_totnorm
reg Finalscore treated tp tm ti ts pre_totnorm, robust

*  (k)
gen i=Finalscore-Y0
tab treated, sum (i)
* we want to see the kdensity of t, which is the difference between Y1 and Y0
gen t=Y1-Y0
kdensity t
* we want to see subgroup distributions 
kdensity t if male==1, addplot( kdensity t if male==0)  legend(ring(0) pos(2) label(1 "male") label(2 "f
> emale") )
kdensity t if std==4, addplot( kdensity t if std==3)  legend(ring(0) pos(2) label(1 "grade4") label(2 "g
> rade3") )
twoway histogram t, color(*.5) || kdensity t ||, by(std)

* (l)
tab treated, sum(std)
tab treated, sum(male)
tab treated, sum(numstud)
tab treated, sum(pre_totnorm)
tab treated, sum(income)

* (m)
reg di treated pre_totnorm
reg di treated pre_totnorm male std numstud income
reg di treated

* (o)
gen ts=treated*std
gen tm=treated*male
gen tn=treated*numstud
gen ti=treated*income
gen tp=treated*pre_totnorm
reg di treated ts tm tn ti tp 

* (p)
 gen dif=Y1-Y0
tab treated, sum(dif)

kdensity dif if std==3, addplot( kdensity dif if std==4)  legend(ring(0) pos(2) label(1 "grade3") label(
> 2 "grade4") )

. kdensity dif if male==1, addplot( kdensity dif if male==0)  legend(ring(0) pos(2) label(1 "male") label(
> 2 "female") )
* in another form to display:
twoway histogram dif, color(*.5) || kdensity dif ||, by(std)

* (q)
twoway histogram dif, color(*.5) || kdensity dif ||, by(side)
kdensity dif if side==0 , addplot(kdensity dif if side==1) legend (ring(0) pos(2) label(1 "side=0") labe
> l(2 "side=1"))

* (r)
eststo clear

eststo: quietly reg di treated pre_totnorm
eststo: quietly reg di treated pre_totnorm side

esttab

*¡¡(s)
tab TreatmentGroup, sum(std)
tab TreatmentGroup, sum(male)
tab TreatmentGroup, sum(numstud)
tab TreatmentGroup, sum (income)
tab TreatmentGroup, sum (pre_totnorm)

* (u)
gen di=Finalscore-pre_totnorm
reg di TreatmentGroup pre_totnorm,robust

* (v)
reg di treated, robust

* (w)
ivregress 2sls di (treated=TreatmentGroup)

* (x)
gen tr=Y1-Y0
tab treated, sum(tr)
 kdensity tr if treated==0, addplot (kdensity tr if treated==1) legend(ring(0) pos(2) label(1 "control") 
> label(2 "treatment"))

* (y)
kdensity tr if TreatmentGroup==1 & treated==1, addplot (kdensity tr if TreatmentGroup==1& treated==0) legend(ring(0) pos(2) label(1 "remain in") label(2 "drop out"))









 
 
 
 
 
 
 
 