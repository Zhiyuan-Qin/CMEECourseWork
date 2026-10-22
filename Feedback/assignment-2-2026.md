# Assignment 2 formative feedback

This feedback is organised by the relevant computing bootcamp criteria. Use it to decide what is already working, what you need to investigate, and what to revise before the cumulative submission.

The full criteria are in the [Computing Bootcamp assessment rubric](https://github.com/MulQuaBio/MQB/blob/main/content/rubrics/Computing_Bootcamp_Rubric.md).

## 1. Repository organisation and workflow discipline

- Your root README, `.gitignore`, cleaning script, test script and supplied data files are in the expected locations. The supplied CSV and metadata are unchanged, giving you a reproducible starting point.

## 2. Code completeness and functional correctness

- Your cleaning script ran and generated all three outputs. Separately, output comparisons found that the clean records, issues and oak-count tables satisfied the required output format and contents in both test runs. The outputs are correct for the checked input; now make sure you can explain the method and test important edge cases.
- Run the tests and cleaning workflow again after any edits, checking that all three outputs are regenerated without changing the raw input.

## 3. Code quality and style

- Your `main()` function gives the program a clear overall structure by connecting loading, processing, summarising and writing. Keep these stages distinct as you revise; use descriptive names and add short comments where the reason for a validation check or data-cleaning step is not obvious.

## 4. Documentation

- Your root README is in place. Make it useful to someone opening the repository for the first time: explain what the cleaner does, how to run the script and tests from the repository root, and which three files it creates. Test the instructions in a newly cloned copy of your repository (a separate folder created with `git clone`): enter that folder and run each README command exactly as written. If something fails, correct the command or add the missing step.

## 5. Version-control practice

- Since the previous formative feedback was added, the saved history contains 2 non-merge commits. `Save Assignment 2 cleaner and initial test progress` followed by `Add tree-survey tests and usage documentation` gives a clear two-step record of implementation followed by testing and documentation.
- Keep this pattern for the final revisions. Before each commit, use `git diff --staged` to check that it contains one coherent, working change, then write a concise message that names that change and, where it is not obvious, why it was needed.

## 8. Basic error handling and input validation

- Your separate test file is present and ran successfully. Your test file includes assertion-style checks covering record validation, the accepted/rejected partition and the oak summary.
- **Make test coverage explicit.** The tests are top-level assertions; successful execution does not show that every important case is covered. Label or group the existing cases by behaviour, then check that they exercise a valid record, an invalid or boundary record, partitioning and summary behaviour. Add a focused assertion wherever that review reveals a gap; named test functions are an option, not a required redesign.
- Check that the root README explains the workflow and gives usable run and test commands. Test the instructions in a newly cloned copy of your repository (a separate folder created with `git clone`): enter that folder and run each README command exactly as written. If something fails, correct the command or add the missing step.

## 9. Problem-solving approach and method implementation

- Your code shows a connected workflow: `main()` calls `load_records()`, passes the rows to `process_records()` and its `validate_record()` checks, then receives `(accepted, issues)`. The cleaned collection feeds `summarise_oaks()`, and three `write_csv()` calls produce the outputs. The route from input to outputs is clear.
- No specific output defect was identified. Focus your revision on making the workflow easier to explain and verify:
- Before final submission, make this check visible in your repository. In `code/test_silwood_trees.py`, add or refine a small assertion-based test with one valid and one invalid record. Check that `process_records()` places them in the cleaned and issues collections respectively. Then pass the returned cleaned collection to `summarise_oaks()` and check that the invalid record does not contribute. Briefly explain this flow in your root README.
