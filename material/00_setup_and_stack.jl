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
## Before We Start

- bring your own laptop
- Julia must already be installed
- Codex access must already be working
- package installation should be verified before the live session
"""

# ╔═╡ 00000000-0000-0000-0000-000000000004
md"""
## Prompt Discipline

Our workflow in this workshop is:

1. restate the mathematical task
2. identify assumptions
3. ask for a small Julia unit
4. test or validate that unit
5. extend only after verification
"""

# ╔═╡ 00000000-0000-0000-0000-000000000005
md"""
## Packages And Environment

The workshop uses a minimal shared environment:

- `Pluto` for notebooks
- `PlutoUI` for light interactivity
- `Plots` for figures
- `BenchmarkTools` for timing and comparisons

`Markdown`, `InteractiveUtils`, `LinearAlgebra`, and `Statistics` come from Julia's standard library.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000006
PlutoUI.TableOfContents()

