# Demonstrate catching errors during repeated sampling.
doit <- function(x) {
    temp_x <- sample(x, replace = TRUE)

    if (length(unique(temp_x)) > 30) {
        print(paste(
            "Mean of this sample was:",
            as.character(mean(temp_x))
        ))
    } else {
        stop("Couldn't calculate mean: too few unique values!")
    }
}

set.seed(1345)
popn <- rnorm(50)

# Attempt all 15 runs, retaining any errors in the results.
result <- lapply(1:15, function(i) {
    try(doit(popn), silent = FALSE)
})

print(class(result))
print(length(result))

# Inspect the results retained by lapply.
print(result)

# Repeat the exercise using a preallocated list and a for loop.
result_loop <- vector("list", 15)

for (i in 1:15) {
    result_loop[[i]] <- try(doit(popn), silent = FALSE)
}

print(length(result_loop))