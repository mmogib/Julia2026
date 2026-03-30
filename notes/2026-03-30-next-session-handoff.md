# Next Session Handoff

## Current State

- The workshop material is merged into `main`.
- The baseline notebook set is:
  - `material/00_setup_and_stack.jl`
  - `material/01_ai_workflow_toy_example.jl`
  - `material/02_paper_reproduction.jl`
  - `material/03_benchmark_and_extensions.jl`
- Local helper files used by the paper-facing notebooks are:
  - `refs/problems.jl`
  - `refs/projections.jl`
- `AGENTS.md` has been updated to reflect the merged state.

## Verified

- All four Pluto notebooks execute successfully from the main checkout with:
  - `julia --project=material`
  - `include("material/<notebook>.jl")`
- The workshop structure, planning notes, prompt notes, and announcement draft are present in the repository.

## Important Boundary

- `material/02_paper_reproduction.jl` is still a partial Experiment 1 notebook.
- It does **not** yet claim a full STTDFPM implementation loop.
- It does **not** yet claim a full Experiment 1 reproduction.
- `material/03_benchmark_and_extensions.jl` is an extension notebook, not proof that the full benchmark suite from the paper has been reproduced.

## First Thing To Do Next

Strengthen `material/02_paper_reproduction.jl`.

That should be the first substantive task next session because it is the core academic notebook of the workshop. The next pass should aim to improve mathematical fidelity, clarity of the paper-to-code mapping, and the completeness of the Experiment 1 workflow, while keeping the current discipline of explicit validation and no overclaiming.

## Secondary Tasks After Notebook 02

- refine notebook `03` so it stays aligned with whatever fidelity level notebook `02` reaches
- revise the workshop title and outward-facing description once the core notebook content stabilizes
- polish the workshop announcement material if needed
