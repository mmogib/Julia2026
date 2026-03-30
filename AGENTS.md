# AGENTS.md

## Project Purpose

This repository prepares the teaching material for a two-day workshop on AI-assisted Julia for scientific computing research.

Current workshop shape:

- two days
- one 2-hour session on each day
- hands-on format
- audience: junior faculty and graduate students in mathematics and related quantitative research areas

Participants are expected to:

- bring their own laptops
- have Julia installed and working before the workshop
- have Codex installed/configured and working before the workshop
- already be comfortable with basic programming concepts

The workshop is not an introduction to programming from scratch.

## Repository State

The workshop material has been merged into `main`.

The historical git worktree used for isolated implementation was:

- `./.worktrees/workshop-material-build`

The source of truth is now the main checkout.

## Current Material Layout

Primary notebook set:

- `material/00_setup_and_stack.jl`
- `material/01_ai_workflow_toy_example.jl`
- `material/02_paper_reproduction.jl`
- `material/03_benchmark_and_extensions.jl`

Environment and usage:

- `material/Project.toml`
- `material/Manifest.toml`
- `material/README.md`

Planning and workshop notes:

- `notes/2026-03-30-workshop-design.md`
- `notes/2026-03-30-workshop-implementation-plan.md`
- `notes/paper_selection.md`
- `notes/prompt_patterns.md`
- `notes/workshop-announcement-email.md`

Local helper definitions used by notebook 02 and notebook 03:

- `refs/problems.jl`
- `refs/projections.jl`

## Workshop Decisions

These decisions are already made unless explicitly revised later.

### Teaching Arc

The current notebook arc is:

1. setup, Pluto workflow, validation habits
2. toy Newton root-finding workflow for `F(x) = 0`
3. paper-facing Experiment 1 notebook based on Ibrahim et al. (2023)
4. benchmark-extension notebook

### Paper Choice

The selected paper is:

- Ibrahim et al. (2023), `Two classes of spectral three-term derivative-free method for solving nonlinear equations with application`

The current notebook-02 direction is:

- anchor on Experiment 1
- stay as close as practical to the paper
- use committed local helper files in `refs/`
- avoid overclaiming any mapping or benchmark result that has not been verified

### Fidelity Boundary

Notebook 02 currently contains:

- paper metadata and fixed parameters
- a verified first Experiment 1 case
- a reusable first-step helper
- one demonstrated `x0 -> x1` update

Notebook 02 does **not** yet claim:

- a full STTDFPM implementation loop
- a full Experiment 1 reproduction
- paper-level convergence or benchmark reproduction

Notebook 03 is a benchmark-extension notebook, not a claim that the full paper benchmark suite has been reproduced.

## Authoring Rules

When extending or revising the material:

- keep notebook cells small and inspectable
- prefer one mathematical unit per step
- separate paper-fixed facts from local workshop choices
- keep validation visible in the notebook artifact itself
- do not replace explicit checks with prose summaries
- do not overclaim reproduction success
- update `material/README.md` whenever notebook roles or execution flow change

For Experiment 1 work specifically:

- only treat a paper-to-helper mapping as verified if the notebook or notes record explicit supporting evidence
- heuristic candidates must be labeled as heuristic/provisional
- benchmark claims must stay downstream of verified case setup

## Current Phase

The first implementation and merge phase is complete.

The next workflow is:

1. refine the merged notebooks in `main`
2. improve mathematical fidelity and teaching clarity where needed
3. prepare outward-facing workshop materials once the core notebook content stabilizes

The highest-priority content task is still notebook `02`.

## Immediate Next Focus

The first substantive task for the next session should be:

- strengthen `material/02_paper_reproduction.jl`

That notebook is the core academic deliverable. It currently stops at a verified first case, a reusable first-step helper, and one demonstrated update. The next pass should move it closer to a fuller and clearer Experiment 1 reproduction without overclaiming results.
