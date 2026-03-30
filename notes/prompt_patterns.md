# Prompt Patterns For The Workshop

## Purpose

Collect reusable prompt patterns that teach disciplined use of Codex for scientific computing in Julia.

## Pattern 1: Restate The Mathematical Task

```text
Restate the numerical task in plain language before writing code.
List the mathematical assumptions, inputs, and outputs you are using.
Then propose a minimal Julia function signature.
Do not write a full notebook yet.
```

## Pattern 2: Ask For One Small Unit

```text
Implement only the smallest correct Julia function needed for this step.
Include one or two validation checks or tests.
Do not generate plotting, benchmarking, or extra abstractions yet.
```

## Pattern 3: Ground The Work In The Paper

```text
Compare this implementation plan against the paper's numerical experiment.
List every formula, stopping rule, initial condition, and parameter that is still ambiguous.
If anything is unclear, stop and identify the exact ambiguity instead of guessing.
```

## Pattern 4: Ask For A Reproducibility Check

```text
Write a Julia check that targets one specific table, figure, tolerance, or trend from the paper.
State the exact reference, the numeric threshold or qualitative trend to check, and what counts as a match.
Prefer a single bounded validation over broad reproduction claims.
```

## Pattern 5: Ask For A Benchmark Harness

```text
Build a minimal Julia benchmark harness for these algorithm variants.
Report exactly what is being timed, what accuracy metric is recorded, and what problem sizes are used.
Do not optimize prematurely.
```

## Pattern 6: Ask For A Notebook Cell, Not A Whole Notebook

```text
Write only the next Pluto cell for this workshop notebook.
Keep the cell self-contained and make sure it can be validated on its own.
Stop after that cell and summarize the test I should run.
```

## Anti-Patterns

- asking for a complete research codebase in one prompt
- asking for polished claims before validation
- asking for benchmarks without defining metrics and problem sizes
- asking for paper reproduction without extracting assumptions first
- asking Codex to "just implement the method" when the mathematical target is still vague
- accepting large untested code dumps that cannot be verified in small steps
