### A Pluto.jl notebook ###

# v0.20.0

using Markdown
using InteractiveUtils
using PlutoUI

# ╔═╡ 00000000-0000-0000-0000-000000000001
md"""
# Setup And Stack

This notebook introduces the minimum Julia and Pluto workflow needed for the workshop.
The main paper path follows Ibrahim et al. (2023): notebook 02 reproduces the compressed-sensing experiment, and notebook 03 extends it into benchmarking.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
md"""
## Learning Goals

- understand the workshop environment
- activate the Julia project
- understand the Codex workflow we will use
- run simple Julia cells and inspect outputs
- keep reproduction work separate from benchmark extension work
"""

# ╔═╡ 00000000-0000-0000-0000-000000000003
md"""
## Pluto Usage

Use Pluto as the notebook interface for the workshop. Pluto is reactive: when an input cell changes, dependent cells update automatically.

- start Pluto from the `material` project
- open this notebook first
- keep each notebook focused on one workflow stage
- use small cells so dependencies stay easy to inspect
"""

# ╔═╡ 00000000-0000-0000-0000-000000000004
md"""
## Package Management

The shared project is intentionally scoped, but it already includes the packages needed for setup, plotting, and later benchmark work.

- activate it with `--project=material`
- instantiate dependencies before the live session
- keep notebook-specific additions minimal until a later notebook needs them
"""

# ╔═╡ 00000000-0000-0000-0000-000000000005
md"""
## Before We Start

- bring your own laptop
- Julia must already be installed
- Codex access must already be working
- package installation should be verified before the live session
"""

# ╔═╡ 00000000-0000-0000-0000-000000000006
md"""
## Prompt Discipline

Our workflow in this workshop is:

1. restate the mathematical task
2. identify assumptions
3. ask for a small Julia unit
4. test or validate that unit
5. extend only after verification
"""

# ╔═╡ 00000000-0000-0000-0000-000000000007
md"""
## Plotting

Plots are the default way to inspect numerical behavior in the workshop.

- use them to check qualitative trends early
- keep figures tied to a specific hypothesis or paper claim
- avoid polishing plots before the underlying result is verified
"""

# ╔═╡ 00000000-0000-0000-0000-000000000008
md"""
### Plotting Smoke Test

The next cell checks that plotting is available and produces a simple figure.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000009
using Plots

# ╔═╡ 00000000-0000-0000-0000-00000000000a
plot(1:3, [1, 4, 9], label="squares", marker=:circle, xlabel="n", ylabel="value")

# ╔═╡ 00000000-0000-0000-0000-00000000000b
md"""
## Reproducibility Practices

- record inputs, tolerances, and parameter choices explicitly
- separate generated code from manually validated code
- prefer small executable checks over large unverified blocks
- document any mismatch with the paper immediately
"""

# ╔═╡ 00000000-0000-0000-0000-00000000000c
md"""
### Environment Smoke Test

The next cell records the Julia version and active project for a quick sanity check.
"""

# ╔═╡ 00000000-0000-0000-0000-00000000000d
(;
    julia_version = string(VERSION),
    active_project = Base.active_project(),
)

# ╔═╡ 00000000-0000-0000-0000-00000000000e
md"""
### Validated Computation Pattern

The next cell demonstrates the workshop pattern: state a tiny computation, run it, and check the result before scaling up.
"""

# ╔═╡ 00000000-0000-0000-0000-00000000000f
f(x) = x^2 - 2
x0 = 1.0
x1 = x0 - f(x0) / (2x0)
isapprox(x1, sqrt(2); atol=0.5)

# ╔═╡ 00000000-0000-0000-0000-000000000010
md"""
## Packages And Environment

The workshop uses a minimal shared environment:

- `Pluto` for notebooks
- `PlutoUI` for light interactivity
- `Plots` for figures
- `BenchmarkTools` for timing and comparisons

`Markdown`, `InteractiveUtils`, `LinearAlgebra`, and `Statistics` come from Julia's standard library.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000011
PlutoUI.TableOfContents()
