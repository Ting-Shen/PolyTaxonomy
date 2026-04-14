
library(ggtree)
library(phytools)
library(geiger)

rm(list=ls())

setwd("~")

mt <- read.tree("rdri02.tre")
ggtree(mt)

write.csv(mt[["tip.label"]],"tip.labels.csv")

# seed column

md <- read.csv("rdri_seed-column.csv", row.names=1)
fmode<-as.factor(setNames(md[,1],rownames(md)))

dotTree(mt,fmode,colors=setNames(c("#E97F5B","#E8BD4A","black","black"), c("biseriate","uniseriate","biseriate*","uniseriate*")),
        type="phylogram",ftype="off",fsize=0.3)

# species

md <- read.csv("rdri_species.csv", row.names=1)
fmode<-as.factor(setNames(md[,1],rownames(md)))

dotTree(mt,fmode,colors=setNames(c("#E97F5B","#E8BD4A","#D85163"), c("ri","rd","rh")),
        type="phylogram",ftype="off",fsize=0.3)

# ploidy

md <- read.csv("rdri_ploidy.csv", row.names=1)
fmode<-as.factor(setNames(md[,1],rownames(md)))

dotTree(mt,fmode,colors=setNames(c("#E97F5B","#E8BD4A","#B1D486","black","black"), 
                                 c("hexaploidy","tetraploidy","Diploidy","hexaploidy*","tetraploidy*")), 
        type="phylogram",ftype="off",fsize=0.3)

# petal

x<-as.matrix(read.csv("rdri_petal.csv",row.names=1))[,1]

dotTree(mt,x,length=10,ftype="i")

# fruit

x<-as.matrix(read.csv("rdri_fruit.csv",row.names=1))[,1]

dotTree(mt,x,length=10,ftype="i")

# leaf

x<-as.matrix(read.csv("rdri_leaf.csv",row.names=1))[,1]

dotTree(mt,x,length=10,ftype="i")

# genome size

x<-as.matrix(read.csv("rdri_gs.csv",row.names=1))[,1]

dotTree(mt,x,length=10,ftype="i")

# branch number

x<-as.matrix(read.csv("rdri_bn.csv",row.names=1))[,1]

dotTree(mt,x,length=10,ftype="i")

# fruit number

x<-as.matrix(read.csv("rdri_fn0.csv",row.names=1))[,1]

dotTree(mt,x,length=10,ftype="i")

# plant height

x<-as.matrix(read.csv("rdri_ph.csv",row.names=1))[,1]

dotTree(mt,x,length=10,ftype="i")

# testing for an evolutionary correlation between binary traits using Pagel's method
# reference: http://www.phytools.org/Cordoba2017/ex/9/Pagel94-method.html
# remove variants, which means the non-binary value for observed traits
# A Pagel's value of zero indicates that the correlation in traits observed between species are independent of their shared evolutionary history, 
# whereas a value of one indicates the correlation in traits is fully determined by it (Meireles et al., 2020; Revell, 2010).
# whether Pagel's lambda is different from 1.0
# or how can we test the alternative hypothesis that Pagel's λ is less then 1.0; against the null that λ=1.0
# if significant P value, then we can distinguish our estimated phylogenetic signal from Brownian motion
# http://blog.phytools.org/2012/11/testing-for-pagels-10.html
# this analysis only performed for R. dubia and R. indica

# remove tips not belonging to R. dubia and R. indica

tips <- c("RO318_1","RO018_5","RO727_1","RO102_1","RO107_1","RO452_1","RO453_1","RO454_4","RO162_5","RO163_1","RO164_2","RO123_5","RO455_1","RO158_3","RO159_2","RO161_2","RO160_1","RO150_Rg","RO646_Rau","RO843_2","RO663_Rse","RO666_Rsi","RO324_Rc","NA6","AP009376","Aethionema_arabicum","Aethionema_cordifolium","Tarenaya_hassleriana"
)
mt1 <- drop.tip(mt, tip = tips)
mt1$mapped.edge<-matrix(mt1$edge.length,nrow(mt1$edge),1)
colnames(mt1$mapped.edge)<-"1"

X1 <- read.csv("rdri_binary_traits.csv",row.names=1,header=TRUE)
dim(X1)
head(X1)

# for petal number
resBM<-brownie.lite(mt1,X1$PN.mean)
resLambda1<-phylosig(mt1,X1$PN.mean,method="lambda")
LR1<-2*(resLambda1$logL-resBM$logL1)
P1<-pchisq(LR1,df=1,lower.tail=F)

# for fruits length
resBM<-brownie.lite(mt1,X1$Fruits.length.mean)
resLambda2<-phylosig(mt1,X1$Fruits.length.mean,method="lambda")
LR2<-2*(resLambda2$logL-resBM$logL1)
P2<-pchisq(LR2,df=1,lower.tail=F)

# for plant height
resBM<-brownie.lite(mt1,X1$plant_height)
resLambda3<-phylosig(mt1,X1$plant_height,method="lambda")
LR3<-2*(resLambda3$logL-resBM$logL1)
P3<-pchisq(LR3,df=1,lower.tail=F)

# for branch number
resBM<-brownie.lite(mt1,X1$branch_number)
resLambda4<-phylosig(mt1,X1$branch_number,method="lambda")
LR4<-2*(resLambda4$logL-resBM$logL1)
P4<-pchisq(LR4,df=1,lower.tail=F)

# for fruit number
resBM<-brownie.lite(mt1,X1$fruit_number)
resLambda5<-phylosig(mt1,X1$fruit_number,method="lambda")
LR5<-2*(resLambda5$logL-resBM$logL1)
P5<-pchisq(LR5,df=1,lower.tail=F)

# for genome size
resBM<-brownie.lite(mt1,X1$GS)
resLambda6<-phylosig(mt1,X1$GS,method="lambda")
resLambda6$lambda
LR6<-2*(resLambda6$logL-resBM$logL1)
P6<-pchisq(LR6,df=1,lower.tail=F)

# for leaf_shape
resBM<-brownie.lite(mt1,X1$leaf_shape)
resLambda7<-phylosig(mt1,X1$leaf_shape,method="lambda")
LR7<-2*(resLambda7$logL-resBM$logL1)
P7<-pchisq(LR7,df=1,lower.tail=F)

# for seed_column
resBM<-brownie.lite(mt1,X1$seed_column)
resLambda8<-phylosig(mt1,X1$seed_column,method="lambda")
resLambda8$lambda
LR8<-2*(resLambda8$logL-resBM$logL1)
P8<-pchisq(LR8,df=1,lower.tail=F)

P <- setNames(c(P1,P2,P3,P4,P5,P6,P7,P8),c("petal_number","fruits_length","plant_height","branch_number","fruit_number","genome_size","leaf_shape","seed_column"))


lambda <- setNames(c(resLambda1$lambda,resLambda2$lambda,resLambda3$lambda,resLambda4$lambda,resLambda5$lambda,resLambda6$lambda,resLambda7$lambda,resLambda8$lambda),
                   c("petal_number","fruits_length","plant_height","branch_number","fruit_number","genome_size","leaf_shape","seed_column"))
lambda
P

# moedl fitting for discrete data
# fitDiscrete(mt1, w, model = "ARD",transform = "lambda")
# tree must be bifurcating (no polytomies or unbranched nodes)
# remove variants, which means the non-binary value for observed traits

tips <- c("RO318_1","RO018_5","RO727_1","RO102_1","RO107_1","RO452_1","RO453_1","RO454_4","RO162_5","RO163_1","RO164_2","RO123_5","RO455_1","RO158_3","RO159_2","RO161_2","RO160_1","RO150_Rg","RO646_Rau","RO843_2","RO663_Rse","RO666_Rsi","RO324_Rc","NA6","AP009376","Aethionema_arabicum","Aethionema_cordifolium","Tarenaya_hassleriana"
)
mt2 <- drop.tip(mt, tip = tips)

X <- read.csv("rdri_binary_traits.csv",row.names=1,header=TRUE)
dim(X)
head(X)

w<-setNames(X$PN.mean,rownames(X))
x<-setNames(X$ploidy,rownames(X))
y<-setNames(X$phylogeny,rownames(X))
z<-setNames(X$seed_column,rownames(X))

fit.wx<-fitPagel(mt2,w,x)
fit.wy<-fitPagel(mt2,w,y)
fit.wz<-fitPagel(mt2,w,z)
fit.xy<-fitPagel(mt2,x,y)
fit.xz<-fitPagel(mt2,x,z)
fit.yz<-fitPagel(mt2,y,z)

fit.w.x<-fitPagel(mt2,w,x,dep.var="x")
fit.w.y<-fitPagel(mt2,w,y,dep.var="y")
fit.w.z<-fitPagel(mt2,w,z,dep.var="z")
fit.x.w<-fitPagel(mt2,w,x,dep.var="w")
fit.y.w<-fitPagel(mt2,w,y,dep.var="w")
fit.z.w<-fitPagel(mt2,w,z,dep.var="w")
fit.x.y<-fitPagel(mt2,x,y,dep.var="y")
fit.x.z<-fitPagel(mt2,x,z,dep.var="z")
fit.y.x<-fitPagel(mt2,x,y,dep.var="x")
fit.z.x<-fitPagel(mt2,x,z,dep.var="x")
fit.y.z<-fitPagel(mt2,y,z,dep.var="y")
fit.z.y<-fitPagel(mt2,y,z,dep.var="z")

aic<-c(fit.wx$independent.AIC,
       fit.wy$independent.AIC,
       fit.wz$independent.AIC,
       fit.xy$independent.AIC,
       fit.xz$independent.AIC,
       fit.yz$independent.AIC,
       fit.wx$dependent.AIC,
       fit.wy$dependent.AIC,
       fit.wz$dependent.AIC,
       fit.xy$dependent.AIC,
       fit.xz$dependent.AIC,
       fit.yz$dependent.AIC,
       fit.w.x$dependent.AIC,
       fit.w.y$dependent.AIC,
       fit.w.z$dependent.AIC,
       fit.x.w$dependent.AIC,
       fit.y.w$dependent.AIC,
       fit.z.w$dependent.AIC,
       fit.x.y$dependent.AIC,
       fit.x.z$dependent.AIC,
       fit.y.x$dependent.AIC,
       fit.z.x$dependent.AIC,
       fit.y.z$dependent.AIC,
       fit.z.y$dependent.AIC
)

aic
aic.w(aic)

