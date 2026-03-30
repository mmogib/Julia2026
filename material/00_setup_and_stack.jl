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

Use Pluto as the notebook interface for the workshop:

1. start Pluto from the `material` project
2. open this notebook first
3. run cells top to bottom
4. keep each notebook focused on one workflow stage
"""

# ╔═╡ 00000000-0000-0000-0000-000000000004
md"""
## Package Management

The shared project is intentionally small.

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
## Reproducibility Practices

- record inputs, tolerances, and parameter choices explicitly
- separate generated code from manually validated code
- prefer small executable checks over large unverified blocks
- document any mismatch with the paper immediately
"""

# ╔═╡ 00000000-0000-0000-0000-000000000009
md"""
## Packages And Environment

The workshop uses a minimal shared environment:

- `Pluto` for notebooks
- `PlutoUI` for light interactivity
- `Plots` for figures
- `BenchmarkTools` for timing and comparisons

`Markdown`, `InteractiveUtils`, `LinearAlgebra`, and `Statistics` come from Julia's standard library.
"""

# ╔═╡ 00000000-0000-0000-0000-00000000000a
PlutoUI.TableOfContents()
