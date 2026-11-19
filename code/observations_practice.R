# Read and validate observation records.
read_observations <- function(path) {
    data <- read.csv(
        path,
        colClasses = "character",
        na.strings = "",
        check.names = FALSE
    )

    expected_columns <- c("site", "date", "count")

    if (!identical(names(data), expected_columns)) {
        stop("Expected columns: site, date, count, in that order.")
    }

        for (column in c("site", "date")) {
        values <- data[[column]]

        if (any(is.na(values) | values == "")) {
            stop(paste(
                path,
                paste0("Column '", column, "' must not contain missing or empty values.")
            ))
        }
    }

        counts <- data$count

    valid_format <- grepl("^(0|[1-9][0-9]*)$", counts)

    invalid_count <- !is.na(counts) & !valid_format

    if (any(invalid_count)) {
        bad_row <- which(invalid_count)[1]

        stop(paste0(
            path, ": CSV line ", bad_row + 1,
            ", column 'count': found '", counts[bad_row],
            "'; expected an empty field or a non-negative integer."
        ))
    }

    data$count <- as.integer(counts)

    return(data)
}

summarise_observations <- function(data) {
    data <- unique(data[c("site", "date", "count")])

    sites <- sort(unique(data$site))

    summary <- data.frame(
        site = character(),
        total_known = integer(),
        missing_count = integer()
    )

    for (site in sites) {
        counts <- data$count[data$site == site]

                missing_count <- sum(is.na(counts))

        if (missing_count == length(counts)) {
            total_known <- NA_integer_
        } else {
            total_known <- sum(counts, na.rm = TRUE)
        }

        summary <- rbind(
            summary,
            data.frame(
                site = site,
                total_known = total_known,
                missing_count = missing_count
            )
        )
    }

    return(summary)
}

observations <- read_observations("data/bootcamp_observations.csv")
str(observations)
print(observations)
ordinary_summary <- summarise_observations(observations)
print(ordinary_summary)

boundary <- read_observations(
    "data/bootcamp_observations_boundary.csv"
)
boundary_summary <- summarise_observations(boundary)
print(boundary_summary)

stopifnot(identical(ordinary_summary$site, c("A", "B")))
stopifnot(identical(boundary_summary$site, c("C", "D")))

# Check the ordinary data.
stopifnot(
    ordinary_summary$total_known[ordinary_summary$site == "A"] == 2,
    ordinary_summary$missing_count[ordinary_summary$site == "A"] == 1,
    ordinary_summary$total_known[ordinary_summary$site == "B"] == 0,
    ordinary_summary$missing_count[ordinary_summary$site == "B"] == 0
)

# Check all-missing counts separately from observed zero.
stopifnot(
    is.na(boundary_summary$total_known[boundary_summary$site == "C"]),
    boundary_summary$missing_count[boundary_summary$site == "C"] == 2,
    boundary_summary$total_known[boundary_summary$site == "D"] == 0,
    boundary_summary$missing_count[boundary_summary$site == "D"] == 0
)

cat("Observation summary checks passed.\n")

# Combine the summaries for plotting.
all_summary <- rbind(ordinary_summary, boundary_summary)

# Plot only sites with known totals.
known <- all_summary[!is.na(all_summary$total_known), ]

dir.create("results", showWarnings = FALSE)
pdf("results/observations_known_totals.pdf", width = 7, height = 5)

positions <- barplot(
    known$total_known,
    names.arg = known$site,
    ylim = c(0, max(known$total_known) + 1),
    xlab = "Site",
    ylab = "Total known count",
    main = "Known observation totals"
)

text(
    x = positions,
    y = known$total_known,
    labels = known$total_known,
    pos = 3
)

mtext(
    "Site C: all counts missing (2 records); total unknown, excluded.",
    side = 1,
    line = 4,
    cex = 0.8
)

dev.off()