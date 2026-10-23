# Calculate tree height from angle (degrees) and distance (metres).
TreeHeight <- function(degrees, distance) {
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    return(height)
}

# Read and inspect the tree measurements.
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1) {
    stop("Usage: Rscript code/get_TreeHeight.R <input.csv>")
}
input_file <- args[1]
if (!file.exists(input_file)) {
    stop(paste("Input file does not exist:", input_file))
}
if (file.access(input_file, mode = 4) != 0) {
    stop(paste("Input file is not readable:", input_file))
}
trees <- read.csv(input_file)

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
input_name <- tools::file_path_sans_ext(basename(input_file))
output_file <- paste0("results/", input_name, "_treeheights.csv")
write.csv(trees, output_file, row.names = FALSE)