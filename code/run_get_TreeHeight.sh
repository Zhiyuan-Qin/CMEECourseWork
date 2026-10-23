#!/bin/bash
set -e

mkdir -p sandbox
printf 'Species,Distance.m,Angle.degrees\nTest tree,8,45\n' > sandbox/toy_trees.csv

Rscript code/get_TreeHeight.R data/trees.csv
Rscript code/get_TreeHeight.R sandbox/toy_trees.csv
Rscript code/get_TreeHeight.R sandbox/toy_trees.csv
Rscript -e '
result <- read.csv("results/toy_trees_treeheights.csv")
stopifnot(nrow(result) == 1)
stopifnot(ncol(result) == 4)
expected_columns <- c("Species", "Distance.m", "Angle.degrees", "height_m")
stopifnot(identical(colnames(result), expected_columns))
stopifnot(abs(result$height_m - 8) < 1e-8)
original <- read.csv("data/trees.csv")
full_result <- read.csv("results/trees_treeheights.csv")
stopifnot(nrow(full_result) == nrow(original))
stopifnot(identical(colnames(full_result), c(colnames(original), "height_m")))
expected_height <- original$Distance.m[1] *
    tan(original$Angle.degrees[1] * pi / 180)
stopifnot(abs(full_result$height_m[1] - expected_height) < 1e-8)
'
if Rscript code/get_TreeHeight.R; then
    echo "ERROR: missing input argument was accepted."
    exit 1
fi
echo "All tree-height checks passed."
