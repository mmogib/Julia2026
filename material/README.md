# Workshop Material

## Purpose

This directory contains the shared Julia project and the current Pluto notebook set for the workshop.

The material follows the workflow-first design and uses Ibrahim et al. (2023) for the main reproduction arc.

## Participant Usage

1. Activate this environment.
2. Install dependencies.
3. Start Pluto.
4. Open `00_setup_and_stack.jl` first.
5. Move to `01_ai_workflow_toy_example.jl` for the toy workflow loop.
6. Move to `02_paper_reproduction.jl` for the verified Experiment 1 scaffold and first-step implementation units.
7. Move to `03_benchmark_and_extensions.jl` for the benchmark-extension notebook.

Suggested commands:

```powershell
julia --project=material -e "using Pkg; Pkg.instantiate()"
julia --project=material -e "using Pluto; Pluto.run()"
```

## Verification Flow

Use the same `material` project for notebook execution and smoke checks.

```powershell
julia --project=material material/00_setup_and_stack.jl
julia --project=material material/01_ai_workflow_toy_example.jl
julia --project=material material/02_paper_reproduction.jl
julia --project=material material/03_benchmark_and_extensions.jl
julia --project=material -e "using Pkg; Pkg.instantiate(); using Pluto, PlutoUI, Plots, BenchmarkTools"
```

## Scaffold Notes

- Participants are expected to arrive with Julia and Codex already working.
- The workshop emphasizes validation of AI-generated code, not blind acceptance.
- `00_setup_and_stack.jl` introduces the shared workflow.
- `01_ai_workflow_toy_example.jl` teaches the small-unit validation loop on a toy problem.
- `02_paper_reproduction.jl` now contains the verified `ExponetialI` case scaffold, one demonstrated first iteration, and a reusable first-step helper for that case.
- `03_benchmark_and_extensions.jl` turns the verified Experiment 1 case into a small benchmark-extension notebook without claiming the paper's full benchmark reproduction.
- `Pluto`, `PlutoUI`, `Plots`, and `BenchmarkTools` are already included because the later notebooks will use them.
