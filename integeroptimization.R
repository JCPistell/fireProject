library(lpSolve)
library(dplyr)

constMatrix <- select(locs, ends_with("Time"))
constMatrix$build <- 1
constMatrix <- as.matrix(constMatrix)
locs.obj <- locs$weightedtimes
signs <- rep(c("<", "="), c(6, 1))
rhs <- rep(c(360, 1), c(6, 1))

optisolve <- lp(direction = "min", 
                objective.in = locs.obj, 
                const.mat = constMatrix, 
                const.dir = signs,
                const.rhs = rhs,
                transpose.constraints = FALSE,
                all.bin = TRUE)

optimized.loc <- which.max(optisolve$solution)
