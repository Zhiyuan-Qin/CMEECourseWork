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