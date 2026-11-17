dir.create("results", showWarnings = FALSE)

MyData <- as.matrix(read.csv("data/pound_hill_data.csv", header = FALSE))
MyMetaData <- read.csv("data/pound_hill_meta_data.csv", header = TRUE, sep = ";")
print(dim(MyData))
str(MyData)
print(head(MyData))
print(MyMetaData)

# Blank species counts represent observed absences, according to the metadata.
MyData[MyData == ""] <- 0

# Transpose the matrix so that sampling units are in rows.
MyData <- t(MyData)
print(dim(MyData))
print(MyData[1:6, 1:7])
TempData <- as.data.frame(MyData[-1, ], stringsAsFactors = FALSE)
colnames(TempData) <- MyData[1, ]
print(dim(TempData))
print(TempData[1:6, 1:7])

library(reshape2)

LongData <- melt(
    TempData,
    id.vars = c("Cultivation", "Block", "Plot", "Quadrat"),
    variable.name = "Species",
    value.name = "Count"
)
print(dim(LongData))
print(head(LongData))
str(LongData$Count)
LongData$Count <- as.numeric(LongData$Count)
str(LongData$Count)

# Stop if species counts contain missing or negative values.
stopifnot(
    !anyNA(LongData$Count),
    all(LongData$Count >= 0)
)

# Display the numbers of species, quadrats and plots.
print(length(unique(LongData$Species)))
print(nrow(unique(LongData[c("Cultivation", "Block", "Plot", "Quadrat")])))
print(nrow(unique(LongData[c("Cultivation", "Block", "Plot")])))

QuadratRichness <- aggregate(
    Count ~ Cultivation + Block + Plot + Quadrat,
    data = LongData,
    FUN = function(x) sum(x > 0)
)
names(QuadratRichness)[names(QuadratRichness) == "Count"] <- "Richness"
print(dim(QuadratRichness))
print(head(QuadratRichness))
print(range(QuadratRichness$Richness))

PlotRichness <- aggregate(
    Richness ~ Cultivation + Block + Plot,
    data = QuadratRichness,
    FUN = mean
)
names(PlotRichness)[names(PlotRichness) == "Richness"] <- "MeanRichness"
print(dim(PlotRichness))
print(PlotRichness)

# Display the number of plots per treatment.
print(table(PlotRichness$Cultivation))

# Require one summary row per plot.
stopifnot(
    anyDuplicated(PlotRichness[c("Cultivation", "Block", "Plot")]) == 0
)

write.csv(PlotRichness, "results/pound_hill_plot_richness.csv", row.names = FALSE)

library(ggplot2)

p <- ggplot(
    data = PlotRichness,
    aes(x = Cultivation, y = MeanRichness)
) +
    geom_point() + labs(x = "Cultivation treatment", y = "Mean plant species richness per quadrat")

ggsave(
    filename = "results/pound_hill_plot_richness.pdf",
    plot = p,
    width = 7,
    height = 5,
    units = "in"
)

# May generally had higher mean species richness per quadrat than March and October.
# Plot values varied within each treatment, and the ranges overlapped among treatments.
# The figure alone cannot establish causation; information on treatment randomisation, blocking and plot independence is needed.
