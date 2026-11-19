# Demonstrate leaving a loop with break.
i <- 0

while (i < Inf) {
    if (i == 10) {
        break
    } else {
        cat("i equals ", i, " \n")
        i <- i + 1
    }
}