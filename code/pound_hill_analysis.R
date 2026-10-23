MyData <- as.matrix(read.csv("data/pound_hill_data.csv", header = FALSE))
MyMetaData <- read.csv("data/pound_hill_meta_data.csv", header = TRUE, sep = ";")
dim(MyData)
str(MyData)
head(MyData)
print(MyMetaData)
# Blank species counts represent observed absences, according to the metadata.
MyData[MyData == ""] <- 0

# Transpose the matrix so that sampling units are in rows.
MyData <- t(MyData)
dim(MyData)
print(MyData[1:6, 1:7])
TempData <- as.data.frame(MyData[-1, ], stringsAsFactors = FALSE)
colnames(TempData) <- MyData[1, ]
dim(TempData)
print(TempData[1:6, 1:7])
library(reshape2)
LongData <- melt(
    TempData,
    id.vars = c("Cultivation", "Block", "Plot", "Quadrat"),
    variable.name = "Species",
    value.name = "Count"
)
dim(LongData)
head(LongData)
str(LongData$Count)
LongData$Count <- as.numeric(LongData$Count)
str(LongData$Count)
sum(is.na(LongData$Count))
all(LongData$Count >= 0)
length(unique(LongData$Species))
nrow(unique(LongData[c("Cultivation", "Block", "Plot", "Quadrat")]))
nrow(unique(LongData[c("Cultivation", "Block", "Plot")]))
QuadratRichness <- aggregate(
    Count ~ Cultivation + Block + Plot + Quadrat,
    data = LongData,
    FUN = function(x) sum(x > 0)
)
names(QuadratRichness)[names(QuadratRichness) == "Count"] <- "Richness"
dim(QuadratRichness)
head(QuadratRichness)
range(QuadratRichness$Richness)
PlotRichness <- aggregate(
    Richness ~ Cultivation + Block + Plot,
    data = QuadratRichness,
    FUN = mean
)
names(PlotRichness)[names(PlotRichness) == "Richness"] <- "MeanRichness"
dim(PlotRichness)
print(PlotRichness)
table(PlotRichness$Cultivation)
anyDuplicated(PlotRichness[c("Cultivation", "Block", "Plot")])
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
