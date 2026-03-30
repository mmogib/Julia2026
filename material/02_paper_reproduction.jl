### A Pluto.jl notebook ###

# v0.20.0

using Markdown
using InteractiveUtils
using PlutoUI

# ╔═╡ 20000000-0000-0000-0000-000000000001
md"""
# Paper Reproduction Scaffold

This notebook is the paper-facing scaffold for Ibrahim et al. (2023).

It does not jump straight into a full implementation. It records the paper metadata, the Experiment 1 scope, the helper definitions available in this repository, and the validation targets that must be checked before any benchmark claim is made.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000002
md"""
## Workflow Discipline

This notebook follows the same discipline as notebooks 00 and 01:

1. restate the numerical task in plain language
2. separate paper-fixed facts from local implementation choices
3. load the smallest useful helper units
4. run explicit checks before expanding scope
5. record what is still open instead of silently guessing
"""

# ╔═╡ 20000000-0000-0000-0000-000000000003
paper_metadata = (
    citation = "Ibrahim et al. (2023), Two classes of spectral three-term derivative-free method for solving nonlinear equations with application",
    source_pdf = joinpath("refs", "Ibrahim et al. - 2023 - Two classes of spectral three-term derivative-free.pdf"),
    notebook_role = "Experiment 1 reproduction scaffold",
    workshop_position = "first paper-specific notebook after the setup and toy-workflow notebooks",
)

# ╔═╡ 20000000-0000-0000-0000-000000000004
md"""
## Experiment Definition

The explicit notebook anchor is **Experiment 1**, not the compressed-sensing application from Experiment 2.

The paper-level target is the large-scale benchmark suite for monotone nonlinear equations with convex constraints. The notebook stays close to that framing while remaining honest about what the paper fixes and what still needs a verified local mapping.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000005
experiment_definition = (
    anchor_experiment = 1,
    paper_problem_class = "large-scale systems of nonlinear equations with convex constraints",
    primary_methods = ("STTDFPM", "ISTTDFPM"),
    comparison_methods = ("MOPCG", "CGDFPM", "AHDFPM"),
    reported_dimensions = (10^3, 10^4, 10^5),
    reported_problem_count = 12,
    reported_initial_point_families = 14,
    reported_summary_artifact = "performance profiles",
)

# ╔═╡ 20000000-0000-0000-0000-000000000006
paper_fixed_choices = (
    julia_version_reported = v"1.8.5",
    hardware_reported = "Intel i9-9900K with 32 GB RAM",
    stopping_tolerance = 1.0e-11,
    iteration_safeguard = 2000,
    parameters = (
        t = 0.11,
        beta = 0.5,
        sigma = 0.01,
        gamma = 1.8,
        alpha_min = 1.0e-10,
        alpha_max = 1.0e30,
        r = 0.1,
        psi = 0.2,
        eta_1 = 0.001,
        eta_2 = 0.6,
    ),
)

# ╔═╡ 20000000-0000-0000-0000-000000000007
md"""
## Repository Helper Definitions

The user added local helper files in the main repository root:

- `refs/problems.jl`
- `refs/projections.jl`

This notebook reads those files directly from the committed repository path instead of copying them into the worktree. That keeps the scaffold honest about source location and avoids unnecessary duplication.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000008
helper_paths = (
    notebook_dir = @__DIR__,
    worktree_root = normpath(joinpath(@__DIR__, "..")),
    main_repo_root = normpath(joinpath(@__DIR__, "..", "..", "..")),
    problems = normpath(joinpath(@__DIR__, "..", "..", "..", "refs", "problems.jl")),
    projections = normpath(joinpath(@__DIR__, "..", "..", "..", "refs", "projections.jl")),
)

# ╔═╡ 20000000-0000-0000-0000-000000000009
helper_verification = (
    helper_files_present = all(isfile, (helper_paths.problems, helper_paths.projections)),
    problems_path = helper_paths.problems,
    projections_path = helper_paths.projections,
)

# ╔═╡ 20000000-0000-0000-0000-00000000000a
begin
    @assert helper_verification.helper_files_present "Expected refs/problems.jl and refs/projections.jl in the main repository root."
    include(helper_paths.problems)
    include(helper_paths.projections)
    nothing
end

# ╔═╡ 20000000-0000-0000-0000-00000000000b
helper_inventory = (
    problem_candidates = (
        :PolynomialSineCosine,
        :ExponetialI,
        :ExponetialIII,
        :PolynomialI,
        :SmoothSine,
        :NonsmoothSine,
        :ModifiedNonsmoothSine,
        :ModifiedNonsmoothSine2,
        :ExponetialSineCosine,
        :ModifiedTrigI,
        :Tridiagonal,
        :ModifiedTridiagonal,
        :Logarithmic,
        :NonmoothLogarithmic,
        :ding2017FunII,
        :ding2017Diagonal6Fun,
    ),
    projection_candidates = (
        :projectOnRn,
        :projectOnBox,
        :projectOnHalfSpace,
        :projectOnTriangle,
    ),
)

# ╔═╡ 20000000-0000-0000-0000-00000000000c
helper_symbol_checks = (
    problems_defined = all(name -> isdefined(@__MODULE__, name), helper_inventory.problem_candidates),
    projections_defined = all(name -> isdefined(@__MODULE__, name), helper_inventory.projection_candidates),
    helper_problem_count = length(helper_inventory.problem_candidates),
    helper_projection_count = length(helper_inventory.projection_candidates),
)

# ╔═╡ 20000000-0000-0000-0000-00000000000d
md"""
## Extracted Assumptions

The notebook can already make these claims directly from the paper and the helper files:

- Experiment 1 is the intended anchor.
- The paper fixes the solver parameters, tolerance, safeguard, dimensions, and comparison methods.
- The repository now provides local problem and projection definitions relevant to the monotone-equation setting.

The notebook should not yet claim one exact manuscript benchmark row unless the helper names have been crosswalked carefully to the paper's Experiment 1 table.
"""

# ╔═╡ 20000000-0000-0000-0000-00000000000e
assumption_register = (
    fixed_from_paper = (
        "Experiment 1 is the benchmark-suite target.",
        "Dimensions are 10^3, 10^4, and 10^5.",
        "Stopping tolerance is 10^-11 with a k > 2000 safeguard.",
        "STTDFPM and ISTTDFPM are the primary methods, compared against MOPCG, CGDFPM, and AHDFPM.",
    ),
    fixed_from_repository = (
        "refs/problems.jl exists in the main repository root.",
        "refs/projections.jl exists in the main repository root.",
        "The helper files expose concrete Julia function definitions for benchmark problems and projection operators.",
    ),
    still_open_but_explicit = (
        "The exact one-to-one mapping between the manuscript's 12 named Experiment 1 problems and the local helper names is not yet fully verified in this notebook.",
        "The first local benchmark case should be selected only after that mapping is checked, not by guessing from similar names.",
        "The manuscript reports suite-level performance profiles, so any local table or per-case result must be labeled as a workshop reproduction choice rather than a direct paper table copy unless the mapping is confirmed.",
    ),
)

# ╔═╡ 20000000-0000-0000-0000-00000000000f
md"""
## Implementation Notes

This scaffold is intentionally narrow.

- It documents the paper and the experiment before any algorithm cell is added.
- It proves the helper definitions are available locally.
- It surfaces the benchmark-case mapping boundary instead of hiding it.
- It leaves room for the next notebook cells to implement one small verified unit at a time.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000010
implementation_notes = (
    immediate_next_units = (
        "Select one helper-backed Experiment 1 case only after verifying the paper-to-helper name mapping.",
        "Implement the smallest STTDFPM step or residual-evaluation unit needed for that case.",
        "Add a local convergence or feasibility check before any runtime comparison.",
    ),
    non_goals_for_this_scaffold = (
        "No benchmark claim is made yet.",
        "No performance profile is recreated yet.",
        "No compressed-sensing Experiment 2 material is used as the notebook anchor.",
    ),
)

# ╔═╡ 20000000-0000-0000-0000-000000000011
workflow_prompt = raw"""
Restate Ibrahim 2023 Experiment 1 in plain language.
List which quantities are fixed by the paper and which choices are still local.
Use the helper problem and projection definitions already loaded in this notebook.
Write the smallest Julia unit that can be validated before any benchmark claim is made.
Do not expand into suite-wide benchmarking until the first case mapping is verified.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000012
md"""
## Validation Targets

Before this notebook can support any reproduction claim, the following checks must stay visible:

- the helper files exist at the committed main-repo paths
- the expected helper symbols are defined after loading
- the notebook states Experiment 1 as the anchor
- the notebook records the paper-fixed parameters explicitly
- the notebook records the remaining local choices explicitly
"""

# ╔═╡ 20000000-0000-0000-0000-000000000013
validation_targets = (
    helper_files_present = helper_verification.helper_files_present,
    helper_symbols_loaded = helper_symbol_checks.problems_defined && helper_symbol_checks.projections_defined,
    experiment_anchor_is_correct = experiment_definition.anchor_experiment == 1,
    paper_parameters_recorded = !isempty(keys(paper_fixed_choices.parameters)),
    open_choices_recorded = !isempty(assumption_register.still_open_but_explicit),
)

# ╔═╡ 20000000-0000-0000-0000-000000000014
notebook_verification_summary = (
    helper_files_present = validation_targets.helper_files_present,
    helper_symbols_loaded = validation_targets.helper_symbols_loaded,
    experiment_anchor_is_correct = validation_targets.experiment_anchor_is_correct,
    paper_parameters_recorded = validation_targets.paper_parameters_recorded,
    open_choices_recorded = validation_targets.open_choices_recorded,
)

# ╔═╡ 20000000-0000-0000-0000-000000000015
md"""
## Scope Boundary

This scaffold is ready when the metadata, helper availability, and validation targets are explicit.

It is not yet a benchmark result notebook. That boundary is deliberate: the paper-fixed Experiment 1 structure is recorded here, while any concrete benchmark row must wait until the helper-to-paper mapping is checked carefully.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000016
PlutoUI.TableOfContents()
