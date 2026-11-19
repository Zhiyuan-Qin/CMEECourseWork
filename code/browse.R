# Inspect an exponential-growth simulation using browser().
Exponential <- function(
    N0 = 1, r = 1, generations = 10,
    debug = interactive()
) {
    N <- rep(NA, generations)
    N[1] <- N0

    for (t in 2:generations) {
        N[t] <- N[t - 1] * exp(r)

        if (debug) {
            browser()
        }
    }

    return(N)
}

growth <- Exponential()

dir.create("results", showWarnings = FALSE)
pdf("results/exponential_growth.pdf")
plot(growth, type = "l", main = "Exponential growth")
dev.off()