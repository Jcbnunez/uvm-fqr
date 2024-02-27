# Annotating the code from Albecker _et al._ 2021

### Simulating conditions
```r

numreads_levels = c(50, 100, 200, 300, 400)

numind_levels <- c(100, 1000, 10000)

p0 = 0.5
```

### Power Analysis
```r

dp <- seq(0.01, 0.4, 0.01)

power<- c()

dat <- data.frame()

length(p0)

k <- 0

for (a in 1: length(numreads_levels)){

	numreads=numreads_levels[a]
		for (b in 1: length(numind_levels)){
	
			numind = numind_levels[b]
			for (i in 1:length(dp)){
			
			print(i)
				for (p_0 in seq(0.01, 0.5, 0.01)){
		
				k <- k+1

				p0 <- rep(p_0, 1000)

		
				delta_p <- dp[i]
			
				p1 <- p0 + delta_p
 
				x <- data.frame(t(mapply(allelefreqchange.pooled, 
											p0,p1,numind=numind ,
											numreads=numreads)))						
				x <- sapply( x, as.numeric )
			
				x <- data.frame(x)
			
				null <- data.frame(t(mapply(allelefreqchange.pooled, 
									p0+0.00001,
									p0,
									numind=numind ,numreads=numreads)))
							
				null <- sapply( null, as.numeric )
			
				null <- data.frame(null)

				cutoff <- quantile(null$dp.2,0.95, type=1)
		
				power <- sum(x$dp.2 > cutoff)/length(x$dp.2)
				
				dat0 <- data.frame(numind, numreads, p_0, delta_p, power)
		
				dat <- rbind(dat, dat0)
				} 
			} 
		} 
} 

```

### The allele frequency change model
```r

allelefreqchange.pooled <- function(p0,p1, numind, numreads){


  p0.samp1 <- rbinom(1, numind, p0)/numind

  p0.samp2 <- rbinom(1, numreads, p0.samp1)/numreads

  p1.samp1 <- rbinom(1, numind, p1)/ numind

  p1.samp2 <- rbinom(1, numreads, p1.samp1)/numreads
  
  dp.true<- p0-p1

  dp.1<- p0.samp1-p1.samp1

  dp.2<- p0.samp2-p1.samp2 

  p.bar<- mean(p0,p1)

  p.bar.samp2<- mean(p0.samp2,p1.samp2)
  

  FST.0<-WC_FST_FiniteSample_Haploids_2AllelesB_MCW(
    matrix(c(p0, p1, (1-p0)*numreads, (1-p1)*numreads), ncol=2))
  
  FST.2<-WC_FST_FiniteSample_Haploids_2AllelesB_MCW(
    matrix(c(p0.samp2*numreads, p1.samp2*numreads, (1-p0.samp2)*numreads, (1-p1.samp2)*numreads), ncol=2))
  
return(list(p0=p0,p1=p1, p0.samp2=p0.samp2, p1.samp2=p1.samp2, dp.true=dp.true, dp.1=dp.1, dp.2=dp.2, FST.0=FST.0[3], FST.2=FST.2[3], He.2=FST.2[1], T1=FST.2[4], T2= FST.2[5])) 
}

## test it
allelefreqchange.pooled(0.5,0.5, 1000, 400)
```
