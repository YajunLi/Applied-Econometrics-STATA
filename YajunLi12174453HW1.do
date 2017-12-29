*problem 1 (a):
cd D:\
log using "Yajun Li12174453.log",replace
use"https://github.com/wooyong/econ-21110-TA/blob/master/AssignmentData/CARD.DTA?raw=true"
desc
egen KWWmean=mean(KWW)
egen sdKWW=sd(KWW)
gen KWWstandard=(KWW-KWWmean)/sdKWW
sum KWWstandard
hist KWWstandard
*standardize KWW because it originally does not have cardinal meanning
graph export "histogram.png", replace
reg lwage educ KWWstandard
egen educmean=mean(educ)
gen educadj=educ-educmean
reg lwage educadj KWWstandard
gen HS=(12<=educ)*(educ<16)
*high school graduates in this group
gen college=(16<=educ)
reg lwage HS college KWWstandard
*problem 1 (b):
test HS=college
*problem 1 (d):
reg lwage educ KWWstandard exper expersq
reg lwage HS college KWWstandard exper expersq
gen marriedadj=0
replace marriedadj=1 if married==1
tab marriedadj
* change married to a standard dummy variable
tab marriedadj, sum(educ)
reg lwage educ KWWstandard exper expersq marriedadj fatheduc black smsa
reg lwage HS college KWWstandard exper expersq marriedadj fatheduc black smsa
scatter lwage educ || lfit lwage educ
graph export "wageeduc.png",replace
reg lwage educ KWWstandard exper expersq marriedadj black smsa if HS==1
reg lwage educ KWWstandard exper expersq marriedadj black smsa if college==1
gen educgroup=1*(educ<12)+2*(12<=educ)*(educ<16)+3*(16<=educ)
tab educgroup, sum(lwage)
reg lwage educ KWWstandard if age==24
reg lwage educ KWWstandard if age==28
reg lwage educ KWWstandard if age==32
scatter lwage educ || lfit lwage educ if age==24  ||lfit lwage educ if age==28 || lfit lwage educ if age==32||, legend(label(1 "educ") label(2 "age=24") label(3 "age=28") label(4 "age=32"))
graph export "educbyage.png",replace
*compare different age groups
*problme 1 (e):
reg lwage HS college KWWstandard if age ==24
reg lwage HS college KWWstandard if age ==28
reg lwage HS college KWWstandard if age ==32
*problem 1 (f):
reg lwage educ KWWstandard if exper==4
reg lwage educ KWWstandard if exper==8
reg lwage educ KWWstandard if exper==12
reg lwage HS college KWWstandard if exper==4
reg lwage HS college KWWstandard if exper==8
reg lwage HS college KWWstandard if exper==12
*problem 1 (g):
reg lwage educ KWWstandard exper expersq
reg lwage HS college KWWstandard exper expersq
*problem 1 (h):
gen expergroup=1*(2<=exper)*(exper<=6)+2*(6<exper)*(exper<9)+3*(9<=exper)*(exper<12) +4*(12<=exper)
scatter lwage educ || lfit lwage educ if expergroup==1  ||lfit lwage educ if expergroup==2 || lfit lwage educ if expergroup==3 ||lfit lwage educ if expergroup==4||, legend(label(1 educ) label(2 group1) label(3 group2) label(4 group3) label(5 group4))
graph export "groupsofeduc.png",replace
*graph return of educ among diff groups
gen g1=(2<=exper)*(exper<=6),
gen g1mix=g1*educ
reg lwage educ KWWstandard g1 g1mix
test g1 g1mix
reg lwage educ KWWstandard exper expersq
test exper expersq
*problem 1 (j):
reg lwage educ KWWstandard exper expersq black
*problem 1 (k)and (l):
gen eb=black*educ
* interaction terms 
reg lwage educ KWWstandard exper expersq black eb
scatter lwage educ || lfit lwage educ if black ==1 || lfit lwage educ if black ==0 ||, legend(label(1 educ) label(2 black) label(3 white))
graph export"black.png",replace
*problem 1 (m):
reg lwage educ KWWstandard exper expersq black eb south smsa
















