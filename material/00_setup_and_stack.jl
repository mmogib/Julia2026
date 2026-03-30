### A Pluto.jl notebook ###

# v0.20.0

using Markdown
using InteractiveUtils
using PlutoUI

# ╔═╡ 00000000-0000-0000-0000-000000000001
md"""
# Setup And Stack

This notebook sets up the workshop workflow before we touch the main paper reproduction.

This notebook is intentionally practical. It covers the environment, Pluto's reactive model, Codex discipline, common failure modes, plotting, and the reproducibility habits we will use everywhere else.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
md"""
## Learning Goals

- confirm the workshop environment before the live coding starts
- understand how Pluto's reactive cells change the way we work
- keep Codex prompts small, testable, and explicit
- know the failure modes that matter in AI-assisted scientific coding
- verify plotting and package availability early
- leave the paper-specific details for the later notebooks
"""

# ╔═╡ 00000000-0000-0000-0000-000000000003
md"""
## Workshop Logistics And Prerequisites

Participants are expected to arrive with the basics already working.

- Julia is installed
- Codex access is configured and usable
- the workshop material has been cloned or copied locally
- the `material` environment can be activated
- Pluto can start and open this notebook

Before Session 1, verify the shared project with:

```powershell
julia --project=material -e "using Pkg; Pkg.instantiate()"
julia --project=material -e "using Pluto; Pluto.run()"
```

If package resolution fails, fix that before trying to follow the workshop content. The goal is to spend the session on scientific workflow, not on rescue installs.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000004
md"""
## Pluto Usage

Pluto is reactive. When one cell changes, every dependent cell updates automatically.

That matters for workshop discipline:

- one cell should do one clear thing
- keep the data flow obvious
- avoid burying setup, computation, and plotting in one large block
- prefer explicit inputs over hidden state

For the later notebooks, that means the reproduction steps can stay small and inspectable instead of becoming a single unreviewable script.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000005
md"""
### Copyable Workflow Template

This is the pattern to copy later: inputs, computation, check, interpretation.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000006
workflow_inputs = (; x0 = 1.0, target = 2.0)
workflow_result = let
    f(x) = x^2 - workflow_inputs.target
    x1 = workflow_inputs.x0 - f(workflow_inputs.x0) / (2 * workflow_inputs.x0)
    residual0 = abs(f(workflow_inputs.x0))
    residual1 = abs(f(x1))
    check = isapprox(x1, 1.5; atol = 1e-12) && residual1 <= 0.3 * residual0
    interpretation = check ? "One Newton step moved closer to the target and cut the residual." : "The update did not pass the sanity check."
    (; x1, residual0, residual1, check, interpretation)
end

# ╔═╡ 00000000-0000-0000-0000-000000000007
md"""
The result is intentionally small but complete:

- inputs are written down
- the computation is explicit
- the check is meaningful
- the interpretation explains what the check means

That is the shape we want in every later notebook cell.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000008
md"""
## Codex Workflow Discipline

Use Codex as a collaborator, not as a substitute for judgment.

The workshop loop is:

1. restate the numerical task in plain language
2. list the assumptions you are making
3. ask for the smallest useful Julia unit
4. run that unit and check the result
5. add the next step only after the previous one is validated

For this workshop, prompts should stay narrow. Good prompts ask for one function, one validation check, one plot, or one benchmark harness. Bad prompts ask for a whole reproduction at once.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000009
md"""
### Prompt Shape We Will Use

Use prompts like this:

```text
Restate the numerical task in plain language.
List the assumptions, inputs, and outputs you are using.
Write the smallest Julia unit that can be tested now.
Do not expand into benchmarking or plotting until this step is validated.
```

This is the same discipline we will use in the later notebooks.
"""

# ╔═╡ 00000000-0000-0000-0000-00000000000a
md"""
## AI Failure Modes

The workshop teaches participants to spot these problems early:

- the code solves the wrong mathematical problem
- the code runs but quietly changes the experiment
- the response invents package APIs or version behavior
- the response returns a huge untested block instead of a testable unit
- the benchmark is reported without fixed sizes, metrics, or hardware notes
- the paper reproduction is claimed on the basis of a pretty plot instead of a documented check

The antidote is boring but reliable: extract assumptions, verify small units, and record what was actually checked.
"""

# ╔═╡ 00000000-0000-0000-0000-00000000000b
md"""
## Later Notebooks

The case-study notebook will use Ibrahim et al. (2023) as the main paper example.

Notebook 00 stops at setup, orientation, and workflow templates. The paper-specific assumptions, numbers, and benchmark details belong in the later notebooks where they can be validated in context.
"""

# ╔═╡ 00000000-0000-0000-0000-00000000000f
md"""
## Package Management

The shared project is the contract for the workshop. Keep package changes small and explicit.

- activate the `material` project before working
- instantiate the environment before the session
- prefer the packages already listed in `material/Project.toml`
- avoid adding new dependencies unless a later notebook really needs them

The workshop environment already includes:

- `Pluto`
- `PlutoUI`
- `Plots`
- `BenchmarkTools`

The standard library gives us tools like `Markdown`, `InteractiveUtils`, and the rest of Julia's base functionality.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000010
md"""
### Environment Smoke Test

The next cell checks that the active project is the workshop project and records the Julia version for the teaching session.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000011
(
    julia_version = string(VERSION),
    active_project = Base.active_project(),
    notebook_dir = @__DIR__,
    project_files_present = isfile(joinpath(@__DIR__, "Project.toml")) && isfile(joinpath(@__DIR__, "Manifest.toml")),
)

# ╔═╡ 00000000-0000-0000-0000-000000000012
md"""
## Plotting

Plots are not decoration here. They are a validation tool.

Use a plot to answer a concrete question:

- does the algorithm move in the right direction?
- do the magnitudes look plausible?
- does a parameter change produce the expected trend?

We do not polish figures before we know the underlying computation is correct.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000013
using Plots

# ╔═╡ 00000000-0000-0000-0000-000000000014
plot(1:3, [1, 4, 9], label = "squares", marker = :circle, xlabel = "n", ylabel = "value", title = "Plotting smoke test")

# ╔═╡ 00000000-0000-0000-0000-000000000015
md"""
## Reproducibility Practices

Keep the following habits visible in every notebook:

- write the parameters down instead of relying on memory
- keep generated code separate from manually checked corrections
- use small executable checks before scaling up
- record mismatches with the paper immediately
- keep benchmark claims tied to a concrete metric and a concrete setup
 
The later notebooks will carry the paper-specific parameters and benchmark definitions.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000016
md"""
### Validated Computation Pattern

This final smoke test is a tiny example of the validate-before-scale workflow.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000017
workflow_result.check

# ╔═╡ 00000000-0000-0000-0000-000000000018
md"""
## What Success Looks Like

By the end of this notebook, participants should be ready to:

- use Pluto without fighting the reactive model
- ask Codex for small, testable Julia units
- check the environment before writing workshop code
- recognize when AI output is plausible but not yet validated
- move into the next notebook with the right workflow discipline
"""

# ╔═╡ 00000000-0000-0000-0000-000000000019
md"""
## Notebook Verification

This notebook is meant to make a few setup checks visible in the artifact itself:

- project files are present and the active project points at the workshop environment
- Julia version is captured for the session
- the plotting smoke test renders a simple figure
- the tiny validated computation returns `true`

These checks are intentionally small. They are there to confirm the setup path, not to substitute for later reproduction validation.
"""

# ╔═╡ 00000000-0000-0000-0000-00000000001a
PlutoUI.TableOfContents()
