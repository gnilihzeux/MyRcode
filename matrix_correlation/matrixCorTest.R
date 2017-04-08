##################################################
### 计算比较大的相关性矩阵以及矩阵的相关性检验 ###
### 仅限于皮尔森相关性                         ###
##################################################

###--- 该函数用于计算比较大的相关性矩阵 ----------
bigcor <- function(
	x, y = NULL,
	fun = c("cor", "cov"), 
	size = 500, verbose = TRUE, 
	...
)
{
  library(ff)
  fun <- match.arg(fun)
  if (fun == "cor") FUN <- cor else FUN <- cov
  if (fun == "cor") STR <- "Correlation" else STR <- "Covariance" 
  if (!is.null(y) & NROW(x) != NROW(y)) stop("'x' and 'y' must have compatible dimensions!")
  
  NCOL <- ncol(x)
  if (!is.null(y)) YCOL <- NCOL(y)
  
  ## calculate remainder, largest 'size'-divisible integer and block size
  REST <- NCOL %% size
  LARGE <- NCOL - REST  
  NBLOCKS <- NCOL %/% size
  
  ## preallocate square matrix of dimension
  ## ncol(x) in 'ff' single format
  if (is.null(y)) resMAT <- ff(vmode = "double", dim = c(NCOL, NCOL))  
  else resMAT <- ff(vmode = "double", dim = c(NCOL, YCOL))
  
  ## split column numbers into 'nblocks' groups + remaining block
  GROUP <- rep(1:NBLOCKS, each = size)
  if (REST > 0) GROUP <- c(GROUP, rep(NBLOCKS + 1, REST))
  SPLIT <- split(1:NCOL, GROUP)
  
  ## create all unique combinations of blocks
  COMBS <- expand.grid(1:length(SPLIT), 1:length(SPLIT))
  COMBS <- t(apply(COMBS, 1, sort))
  COMBS <- unique(COMBS)  
  if (!is.null(y)) COMBS <- cbind(1:length(SPLIT), rep(1, length(SPLIT)))
  
  ## initiate time counter
  timeINIT <- proc.time() 
  
  ## iterate through each block combination, calculate correlation matrix
  ## between blocks and store them in the preallocated matrix on both
  ## symmetric sides of the diagonal
  for (i in 1:nrow(COMBS)) {
    COMB <- COMBS[i, ]    
    G1 <- SPLIT[[COMB[1]]]
    G2 <- SPLIT[[COMB[2]]]    
    
    ## if y = NULL
    if (is.null(y)) {
      if (verbose) cat(sprintf("#%d: %s of Block %s and Block %s (%s x %s) ... ", i, STR,  COMB[1],
                               COMB[2], length(G1),  length(G2)))      
      RES <- FUN(x[, G1], x[, G2], ...)
      resMAT[G1, G2] <- RES
      resMAT[G2, G1] <- t(RES) 
    } else ## if y = smaller matrix or vector  
    {
      if (verbose) cat(sprintf("#%d: %s of Block %s and 'y' (%s x %s) ... ", i, STR,  COMB[1],
                               length(G1),  YCOL))    
      RES <- FUN(x[, G1], y, ...)
      resMAT[G1, ] <- RES             
    }
    
    if (verbose) {
      timeNOW <- proc.time() - timeINIT
      cat(timeNOW[3], "s\n")
    }
    
    gc()
  } 
  
  return(resMAT)
}

###--- 通过判断矩阵大小评估使用cor还是bigcor -----
pearsonCorrelationMatrix <- function(
	x, y= NULL, size= 500
)
{
	NROW <- ifelse(is.null(y), 
		ncol(x), 
		max(ncol(x), ncol(y))
	)
	if(NROW >= 5000){
		r <- bigcor(x, y, size= size, fun= "cor", method= "pearson")
		# 将ff格式转化为matrix，用as.ffdf或者下面的方式
		r <- r[,]
	}else{
		r <- cor(x, y, method= "pearson")
	}
	rownames(r) <- colnames(x)
	ifelse(is.null(y), 
		colnames(r) <- colnames(x), 
		colnames(r) <- colnames(y)
	)
	r
}

###--- cor.test ----------------------------------
### 用t-test对皮尔森相关性进行检验，默认双边检验，参考自cor.test.default
pearsonTestMatrix <- function(
	x, y= NULL, size= 500, adjust= "BH"
)
{
	# 计算相关系数
	r <- pearsonCorrelationMatrix(x, y, size)
	# 观测值
	n <- nrow(x)
	# 自由度
	df <- n - 2
	# t值
	tv <- (r * sqrt(df))/sqrt(1 - r^2)
	# p值
	p <- pt(tv, df)
	p_vec <- mapply(FUN= function(x)2 * min(x, 1-x), p)
	p_mat <- matrix(p_vec, nrow= nrow(r), ncol= ncol(r), dimnames= dimnames(r))
	# fdr值
	fdr_mat <- p_mat
	if(is.null(y)){
		fdr_mat[!lower.tri(fdr_mat)] <- NA
		fdr <- matrix(p.adjust(fdr_mat, method= adjust), 
		              nrow= nrow(r), ncol= ncol(r), dimnames= dimnames(r)
		)
	}else{
		fdr <- matrix(p.adjust(fdr_mat, method= adjust), 
		              nrow= nrow(r), ncol= ncol(r), dimnames= dimnames(r)
		)
	}
	# 将vector转换为matrix
	list(r= r, p= p_mat, fdr= fdr)
}

###--- transform matrix 2 long -------------------
### 将相关性矩阵输出为long format，包含5列，分别为：
### x的行名，y的行名，相关系数r，相关性检验p，校正后的fdr
outputDF <- function(
	lst,
	symmetric= TRUE
)
{
	library(reshape2)
	mat2df <- function(
		m
	)
	{
		if(symmetric){
			m[!lower.tri(m)] <- NA
			na.omit(melt(m))
		}else{
			melt(m)
		}
	}
	rlst <- data.frame(mat2df(lst[[1]]), 
	                   mat2df(lst[[2]])[, 3], 
			           mat2df(lst[[3]])[, 3], 
					   stringsAsFactors= F
	)
	colnames(rlst) <- c("V1", "V2", "r", "p", "fdr")
	rlst
}

###--- check the consistency with cor.test -------
### 检查结果是否与原函数cor.test一致,这里只评估r值与p值
### 这里的x与y就是指的表达谱，而前面函数的x与y分别是表达谱的转置

checkPoint <- function(
	x, y= NULL,
	outputdf, 
	rownum= NULL
)
{
	# 默认检查是分位数的行号，也可以自己输入向量
	ifelse(is.null(rownum), 
	       vec <- round(quantile(seq_len(nrow(outputdf)))),
		   vec <- rownum
	)
	tTest <- function(num){
		nms <- c(as.character(outputdf[num, 1]), as.character(outputdf[num, 2]))
		x1 <- as.numeric(x[nms[1], ])
		if(is.null(y)){
			x2 <- as.numeric(x[nms[2], ])
			tt <- cor.test(x1, x2)
		}else{
			x2 <- as.numeric(y[nms[2], ])
			tt <- cor.test(x1, x2)
		}
		c(nms, tt$estimate, tt$p.value)
	}
	s <- t(sapply(vec, tTest))
	rownames(s) <- colnames(s) <- NULL
	l <- c(list(outputdf[vec, 1:4]),list(s))
	names(l) <- c("Results", "Results with cor.test()")
	l
}

