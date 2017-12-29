# (i) 

install.packages("rdrobust")
library(rdrobust)

# import dataset Damonclark, creat dps

dps<-Damonclark$passrate2-Damonclark$passrate0
x<-Damonclark$vote
rdplot(dps,x,c=50)
rdrobust(dps,x,c=50)
rdrobust(dps,x,c=50,h=10)
rdrobust(dps,x,c=50,h=5)
rdrobust(dps,x,c=50,h=1)
rdrobust(dps,x,c=50,h=7)

# (j)

rdplot(dps,x,c=50,h=10)
help(rdplot)
# BW by default is the full range of support of running variable
rdplot(dps,x,c=50)
rdplot(dps,x,c=50,p=1,h=5)
# p=4 by default
rdplot(dps,x,c=50,h=5)

