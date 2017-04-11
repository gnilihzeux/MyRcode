########################################################
###　Examples to display how to use  matrixCorTest.R ###
########################################################
###--- header ------------------------------------------
source("matrixCorTest.R")
options(stringsAsFactors= F)

###--- input -------------------------------------------
gn <- read.table("protein_expression_profile.txt", header= T, sep= "\t")
lnc <- read.table("lncRNA_expression_profile.txt", header= T, sep= "\t")

###--- calculate correlations between lncRNAs and genes -
# calculate cor, p and fdr
# the bigger matrix as 'x'
mat <- pearsonTestMatrix(t(gn), t(lnc))
# display
class(mat)
names(mat)

# convert result into data.frame
# set 'symmetric', here is not.
rslt <- outputDF(mat, symmetric= F)

# estimate with 
checkPoint(gn, lnc, rslt)

###--- calculate correlation between genes --------------
mat <- pearsonTestMatrix(t(gn), size= 1000)
# display
class(mat)
names(mat)

# convert result into data.frame
# set 'symmetric', here is not.
rslt <- outputDF(mat, symmetric= F)

# estimate with 
checkPoint(gn, lnc, rslt)
