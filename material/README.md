# Workshop Material

## Purpose

This directory contains the first Pluto notebook and the shared Julia project scaffold for the workshop.

The material follows the approved workflow-first design and uses the Ibrahim et al. 2023 paper direction for the main reproduction arc. Later notebooks for the toy example, paper reproduction, and benchmarking will be added after this initial scaffold.

## Participant Usage

1. Activate this environment.
2. Install dependencies.
3. Start Pluto.
4. Open `00_setup_and_stack.jl` first.
5. Use the notebook to confirm the workshop environment and workflow before moving on to later material.

Suggested commands:

```powershell
julia --project=material -e "using Pkg; Pkg.instantiate()"
julia --project=material -e "using Pluto; Pluto.run()"
```

## Scaffold Notes

- Participants are expected to arrive with Julia and Codex already working.
- The workshop emphasizes validation of AI-generated code, not blind acceptance.
- `00_setup_and_stack.jl` introduces the shared workflow.
- `Pluto`, `PlutoUI`, `Plots`, and `BenchmarkTools` are already included because the later notebooks will use them.
- `01_ai_workflow_toy_example.jl`, `02_paper_reproduction.jl`, and `03_benchmark_and_extensions.jl` are planned follow-on notebooks and are not yet part of this scaffold.
