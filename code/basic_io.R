# A simple R script illustrating file input and output.
# Run from the coursework project root.

dir.create("results", showWarnings = FALSE)

MyData <- read.csv("data/trees.csv", header = TRUE)

print(head(MyData))
print(dim(MyData))

# Write the data as a CSV file.
write.csv(MyData, "results/MyData.csv")

# Inspect the beginning of the saved file.
print(readLines("results/MyData.csv", n = 3))

# Append the first record to the existing file.
write.table(MyData[1, ], file = "results/MyData.csv", append = TRUE)

# Inspect the appended lines.
print(tail(readLines("results/MyData.csv"), n = 3))

# Overwrite with CSV output, explicitly including row names.
write.csv(MyData, "results/MyData.csv", row.names = TRUE)
print(readLines("results/MyData.csv", n = 2))

# Overwrite with a space-separated table without column names.
write.table(MyData, "results/MyData.csv", col.names = FALSE)
print(readLines("results/MyData.csv", n = 2))