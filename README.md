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

### How to run

The commands in `code/unixPrac1.txt` are intended to be entered from
the `code/` directory and therefore use `../data/` paths. They use
`wc`, `tail`, `tr`, `grep` and `awk`.

The converter commands below are run from the repository root.

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

### Testing

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

### Clean-checkout verification - 2026-11-19

I repeated the converter checks in a fresh local clone of commit
`5ccbcbb`, running both scripts from the repository root.
The tracked `data/tab-example.tsv` and a temporary file named
`input with spaces.tsv` both passed.

The generated paths were:
- `results/tab-example.tsv.csv`
- `results/tab-example.tsv.csv.txt`
- `results/input with spaces.tsv.csv`
- `results/input with spaces.tsv.csv.txt`

For each input, I ran each converter twice and compared the complete
output bytes with the expected character substitutions. These checks
confirmed that empty-field positions and line endings were preserved,
inputs remained unchanged and repeated runs replaced outputs rather
than appending to them. All converter calls and the verification
command returned status 0.

### Data and limitations

The FASTA and temperature input files were copied from the course materials.
`data/tab-example.tsv` is a small example I created for testing, containing an empty field.

The scripts perform simple character substitution and preserve empty fields.
They do not handle quoted CSV fields containing commas.
Spaces within CSV fields can make the space-delimited output ambiguous.

### AI use record

- Tool: ChatGPT / Codex.
- Date: 2026-10-08.
- Tasks: Assignment 1 UNIX practicals, shell scripts, testing, and README documentation.
- Purpose: Explain commands and shell syntax, help diagnose errors, suggest small code snippets and test commands, and help draft documentation.
- Verification: I ran the commands and scripts locally, inspected their outputs and exit statuses, checked script syntax with `bash -n`, and used `diff` to confirm that the tested input files remained unchanged.

ChatGPT supplied the additional clean-checkout verification code and
helped review the README against the feedback. I ran the checks locally
and inspected the reported output paths and exit status.

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

On 19 November 2026, I repeated the README cleaning and test commands
in a fresh local clone of commit `c99f7ef`. Both returned status 0.
The cleaner generated all three outputs, containing 24 accepted
records, 12 issue records and oak counts of 4 each for petraea and
robur. Additional checks confirmed that every input record was
accounted for, accepted records were sorted by identifier and the
raw CSV remained unchanged. Running the cleaner again produced
byte-identical copies of all three outputs.

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

ChatGPT reviewed the labelled tests against the feedback and supplied
the additional clean-checkout verification code. I ran it locally
and checked the record counts, oak summary, input preservation and
repeatability.

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

On 19 November 2026, I repeated the checks in a fresh local clone
of commit `7da90a4`. I ran the Pound Hill script first, with no
results/ directory present. It returned status 0 and created both
required outputs. The CSV contained 12 unique plots, with four
plots per treatment and finite, non-negative mean richness values.
I opened the newly generated PDF and checked its labels and plotted
values against the table.

TreeHeight.R and the documented tree-height shell checks also
returned status 0. For both full-data outputs, I checked all 120
rows, confirmed that the original columns and row order were
preserved, and compared every height with
distance * tan(angle * pi / 180). The toy example returned a height
of 8 metres.

In separate temporary directories, I tested both tree-height scripts
with a zero distance, first without an existing output and then
with a previously generated output. Both scripts returned status 1
with the expected distance-validation message. Neither created a
new output nor changed an existing one, and the test inputs remained
unchanged. The verification command returned status 0.

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

ChatGPT supplied additional clean-checkout, numerical comparison
and invalid-input verification code, and helped document the results.
I ran these checks locally, inspected the exit statuses and output
tables, and opened the newly generated Pound Hill PDF.

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

### Python: loops.py

Demonstrates for loops over a range and a mixed-type list,
a running total, and a while loop. Requires Python 3.
No arguments or input files are needed; output is printed
to the terminal and no files are created.

Run from the repository root:

```bash
python3 code/loops.py
echo "$?"
```

Checked on 17 November 2026. The output showed 0 through 4,
the six list elements in order, running totals of
0, 1, 12, 123 and 1234, and integers 1 through 100.
The script returned status 0.

### Python: cfexercises1.py

Demonstrates functions, conditionals, sorting three numbers,
and factorial calculations using for loops, recursion and while loops.
Requires Python 3. No input files are read and no output files are created.

Run these checks from the repository root:

```bash
python3 code/cfexercises1.py
echo "$?"
PYTHONPATH=code python3 -c "import cfexercises1"
echo "$?"
```

Checked on 18 November 2026. Direct execution produced 3.0,
8, [1, 2, 3], three results of 120 for factorial(5), and three
results of 1 for factorial(0). Both commands returned status 0.
Importing the module did not execute the example calls.

I extended foo_5's stopping condition to include zero, added
function docstrings, and placed example calls under a main guard.
The examples assume suitable numeric inputs. Factorial inputs
must be non-negative integers; validation is not implemented.
The recursive version is also limited by Python's recursion depth.

### Python: cfexercises2.py

Demonstrates loops combined with conditionals, remainder tests,
nested loops and break. Requires Python 3.
No arguments or input files are needed. Output is printed to the
terminal and no files are created.

Run from the repository root:

```bash
python3 code/cfexercises2.py
echo "$?"
```

Checked on 18 November 2026 in IPython and by direct execution.
The six example calls printed 4, 4, 14, 5, 8 and 6 greetings
respectively. The final example printed hello! 0 through hello! 5.
Direct execution returned status 0.

These teaching functions assume the example inputs.
For integer inputs, hello_4 reaches its stopping value only when
its initial x is at most 15 and 15 - x is divisible by 3.
With x=True, hello_6 requires an integer starting y below 6 to
reach its break condition. Other inputs can cause infinite loops.

### Python: MyExampleScript.py

Demonstrates defining a function, storing its returned value,
and displaying it using an f-string. Requires Python 3.
No arguments or input files are needed; no files are created.

Run from the repository root:

```bash
python3 code/MyExampleScript.py
echo "$?"
```

Checked on 18 November 2026. The script printed
"The square of 2 is 4" and returned status 0.

### Python: boilerplate.py

Demonstrates a main function, module and function docstrings,
and a main guard. Requires Python 3.
No arguments or input files are needed; no files are created.

Run from the repository root:

```bash
python3 code/boilerplate.py
echo "$?"
PYTHONPATH=code python3 -c "import boilerplate"
echo "$?"
```

Checked on 18 November 2026. Direct execution printed
"This is a boilerplate". Importing the module produced no output.
Both commands returned status 0.

### Python: using_name.py

Demonstrates how __name__ differs between direct execution and import.
Requires Python 3. No arguments or input files are needed;
no files are created.

Run from the repository root:

```bash
python3 code/using_name.py
echo "$?"
PYTHONPATH=code python3 -c "import using_name; print(using_name.module_name())"
echo "$?"
```

Checked on 18 November 2026. Direct execution printed
"This module's name is: __main__". After import, module_name()
returned using_name, which the explicit print call displayed.
The guarded main() did not run during import.
Both commands returned status 0.

### Python: sysargv.py

`code/sysargv.py` displays the script name, the number of supplied
command-line arguments and their values. Arguments are received as strings.

Run from the repository root:

```bash
python3 code/sysargv.py
echo "$?"

python3 code/sysargv.py oak 12
echo "$?"
```

Checked on 18 November 2026. Without arguments, the script reported
0 arguments and an empty list. With oak 12, it reported 2 arguments
and ['oak', '12']. Both commands returned status 0.

### Python: control_flow.py

`code/control_flow.py` contains the MQB examples for conditionals,
loops and reusable functions. Its main guard keeps the demonstration
output separate from importing the functions.

Run from the repository root:

```bash
python3 code/control_flow.py
echo "$?"

python3 -m doctest -v code/control_flow.py
echo "$?"

PYTHONPATH=code python3 -c "import control_flow"
echo "$?"
```

Checked on 18 November 2026. Direct execution displayed the expected
parity, divisor and prime results. All three doctest examples for
even_or_odd passed. Importing the module produced no demonstration
output. All three commands returned status 0.

### Python: test_control_flow.py

Imports functions from `control_flow.py` and checks their behaviour
using assertions. Requires Python 3 and the sibling `control_flow.py`;
no input files are needed and no files are created.

Run from the repository root:

```bash
python3 code/test_control_flow.py
echo "$?"
```

Checked on 18 November 2026. The supplied checks passed for parity,
divisors, primes and counting values strictly above a threshold.
Cases included zero, negative integers, an invalid text input,
values around the threshold and an empty list.
The script produced no output and returned status 0.

### Python: observations_practice.py

Reads observation records from CSV and summarises each site's known total
and missing counts. Exact duplicate records, identified by site, date and
count text, are counted once. Zero is a known count; a site with no known
counts has a total of None. Invalid records raise ValueError, including
invalid records belonging to other sites. Input records are not modified.

Requires Python 3 and the standard-library csv module.
The report uses data/bootcamp_observations.csv and prints to the terminal;
no output files are created.

Run from the repository root:

```bash
python3 code/observations_practice.py
echo "$?"
```

Checked on 18 November 2026. The report printed A: (2, 1) and B: (0, 0)
and returned status 0.

### Python: test_observations_practice.py

Checks count parsing, site filtering, exact duplicates, missing counts,
known zero counts, empty inputs, invalid records and unchanged input data.
Uses the ordinary, boundary and invalid bootcamp_observations CSV files
in data/. An additional E/F example was checked against the manually
predicted result (10, 1) for E.

Run from the repository root:

```bash
python3 code/test_observations_practice.py
echo "$?"
```

Checked on 18 November 2026. All active checks passed silently and the
command returned status 0. A deliberate check of the teaching example
suggested_total failed with status 1: it returned 0 for an all-missing
site where None was required. The failing assertion is retained as a
comment with an explanation. The implemented summarise_site distinguishes
an unknown total from a known zero.

### Python: debugme.py

Demonstrates debugging and exception handling using the MQB division
example. The final version uses try/except/else to report successful
divisions and handle division by zero. A main guard prevents the
demonstration from running during import.

Requires Python 3. No arguments or input files are needed, and no output
files are created. IPython was used for the interactive debugging steps.

Run from the repository root:

```bash
python3 code/debugme.py
echo "$?"
PYTHONPATH=code python3 -c "import debugme"
echo "$?"
```

Checked on 18 November 2026. The original example raised ZeroDivisionError.
Using IPython's %pdb and a temporary conditional breakpoint confirmed
x = 20, y = 0 and i = 19 at the failing iteration. The temporary breakpoint
was then removed. The final version printed 19 successful divisions and
one division-by-zero message. Direct execution and silent import both
returned status 0.

This is a teaching example using x = 20, not a general-purpose division
function. Its returned value is the last successful result, 20.0; this
does not represent the result of division by zero. Inputs that produce
no successful division can leave z undefined.

### R: basic_io.R

Demonstrates reading data, writing files, appending records and overwriting
files using the MQB input/output examples. Additional print statements
show the data dimensions and file contents after each writing step.

Requires R with base packages only.
Input: data/trees.csv.
Output: results/MyData.csv. The results directory is created if needed.

Run from the repository root:

```bash
Rscript code/basic_io.R
echo "$?"
```

The script writes to the same output file several times. The final file
is a space-separated table without column headers, with row names retained,
despite its .csv extension. It can be read using
read.table("results/MyData.csv", header = FALSE, row.names = 1).

Checked on 18 November 2026. The input contained 120 rows and 3 columns.
Direct execution returned status 0. Additional checks using source()
confirmed that the final output preserved all records and data values.
Running the script again produced identical final file contents.
The warning "appending column names to file" is expected during the
intermediate append demonstration; subsequent writes overwrite that content.

### R: boilerplate.R

Demonstrates defining and calling an R function. my_function prints the
class of each argument and returns a vector combining the two arguments.
The script includes numeric and character examples.

Requires R with base packages only.
No input files or command-line arguments are needed; no files are created.

Run from the repository root:

```bash
Rscript code/boilerplate.R
echo "$?"
```

To load the function into an interactive R session, start R from the
repository root and run:

```r
source("code/boilerplate.R")
ls(pattern = "my_fun")
class(my_function)
```

Checked on 18 November 2026. Direct execution printed the expected argument
classes and returned vectors, and exited with status 0. Sourcing the script
made my_function available as a function object. An additional mixed-input
call, my_function(1, "Tiki"), returned c("1", "Tiki") with class "character",
demonstrating type coercion when combining numeric and character values.

### R: control_flow.R

Demonstrates if/else conditions, for loops over numbers and character
vectors, and a while loop using the MQB examples. The random-number
example prints a message only when the generated value is at most 0.5.

Requires R with base packages only.
No arguments or input files are needed; no output files are created.

Run from the repository root:

```bash
Rscript code/control_flow.R
echo "$?"
Rscript -e 'source("code/control_flow.R"); stopifnot(i == 10)'
echo "$?"
```

Checked on 18 November 2026. The logical condition printed "a is TRUE".
The for loops printed ten square messages, three species messages and
the elements "a", "bc" and "def". The while loop printed the squares
from 1 to 100 and finished with i equal to 10. Direct execution and the
source check both returned status 0. The random conditional message
appeared in some runs and was absent in others, as expected.

### R: r_conditionals.R

`code/r_conditionals.R` demonstrates conditional branches, required and
default arguments, rounding, and checks for parity, powers of two and
prime numbers. It uses base R and requires no input files.

Run from the project root:

```bash
Rscript code/r_conditionals.R
```

The prime-number example includes an additional branch for `n == 2`.
Without this branch, `2:(n - 1)` produces `c(2, 1)` when `n` is 2,
causing the original example to classify 2 as composite. The prime
function is intended for single non-negative integers; the power-of-two
example is used with positive numbers.

Checked on 18 November 2026. The script ran successfully. Additional
console checks covered even and odd inputs, zero, default arguments,
an explicit rounding precision, powers of two and a non-power, and
prime classifications for 0, 1, 2, 3, 4 and 9. These checks returned
status 0 after correcting the prime-number boundary case. Deliberately
omitting the required arguments to `is.even()` and `report_height()`
produced errors and status 1, as expected.

### R: break.R

`code/break.R` demonstrates using `break` to leave a while loop.
It prints counter values from 0 to 9 and exits when the counter
reaches 10. It uses base R and requires no input files.

Run from the project root:

```bash
Rscript code/break.R
```

Checked on 18 November 2026. The script printed the ten expected
counter values, excluded 10 from the output and returned status 0.

### R: next.R

`code/next.R` demonstrates using `next` to skip the remainder of
a loop iteration. It loops over 1 to 10, skips even numbers and
prints only odd numbers. It uses base R and requires no input files.

Run from the project root:

```bash
Rscript code/next.R
```

Checked on 18 November 2026. The script printed 1, 3, 5, 7 and 9,
excluded the even numbers and returned status 0.

### R: try.R

`code/try.R` demonstrates catching errors during repeated sampling.
Each sample is drawn with replacement from a simulated population.
The function reports a mean only when the sample contains more than
30 distinct values; otherwise it raises an error. Both `lapply()`
and a for loop use `try()` to retain failed attempts and continue.

The script uses base R, sets a random seed and requires no input files.
Successful results contain text messages; failed results have class
`try-error`. Error messages remain visible because `silent = FALSE`.

Run from the project root:

```bash
Rscript code/try.R
```

Checked on 18 November 2026. Both methods completed all 15 attempts.
The lapply results retained two failures, and the for loop continued
despite three failures. The script returned status 0.

### R: browse.R

`code/browse.R` demonstrates inspecting an exponential-growth
simulation with `browser()`. The `debug` argument defaults to
`interactive()`: interactive calls pause inside the loop, while
Rscript runs complete without entering the debugger.

The script uses base R, requires no input files and saves a plot
to `results/exponential_growth.pdf`, creating `results` if needed.

Run from the project root:

```bash
Rscript code/browse.R
```

To explore the breakpoints, start R from the project root and run
`source("code/browse.R")`. At the browser prompt, inspect variables,
use `c` to continue to the next breakpoint, or `Q` to abort the run.

Checked on 18 November 2026. During interactive debugging, I inspected
the variables at generations 2 and 3, continued with `c` and aborted
with `Q`. The revised script ran with Rscript and returned status 0.
Additional checks confirmed that the ten default population values
matched `exp(0:9)` and that the output PDF existed and was non-empty.
These checks also returned status 0.

### R: observations_practice.R

`code/observations_practice.R` reads observation data as character
columns, checks the column names and required fields, validates counts
and then converts them to integers. Invalid counts produce an error
identifying the file, CSV line, column, value and expected format.

The summary removes exact duplicate rows before calculating
`total_known` and `missing_count` for each site. All-missing counts
produce an unknown total (`NA`), while observed zeros remain zero.

Inputs:
- `data/bootcamp_observations.csv`
- `data/bootcamp_observations_boundary.csv`

Output: `results/observations_known_totals.pdf`. The base-R plot
shows known totals and explicitly identifies site C as all-missing.

Run from the project root:

```bash
Rscript code/observations_practice.R
```

Checked on 19 November 2026. The script returned status 0 and passed
checks for A (2, 1), B (0, 0), C (NA, 2) and D (0, 0), where each
pair represents total known count and missing count. I inspected
the PDF and confirmed that zero values and the all-missing case
were distinguished. A separate call using
`data/bootcamp_observations_invalid.csv` rejected -1 on CSV line 2
with an informative error and status 1, as expected.

#### Comparison with Python

Missing counts, observed zeros and duplicate records have the same
meaning in both languages. Python uses None for the unknown total
in this exercise, while R uses NA. In R, summing all-missing counts
with `na.rm = TRUE` returns zero, so the all-missing case must be
checked before interpreting the sum.

Checking only the number of sites would not detect double-counting:
without deduplication, A would total 4 while the number of sites
would remain two. The check that A totals 2 detects this mistake.
Deduplication must compare complete rows, because separate genuine
observations can have equal counts.

An informative error for the other invalid entry would be:
`bootcamp_observations_invalid.csv: CSV line 3, column 'count': found 'many'; expected an empty field or a non-negative integer.`

### R: data_wrang.R

`code/data_wrang.R` follows the MQB starter script to reshape the
Pound Hill dataset using `reshape2`. It transposes the raw matrix,
sets column names, converts documented blank counts to zeros and
uses `melt()` to create a long table. Each row represents one
species count in one sampled quadrat.

Inputs:
- `data/pound_hill_data.csv`
- `data/pound_hill_meta_data.csv`

Output: `results/pound_hill_long.csv`.
Requires R and the `reshape2` package.

Run from the project root:

```bash
Rscript code/data_wrang.R
```

Checked on 19 November 2026. The script and additional output checks
returned status 0. The saved table contained 2419 rows and six columns,
representing 41 species across 59 sampled quadrats and 12 plots.
Counts were numeric, non-negative whole numbers without missing
values. No quadrat–species combination was duplicated. Quadrats
were identified using Cultivation, Block, Plot and Quadrat together.

### R: data_wrang_tidy.R

`code/data_wrang_tidy.R` adapts the MQB reshape2 starter using
`tidyr::pivot_longer()` to reshape species columns and
`dplyr::mutate()` with `across()` to convert column types.
It retains the same metadata-based treatment of blank counts.

Inputs:
- `data/pound_hill_data.csv`
- `data/pound_hill_meta_data.csv`

Output: `results/pound_hill_long_tidy.csv`.
Requires R and the `dplyr` and `tidyr` packages.

Run from the project root:

```bash
Rscript code/data_wrang_tidy.R
```

Checked on 19 November 2026. The script returned status 0 and
produced 2419 rows and six columns, with five factor columns and
integer counts. An initial type-conversion error arose because
single-column bracket selection on a tibble returned a table.
Replacing the original conversions with mutate and across resolved it.

Additional console checks confirmed matching column names and
dimensions and unique quadrat–species combinations. After sorting
both saved tables by Cultivation, Block, Plot, Quadrat and Species
and resetting row names, identical() confirmed that the reshape2
and tidyverse outputs matched. The comparison returned status 0.

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

On 18 November 2026, I used ChatGPT to explain the MQB functions,
recursion, docstrings and the main guard, and to help draft README
documentation. It gave hints for handling factorial(0) and suggested
small execution and import checks. I wrote the changes, ran the checks
locally and compared the returned values with expected results.

ChatGPT helped explain range, remainder tests, elif, nested loops
and break. I traced the examples, ran the script in IPython and
from the repository root, and checked all six greeting counts
against the expected results.

ChatGPT explained the f-string in MyExampleScript.py.
I ran the script locally and checked the displayed result and exit status.

ChatGPT explained how the main guard controls the call to main().
I checked direct execution and import locally, confirming the
expected output and exit statuses.

ChatGPT explained the different values of __name__ during direct
execution and import. I ran both checks locally and compared
the module names and exit statuses with the expected results.

ChatGPT explained how sys.argv stores the script name and command-line
arguments, and helped me check the output. I ran the script with no
arguments and with two arguments, and checked the exit status locally.

ChatGPT explained the control-flow functions, the doctest examples and
the main guard, and helped me interpret the check results. I ran the
script, checked its three doctest examples and confirmed that importing
the module produced no demonstration output.

ChatGPT explained how the separate test script imports the functions,
how assertions check results, and how the invalid-input and threshold
checks work. I reviewed and ran the supplied MQB tests locally and
checked the exit status.

ChatGPT provided staged hints and corrections while I implemented the
observation functions, explained the supplied checks, and helped construct
additional checks. ChatGPT suggested the E/F example, whose expected result
I calculated before testing, and guided the comparison with suggested_total.

ChatGPT guided me through the MQB debugging example, explained the
traceback, debugger commands and try/except/else behaviour, and helped
add the main guard. I ran the debugging steps and checked direct
execution and import locally.

ChatGPT explained the MQB input/output examples and supplied additional
inspection statements and checks for the saved data and repeated execution.
I ran the script and checks locally and reviewed the output and expected
append warning.

ChatGPT explained the MQB function example, the difference between printed
messages and returned values, and suggested a mixed-input check to
demonstrate vector type coercion. I ran the script and interactive checks
locally and reviewed the results.

ChatGPT explained the MQB conditional and loop examples and supplied an
additional check of the final loop counter. I ran the examples using
Rscript and source() and reviewed their output locally.

ChatGPT explained the conditional examples and the distinction between
required and default arguments, supplied additional console checks,
and helped identify why the original prime-number example misclassified
2. ChatGPT suggested an explicit branch for this boundary case. I added
the branch and ran the checks locally.

ChatGPT explained the MQB break and next examples, clarified the
difference between leaving a loop and skipping one iteration,
and helped me compare the observed output with the expected values.
I saved and ran both scripts locally.

ChatGPT explained the MQB sampling and error-catching examples,
including how try-error objects are retained in lists. It suggested
printing the result class and list lengths, and using separate names
for the lapply and loop results. I ran the script and inspected the
successful and failed attempts locally.

ChatGPT explained the MQB browser example and guided me through
inspecting variables, continuing execution and aborting a debug run.
It supplied an adaptation using `debug = interactive()` and PDF output,
plus checks against the expected exponential-growth values. I applied
the changes and ran the interactive and terminal checks locally.

On 19 November 2026, ChatGPT provided staged scaffolds, hints and
corrections for reading, validation, deduplication and grouped summaries.
I filled in the conditions and calculations and ran each stage locally.
ChatGPT supplied the result-table assembly, assertion checks and plotting
code, and explained the comparison questions when I was unsure.
I confirmed that failing to deduplicate would give A a total of 4
without changing the number of sites. ChatGPT helped draft this
documentation.

ChatGPT explained the MQB starter script and supplied additional
console checks for the saved long table. I ran the script and checks
locally and explained why the data were transposed and why the
metadata justified converting blanks to zeros. ChatGPT helped turn
my explanations into English comments and draft this documentation.

ChatGPT guided the adaptation of the MQB starter using pivot_longer,
supplied the mutate and across conversion code, and explained the
tibble-related type-conversion error. It also supplied console checks
to compare the two saved outputs after sorting. I applied the changes
and ran the script and comparison locally.
