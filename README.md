# CMEE Coursework

Author: Zhiyuan Qin

This repository contains my CMEE coursework and practical exercises.

## Repository structure

- `code/`: scripts and answers to practical exercises.
- `data/`: input data used by the scripts.
- `results/`: generated outputs, excluded from Git.
- `sandbox/`: temporary test files, excluded from Git.

## Assignment 1

- `code/unixPrac1.txt`: commands and explanations for the five UNIX practical questions.
- `code/tabtocsv.sh`: converts tabs to commas.
- `code/csvtospace.sh`: converts commas to spaces.

## How to run

The shell scripts require Bash and standard UNIX command-line tools.

From the repository root, enter the code directory:

```bash
cd code
```

Convert the tab-delimited example to CSV:

```bash
bash tabtocsv.sh ../data/tab-example.tsv
```

Convert a temperature CSV file to space-delimited text:

```bash
bash csvtospace.sh ../data/temperatures/1800.csv
```

The outputs are saved as `results/tab-example.tsv.csv` and
`results/1800.csv.txt`, relative to the repository root.
Running a script again overwrites its corresponding output file.
The input files remain unchanged.

## Testing

- Both scripts passed syntax checks using `bash -n`.
- Both scripts were tested with filenames containing spaces and with empty fields.
- Running each script twice overwrote the output without appending extra lines.
- Missing arguments returned exit status 2; nonexistent input files returned exit status 1.
- Input files were compared with their original copies using `diff` and remained unchanged.
- `csvtospace.sh` successfully converted all four temperature files, from `1800.csv` to `1803.csv`.

## Data and limitations

The FASTA and temperature input files were copied from the course materials.
`data/tab-example.tsv` is a small example I created for testing, containing an empty field.

The scripts perform simple character substitution and preserve empty fields.
They do not handle quoted CSV fields containing commas.
Spaces within CSV fields can make the space-delimited output ambiguous.

## AI use record

- Tool: ChatGPT / Codex.
- Date: 2026-10-08.
- Tasks: Assignment 1 UNIX practicals, shell scripts, testing, and README documentation.
- Purpose: Explain commands and shell syntax, help diagnose errors, suggest small code snippets and test commands, and help draft documentation.
- Verification: I ran the commands and scripts locally, inspected their outputs and exit statuses, checked script syntax with `bash -n`, and used `diff` to confirm that the tested input files remained unchanged.

## Bootcamp Assignment 2: Tree-survey cleaning

### Input and outputs

Input: `data/silwood_trees_raw.csv`

Outputs:
- `results/silwood_trees_clean.csv`: cleaned, accepted records.
- `results/silwood_tree_issues.csv`: rejected records with source row numbers, record identifiers and rejection reasons.
- `results/oak_species_counts.csv`: counts of accepted oak records by species.

### Processing plan

```text
Read records from the input CSV.

Before checking records:
    Create an empty list for accepted records.
    Create an empty list for issue reports.
    Create an empty set for accepted identifiers.

Check each record in input order:
    If the record is valid:
        Add the cleaned record to the accepted records list.
        Add its identifier to the accepted identifiers set.
    Otherwise:
        Add one issue report containing source_row, record_id
        and reasons to the issue reports list.
Count accepted oak records by species.

Sort accepted records by record_id.
Keep issue reports in source-row order.
Sort oak species counts by species.

Write accepted records to results/silwood_trees_clean.csv.
Write issue reports to results/silwood_tree_issues.csv.
Write oak species counts to results/oak_species_counts.csv.
```
### Running and testing

Run these commands from the project root:

```bash
python3 code/clean_silwood_trees.py
python3 code/test_silwood_trees.py
```
### A useful test

I tested a record with a missing location and a distance of zero.
I expected both rejection reasons, with the location reason first.
This test checks that the program collects all applicable reasons
instead of stopping after the first problem.

### AI assistance

I used ChatGPT to understand Python syntax, dictionaries, sets,
validation rules and testing. It also helped me with error messages,
code examples, test inputs and README wording. I checked the suggestions
against the metadata, predicted expected results and ran assertions.
I also inspected the output files and compared checksums after rerunning
the program.

### Limitations

The program follows the supplied metadata. It does not guess missing
values or correct unrecognised spellings. Passing the current tests
does not guarantee that every possible input has been covered.

## Assignment 3: Tree heights and Pound Hill species richness

### Input and output

- Script: `code/TreeHeight.R`
- Input: `data/trees.csv` (kept unchanged).
- Output: `results/TreeHts.csv`.

The script checks the required columns, numeric types, finite values and measurement ranges. It preserves the original three columns and row order, and adds `height_m` as the fourth column.

### How to run

Run from the repository root:

```bash
Rscript code/TreeHeight.R
```

Alternatively, start R from the repository root and run:

```r
source("code/TreeHeight.R")
```

### Checks performed

- The output contains 120 data rows.
- The original three columns and row order match the input.
- I independently checked the first record, Populus tremula:
  `31.6658337740228 * tan(41.2826361937914 * pi / 180)`,
  giving approximately 27.80212 metres, matching the output.
- Running the script again replaces the output and still produces 120 data rows.
- The script also runs successfully using `source()`.

### Tree heights from a command-line input

Run from the repository root:

```bash
Rscript code/get_TreeHeight.R data/trees.csv
```

The script accepts exactly one readable CSV file containing Species,
Distance.m and Angle.degrees. It applies the same validation and height
calculation as TreeHeight.R.

The output is saved as results/<input_basename>_treeheights.csv.
For example, data/trees.csv produces results/trees_treeheights.csv.
Running the script again replaces the existing output. Input files with
the same basename produce the same output filename, even when stored in
different directories.

Run the checks with:

```bash
bash code/run_get_TreeHeight.sh
```

The shell script creates a small test CSV in sandbox, runs both datasets,
and checks output dimensions, column names and calculated heights.
It also checks repeated execution and rejection of a missing argument.
Additional manual checks confirmed rejection of multiple arguments,
a nonexistent input file and missing required columns.

### Pound Hill species richness

Script: `code/pound_hill_analysis.R`

Inputs (kept unchanged):
- `data/pound_hill_data.csv`
- `data/pound_hill_meta_data.csv`

Required R packages: `reshape2` and `ggplot2`.

Run from the repository root:

```bash
Rscript code/pound_hill_analysis.R
```

Outputs:
- `results/pound_hill_plot_richness.csv`: one row per plot, containing Cultivation, Block, Plot and MeanRichness.
- `results/pound_hill_plot_richness.pdf`: individual plot-level mean richness values shown by cultivation treatment.

Blank species counts are treated as observed zeros, as specified in the metadata. Richness is calculated for each quadrat first, then averaged within each plot.

Checks confirmed numeric, non-negative counts with no missing values, 41 species, 59 quadrats and 12 plots. The plot summary contains four plots per treatment and no duplicate plot identifiers. The script was rerun successfully in a fresh Rscript session.

### AI assistance

I used ChatGPT on 20 and 23 October 2026 for step-by-step explanations of R syntax, feedback on my code, suggestions for checks, and help with README documentation. I checked the suggestions by running the script, independently calculating the first tree height, comparing the original columns and row order, and checking that rerunning replaced the output. I also tested the script using source().

For the Pound Hill practical on 23 October 2026, I used ChatGPT for explanations of R syntax, data reshaping and plotting, code examples and feedback, suggestions for small checks, troubleshooting package installation, and help with documentation and English wording. I checked its suggestions against the supplied metadata, inspected the summary table and generated figure, and reran the script to check reproducibility.