# Demonstrate control flow in R.

# Choose a branch using a logical value.
a <- TRUE
if (a) {
    print("a is TRUE")
} else {
    print("a is FALSE")
}

# Check a randomly generated number.
z <- runif(1)
if (z <= 0.5) {
    print("Less than a half")
}

# Loop over numbers and print their squares.
for (i in 1:10) {
    j <- i * i
    print(paste(i, "squared is", j))
}

# Loop over species names.
for (species in c(
    "Heliodoxa rubinoides",
    "Boissonneaua jardini",
    "Sula nebouxii"
)) {
    print(paste("The species is", species))
}

# Loop over an existing vector.
v1 <- c("a", "bc", "def")
for (i in v1) {
    print(i)
}

# Repeat while the condition remains true.
i <- 0
while (i < 10) {
    i <- i + 1
    print(i^2)
}