#' @title Sign-Flipping Test
#' @description Performs sign-flipping, i.e. permutation, one-sample t-tests
#' @param X = data where rows represents the variables and columns the observations
#' @param perms = number of permutations to perform, default is 1000.
#' @param alternative = character referring to the alternative hypothesis, "two.sided", "greater" or "less". Default is "two.sided"
#' @param seed = specify seed, default is 1234.
#' @author Angela Andreella
#' @return Returns a list with the following objects: \code{Test} observed one sample t-test, \code{Test_H0} Test statistics under H0, \code{pv} observed p-values, \code{pv_H0} p-values under H0
#' @export


alternative_set <- c("two.sided", "greater", "lower")

signTest <- function(X, perms = 1000, alternative = "two.sided", seed = NULL){
  
  if(!is.null(seed)){set.seed(seed)}else{set.seed(1234)}
  
  alternative <- match.arg(tolower(alternative), alternative_set)
  
  ## number of obeservation
  n <- ncol(X)
  # number of variables
  m <- nrow(X)

  ## Observed test statistics and p-values
  
  Test <- rowMeans(X)/(sqrt((rowVariance(X))/n))
  pv <- switch(alternative, 
              "two.sided" = 2*(pnorm(abs(Test), lower.tail=FALSE)),
              "greater" = pnorm(Test, lower.tail=FALSE),
              "less" = 1-pnorm(Test, lower.tail=FALSE))
  
  ## Test statistics and p-values under H0
  
  Test_H0 <- signFlip(X,B)
  #T0_m <- meanBySignFlipping(X,B)
  #T0_v <- varBySignFlipping(X,B)
  #T0 <- T0_m/ sqrt((T0_v)/n)
  
  pv_H0 <- switch(alternative, 
                 "two.sided" = 2*(pnorm(abs(Test_H0), lower.tail=FALSE)),
                 "greater" = pnorm(Test_H0, lower.tail=FALSE),
                 "less" = 1-pnorm(Test_H0, lower.tail=FALSE))
  
  out <- list(Test = Test, Test_H0 = Test_H0, pv = pv, pv_H0 = pv_H0)

  return(out)
}