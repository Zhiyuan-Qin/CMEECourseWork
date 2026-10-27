# Assignment 3 formative feedback

This feedback is organised using the [Computing Bootcamp rubric](https://mulquabio.github.io/MQB/rubrics/Computing_Bootcamp_Rubric.html). It does not award a mark; use it to decide what to revise and check before final submission.

## Criterion 1: Repository organisation & workflow discipline

Before final submission, check that the required scripts are under `code/`, supplied inputs are under `data/`, and generated files remain outside Git.

## Criterion 2: Code completeness & functional correctness

- The fixed and generalised tree-height programs both ran and produced outputs that had the required columns and calculated height values. These are separate pieces of execution evidence; neither establishes all aspects of the other. Your code shows the degrees-to-radians conversion and checks before writing results. Your README records an independent first-record calculation, and the shell test includes a simple measurement case with assertions.
- Before final submission, **Make Pound Hill run independently from a clean project directory.** Execution stopped when writing the CSV because `results/` did not exist. Consequently, neither `results/pound_hill_plot_richness.csv` nor `results/pound_hill_plot_richness.pdf` was generated. The required script and inputs are present: the issue is output-directory preparation, not missing source work. Arrange for this program to create its output directory before writing, rather than relying on a tree-height script having run first. Compare the filenames it creates with both exact required paths; even a spelling difference matters.

## Criterion 3: Code quality & style

As you revise, keep names descriptive, use comments to explain decisions rather than restating code, and avoid repeating the same calculation in several places.

## Criterion 4: Documentation

- Before final submission, **Make the Pound Hill checks observable and actionable.** The code includes expressions checking missing counts, non-negative values and plot identifiers, but these do not stop processing when a condition is wrong, and bare expressions may not display their results under `Rscript`. Turn the important checks into explicit reports or simple assertions. This will make the route from reshaped measurements to the summary table easier to verify. Your README reports a successful fresh-session run, but the collected run did not reproduce it; update that account after testing without an existing `results/` directory.

## Criterion 5: Version-control practice

- Your root README documents Assignment 3 inputs, commands, dependencies and output names. The supplied input files match the originals. `.gitignore` excludes generated results and sandbox files, no generated results are tracked, and your Git history contains descriptive task-focused commits.

## Criterion 8: Basic error-handling & input validation

Test an ordinary case and an invalid case for each tree-height route, and confirm both the message shown and whether an output file was created or changed.

## Criterion 9: Problem-solving approach & method implementation

- The Pound Hill source follows the route from species counts to quadrat richness and then plot-level means. Your comments distinguish within-treatment variation from causal interpretation. These are useful observations from your code, not verification of the missing outputs or the claimed biological pattern.

## Criterion 10: Learning progression demonstration

Use this feedback as a revision checklist. Make the changes in small, descriptive commits, then add a short README note explaining what you changed and how you checked it. This will make your development from this formative checkpoint visible in the final portfolio.

## Priorities before final submission

- Run Pound Hill on its own from the directory containing `code/`, `data/` and the root `README.md`, with no existing generated results. Inspect the CSV, then open the PDF to check labels, plotted values and whether your biological interpretation is supported. No newly generated PDF was available for visual review here.
- Rerun one ordinary and one invalid case for **each** tree-height route. The invalid-input tests run for this feedback halted with distance-related messages and the expected no-output behaviour; confirm that the intended bad value triggers the error and that no new result is written. The function-interface test the expected exit but did not check its numerical output.
- Commit the repair and any revised run instructions with a descriptive message.
