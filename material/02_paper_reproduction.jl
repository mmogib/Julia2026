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

This branch now carries the helper files directly under the repository `refs/` directory:

- `refs/problems.jl`
- `refs/projections.jl`

This notebook loads those committed branch-local files through a repo-local path based on `@__DIR__`. The same path shape works inside the worktree now and after merge into the main checkout.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000008
helper_paths = (
    notebook_dir = @__DIR__,
    repo_root = normpath(joinpath(@__DIR__, "..")),
    helper_dir = normpath(joinpath(@__DIR__, "..", "refs")),
    problems = normpath(joinpath(@__DIR__, "..", "refs", "problems.jl")),
    projections = normpath(joinpath(@__DIR__, "..", "refs", "projections.jl")),
)

# ╔═╡ 20000000-0000-0000-0000-000000000009
helper_verification = (
    helper_files_present = all(isfile, (helper_paths.problems, helper_paths.projections)),
    problems_path = helper_paths.problems,
    projections_path = helper_paths.projections,
)

# ╔═╡ 20000000-0000-0000-0000-00000000000a
begin
    @assert helper_verification.helper_files_present "Expected refs/problems.jl and refs/projections.jl inside this repository."
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
crosswalk_rows = [
    (
        paper_label = "Problem 2",
        paper_source = "[53, Problem 9]",
        local_helper_symbol = :ExponetialI,
        projection_symbol = :projectOnBox,
        projection_config = (bounds = (0.0, Inf),),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list, with explicit positive-orthant evidence `R_n^+`.",
    ),
    (
        paper_label = "Problem 3",
        paper_source = "[54, Problem 1]",
        local_helper_symbol = :ExponetialSineCosine,
        projection_symbol = nothing,
        projection_config = (;),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list; the projection is not fixed by the current excerpt.",
    ),
    (
        paper_label = "Problem 4",
        paper_source = "[55, Problem 10]",
        local_helper_symbol = :Logarithmic,
        projection_symbol = nothing,
        projection_config = (;),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list; the projection is not fixed by the current excerpt.",
    ),
    (
        paper_label = "Problem 5",
        paper_source = "[56, Problem 2]",
        local_helper_symbol = :ModifiedNonsmoothSine,
        projection_symbol = nothing,
        projection_config = (;),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list; the projection is not fixed by the current excerpt.",
    ),
    (
        paper_label = "Problem 6",
        paper_source = "[54, Problem 2]",
        local_helper_symbol = :ModifiedNonsmoothSine2,
        projection_symbol = nothing,
        projection_config = (;),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list; the projection is not fixed by the current excerpt.",
    ),
    (
        paper_label = "Problem 7",
        paper_source = "[49, Problem 4.4]",
        local_helper_symbol = :ModifiedTridiagonal,
        projection_symbol = nothing,
        projection_config = (;),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list; the projection is not fixed by the current excerpt.",
    ),
    (
        paper_label = "Problem 8",
        paper_source = "[49, Problem 4.2]",
        local_helper_symbol = :ModifiedTrigI,
        projection_symbol = nothing,
        projection_config = (;),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list; the projection is not fixed by the current excerpt.",
    ),
    (
        paper_label = "Problem 9",
        paper_source = "[48, Problem 4.2]",
        local_helper_symbol = :NonmoothLogarithmic,
        projection_symbol = nothing,
        projection_config = (;),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list; the projection is not fixed by the current excerpt.",
    ),
    (
        paper_label = "Problem 10",
        paper_source = "[57, Problem 1]",
        local_helper_symbol = :NonsmoothSine,
        projection_symbol = nothing,
        projection_config = (;),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list; the projection is not fixed by the current excerpt.",
    ),
    (
        paper_label = "Problem 11",
        paper_source = "[53, Problem 9]",
        local_helper_symbol = :PolynomialI,
        projection_symbol = nothing,
        projection_config = (;),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list; the projection is not fixed by the current excerpt.",
    ),
    (
        paper_label = "Problem 12",
        paper_source = "[57, Problem 2]",
        local_helper_symbol = :SmoothSine,
        projection_symbol = nothing,
        projection_config = (;),
        dimensions = experiment_definition.reported_dimensions,
        mapping_status = :verified_from_pdftotext,
        notes = "Exact helper-name match from the extracted Experiment 1 list; the projection is not fixed by the current excerpt.",
    ),
]

# ╔═╡ 20000000-0000-0000-0000-00000000000da
crosswalk_summary = (
    rows = length(crosswalk_rows),
    statuses = map(row -> row.mapping_status, crosswalk_rows),
    verified_rows = count(row -> row.mapping_status == :verified_from_pdftotext, crosswalk_rows),
    mapped_problem_symbols_defined = all(
        row -> isdefined(@__MODULE__, row.local_helper_symbol),
        crosswalk_rows,
    ),
    mapped_projection_symbols_defined = all(
        row -> isnothing(row.projection_symbol) || isdefined(@__MODULE__, row.projection_symbol),
        crosswalk_rows,
    ),
)

# ╔═╡ 20000000-0000-0000-0000-00000000000db
first_case_slot = (
    paper_label = "Problem 2",
    local_helper_symbol = :ExponetialI,
    projection_symbol = :projectOnBox,
    projection_config = (bounds = (0.0, Inf),),
    dimension = 10^3,
    mapping_status = :verified_from_pdftotext,
    verification_boundary = "The helper name and `R_n^+` constraint are both supported by the extracted paper list, but this notebook still does not claim a reproduced STTDFPM run.",
    implementation_readiness = "This is the best teaching entry point because the positive-orthant projection is explicit and the residual can be checked on a simple nonnegative initialization.",
)

# ╔═╡ 20000000-0000-0000-0000-00000000000dc
md"""
## First-Case Choice

The first implementation runway is now the verified `Problem 2` row from the extracted paper list:

- local helper: `ExponetialI`
- projection: `projectOnBox`
- projection config: `bounds = (0.0, Inf)`
- starting dimension for the first executable unit: `10^3`

This choice is conservative and stronger than the earlier runway. The helper name and the positive-orthant constraint are both supported directly by the extracted Experiment 1 list. It is still only the first verified unit, not a full algorithm reproduction, which makes it a better teaching entry point than a broader step implementation.
"""

# ╔═╡ 20000000-0000-0000-0000-00000000000dd
first_case_choice = (
    selected_from_crosswalk = first_case_slot.paper_label,
    local_helper_symbol = first_case_slot.local_helper_symbol,
    projection_symbol = first_case_slot.projection_symbol,
    projection_config = first_case_slot.projection_config,
    dimension = first_case_slot.dimension,
    mapping_status = first_case_slot.mapping_status,
    choice_reason = "Best verified runway: exact paper-list helper match, explicit positive-orthant projection, and a residual that can be checked directly on a simple nonnegative initialization.",
    paper_mapping_boundary = first_case_slot.verification_boundary,
)

# ╔═╡ 20000000-0000-0000-0000-00000000000de
first_case_problem = getfield(@__MODULE__, first_case_choice.local_helper_symbol)
first_case_projection = getfield(@__MODULE__, first_case_choice.projection_symbol)

# ╔═╡ 20000000-0000-0000-0000-00000000000df
first_case_unit = let
    n = first_case_choice.dimension
    x0 = ones(Float64, n)
    projected_x0 = first_case_projection(x0; first_case_choice.projection_config...)
    residual = first_case_problem(projected_x0)
    expected_entry = exp(1.0) - 1.0
    (
        n = n,
        x0 = x0,
        projected_x0 = projected_x0,
        residual = residual,
        residual_norm = sqrt(sum(abs2, residual)),
        expected_entry = expected_entry,
        projection_bounds = first_case_choice.projection_config.bounds,
    )
end

# ╔═╡ 20000000-0000-0000-0000-00000000000e0
first_case_validation = (
    projected_point_is_feasible = minimum(first_case_unit.projected_x0) >= first_case_unit.projection_bounds[1],
    projection_is_identity_on_positive_x0 = first_case_unit.projected_x0 == first_case_unit.x0,
    residual_length_matches_dimension = length(first_case_unit.residual) == first_case_unit.n,
    residual_entries_match_expected_value = all(isapprox.(first_case_unit.residual, first_case_unit.expected_entry; atol = 1e-12)),
    residual_norm_is_finite = isfinite(first_case_unit.residual_norm) && first_case_unit.residual_norm > 0,
)

# ╔═╡ 20000000-0000-0000-0000-00000000000e1
md"""
## First STTDFPM State Unit

The next smallest paper-specific unit is a step-ready state for the verified `ExponetialI` case.

This notebook still does not implement a full STTDFPM iteration or line search. It only makes the paper parameters visible, forms the initial direction `d0 = -F(x0)`, applies one explicit trial step using the paper's `t`, and checks the geometry that should already hold before any full update logic is added.
"""

# ╔═╡ 20000000-0000-0000-0000-00000000000e2
first_case_paper_parameters = (
    t = paper_fixed_choices.parameters.t,
    beta = paper_fixed_choices.parameters.beta,
    sigma = paper_fixed_choices.parameters.sigma,
    gamma = paper_fixed_choices.parameters.gamma,
)

# ╔═╡ 20000000-0000-0000-0000-00000000000e3
first_case_sttdfpm_state = let
    F0 = first_case_unit.residual
    d0 = .-F0
    trial_step = first_case_paper_parameters.t
    z0 = first_case_unit.projected_x0 .+ trial_step .* d0
    projected_z0 = first_case_projection(z0; first_case_choice.projection_config...)
    (
        F0 = F0,
        d0 = d0,
        trial_step = trial_step,
        z0 = z0,
        projected_z0 = projected_z0,
        directional_inner_product = sum(F0 .* d0),
        projected_trial_minimum = minimum(projected_z0),
    )
end

# ╔═╡ 20000000-0000-0000-0000-00000000000e4
first_case_sttdfpm_validation = (
    paper_trial_step_is_used = isapprox(first_case_sttdfpm_state.trial_step, paper_fixed_choices.parameters.t; atol = 0.0),
    initial_direction_is_negative_residual = all(isapprox.(first_case_sttdfpm_state.d0, .-first_case_sttdfpm_state.F0; atol = 1e-12)),
    initial_direction_is_descent_like = first_case_sttdfpm_state.directional_inner_product < 0,
    projected_trial_point_is_feasible = first_case_sttdfpm_state.projected_trial_minimum >= first_case_unit.projection_bounds[1],
    trial_point_stays_in_positive_orthant = first_case_sttdfpm_state.projected_z0 == first_case_sttdfpm_state.z0,
)

# ╔═╡ 20000000-0000-0000-0000-00000000000e5
md"""
## Extracted Assumptions

The notebook can already make these claims directly from the paper and the helper files:

- Experiment 1 is the intended anchor.
- The paper fixes the solver parameters, tolerance, safeguard, dimensions, and comparison methods.
- The extracted Experiment 1 list now verifies exact helper-name matches for rows 2-12 and explicitly identifies `ExponetialI` as row 2 with `R_n^+`.
- The repository now provides local problem and projection definitions relevant to the monotone-equation setting.

The notebook should still avoid overclaiming rows that remain outside the current extraction or any algorithm-level result that has not yet been run.
"""

# ╔═╡ 20000000-0000-0000-0000-00000000000e
assumption_register = (
    fixed_from_paper = (
        "Experiment 1 is the benchmark-suite target.",
        "Dimensions are 10^3, 10^4, and 10^5.",
        "Stopping tolerance is 10^-11 with a k > 2000 safeguard.",
        "STTDFPM and ISTTDFPM are the primary methods, compared against MOPCG, CGDFPM, and AHDFPM.",
        "The extracted Experiment 1 list verifies rows 2-12 by exact helper name, and row 2 explicitly carries the `R_n^+` constraint.",
    ),
    fixed_from_repository = (
        "refs/problems.jl exists inside this branch.",
        "refs/projections.jl exists inside this branch.",
        "The helper files expose concrete Julia function definitions for benchmark problems and projection operators through repo-local paths.",
    ),
    still_open_but_explicit = (
        "The crosswalk now records exact verified rows where the extraction supports them, but not every Experiment 1 row is verified yet.",
        "The first local benchmark case is represented explicitly as a verified paper row for helper name and projection family, not as a finished reproduced benchmark run.",
        "The manuscript reports suite-level performance profiles, so any local table or per-case result must still be labeled as a workshop reproduction choice unless the mapping is confirmed.",
    ),
)

# ╔═╡ 20000000-0000-0000-0000-00000000000f
md"""
## Implementation Notes

This scaffold is intentionally narrow.

- It documents the paper and the experiment before any algorithm cell is added.
- It proves the helper definitions are available locally.
- It records a concrete crosswalk structure for paper labels, helper symbols, projections, dimensions, and mapping status.
- It now contains one small executable verified first-case unit: initialize `x0`, apply the explicit positive-orthant projection, evaluate the residual, and validate that result before scaling.
- It now contains one small STTDFPM-specific state unit: use the paper's `t`, form `d0 = -F(x0)`, build a projected trial point, and validate that state before any line search logic is added.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000010
implementation_notes = (
    immediate_next_units = (
        "Use the verified `ExponetialI` case to extend the step-ready state into one more paper-specific quantity after the current trial point.",
        "Add one small geometry or residual check tied to that same state bundle.",
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
Use the verified `ExponetialI` first-case slot and its explicit projection config to pick the next smallest implementation unit.
Keep the unit small: parameter bundle, direction, trial point, or one geometry check is enough.
Do not expand into suite-wide benchmarking until the first case mapping is verified.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000012
md"""
## Validation Targets

Before this notebook can support any reproduction claim, the following checks must stay visible:

- the helper files exist at the committed main-repo paths
- the helper files exist at the committed repo-local `refs/` paths
- the expected helper symbols are defined after loading
- the notebook states Experiment 1 as the anchor
- the notebook records the paper-fixed parameters explicitly
- the notebook records the remaining local choices explicitly
- the notebook contains a concrete crosswalk and a first-case candidate slot
- the notebook contains one small executable unit with a visible pass/fail validation check
- the notebook contains one small STTDFPM-specific state unit with a visible validation check
"""

# ╔═╡ 20000000-0000-0000-0000-000000000013
validation_targets = (
    helper_files_present = helper_verification.helper_files_present,
    helper_symbols_loaded = helper_symbol_checks.problems_defined && helper_symbol_checks.projections_defined,
    experiment_anchor_is_correct = experiment_definition.anchor_experiment == 1,
    paper_parameters_recorded = !isempty(keys(paper_fixed_choices.parameters)),
    open_choices_recorded = !isempty(assumption_register.still_open_but_explicit),
    crosswalk_present = !isempty(crosswalk_rows) && crosswalk_summary.mapped_problem_symbols_defined && crosswalk_summary.mapped_projection_symbols_defined,
    first_case_slot_present = first_case_slot.mapping_status == :verified_from_pdftotext,
    first_case_unit_validated = all(values(first_case_validation)),
    first_case_sttdfpm_state_validated = all(values(first_case_sttdfpm_validation)),
)

# ╔═╡ 20000000-0000-0000-0000-000000000014
notebook_verification_summary = (
    helper_files_present = validation_targets.helper_files_present,
    helper_symbols_loaded = validation_targets.helper_symbols_loaded,
    experiment_anchor_is_correct = validation_targets.experiment_anchor_is_correct,
    paper_parameters_recorded = validation_targets.paper_parameters_recorded,
    open_choices_recorded = validation_targets.open_choices_recorded,
    crosswalk_present = validation_targets.crosswalk_present,
    first_case_slot_present = validation_targets.first_case_slot_present,
    first_case_unit_validated = validation_targets.first_case_unit_validated,
    first_case_sttdfpm_state_validated = validation_targets.first_case_sttdfpm_state_validated,
)

# ╔═╡ 20000000-0000-0000-0000-000000000015
md"""
## Scope Boundary

This scaffold is ready when the metadata, helper availability, crosswalk structure, first executable unit, first STTDFPM-specific state unit, and validation targets are explicit.

It is not yet a benchmark result notebook. That boundary is deliberate: the paper-fixed Experiment 1 structure and the first-case runway are recorded here, while any concrete benchmark claim or full algorithm reproduction must still wait until the helper-to-paper mapping is checked carefully.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000016
PlutoUI.TableOfContents()
