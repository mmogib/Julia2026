### A Pluto.jl notebook ###

# v0.20.0

using Markdown
using InteractiveUtils
using BenchmarkTools
using PlutoUI

# ╔═╡ 30000000-0000-0000-0000-000000000001
md"""
# Benchmark And Extensions

This notebook follows the Experiment 1 scaffold from notebook 02.

It is a benchmark-extension notebook, not a compressed-sensing notebook. The goal is to keep the workshop pattern intact: validate a small unit first, then decide whether any scaling or extension is worth doing.
"""

# ╔═╡ 30000000-0000-0000-0000-000000000002
md"""
## Benchmark Question

What is the cost of one small Experiment 1-style residual evaluation, with and without the local positive-orthant projection, on a single honest input vector?

That question is narrow on purpose. It supports a benchmark discussion without claiming the full performance-profile reproduction from the paper.
"""

# ╔═╡ 30000000-0000-0000-0000-000000000003
md"""
## Scope Boundary

The notebook stays inside the workshop direction:

- anchor on Experiment 1
- reuse the repository-local helper and projection definitions
- compare one tiny benchmark-style unit before considering any extension
- avoid compressed-sensing material and avoid suite-wide claims

The paper's large benchmark table still belongs to a later, fully validated reproduction workflow.
"""

# ╔═╡ 30000000-0000-0000-0000-000000000004
notebook_paths = (
    notebook_dir = @__DIR__,
    repo_root = normpath(joinpath(@__DIR__, "..")),
    helper_dir = normpath(joinpath(@__DIR__, "..", "refs")),
    problems = normpath(joinpath(@__DIR__, "..", "refs", "problems.jl")),
    projections = normpath(joinpath(@__DIR__, "..", "refs", "projections.jl")),
)

# ╔═╡ 30000000-0000-0000-0000-000000000005
helper_verification = (
    helper_files_present = all(isfile, (notebook_paths.problems, notebook_paths.projections)),
    notebook_active_project = Base.active_project(),
    julia_version = string(VERSION),
)

# ╔═╡ 30000000-0000-0000-0000-000000000006
begin
    @assert helper_verification.helper_files_present "Expected refs/problems.jl and refs/projections.jl inside this repository."
    include(notebook_paths.problems)
    include(notebook_paths.projections)
    nothing
end

# ╔═╡ 30000000-0000-0000-0000-000000000007
benchmark_context = (
    problem_symbol = :ExponetialI,
    projection_symbol = :projectOnBox,
    projection_check_symbol = :projectOnBoxCheck,
    bounds = (0.0, Inf),
    dimension = 10^3,
    note = "This is the smallest paper-sized dimension used here; it is still a local benchmark extension, not the paper's full suite result.",
)

# ╔═╡ 30000000-0000-0000-0000-000000000008
benchmark_input = collect(range(-1.0, 1.0; length = benchmark_context.dimension))

# ╔═╡ 30000000-0000-0000-0000-000000000009
benchmark_case = let
    projected_input = projectOnBox(benchmark_input; bounds = benchmark_context.bounds)
    residual = ExponetialI(projected_input)
    residual_norm = sqrt(sum(abs2, residual))
    feasible = projectOnBoxCheck(projected_input; bounds = benchmark_context.bounds)
    (
        projected_input = projected_input,
        residual = residual,
        residual_norm = residual_norm,
        feasible = feasible,
        residual_length_matches_dimension = length(residual) == benchmark_context.dimension,
        projection_is_active = projected_input != benchmark_input,
    )
end

# ╔═╡ 30000000-0000-0000-0000-00000000000a
md"""
## Protocol

The benchmark protocol is intentionally simple:

1. fix a single input vector and a single dimension
2. project the input onto the positive orthant with `projectOnBox`
3. evaluate `ExponetialI` on the projected vector
4. record residual size, feasibility, time, and allocations
5. keep the setup unchanged when comparing runs

This is enough to check the workshop path without pretending to reproduce the whole paper benchmark suite.
"""

# ╔═╡ 30000000-0000-0000-0000-00000000000b
md"""
## Comparison Metrics

The notebook compares the following quantities:

- runtime from `BenchmarkTools`
- allocations and bytes from `BenchmarkTools`
- residual norm from the helper problem
- feasibility of the projected input
- dimension and input shape

The metrics are intentionally concrete. They are small enough to inspect directly and stable enough to explain in the workshop.
"""

# ╔═╡ 30000000-0000-0000-0000-00000000000c
benchmark_trials = let
    x = benchmark_input
    bounds = benchmark_context.bounds
    projected_trial = @benchmark begin
        y = projectOnBox($x; bounds = $bounds)
        ExponetialI(y)
    end
    raw_trial = @benchmark ExponetialI($x)
    projected_only_trial = @benchmark projectOnBox($x; bounds = $bounds)
    (
        raw_trial = raw_trial,
        projected_trial = projected_trial,
        projected_only_trial = projected_only_trial,
    )
end

# ╔═╡ 30000000-0000-0000-0000-00000000000d
benchmark_report = (
    raw_minimum_ns = minimum(benchmark_trials.raw_trial).time,
    raw_allocations = minimum(benchmark_trials.raw_trial).allocs,
    raw_bytes = minimum(benchmark_trials.raw_trial).memory,
    projected_minimum_ns = minimum(benchmark_trials.projected_trial).time,
    projected_allocations = minimum(benchmark_trials.projected_trial).allocs,
    projected_bytes = minimum(benchmark_trials.projected_trial).memory,
    projection_only_minimum_ns = minimum(benchmark_trials.projected_only_trial).time,
    projection_only_allocations = minimum(benchmark_trials.projected_only_trial).allocs,
    projection_only_bytes = minimum(benchmark_trials.projected_only_trial).memory,
    residual_norm = benchmark_case.residual_norm,
    feasible = benchmark_case.feasible,
    residual_length_matches_dimension = benchmark_case.residual_length_matches_dimension,
    projected_input_changed = benchmark_case.projection_is_active,
    projected_over_raw_ratio = minimum(benchmark_trials.projected_trial).time / minimum(benchmark_trials.raw_trial).time,
)

# ╔═╡ 30000000-0000-0000-0000-00000000000e
md"""
## Reporting Rules

Report the benchmark as a local workshop check, not as a paper claim.

- name the problem and projection used
- state the exact dimension and input pattern
- record the Julia version and active project
- report timing together with allocations and bytes
- keep the benchmark input fixed while comparing repeated runs
- if you change the dimension, treat that as a new benchmark point

Do not turn this notebook into a suite-wide claim unless the full Experiment 1 mapping and run protocol are validated separately.
"""

# ╔═╡ 30000000-0000-0000-0000-00000000000f
md"""
## Sensitivity Note

This is the appropriate place to note sensitivity, but only narrowly:

- runtime will vary with dimension, warm-up, and machine load
- projection cost is sensitive to whether the input already satisfies the bound
- the benchmark should be extended one factor at a time, not all at once

That is an extension note, not a claim that the paper's benchmark profile has been reproduced.
"""

# ╔═╡ 30000000-0000-0000-0000-000000000010
md"""
## Minimal Executable Benchmark Unit

The next cell is the smallest benchmark-style unit in this notebook.
It checks a real helper problem, a real projection, and a real benchmark summary.
"""

# ╔═╡ 30000000-0000-0000-0000-000000000011
benchmark_unit_ok = (
    helper_files_present = helper_verification.helper_files_present,
    projection_feasible = benchmark_case.feasible,
    projected_input_changed = benchmark_case.projection_is_active,
    residual_length_matches_dimension = benchmark_case.residual_length_matches_dimension,
    residual_norm_is_finite = isfinite(benchmark_case.residual_norm),
    raw_benchmark_time_is_finite = isfinite(benchmark_report.raw_minimum_ns),
    projected_benchmark_time_is_finite = isfinite(benchmark_report.projected_minimum_ns),
    projection_benchmark_time_is_finite = isfinite(benchmark_report.projection_only_minimum_ns),
    projected_ratio_is_positive = benchmark_report.projected_over_raw_ratio > 0,
)

# ╔═╡ 30000000-0000-0000-0000-000000000012
md"""
## Benchmark Snapshot

This notebook intentionally exposes a small report object so the run is visible in the artifact itself.
"""

# ╔═╡ 30000000-0000-0000-0000-000000000013
benchmark_report

# ╔═╡ 30000000-0000-0000-0000-000000000014
md"""
## Notebook Verification

The visible verification summary keeps the workshop discipline explicit.
"""

# ╔═╡ 30000000-0000-0000-0000-000000000015
notebook_verification = (
    helper_files_present = helper_verification.helper_files_present,
    active_project_recorded = !isempty(helper_verification.notebook_active_project),
    experiment_one_anchor = benchmark_context.problem_symbol == :ExponetialI,
    projection_recorded = benchmark_context.projection_symbol == :projectOnBox,
    benchmark_unit_valid = all(values(benchmark_unit_ok)),
    report_is_finite = isfinite(benchmark_report.raw_minimum_ns) && isfinite(benchmark_report.projected_minimum_ns),
    scope_boundary_explicit = true,
)

# ╔═╡ 30000000-0000-0000-0000-000000000016
md"""
## Outcome

This notebook is a benchmark-extension scaffold for Experiment 1. It gives the workshop a concrete and honest local benchmark unit, but it does not claim the paper's full benchmark reproduction.
"""

# ╔═╡ 30000000-0000-0000-0000-000000000017
PlutoUI.TableOfContents()
