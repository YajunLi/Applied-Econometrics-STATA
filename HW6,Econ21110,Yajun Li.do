* HW6 Yajun Li 

* (a) without loss of generality, we only use data of Kentucky. Michigan follows the same logic and process. So I don't need to do it a second time. 
reg ldurat  afchnge  if ky==1 & highearn==1

* (b) for control group, namely, low earn people
reg ldurat afchnge if ky==1 & highearn==0
* drwa the graph
twoway  scatter ldurat afchnge if ky==1 || lfit ldurat afchnge if ky==1 & highearn==1|| lfit ldurat afchnge if ky==1 & highearn==0

* (c)
reg ldurat highearn if ky==1 & afchnge==1

* (d)
reg ldurat highearn if ky==1 & afchnge==0
twoway  scatter ldurat highearn if ky==1 || lfit ldurat highearn if ky==1 & afchnge==1|| lfit ldurat highearn if ky==1 & afchnge==0

* (e)
reg ldurat afchnge highearn afhigh if ky==1

* (g)
reg ldurat highearn afhigh if ky==1
reg ldurat afchnge afhigh if ky==1

* (h)
eststo: quietly reg ldurat afchnge highearn afhigh if ky==1
eststo: quietly reg ldurat afchnge highearn afhigh male married  indust##injtype if ky==1
esttab
reg ldurat afchnge highearn afhigh male married  indust##injtype if ky==1
reg ldurat afchnge highearn afhigh if ky==1

* compute for Michigan
eststo: quietly reg ldurat afchnge highearn afhigh if mi==1
eststo: quietly reg ldurat afchnge highearn afhigh male married  indust##injtype if mi==1
esttab


* Problem 2 (a)
reg lwage y85 educ y85educ exper expersq union female y85fem

* (ii)
gen educ2=educ-12
gen y85educ2=y85*educ2
reg lwage y85 educ y85educ2 exper expersq union female y85fem

* (iii) log(1.65)=0.5 
replace lwage=lwage-0.5 if y85==1
reg lwage y85 educ y85educ exper expersq union female y85fem


* (v)
tab y85, sum(union)

* (vi) including union interaction term with year dummy
gen unye=union*y85
reg lwage y85 educ y85educ exper expersq union unye female y85fem 
















