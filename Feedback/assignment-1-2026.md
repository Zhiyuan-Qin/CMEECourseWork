# Assignment 1 feedback - Zhiyuan Qin

**Formative feedback | Rubric 2026.2**

Your README is useful: it records specific tests, limitations and a dated account of assistance and verification. The own TSV includes an empty field, generated results are ignored, and all five FASTA answers matched the independent checks. The converter sources also have consistent validation and explicit creation/conversion error handling.

The main remaining issue is the shared ../results convention. It assumes both converters are launched from code/, while the released interface starts from the repository root. Correct that convention and the README examples together, without losing the useful checking already in place.

Repeat the clean-checkout tests after the correction. Keep the empty-field and input-preservation checks, add a spaced filename and confirm that a second run replaces the output rather than accumulating it. Record the actual corrected output paths and observations. A test account is most useful when it describes the version someone is about to run.

There is no need to replace the valid wc -m or awk methods merely to match another solution. Keep explaining why they work for these inputs and list the tools used. Most assessed work is bundled into one completion commit; make the next revisions smaller and task-specific so their purpose is visible. This is a focused reproducibility fix, not a reason to add unnecessary machinery.

---

## Project structure

Relevant tracked layout (simplified; missing required paths are marked):

```text
README.md
.gitignore
code/  unixPrac1.txt, tabtocsv.sh, csvtospace.sh
data/fasta/  3 required files present
data/temperatures/  4 required files present
data/tab-example.tsv
results/  no files tracked; generated on run
sandbox/  no files tracked; optional
```

The root README, ignore file, assessed scripts and all input paths are present. The own TSV is usable, and results, sandbox and local environments are ignored without tracked files in those locations. The structure already separates reusable inputs from generated material.

Retain that separation. Align the converter paths and README examples with root-based execution, and let results/ be created when needed. A missing tracked output directory is not a missing submission component; there is no need to commit generated files just to make the tree look complete.

**Assessed snapshot:** `b025ecaa09c0ddbd8eadefc1a51c4c00dbad6dfa`
