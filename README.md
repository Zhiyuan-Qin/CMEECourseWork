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