# Workshop Material Buildout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the planning artifacts and Pluto-based Julia teaching materials for a two-session workshop on using Codex to produce, validate, reproduce, and extend scientific computing workflows in Julia.

**Architecture:** The project is split into two layers. The `notes/` layer captures workshop decisions, paper-selection criteria, and reusable prompt patterns. The `material/` layer contains a reproducible Julia environment and four Pluto notebooks that progress from setup and workflow, to a toy academic example, to a real paper reproduction, and finally to benchmarking and optional sensitivity analysis.

**Tech Stack:** Julia, Pluto.jl, Markdown, Project.toml/Manifest.toml, basic plotting and benchmarking packages selected to match the final paper choice

---

### Task 1: Create The Planning Notes Backbone

**Files:**
- Create: `notes/paper_selection.md`
- Create: `notes/prompt_patterns.md`
- Modify: `notes/2026-03-30-workshop-design.md`

- [ ] **Step 1: Write the failing structure check for the planning files**

Use this PowerShell check from `D:\Dropbox\Research\Presentations\Workshops\Julia2026`:

```powershell
Test-Path notes/paper_selection.md
Test-Path notes/prompt_patterns.md
```

Expected:

```text
False
False
```

- [ ] **Step 2: Create `notes/paper_selection.md` with a rubric and decision table**

Write this initial content:

```md
# Paper Selection

## Purpose

Choose one paper that is academically respectable, implementable in a workshop setting, and suitable for Codex-assisted Julia reproduction plus a benchmark extension.

## Selection Criteria

| Criterion | Weight | What Good Looks Like |
| --- | ---: | --- |
| Numerical experiment clarity | 5 | The paper states inputs, parameters, and outputs clearly. |
| Implementation complexity | 5 | A clean baseline version can be coded in workshop time. |
| Validation tractability | 5 | Results can be checked by plots, tables, or known trends. |
| Benchmark extension potential | 4 | The implementation can be extended into runtime/accuracy comparisons. |
| Sensitivity-analysis potential | 2 | Optional parameter variation is meaningful but not required. |
| Data/setup burden | 4 | No heavy external data pipeline is needed. |
| Workshop fit | 5 | The core experiment fits inside the two-session narrative. |

## Candidate Table

| Candidate | Source | Experiment Target | Complexity | Benchmark Potential | Risks | Decision |
| --- | --- | --- | --- | --- | --- | --- |
| `aFairagShahraniTawfiq2016SIAMJMATRIX` | `refs/895 - aFairagShahraniTawfiq2016SIAMJMATRIX.pdf` | Fill after review | High/Medium/Low | High/Medium/Low | Brief risk summary | Keep/Reject |
| `Ibrahim2023 spectral three-term derivative-free` | `refs/Ibrahim et al. - 2023 - Two classes of spectral three-term derivative-free.pdf` | Fill after review | High/Medium/Low | High/Medium/Low | Brief risk summary | Keep/Reject |
| `NMS_DEED_MPSGrid_DR` | `refs/NMS_DEED_MPSGrid_DR.pdf` | Fill after review | High/Medium/Low | High/Medium/Low | Brief risk summary | Keep/Reject |

## Decision Rule

Pick the paper that best supports the workflow-first teaching goal, even if it is not the most mathematically sophisticated paper under consideration.
```

- [ ] **Step 3: Create `notes/prompt_patterns.md` with Codex prompt templates**

Write this initial content:

```md
# Prompt Patterns For The Workshop

## Purpose

Collect prompt patterns that teach disciplined use of Codex for scientific computing in Julia.

## Pattern 1: Ask For Problem Restatement

```text
Restate the numerical task in plain language before writing code.
List the mathematical assumptions you are making.
Then propose a minimal Julia function signature.
Do not write a full notebook yet.
```

## Pattern 2: Ask For Small Testable Units

```text
Implement only the smallest correct Julia function needed for this step.
Also provide one or two simple tests or validation checks.
Do not generate plotting, benchmarking, or extra abstractions yet.
```

## Pattern 3: Ask For Paper-Grounded Validation

```text
Compare this implementation plan against the numerical experiment description from the paper.
List any values, formulas, stopping criteria, or initial conditions that are still ambiguous.
```

## Pattern 4: Ask For Benchmark Harnesses

```text
Build a minimal Julia benchmark harness for these algorithm variants.
Report clearly what is being timed and what accuracy metric is being recorded.
Do not optimize prematurely.
```

## Anti-Patterns

- asking for a complete research codebase in one prompt
- asking for polished claims before validation
- asking for benchmarks without defining metrics
- asking for paper reproduction without extracting assumptions first
```

- [ ] **Step 4: Run a content check**

Run:

```powershell
Get-Content -Raw notes/paper_selection.md
Get-Content -Raw notes/prompt_patterns.md
```

Expected:

```text
Both files display Markdown content with headings, a rubric/template, and reusable prompt patterns.
```

- [ ] **Step 5: Commit**

Run:

```bash
git add notes/paper_selection.md notes/prompt_patterns.md notes/2026-03-30-workshop-design.md
git commit -m "docs: add workshop planning notes"
```

Expected:

```text
If the workspace is not a git repository, skip this commit step and record that limitation in the work log.
```

### Task 2: Shortlist And Select The Workshop Paper

**Files:**
- Modify: `notes/paper_selection.md`
- Read: `refs/895 - aFairagShahraniTawfiq2016SIAMJMATRIX.pdf`
- Read: `refs/Ibrahim et al. - 2023 - Two classes of spectral three-term derivative-free.pdf`
- Read: `refs/NMS_DEED_MPSGrid_DR.pdf`

- [ ] **Step 1: Write the failing evidence check**

Run:

```powershell
Select-String -Path notes/paper_selection.md -Pattern "Recommended Paper|Rejected Candidates|Why This Fits"
```

Expected:

```text
No matches are returned yet.
```

- [ ] **Step 2: Read the candidate papers and extract workshop-relevant metadata**

For each paper, record one section using this exact structure:

```md
## aFairagShahraniTawfiq2016SIAMJMATRIX

- Problem type:
- Core algorithmic ingredients:
- Numerical experiment target:
- Inputs/data required:
- Figures/tables that appear reproducible:
- Likely Julia package needs:
- Main workshop risks:

## Ibrahim2023 spectral three-term derivative-free

- Problem type:
- Core algorithmic ingredients:
- Numerical experiment target:
- Inputs/data required:
- Figures/tables that appear reproducible:
- Likely Julia package needs:
- Main workshop risks:

## NMS_DEED_MPSGrid_DR

- Problem type:
- Core algorithmic ingredients:
- Numerical experiment target:
- Inputs/data required:
- Figures/tables that appear reproducible:
- Likely Julia package needs:
- Main workshop risks:
```

Append those entries under a new `## Candidate Reviews` section in `notes/paper_selection.md`.

- [ ] **Step 3: Score each paper against the rubric**

Add a scored table like this:

```md
## Scored Comparison

| Candidate | Experiment Clarity | Complexity | Validation | Benchmark | Setup Burden | Workshop Fit | Total |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Paper 1 | 4 | 3 | 4 | 4 | 5 | 4 | 24 |
```

- [ ] **Step 4: Record the final recommendation and rejection reasons**

Add this section structure:

```md
## Recommended Paper

**Choice:** Write the exact title of the selected paper here.

### Why This Fits

- workflow-first rather than derivation-heavy
- main experiment is narrow enough to reproduce in session time
- benchmark extension is natural

## Rejected Candidates

### First rejected paper

- explain the strongest reason it is not workshop-fit
- explain whether the issue is mathematical heaviness, unclear experiments, or setup burden

### Second rejected paper

- explain the strongest reason it is not workshop-fit
- explain whether the issue is mathematical heaviness, unclear experiments, or setup burden
```

- [ ] **Step 5: Run a review check**

Run:

```powershell
Get-Content -Raw notes/paper_selection.md
```

Expected:

```text
The file contains candidate reviews, a scored comparison, one recommended paper, and explicit reasons for rejecting the others.
```

- [ ] **Step 6: Commit**

Run:

```bash
git add notes/paper_selection.md refs
git commit -m "docs: shortlist workshop paper"
```

Expected:

```text
If the workspace is not a git repository, skip this commit step and record that limitation in the work log.
```

### Task 3: Scaffold The Reproducible Julia Material Environment

**Files:**
- Create: `material/Project.toml`
- Create: `material/README.md`
- Create: `material/00_setup_and_stack.jl`

- [ ] **Step 1: Write the failing file check**

Run:

```powershell
Test-Path material/Project.toml
Test-Path material/README.md
Test-Path material/00_setup_and_stack.jl
```

Expected:

```text
False
False
False
```

- [ ] **Step 2: Create `material/Project.toml` with a minimal starter environment**

Write:

```toml
[deps]
BenchmarkTools = "6e4b80f9-93f8-5d43-8f7b-1f6f09d2f417"
DelimitedFiles = "8bb1440f-4735-579b-a4ab-409b98df4dab"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
```

Leave `Manifest.toml` to be generated only after package installation succeeds.

- [ ] **Step 3: Create `material/README.md` with workshop run instructions**

Write:

```md
# Workshop Material

## Purpose

This directory contains the Pluto notebooks and Julia environment for the workshop.

## Expected Workflow

1. Activate this environment.
2. Install dependencies.
3. Start Pluto.
4. Open notebooks in order from `00_` to `03_`.

## Notes

- Participants are expected to arrive with Julia and Codex already working.
- The workshop emphasizes validation of AI-generated code, not blind acceptance.
```

- [ ] **Step 4: Create `material/00_setup_and_stack.jl` as a Pluto notebook skeleton**

Use this starter content:

```julia
### A Pluto.jl notebook ###

# v0.20.0

using Markdown
using InteractiveUtils

# ╔═╡ 00000000-0000-0000-0000-000000000001
md"""
# Setup And Stack

This notebook introduces the minimum Julia and Pluto workflow needed for the workshop.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
md"""
## Learning Goals

- understand the workshop environment
- activate the Julia project
- understand the Codex workflow we will use
- run simple Julia cells and inspect outputs
"""

# ╔═╡ 00000000-0000-0000-0000-000000000003
md"""
## Packages And Environment

This section will explain the project environment and package setup.
"""
```

- [ ] **Step 5: Run a file presence check**

Run:

```powershell
Get-ChildItem material
```

Expected:

```text
The directory contains Project.toml, README.md, and 00_setup_and_stack.jl.
```

- [ ] **Step 6: Commit**

Run:

```bash
git add material/Project.toml material/README.md material/00_setup_and_stack.jl
git commit -m "feat: scaffold workshop material environment"
```

Expected:

```text
If the workspace is not a git repository, skip this commit step and record that limitation in the work log.
```

### Task 4: Build The Setup And Workflow Notebook

**Files:**
- Modify: `material/00_setup_and_stack.jl`

- [ ] **Step 1: Write the failing content check**

Run:

```powershell
Select-String -Path material/00_setup_and_stack.jl -Pattern "Failure Modes|Prompt Discipline|Bring Your Own Laptop"
```

Expected:

```text
No matches are returned yet.
```

- [ ] **Step 2: Add workshop logistics and prerequisites cells**

Insert a Markdown cell with content like:

```julia
md"""
## Before We Start

- bring your own laptop
- Julia must already be installed
- Codex access must already be working
- package installation should be verified before the live session
"""
```

- [ ] **Step 3: Add the Codex workflow discipline section**

Insert:

```julia
md"""
## Prompt Discipline

Our workflow in this workshop is:

1. restate the mathematical task
2. identify assumptions
3. ask for a small Julia unit
4. test or validate that unit
5. extend only after verification
"""
```

- [ ] **Step 4: Add the AI failure mode section**

Insert:

```julia
md"""
## Failure Modes

- mathematically wrong interpretation
- plausible but unvalidated code
- hidden assumptions
- benchmarking errors
- unsupported claims of successful reproduction
"""
```

- [ ] **Step 5: Run a content check**

Run:

```powershell
Get-Content -Raw material/00_setup_and_stack.jl
```

Expected:

```text
The notebook contains setup logistics, workflow discipline, and failure mode sections.
```

- [ ] **Step 6: Commit**

Run:

```bash
git add material/00_setup_and_stack.jl
git commit -m "feat: add setup and workflow notebook content"
```

Expected:

```text
If the workspace is not a git repository, skip this commit step and record that limitation in the work log.
```

### Task 5: Build The Toy Example Notebook

**Files:**
- Create: `material/01_ai_workflow_toy_example.jl`
- Modify: `notes/prompt_patterns.md`

- [ ] **Step 1: Write the failing file check**

Run:

```powershell
Test-Path material/01_ai_workflow_toy_example.jl
```

Expected:

```text
False
```

- [ ] **Step 2: Select one toy example and record the rationale**

Append to `notes/prompt_patterns.md`:

```md
## Toy Example Choice

**Choice:** Root-finding with Newton's method on a scalar nonlinear equation

### Why This Example

- mathematically recognizable to the audience
- easy to validate with small checks
- can be implemented incrementally with Codex
```

- [ ] **Step 3: Create `material/01_ai_workflow_toy_example.jl`**

Use this skeleton:

```julia
### A Pluto.jl notebook ###

# v0.20.0

using Markdown
using InteractiveUtils
using LinearAlgebra
using Plots

# ╔═╡ 10000000-0000-0000-0000-000000000001
md"""
# AI Workflow Toy Example
"""

# ╔═╡ 10000000-0000-0000-0000-000000000002
md"""
## Problem Statement

State the small numerical task in mathematical language before generating code.
"""

# ╔═╡ 10000000-0000-0000-0000-000000000003
md"""
## Codex Prompt

Show the exact prompt used for the first small code unit.
"""

# ╔═╡ 10000000-0000-0000-0000-000000000004
md"""
## Validation

Check the generated code on simple test cases and explain any manual correction.
"""
```

- [ ] **Step 4: Add one minimal executable example cell**

Include something concrete such as:

```julia
f(x) = x^2 - 2

xs = range(0, 2; length=200)
plot(xs, f.(xs), xlabel="x", ylabel="f(x)", label="f(x)")
```

Use the equivalent code for the chosen toy example if root-finding is not selected.

- [ ] **Step 5: Run a content check**

Run:

```powershell
Get-Content -Raw material/01_ai_workflow_toy_example.jl
```

Expected:

```text
The notebook contains a problem statement, an explicit prompt section, validation notes, and one executable example cell.
```

- [ ] **Step 6: Commit**

Run:

```bash
git add material/01_ai_workflow_toy_example.jl notes/prompt_patterns.md
git commit -m "feat: add toy workflow notebook"
```

Expected:

```text
If the workspace is not a git repository, skip this commit step and record that limitation in the work log.
```

### Task 6: Build The Paper Reproduction Notebook

**Files:**
- Create: `material/02_paper_reproduction.jl`
- Modify: `notes/paper_selection.md`

- [ ] **Step 1: Write the failing file check**

Run:

```powershell
Test-Path material/02_paper_reproduction.jl
```

Expected:

```text
False
```

- [ ] **Step 2: Record the target experiment in the paper-selection notes**

Append:

```md
## Workshop Experiment Target

- selected figure/table:
- exact claim we want to reproduce:
- required inputs and parameters:
- acceptance criteria for a successful workshop reproduction:
```

- [ ] **Step 3: Create `material/02_paper_reproduction.jl`**

Use this skeleton:

```julia
### A Pluto.jl notebook ###

# v0.20.0

using Markdown
using InteractiveUtils
using LinearAlgebra
using Statistics
using Plots

# ╔═╡ 20000000-0000-0000-0000-000000000001
md"""
# Paper Reproduction
"""

# ╔═╡ 20000000-0000-0000-0000-000000000002
md"""
## Paper And Experiment

State the chosen paper and the exact numerical experiment target.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000003
md"""
## Assumptions Extracted From The Paper

List formulas, parameters, stopping criteria, and any ambiguities.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000004
md"""
## Implementation Notes

Build the code in small validated pieces. Record manual corrections explicitly.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000005
md"""
## Comparison To The Paper

Document what matches, what differs, and what remains uncertain.
"""
```

- [ ] **Step 4: Add a placeholder validation cell for computed outputs**

Insert a cell shaped like:

```julia
md"""
## Validation Checklist

- reproduce the target trend, figure, or table
- compare key values with the paper
- record any mismatch explicitly
"""
```

- [ ] **Step 5: Run a content check**

Run:

```powershell
Get-Content -Raw material/02_paper_reproduction.jl
```

Expected:

```text
The notebook contains experiment definition, extracted assumptions, implementation notes, and comparison sections.
```

- [ ] **Step 6: Commit**

Run:

```bash
git add material/02_paper_reproduction.jl notes/paper_selection.md
git commit -m "feat: scaffold paper reproduction notebook"
```

Expected:

```text
If the workspace is not a git repository, skip this commit step and record that limitation in the work log.
```

### Task 7: Build The Benchmark And Extension Notebook

**Files:**
- Create: `material/03_benchmark_and_extensions.jl`

- [ ] **Step 1: Write the failing file check**

Run:

```powershell
Test-Path material/03_benchmark_and_extensions.jl
```

Expected:

```text
False
```

- [ ] **Step 2: Create `material/03_benchmark_and_extensions.jl`**

Use this skeleton:

```julia
### A Pluto.jl notebook ###

# v0.20.0

using Markdown
using InteractiveUtils
using BenchmarkTools
using Statistics
using Plots

# ╔═╡ 30000000-0000-0000-0000-000000000001
md"""
# Benchmark And Extensions
"""

# ╔═╡ 30000000-0000-0000-0000-000000000002
md"""
## Benchmark Question

State exactly what variants will be compared and which metrics matter.
"""

# ╔═╡ 30000000-0000-0000-0000-000000000003
md"""
## Benchmark Protocol

- fixed problem sizes
- fixed tolerance or stopping rule
- clearly named runtime and accuracy metrics
"""

# ╔═╡ 30000000-0000-0000-0000-000000000004
md"""
## Optional Sensitivity Analysis

Only include this section if the selected paper has a natural parameter study.
"""
```

- [ ] **Step 3: Add a minimal benchmark code example**

Insert:

```julia
dummy_algorithm(n) = sum(1:n)

@benchmark dummy_algorithm(10_000)
```

Replace the dummy function with the paper-specific baseline once the reproduction notebook has working code.

- [ ] **Step 4: Add result-reporting guidance**

Insert:

```julia
md"""
## Reporting Rules

- define every metric
- keep hardware and environment notes visible
- do not claim superiority without context
"""
```

- [ ] **Step 5: Run a content check**

Run:

```powershell
Get-Content -Raw material/03_benchmark_and_extensions.jl
```

Expected:

```text
The notebook contains benchmark question, protocol, minimal example code, and reporting guidance.
```

- [ ] **Step 6: Commit**

Run:

```bash
git add material/03_benchmark_and_extensions.jl
git commit -m "feat: add benchmark notebook scaffold"
```

Expected:

```text
If the workspace is not a git repository, skip this commit step and record that limitation in the work log.
```

### Task 8: Generate The Julia Environment And Verify The Workshop Flow

**Files:**
- Create: `material/Manifest.toml`
- Modify: `material/README.md`
- Verify: `material/00_setup_and_stack.jl`
- Verify: `material/01_ai_workflow_toy_example.jl`
- Verify: `material/02_paper_reproduction.jl`
- Verify: `material/03_benchmark_and_extensions.jl`

- [ ] **Step 1: Write the failing manifest check**

Run:

```powershell
Test-Path material/Manifest.toml
```

Expected:

```text
False
```

- [ ] **Step 2: Instantiate the Julia environment**

Run:

```powershell
julia --project=material -e "using Pkg; Pkg.instantiate()"
```

Expected:

```text
Package resolution succeeds and material/Manifest.toml is created.
```

- [ ] **Step 3: Add environment verification instructions to `material/README.md`**

Append:

```md
## Verification

Run:

```powershell
julia --project=material -e "using Pkg; Pkg.instantiate()"
```

Then launch Pluto and open the notebooks in order.
```

- [ ] **Step 4: Run a basic notebook syntax check**

Run:

```powershell
julia --project=material -e "include(\"material/00_setup_and_stack.jl\"); include(\"material/01_ai_workflow_toy_example.jl\"); include(\"material/02_paper_reproduction.jl\"); include(\"material/03_benchmark_and_extensions.jl\")"
```

Expected:

```text
The files load without syntax errors. If Pluto metadata or execution order causes issues, adjust the check to a lighter parse-based validation and document the reason.
```

- [ ] **Step 5: Review the end-to-end workshop story**

Use this checklist:

```md
- notebook 00 explains setup and workflow clearly
- notebook 01 provides a safe first win
- notebook 02 has one explicit reproducibility target
- notebook 03 extends into benchmarking without changing the core story
- all notes align with the selected paper and stated prerequisites
```

Record any gaps directly in the relevant file and resolve them before closing the task.

- [ ] **Step 6: Commit**

Run:

```bash
git add material/Manifest.toml material/README.md material/00_setup_and_stack.jl material/01_ai_workflow_toy_example.jl material/02_paper_reproduction.jl material/03_benchmark_and_extensions.jl notes/paper_selection.md notes/prompt_patterns.md
git commit -m "feat: verify workshop material flow"
```

Expected:

```text
If the workspace is not a git repository, skip this commit step and record that limitation in the work log.
```
