# Calculate tree height from angle (degrees) and distance (metres).
TreeHeight <- function(degrees, distance) {
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    return(height)
}

print(TreeHeight(37, 40))

# Read and inspect the tree measurements.
trees <- read.csv("data/trees.csv")

print(head(trees))
str(trees)
required_columns <- c("Species", "Distance.m", "Angle.degrees")
if (!all(required_columns %in% colnames(trees))) {
    stop("The required columns are not present in the data frame.")
}
if (!is.numeric(trees$Distance.m)) {
    stop("The Distance.m column is not numeric.")
}
if (!is.numeric(trees$Angle.degrees)) {
    stop("The Angle.degrees column is not numeric.")
}
if (!all(is.finite(trees$Distance.m))) {
    stop("The Distance.m column contains infinite or missing values.")
}
if (!all(is.finite(trees$Angle.degrees))) {
    stop("The Angle.degrees column contains infinite or missing values.")
}
if (!all(trees$Distance.m > 0 & trees$Distance.m <= 100)) {
    stop("The Distance.m column contains invalid values.")
}
if (!all(trees$Angle.degrees > 0 & trees$Angle.degrees < 90)) {
    stop("The Angle.degrees column contains invalid values.")
}
trees$height_m <- TreeHeight(trees$Angle.degrees, trees$Distance.m)
print(head(trees))
dir.create("results", showWarnings = FALSE)
write.csv(trees, "results/TreeHts.csv", row.names = FALSE)