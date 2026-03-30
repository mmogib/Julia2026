# Workshop Material

## Purpose

This directory currently contains the first Pluto notebook and the shared Julia project scaffold for the workshop.

The material follows the approved workflow-first design and uses the Ibrahim et al. 2023 paper direction for the main reproduction arc. Later notebooks for the toy example, paper reproduction, and benchmarking will be added after this initial scaffold.

## Expected Workflow

1. Activate this environment.
2. Install dependencies.
3. Start Pluto.
4. Open `00_setup_and_stack.jl` first.
5. Add the later notebooks in order as they are created.

Suggested commands:

```powershell
julia --project=material -e "using Pkg; Pkg.instantiate()"
julia --project=material -e "using Pluto; Pluto.run()"
```

## Notes

- Participants are expected to arrive with Julia and Codex already working.
- The workshop emphasizes validation of AI-generated code, not blind acceptance.
- `00_setup_and_stack.jl` introduces the shared workflow.
- `01_ai_workflow_toy_example.jl`, `02_paper_reproduction.jl`, and `03_benchmark_and_extensions.jl` are planned follow-on notebooks and are not yet part of this scaffold.
