# AI-Assisted Julia for Scientific Computing Research

## Purpose

This project prepares teaching material for a two-day workshop delivered in two sessions of two hours each. The workshop teaches academic researchers how to use Codex in a disciplined way to produce, validate, and extend Julia code for scientific computing tasks that arise in mathematical research.

The workshop is not a Julia course and not a general AI-tools survey. It is a guided workflow workshop centered on one end-to-end paper reproduction, supported by a smaller toy example that teaches the AI-assisted coding loop safely.

## Working Title

Recommended title:

- `AI-Assisted Julia for Scientific Computing Research`

Alternative titles:

- `Reproducible Scientific Computing in Julia with Codex`
- `AI-Powered Julia Workflows for Mathematical Research`

## Audience And Prerequisites

### Audience

- Junior faculty
- Graduate students
- Primary domain: mathematics and related quantitative research areas

### Required Prerequisites

Attendees must already be comfortable with basic programming concepts:

- variables
- functions
- loops
- arrays
- reading and modifying code

Julia may be new. Numerical analysis background may vary.

Attendees must also bring their own laptops with the required software installed and ready before the workshop. At minimum, this includes:

- Codex access configured and working
- Julia installed
- any workshop prerequisite software specified in advance

The workshop should assume these tools are already functional at the start of Session 1.

### Non-Goal

The workshop will not teach programming from scratch. This requirement should be stated explicitly in the workshop description so the material can stay focused on AI-assisted scientific computing rather than beginner coding.

The workshop will also not allocate core teaching time to participant installation and environment setup beyond brief verification.

## Primary Outcome

The main participant deliverable is one solid end-to-end reproduced numerical experiment from a published paper.

The workshop should optimize for depth rather than breadth. Benchmarking is a core extension after reproduction. Sensitivity analysis is secondary and should be included only if it fits naturally and time permits.

## Chosen Workshop Structure

The selected structure is:

- `Scaffolded Workflow-to-Paper`

This means the workshop starts with a small academic-style numerical example to teach the workflow, then moves to one carefully chosen real paper as the main case study, and finally extends that reproduction into a benchmark exercise.

### Reason For Choosing This Structure

- It reduces risk for an audience with uneven Julia experience.
- It gives participants a controlled first success before the main paper.
- It preserves the main goal of one meaningful paper reproduction.
- It creates a natural path into benchmarking.

## Tool Positioning

The workshop will teach tool-agnostic habits for AI-assisted scientific computing, but Codex will be the required tool used in the workshop.

This positioning should be reflected in the material:

- the workflow lessons should generalize
- the live examples and prompts should assume Codex
- participants should use Codex during the workshop

## Session Design

## Session 1

### Part 1: Setup And Workflow

Participants learn the minimum Julia and Pluto stack required for the workshop:

- Julia environment and packages
- Pluto notebooks
- plotting and reproducibility basics
- how Codex will be used during the workshop

### Part 2: Toy Academic Example

Participants work through a small academic-style numerical task. The purpose is to teach the workflow:

- state the task clearly
- prompt Codex for a small unit of code
- inspect the result
- run and test it
- correct errors
- document assumptions

The example should be simple enough to finish cleanly and meaningful enough to feel academic rather than contrived.

### Part 3: Transition To The Main Paper

Participants are introduced to the selected paper and the specific numerical experiment to reproduce. The notebook should identify:

- what result will be reproduced
- what algorithmic ingredients are needed
- what data, parameters, and outputs are required
- what parts are straightforward versus uncertain

## Session 2

### Part 1: Complete The Reproduction

Participants finish implementing and validating the numerical experiment from the selected paper.

### Part 2: Benchmark Extension

The reproduction is turned into a small benchmark study. This may compare:

- implementation variants
- parameter choices
- problem sizes
- runtime and accuracy trade-offs

### Part 3: Validation And Extension

The workshop closes by emphasizing scientific validation and AI failure modes. If the selected example supports it cleanly, a light sensitivity-analysis extension can be added at the end.

## Notebook Set

The teaching material in `/material` should contain four Pluto notebooks and one reproducible Julia environment.

### `00_setup_and_stack.jl`

Purpose:

- minimal Julia introduction needed for the workshop
- Pluto usage
- package management
- plotting
- reproducibility practices
- Codex workflow conventions used throughout the workshop

### `01_ai_workflow_toy_example.jl`

Purpose:

- teach the AI-assisted coding loop on a safe academic example

Candidate example families:

- root-finding
- interpolation
- fixed-point iteration
- simple iterative linear algebra

Selection criterion:

- mathematically respectable
- easy to validate
- small enough to complete reliably during the session

### `02_paper_reproduction.jl`

Purpose:

- the main workshop notebook
- reproduce one numerical experiment from a selected paper
- clearly separate paper interpretation, code generation, validation, and documented corrections

The notebook must record:

- the target experiment
- the extracted assumptions
- implementation steps
- checks against the paper
- any mismatches or uncertainties

### `03_benchmark_and_extensions.jl`

Purpose:

- extend the reproduced implementation into a benchmark study
- add sensitivity analysis only if it fits naturally

This notebook should make benchmarking choices explicit:

- metrics
- parameter settings
- hardware or environment notes when relevant
- experiment design

## Supporting Notes

The project should maintain the following planning files in `/notes`:

### `paper_selection.md`

Evaluate candidate papers against workshop-fit criteria:

- academic legitimacy
- implementation difficulty
- clarity of numerical experiment section
- reproducibility risk
- suitability for benchmarking extension
- suitability for a four-hour total teaching window

### `prompt_patterns.md`

Collect reusable prompt patterns and anti-patterns for Codex, including:

- asking for small units
- asking for tests
- asking for explicit assumptions
- asking for benchmarking harnesses
- prompts to avoid because they encourage large unverified code dumps

## Teaching Method

The workshop should teach a repeatable scientific coding discipline, not merely prompting for code.

Each notebook should explicitly model the following habits:

- state the mathematical task before prompting
- ask for small, testable units
- verify formulas and edge cases against the paper
- compare outputs with expected qualitative behavior
- annotate every manual correction
- separate `generated by AI` from `validated by us`

## Scientific Quality Bar

The material should satisfy the following standard:

- every important result is reproducible from a clean environment
- figures and tables are generated by code, not pasted manually
- any mismatch with the paper is documented explicitly
- benchmark claims are tied to defined metrics and settings

## Failure Modes To Teach Explicitly

The workshop should include explicit discussion of these risks:

- wrong mathematical interpretation
- plausible but unvalidated Julia code
- hidden package or version assumptions
- benchmarking mistakes
- claiming reproduction success when only broad trends match and exact results do not

## Immediate Next Step

The next planning phase should produce:

- paper selection criteria and candidate shortlist
- notebook-level learning objectives
- a concrete implementation plan for files under `/notes` and `/material`

This plan should assume there is currently no existing workshop code in the repository beyond the `refs/` and `notes/` directories.
