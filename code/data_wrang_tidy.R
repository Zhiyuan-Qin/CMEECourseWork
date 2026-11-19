# Wrangle the Pound Hill dataset.
# Run from the coursework project root with:
# Rscript code/data_wrang.R

# Load the data ----------------------------------------------------------
# The first rows describe the sampling design, so do not use one as a header yet.
MyData <- as.matrix(read.csv("data/pound_hill_data.csv", header = FALSE))

# The metadata file does have a header and uses semicolons as separators.
MyMetaData <- read.csv("data/pound_hill_meta_data.csv", header = TRUE, sep = ";")

# Inspect the data -------------------------------------------------------
head(MyData)
dim(MyData)
str(MyData)
head(MyMetaData)

# Put sampled quadrats in rows and species in columns before reshaping.
MyData <- t(MyData)
head(MyData)
dim(MyData)

# The metadata define blank species counts as observed absences.
# Convert these blanks to zero; this rule does not apply to every dataset.
MyData[MyData == ""] <- 0

# Convert the raw matrix to a data frame --------------------------------

TempData <- as.data.frame(MyData[-1, ], stringsAsFactors = FALSE)
colnames(TempData) <- MyData[1, ]
rownames(TempData) <- NULL

# Reshape species columns into Species and Count using tidyr.
library(dplyr)
library(tidyr)

MyWrangledData <- TempData |>
    tidyr::pivot_longer(
        cols = -c(Cultivation, Block, Plot, Quadrat),
        names_to = "Species",
        values_to = "Count"
    )

# Convert sampling labels and species to factors, and counts to integers.
MyWrangledData <- MyWrangledData |>
    dplyr::mutate(
        dplyr::across(
            c(Cultivation, Block, Plot, Quadrat, Species),
            as.factor
        ),
        Count = as.integer(Count)
    )

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

# Save a derived table while leaving the raw files unchanged.
dir.create("results", showWarnings = FALSE)
write.csv(
    MyWrangledData,
    "results/pound_hill_long_tidy.csv",
    row.names = FALSE
)

# Explore the data below this line.
