# Workshop Material

## Purpose

This directory contains the Pluto notebooks and Julia environment for the workshop.

The material follows the approved workflow-first design and uses the Ibrahim et al. 2023 paper direction for the main reproduction arc.

## Expected Workflow

1. Activate this environment.
2. Install dependencies.
3. Start Pluto.
4. Open the notebooks in order from `00_` to `03_`.

Suggested commands:

```powershell
julia --project=material -e "using Pkg; Pkg.instantiate()"
julia --project=material -e "using Pluto; Pluto.run()"
```

## Notes

- Participants are expected to arrive with Julia and Codex already working.
- The workshop emphasizes validation of AI-generated code, not blind acceptance.
- `00_setup_and_stack.jl` introduces the shared workflow.
- `02_paper_reproduction.jl` will reproduce the selected Ibrahim compressed-sensing experiment.
- `03_benchmark_and_extensions.jl` will extend that reproduction into benchmarking.
