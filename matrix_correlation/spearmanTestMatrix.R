AS89 <- function(s, n, lower.tail){
	.C("prho", as.integer(n), as.double(s + 2 * lower.tail), 
				p = double(1), integer(1), as.logical(lower.tail), 
				PACKAGE = "pspearman")$p
}			
spearmanMatrix <- function(
	x, y= NULL, adjust= "BH", CPU= 4
)
{
	library(pspearman)
	library(parallel)
    n <- nrow(x)
	NCOL_x <- ncol(x)
    PVAL <- NULL
    if (n < 2) 
        stop("not enough finite observations")
    PARAMETER <- NULL
	rank_x <- apply(x, 2, rank)
	if(is.null(y)){
		r <- cor(rank_x)
	}else{
		rank_y <- apply(y, 2, rank)
		r <- cor(rank_x, rank_y)
	}
	s <- (n^3 - n) * (1 - r)/6
	S <- s > (n^3 - n)/6
	p <- matrix(nrow= nrow(s), ncol= ncol(s))
	if(n < 1290){
		ifelse(detectCores() <= 4, CPU <- 4, CPU <- CPU)
		c1 <- makeCluster(CPU)
		clusterExport(c1, "pspearman")
		p[S] <- parSapply(c1, s[S], AS89, n= n, lower.tail= FALSE)
		p[!S] <- parSapply(c1, s[!S], AS89, n= n, lower.tail= TRUE)
		stopCluster(c1)
	}else{
		r <- 1 - 6 * s/(n * (n^2 - 1))
        p[S] <- pt(r[S]/sqrt((1 - r[S]^2)/(n - 2)), df = n - 2, lower.tail = TRUE)
		p[!S] <- pt(r[!S]/sqrt((1 - r[!S]^2)/(n - 2)), df = n - 2, lower.tail = FALSE)
	}
	p_vec <- mapply(FUN= function(pval)min(2*pval, 1), p)
	p_mat <- matrix(p_vec, nrow= nrow(r), ncol= ncol(r), dimnames= dimnames(r))
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
	list(r= r, p= p_mat, fdr= fdr)
}
