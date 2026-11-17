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

Run the following commands from the repository root:

Convert the tab-delimited example to CSV:

```bash
bash code/tabtocsv.sh data/tab-example.tsv
```

Convert a temperature CSV file to space-delimited text:

```bash
bash code/csvtospace.sh data/temperatures/1800.csv
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

### Revision and checks - 2026 - 11 - 15

Following the Assignment 1 feedback, I changed both converters to use
`results/` instead of `../results/` and updated the README commands
to run from the repository root. Empty fields were preserved, and
both scripts handled filenames containing spaces, producing
`results/tab example.tsv.csv` and
`results/tab example.tsv.csv.txt`. Comparisons using `cmp` returned
exit status 0 after rerunning both converters, confirming that the
outputs did not accumulate extra content. Input-preservation
comparisons also returned 0. The temperature example generated
`results/1800.csv.txt`, and I inspected its first five lines.
In a fresh clone of commit `b7dbfed`, I ran both README example
commands from the repository root. The scripts created `results/`
and generated `results/tab-example.tsv.csv` and
`results/1800.csv.txt`. I inspected the outputs and confirmed that
the empty field was preserved in the CSV. After running the
examples, `git status --short` produced no output.

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

Requires Python 3. The cleaner uses only the Python standard library;
no third-party packages are required.

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

### Revisions following feedback

Added descriptive comments to existing tests.

Passed one valid record and one invalid record (with a distance value of "ten") into process_records(), verifying that they are correctly categorized into accepted and issues, respectively.

Passed the resulting `accepted` records into `summarise_oaks()` and
confirmed that the count for `robur` is 1, so the rejected record
does not contribute to the summary.

Both the tests and the data-cleaning script exited with status 0.
The original CSV remained unchanged, and the summary contained
4 records each for `petraea` and `robur`.

In a fresh clone of commit `64e7762`, I ran the cleaning and test
commands from the repository root exactly as documented above.
Both exited with status 0, and all three output files were generated.
I inspected the clean and issues file headers and sample rows,
and confirmed oak counts of 4 each for `petraea` and `robur`.
`git status --short` produced no output after these checks.

### AI assistance

I used ChatGPT to understand Python syntax, dictionaries, sets,
validation rules and testing. It also helped me with error messages,
code examples, test inputs and README wording. I checked the suggestions
against the metadata, predicted expected results and ran assertions.
I also inspected the output files and compared checksums after rerunning
the program.

On 2026-11-17, I used ChatGPT to interpret the feedback, explain how
to test the connection between record cleaning and oak summarisation,
and help label existing tests with descriptive comments. I ran the
tests and cleaning script, inspected the outputs, and checked that
the raw input remained unchanged.

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

### Tree-height checks following feedback

On 17 November 2026, I reran TreeHeight.R directly and using source(),
and ran bash code/run_get_TreeHeight.sh. All three checks exited
with status 0.

For both full-data output files, I checked all 120 rows, confirmed
that the original columns and row order were preserved, and compared
every height against distance * tan(angle * pi / 180), using a
tolerance of 1e-8.

In a separate temporary directory, I tested both TreeHeight.R and
get_TreeHeight.R with a zero distance and, separately, an angle of
90 degrees. Both scripts rejected each input with the appropriate
error message and exit status 1.

After the invalid-input checks, I confirmed that neither
results/TreeHts.csv nor results/trees_treeheights.csv existed
in the temporary test directory.

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

The script explicitly prints diagnostic summaries and uses assertions
to reject missing or negative counts and duplicate plot summary rows.
The checks showed 41 species, 59 quadrats and 12 plots, with four plots
per treatment.

On 17 November 2026, I copied the script and its two input files into
a temporary directory containing only code/ and data/, with no results/
directory. Running Rscript code/pound_hill_analysis.R from that directory
exited with status 0 and created results/ with both the CSV and PDF.
The CSV contained the same 12 plot means as the original run.
I also inspected the original run's PDF and checked its axis labels
and plotted values against the summary table.

### Fresh-clone verification

On 17 November 2026, I checked a fresh clone of commit `b9c8b01`.
I ran Pound Hill before either tree-height script; it exited with
status 0 and generated both required output files.

I then ran TreeHeight.R directly and using source(), ran
get_TreeHeight.R with data/trees.csv, and ran the documented shell
checks. All four commands exited with status 0.
`git status --short` produced no output after these checks.

### AI assistance

I used ChatGPT on 20 and 23 October 2026 for step-by-step explanations of R syntax, feedback on my code, suggestions for checks, and help with README documentation. I checked the suggestions by running the script, independently calculating the first tree height, comparing the original columns and row order, and checking that rerunning replaced the output. I also tested the script using source().

For the Pound Hill practical on 23 October 2026, I used ChatGPT for explanations of R syntax, data reshaping and plotting, code examples and feedback, suggestions for small checks, troubleshooting package installation, and help with documentation and English wording. I checked its suggestions against the supplied metadata, inspected the summary table and generated figure, and reran the script to check reproducibility.

On 17 November 2026, I used ChatGPT to interpret the Assignment 3
feedback, explain output-directory creation, explicit printing and
assertions, troubleshoot a missing R package, and help document the
checks. I ran the revised Pound Hill script, inspected its output,
and tested it independently in a temporary directory that initially
had no results/ directory. ChatGPT also helped me construct tree-height output checks and
invalid-input checks, which I ran and inspected.

## In-class practice scripts

### Shell: variables.sh

Demonstrates command-line parameters, variable assignment, interactive
input and integer addition. Requires Bash and the standard UNIX tool expr.

Run from the repository root:

```bash
bash code/variables.sh
bash code/variables.sh 1 "two words"
```

Each run asks for a string, then two integers separated by a space.
The script reads interactive input and prints to the terminal; it
does not read or create files. Integer input is assumed, as in the
MQB teaching example.

Checks performed on 17 November 2026:
- Without arguments, the parameter count was 0 and the first and
  second parameters were empty. Entering oak and then 0 5 produced
  the updated string oak and a sum of 5.
- With arguments 1 "two words", the parameter count was 2 and
  two words remained one argument. Entering oak and then 3 5
  produced the updated string oak and a sum of 8.

  ### Shell: MyExampleScript.sh

Demonstrates variable assignment and use of the USER environment
variable. Requires Bash.

Run from the repository root:

```bash
bash code/MyExampleScript.sh
```

The script prints Hello followed by the value of USER.
It requires no arguments or input files and creates no files.

Checked on 17 November 2026: the output was Hello qinzhiyuan.
I also compared USER with whoami; both returned qinzhiyuan.
USER can be changed or unset, so it is not proof of identity.

### Shell: boilerplate.sh

Demonstrates a Bash shebang, script documentation, echo -e and exit status.
Requires Bash. No arguments or input files are needed; no files are created.

Run from the repository root:

```bash
bash code/boilerplate.sh
echo "$?"
```

Checked on 17 November 2026: the script printed
"This is a shell script!" with blank lines before and after it,
and returned exit status 0.

### Shell: CheckLabel.sh

Demonstrates argument validation, Bash conditionals and exit statuses.
Requires Bash and exactly one argument: oak or pine.
No input files are read and no files are created.

Run these checks from the repository root, inspecting the exit
status immediately after each call:

```bash
bash code/CheckLabel.sh oak
echo "$?"
bash code/CheckLabel.sh
echo "$?"
bash code/CheckLabel.sh birch
echo "$?"
bash code/CheckLabel.sh oak pine
echo "$?"
```

Checked on 17 November 2026: oak was accepted with status 0;
missing arguments produced a usage message and status 2;
birch produced an unknown-label message and status 1;
two arguments produced a usage message and status 2.

### Shell: CountLines.sh

Counts newline characters in a file using `wc -l`. Requires Bash and `wc`.
Pass the input file path as the first argument. The script prints the
count to the terminal and creates no output files.

Run these checks from the repository root:

```bash
shell_practice=$(mktemp -d)
printf 'species\tcount\noak\t12\n' > "$shell_practice/test.txt"
bash code/CountLines.sh "$shell_practice/test.txt"
echo "$?"
bash code/CountLines.sh "$shell_practice/missing.txt"
echo "$?"
```

Checked on 17 November 2026. The test file contained two newline
characters. The script reported 2 lines and returned status 0.
The original MQB example returned status 0 even when the file was
missing. After I added `|| exit 1`, the missing-file check printed
an error and returned status 1.

### Shell: ConcatenateTwoFiles.sh

Demonstrates file concatenation and the difference between writing
with > and appending with >>. Requires Bash and cat.
Arguments are two input file paths followed by an output file path.
The script writes the merged file and displays its contents.

Run these checks from the repository root:

```bash
shell_practice=$(mktemp -d)
printf 'oak\n' > "$shell_practice/first.txt"
printf 'pine\n' > "$shell_practice/second.txt"
bash code/ConcatenateTwoFiles.sh "$shell_practice/first.txt" "$shell_practice/second.txt" "$shell_practice/combined.txt"
echo "$?"
```

Repeat the final two commands to check that rerunning produces
the same two lines without duplicating them.

Checked on 17 November 2026. Normal and repeated runs produced oak
followed by pine with status 0. After adding argument-count validation,
calling without arguments printed usage and returned status 2.
After adding failure checks to both writing commands, a missing first
or second input printed an error and returned status 1.

The output path must be distinct from both inputs. Existing output
content is overwritten. A failed run can leave an empty or partially
written output file.

### Shell: tiff2_png.sh

Demonstrates a for loop, filename expansion and TIFF-to-PNG conversion.
Requires Bash, basename and ImageMagick 7 with the magick command.
I replaced the starter's convert command with magick for ImageMagick 7.

The script takes no arguments. It processes lowercase .tif files in
the current directory and writes same-name .png files there.
Existing PNG outputs are overwritten.

Run this check starting from the repository root:

```bash
project_root=$PWD
mkdir -p sandbox
image_practice=$(mktemp -d "$project_root/sandbox/tiff-test.XXXXXX")
magick -size 10x10 xc:red "$image_practice/red square.tif"
cd "$image_practice"
bash "$project_root/code/tiff2_png.sh"
echo "$?"
magick identify "red square.png"
cd "$project_root"
```

To check a repeated run, repeat the commands from cd "$image_practice"
onwards.

Checked on 17 November 2026 using ImageMagick 7.1.2-36.
The syntax check passed. Initial and repeated conversions returned
status 0 and produced a 10x10 PNG. The filename containing a space
was preserved.

Use a directory containing valid .tif files, with filenames that
do not begin with a hyphen. The teaching example does not handle
an empty directory explicitly or match uppercase .TIF extensions.
Temporary test images and generated PNGs remain outside Git.

### AI assistance for practice scripts

On 17 November 2026, I used ChatGPT to explain the MQB shell example,
including printf, positional parameters, quoting and interactive input,
and to help draft README documentation. I checked the explanations
against the MQB example and ran the script locally, comparing the
displayed parameters, updated strings and sums with expected values.

ChatGPT helped me understand why the missing-file check returned status 0
and suggested adding `|| exit 1`. I tested the change locally with both
a missing file and a two-line file.

ChatGPT helped explain failed concatenation checks and gave hints
on argument-count validation and stopping after a failed command.
I wrote the changes and checked normal runs, repeated runs,
missing arguments and missing input files locally.

ChatGPT explained the TIFF conversion loop and helped me check
dependencies, select the ImageMagick 7 command and prepare a small
test image. I ran the script twice and checked the output format,
dimensions and exit status locally.
