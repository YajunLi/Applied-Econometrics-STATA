* (a) as there is only one data point whose vote=50, we may not account for this case,
gen win=1*(vote>50)+0*(vote<50)
gen lose=1*(vote<50)+0*(vote>50)

gen margin=vote-50
gen margin2=margin^2
label variable margin2 "margin squared"

gen winmar=win*margin
gen winmar2=win*margin2
gen losemar=lose*margin
gen losemar2=lose*margin2

* (b)
gen dps=passrate2-passrate0

keep dps passrate0 passrate2
egen votebin=cut(vote),at(16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80)
collapse(mean) passave0=passrate0 passave2=passrate2 avedps=dps, by(votebin)

* genearate graph
twoway scatter passave0 votebin,title("Figure 8: Two Years after Base Year")xline(50)|| scatter passave2 votebin || scatter avedps votebin 

* (d) we should clear and import the data again
keep if vote>=15 & vote<=85
eststo: reg dps win,robust noheader notable
eststo: reg dps win margin,robust noheader notable
eststo: reg dps win winmar losemar,robust noheader notable
eststo: reg dps win winmar losemar winmar2 losemar2,robust noheader notable
esttab

* (e) generate variables as before, but cut off vote=30
gen w=1*(vote>=30)+0*(vote<30)
gen l=1*(vote<=30)+0*(vote>30)
gen margin=vote-30
gen margin2=margin^2
gen wm=w*margin
gen wm2=w*margin2
gen lm=l*margin
gen lm2=l*margin2
gen dps=passrate2-passrate0
* run the regression, produce the table
keep if vote>=15 & vote<=85
eststo: reg dps w,robust noheader notable
eststo: reg dps w margin,robust noheader notable
eststo: reg dps w wm lm,robust noheader notable
eststo: reg dps w wm lm wm2 lm2,robust noheader notable
esttab

* we examine from [40,60], namely, to decrease sample interval.
eststo clear
keep if vote>=40 & vote<=60
eststo: reg dps win,robust noheader notable
eststo: reg dps win margin,robust noheader notable
eststo: reg dps win winmar losemar,robust noheader notable
eststo: reg dps win winmar losemar winmar2 losemar2,robust noheader notable
esttab

* (f) we should re upload the data again
gen win=1*(vote>50)+0*(vote<50)
gen lose=1*(vote<50)+0*(vote>50)

gen margin=vote-50
gen margin2=margin^2
label variable margin2 "margin squared"

gen winmar=win*margin
gen winmar2=win*margin2
gen losemar=lose*margin
gen losemar2=lose*margin2
gen dps=passrate2-passrate0

keep if vote>=15 & vote<=85
reg passrate0 win,robust

* (g)
reg passrate0 win,robust
reg passrate0 win vote,robust
twoway scatter passrate0 vote || lfit passrate0 vote

twoway scatter passrate0 vote || lfit passrate0 vote if win==1|| lfit passrate0 vote if win==0

twoway (kdensity passrate0 if win == 1) (kdensity passrate0 if win == 0), legend(order(1 "win" 2 "lose")) title("15 < vote < 85"
> )

* (i) I try it in R instead of STATA, I attach script file in r in another document
rdrobust dps vote, c(50)














