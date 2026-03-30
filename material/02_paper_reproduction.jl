### A Pluto.jl notebook ###
# v0.20.24

using Markdown
using InteractiveUtils

# ╔═╡ 4d641635-10c1-4432-83b7-a13a55668a8c
begin
	import PlutoUI
	using Plots
end

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

# ╔═╡ 7432cb50-2c14-11f1-0782-bb0955e7e3be
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

# ╔═╡ 7432cb50-2c14-11f1-3706-cfc2bf585c3e
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

# ╔═╡ 7432cb50-2c14-11f1-2711-bb93150db1a5
md"""
## First-Case Choice

The first implementation runway is now the verified `Problem 2` row from the extracted paper list:

- local helper: `ExponetialI`
- projection: `projectOnBox`
- projection config: `bounds = (0.0, Inf)`
- starting dimension for the first executable unit: `10^3`

This choice is conservative and stronger than the earlier runway. The helper name and the positive-orthant constraint are both supported directly by the extracted Experiment 1 list. It is still only the first verified unit, not a full algorithm reproduction, which makes it a better teaching entry point than a broader step implementation.
"""

# ╔═╡ 7432cb50-2c14-11f1-34e7-9d937f68c211
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

# ╔═╡ 7432cb50-2c14-11f1-0bf9-6d40bf0a96eb
begin
	first_case_problem = getfield(@__MODULE__, first_case_choice.local_helper_symbol)
	first_case_projection = getfield(@__MODULE__, first_case_choice.projection_symbol)
end

# ╔═╡ 7432cb50-2c14-11f1-0baa-e9387f0e2977
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

# ╔═╡ 7432cb50-2c14-11f1-0341-cb58ebe4566c
first_case_validation = (
    projected_point_is_feasible = minimum(first_case_unit.projected_x0) >= first_case_unit.projection_bounds[1],
    projection_is_identity_on_positive_x0 = first_case_unit.projected_x0 == first_case_unit.x0,
    residual_length_matches_dimension = length(first_case_unit.residual) == first_case_unit.n,
    residual_entries_match_expected_value = all(isapprox.(first_case_unit.residual, first_case_unit.expected_entry; atol = 1e-12)),
    residual_norm_is_finite = isfinite(first_case_unit.residual_norm) && first_case_unit.residual_norm > 0,
)

# ╔═╡ 7432cb50-2c14-11f1-3f48-5ba8dba96179
md"""
## First STTDFPM State Unit

The next smallest paper-specific unit is a step-ready state for the verified `ExponetialI` case.

This notebook still does not implement a full STTDFPM iteration or line search. It only makes the paper parameters visible, forms the initial direction `d0 = -F(x0)`, applies one explicit trial step using the paper's `t`, and checks the geometry that should already hold before any full update logic is added.
"""

# ╔═╡ 7432cb50-2c14-11f1-131e-43bfb162fb99
first_case_paper_parameters = (
    t = paper_fixed_choices.parameters.t,
    beta = paper_fixed_choices.parameters.beta,
    sigma = paper_fixed_choices.parameters.sigma,
    gamma = paper_fixed_choices.parameters.gamma,
)

# ╔═╡ 7432cb50-2c14-11f1-1074-074d0e9f2aae
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

# ╔═╡ 7432cb50-2c14-11f1-191e-2fb891d8667e
first_case_sttdfpm_validation = (
    paper_trial_step_is_used = isapprox(first_case_sttdfpm_state.trial_step, paper_fixed_choices.parameters.t; atol = 0.0),
    initial_direction_is_negative_residual = all(isapprox.(first_case_sttdfpm_state.d0, .-first_case_sttdfpm_state.F0; atol = 1e-12)),
    initial_direction_is_descent_like = first_case_sttdfpm_state.directional_inner_product < 0,
    projected_trial_point_is_feasible = first_case_sttdfpm_state.projected_trial_minimum >= first_case_unit.projection_bounds[1],
    trial_point_stays_in_positive_orthant = first_case_sttdfpm_state.projected_z0 == first_case_sttdfpm_state.z0,
)

# ╔═╡ 7432cb50-2c14-11f1-389e-25ddbe3a9e44
md"""
## First Line-Search Condition Unit

The next smallest paper-facing unit is a single trial-point condition check on the current STTDFPM state.

This notebook still does not implement the full line search. It evaluates one paper-style sufficient-descent inequality at the current trial point:

```math
-F(z_0)^T d_0 \ge \sigma \, t \, \|d_0\|^2
```

That gives a visible pass/fail result for the chosen initialization without claiming that the complete acceptance procedure is implemented.
"""

# ╔═╡ 7432cb50-2c14-11f1-1c91-d766eb081efa
first_case_line_search_unit = let
    Fz0 = first_case_problem(first_case_sttdfpm_state.projected_z0)
    lhs = -sum(Fz0 .* first_case_sttdfpm_state.d0)
    rhs = first_case_paper_parameters.sigma * first_case_sttdfpm_state.trial_step * sum(abs2, first_case_sttdfpm_state.d0)
    condition_passes = lhs >= rhs
    (
        Fz0 = Fz0,
        lhs = lhs,
        rhs = rhs,
        condition_passes = condition_passes,
        summary = condition_passes ? "The current trial point passes this first sufficient-descent check." : "The current trial point fails this first sufficient-descent check.",
    )
end

# ╔═╡ 7432cb50-2c14-11f1-1051-f1db8af70b75
first_case_line_search_validation = (
    trial_residual_length_matches_dimension = length(first_case_line_search_unit.Fz0) == first_case_unit.n,
    lhs_is_finite = isfinite(first_case_line_search_unit.lhs),
    rhs_is_finite = isfinite(first_case_line_search_unit.rhs),
    rhs_is_nonnegative = first_case_line_search_unit.rhs >= 0,
    condition_evaluated = first_case_line_search_unit.condition_passes == (first_case_line_search_unit.lhs >= first_case_line_search_unit.rhs),
)

# ╔═╡ 7432cb50-2c14-11f1-1613-910ac2505963
md"""
## First Correction Step Unit

The next smallest STTDFPM-structured unit is the projection/hyperplane-style correction built from the current trial point.

At this stage the notebook still does not claim a full `x_0 -> x_1` method update. It only computes the derived quantities needed for the correction:

```math
\rho_0 = F(z_0)^T (x_0 - z_0), \qquad
\lambda_0 = \rho_0 / \|F(z_0)\|^2
```

and then forms one projected correction candidate using the current feasible point and `F(z_0)`.
"""

# ╔═╡ 7432cb50-2c14-11f1-041b-758015c9ffd8
first_case_correction_unit = let
    x0 = first_case_unit.projected_x0
    z0 = first_case_sttdfpm_state.projected_z0
    Fz0 = first_case_line_search_unit.Fz0
    rho0 = sum(Fz0 .* (x0 .- z0))
    Fz0_norm_sq = sum(abs2, Fz0)
    lambda0 = rho0 / Fz0_norm_sq
    correction_direction = lambda0 .* Fz0
    corrected_candidate = first_case_projection(x0 .- correction_direction; first_case_choice.projection_config...)
    (
        x0 = x0,
        z0 = z0,
        Fz0 = Fz0,
        rho0 = rho0,
        Fz0_norm_sq = Fz0_norm_sq,
        lambda0 = lambda0,
        correction_direction = correction_direction,
        corrected_candidate = corrected_candidate,
        corrected_candidate_minimum = minimum(corrected_candidate),
    )
end

# ╔═╡ 7432cb50-2c14-11f1-12d8-a36e0820afa7
first_case_correction_validation = (
    rho0_is_finite = isfinite(first_case_correction_unit.rho0),
    rho0_is_positive = first_case_correction_unit.rho0 > 0,
    correction_scale_is_finite = isfinite(first_case_correction_unit.lambda0) && first_case_correction_unit.lambda0 > 0,
    corrected_candidate_is_feasible = first_case_correction_unit.corrected_candidate_minimum >= first_case_unit.projection_bounds[1],
    correction_direction_matches_formula = all(
        isapprox.(
            first_case_correction_unit.correction_direction,
            first_case_correction_unit.lambda0 .* first_case_correction_unit.Fz0;
            atol = 1e-12,
        ),
    ),
)

# ╔═╡ 7432cb50-2c14-11f1-1388-4bdba9409b42
md"""
## First Single-Iteration Update

The next bounded unit is one explicit demonstrated update for the verified first case.

At this stage the notebook promotes the current projected correction candidate to a concrete
`x1`, evaluates `F(x1)`, and compares the updated residual against the starting state.

This is still not a general loop. It is one worked iteration artifact for the chosen initialization.
"""

# ╔═╡ 7432cb50-2c14-11f1-0c33-f987b0dbd07c
first_case_iteration_unit = let
    x1 = first_case_correction_unit.corrected_candidate
    F1 = first_case_problem(x1)
    residual_norm_0 = first_case_unit.residual_norm
    residual_norm_1 = sqrt(sum(abs2, F1))
    residual_change = residual_norm_1 - residual_norm_0
    residual_ratio = residual_norm_1 / residual_norm_0
    (
        x1 = x1,
        F1 = F1,
        residual_norm_0 = residual_norm_0,
        residual_norm_1 = residual_norm_1,
        residual_change = residual_change,
        residual_ratio = residual_ratio,
        iterate_changed = x1 != first_case_unit.projected_x0,
        residual_decreased = residual_norm_1 < residual_norm_0,
        summary = residual_norm_1 < residual_norm_0 ?
            "This demonstrated first update reduces the residual norm at the chosen initialization." :
            "This demonstrated first update does not reduce the residual norm at the chosen initialization.",
    )
end

# ╔═╡ 7432f260-2c14-11f1-2290-c702f4db17a1
first_case_iteration_validation = (
    updated_iterate_is_feasible = minimum(first_case_iteration_unit.x1) >= first_case_unit.projection_bounds[1],
    updated_residual_length_matches_dimension = length(first_case_iteration_unit.F1) == first_case_unit.n,
    updated_residual_norm_is_finite = isfinite(first_case_iteration_unit.residual_norm_1),
    residual_comparison_is_finite = isfinite(first_case_iteration_unit.residual_change) && isfinite(first_case_iteration_unit.residual_ratio),
    iterate_change_flag_is_consistent = first_case_iteration_unit.iterate_changed == (first_case_iteration_unit.x1 != first_case_unit.projected_x0),
)

# ╔═╡ 7432f260-2c14-11f1-1c6a-031899a399eb
md"""
## Reusable First-Step Unit

The demonstrated `x_0 -> x_1` calculation is now packaged as one reusable first-step helper for the verified `ExponetialI` case shape.

This helper is still intentionally small. It covers the current notebook scope only:

- project the input point
- evaluate `F(x_0)`
- build the first direction and trial point
- evaluate the first line-search condition quantities
- build the first correction candidate
- return one demonstrated `x_1` and `F(x_1)`

It does not implement the general iteration loop or the full method.
"""

# ╔═╡ 7432f260-2c14-11f1-2c67-71e7d63a301f
function sttdfpm_first_step_unit(problem, projection, x0; projection_config, t, sigma)
    projected_x0 = projection(x0; projection_config...)
    F0 = problem(projected_x0)
    d0 = .-F0
    z0 = projected_x0 .+ t .* d0
    projected_z0 = projection(z0; projection_config...)
    Fz0 = problem(projected_z0)
    line_search_lhs = -sum(Fz0 .* d0)
    line_search_rhs = sigma * t * sum(abs2, d0)
    rho0 = sum(Fz0 .* (projected_x0 .- projected_z0))
    Fz0_norm_sq = sum(abs2, Fz0)
    lambda0 = rho0 / Fz0_norm_sq
    correction_direction = lambda0 .* Fz0
    x1 = projection(projected_x0 .- correction_direction; projection_config...)
    F1 = problem(x1)
    (
        projected_x0 = projected_x0,
        F0 = F0,
        d0 = d0,
        z0 = z0,
        projected_z0 = projected_z0,
        Fz0 = Fz0,
        line_search_lhs = line_search_lhs,
        line_search_rhs = line_search_rhs,
        rho0 = rho0,
        lambda0 = lambda0,
        correction_direction = correction_direction,
        x1 = x1,
        F1 = F1,
        residual_norm_0 = sqrt(sum(abs2, F0)),
        residual_norm_1 = sqrt(sum(abs2, F1)),
    )
end

# ╔═╡ 7432f260-2c14-11f1-0321-75fe853beda1
first_case_first_step_function_unit = sttdfpm_first_step_unit(
    first_case_problem,
    first_case_projection,
    first_case_unit.x0;
    projection_config = first_case_choice.projection_config,
    t = first_case_paper_parameters.t,
    sigma = first_case_paper_parameters.sigma,
)

# ╔═╡ 7432f260-2c14-11f1-352d-f55876d1856f
first_case_first_step_function_validation = (
    projected_x0_matches_demonstration = first_case_first_step_function_unit.projected_x0 == first_case_unit.projected_x0,
    trial_point_matches_demonstration = first_case_first_step_function_unit.projected_z0 == first_case_sttdfpm_state.projected_z0,
    line_search_terms_match_demonstration = isapprox(first_case_first_step_function_unit.line_search_lhs, first_case_line_search_unit.lhs; atol = 1e-12) &&
        isapprox(first_case_first_step_function_unit.line_search_rhs, first_case_line_search_unit.rhs; atol = 1e-12),
    correction_terms_match_demonstration = isapprox(first_case_first_step_function_unit.rho0, first_case_correction_unit.rho0; atol = 1e-12) &&
        isapprox(first_case_first_step_function_unit.lambda0, first_case_correction_unit.lambda0; atol = 1e-12),
    x1_matches_demonstration = first_case_first_step_function_unit.x1 == first_case_iteration_unit.x1,
    residual_norm_matches_demonstration = isapprox(first_case_first_step_function_unit.residual_norm_1, first_case_iteration_unit.residual_norm_1; atol = 1e-12),
)

# ╔═╡ 7432f260-2c14-11f1-2cde-49aed6cf8e53
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
- It now contains one small line-search condition unit: evaluate a single sufficient-descent inequality at the current trial point and report whether it passes at the chosen initialization.
- It now contains one small correction-step unit: derive `rho0`, derive the scalar correction coefficient, form one projected correction candidate, and validate those quantities without yet claiming a full next iterate.
- It now contains one demonstrated single-iteration update unit: set `x1` equal to the current correction candidate, evaluate `F(x1)`, and compare the before/after residual norms without claiming a general convergence result.
- It now contains one reusable first-step helper that reproduces the same demonstrated `x0 -> x1` calculation for this verified case.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000010
implementation_notes = (
    immediate_next_units = (
        "Decide whether the next unit should generalize the helper beyond the first case or add one more paper-specific condition around the demonstrated `x1` update.",
        "Keep the next unit tied to the same verified `ExponetialI` state bundle.",
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
Keep the unit small: parameter bundle, direction, trial point, one condition check, or one geometry check is enough.
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
- the notebook contains one small line-search condition unit with a visible validation check
- the notebook contains one small correction-step unit with a visible validation check
- the notebook contains one demonstrated single-iteration update unit with a visible validation check
- the notebook contains one reusable first-step helper validated against the demonstrated first update
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
    first_case_line_search_validated = all(values(first_case_line_search_validation)),
    first_case_correction_validated = all(values(first_case_correction_validation)),
    first_case_iteration_validated = all(values(first_case_iteration_validation)),
    first_case_function_unit_validated = all(values(first_case_first_step_function_validation)),
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
    first_case_line_search_validated = validation_targets.first_case_line_search_validated,
    first_case_correction_validated = validation_targets.first_case_correction_validated,
    first_case_iteration_validated = validation_targets.first_case_iteration_validated,
    first_case_function_unit_validated = validation_targets.first_case_function_unit_validated,
)

# ╔═╡ 20000000-0000-0000-0000-000000000015
md"""
## Scope Boundary

This scaffold is ready when the metadata, helper availability, crosswalk structure, first executable unit, first STTDFPM-specific state unit, first line-search condition unit, first correction-step unit, demonstrated first single-iteration update, reusable first-step helper, and validation targets are explicit.

It is not yet a benchmark result notebook. That boundary is deliberate: the paper-fixed Experiment 1 structure and the first-case runway are recorded here, while any concrete benchmark claim or full algorithm reproduction must still wait until the helper-to-paper mapping is checked carefully. In particular, the notebook now demonstrates one explicit `x_1` update for this initialization, but it still does not claim a general loop or a full implementation of the complete method.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000016
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Plots = "~1.41.6"
PlutoUI = "~0.7.80"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.11"
manifest_format = "2.0"
project_hash = "87369d43b827ccd09dbc61a9a2fe9ffd38793a1d"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a21c5464519504e41e0cbc91f0188e8ca23d7440"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.5+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b0fd3f56fa442f81e0a47815c92245acfaaa4e34"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.31.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "67e11ee83a43eb71ddc950302c53bf33f0690dfe"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.12.1"

    [deps.ColorTypes.extensions]
    StyledStringsExt = "StyledStrings"

    [deps.ColorTypes.weakdeps]
    StyledStrings = "f489334b-da3d-4c2e-b8f0-e476e12c162b"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "8b3b6f87ce8f65a2b4f857528fd8d70086cd72b1"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.11.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "37ea44092930b1811e666c3bc38065d7d87fcc74"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.1"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "21d088c496ea22914fe80906eb5bce65755e5ec8"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.1"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["OrderedCollections"]
git-tree-sha1 = "e86f4a2805f7f19bec5129bc9150c38208e5dc23"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.19.4"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "473e9afc9cf30814eb67ffa5f2db7df82c3ad9fd"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.16.2+0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a4be429317c42cfae6a7fc03c31bad1970c310d"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+1"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "27af30de8b5445644e8ffe3bcb0d72049c089cf1"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.7.3+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "95ecf07c2eea562b5adbd0696af6db62c0f52560"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.5"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libva_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "66381d7059b5f3f6162f28831854008040a4e905"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "8.0.1+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "f85dac9a96a01087df6e3a749840015a0ca3817d"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.17.1+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "70329abc09b886fd2c5d94ad2d9527639c421e3e"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.14.3+1"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7a214fdac5ed5f59a22c2d9a885a16da1c74bbc7"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.17+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "b7bfd56fa66616138dfe5237da4dc13bbd83c67f"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.1+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "44716a1a667cb867ee0e9ec8edc31c3e4aa5afdc"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.24"

    [deps.GR.extensions]
    IJuliaExt = "IJulia"

    [deps.GR.weakdeps]
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "be8a1b8065959e24fdc1b51402f39f3b6f0f6653"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.24+0"

[[deps.GettextRuntime_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll"]
git-tree-sha1 = "45288942190db7c5f760f59c04495064eedf9340"
uuid = "b0724c58-0f36-5564-988d-3bb0596ebc4a"
version = "0.22.4+0"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Zlib_jll"]
git-tree-sha1 = "38044a04637976140074d0b0621c1edf0eb531fd"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.1+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "GettextRuntime_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "24f6def62397474a297bfcec22384101609142ed"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.86.3+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "51059d23c8bb67911a2e6fd5130229113735fc7e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.11.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "f923f9a774fcf3f5cb761bfa43aeadd689714813"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.1+0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "d1a86724f81bcd184a38fd284ce183ec067d71a0"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "1.0.0"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "0ee181ec08df7d7c911901ea38baf16f755114dc"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "b2d91fe939cae05960e760110b328288867b5758"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.6"

[[deps.JLFzf]]
deps = ["REPL", "Random", "fzf_jll"]
git-tree-sha1 = "82f7acdc599b65e0f8ccd270ffa1467c21cb647b"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.11"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "0533e564aae234aff59ab625543145446d8b6ec2"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.1"

[[deps.JSON]]
deps = ["Dates", "Logging", "Parsers", "PrecompileTools", "StructUtils", "UUIDs", "Unicode"]
git-tree-sha1 = "b3ad4a0255688dcb895a52fafbaae3023b588a90"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "1.4.0"

    [deps.JSON.extensions]
    JSONArrowExt = ["ArrowTypes"]

    [deps.JSON.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6893345fd6658c8e475d40155789f4860ac3b21"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.4+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "059aabebaa7c82ccb853dd4a0ee9d17796f7e1bc"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.3+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aaafe88dccbd957a8d82f7d05be9b69172e0cee3"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.1+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eb62a3deb62fc6d8822c0c4bef73e4412419c5d8"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.8+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c602b1127f4751facb671441ca72715cc95938a"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.3+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "Ghostscript_jll", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "44f93c47f9cd6c7e431f2f2091fcba8f01cd7e8f"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.10"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"
    TectonicExt = "tectonic_jll"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"
    tectonic_jll = "d7dd28d6-a5e6-559c-9131-7eb760cdacc5"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c8da7e6a91781c41a863611c7e966098d783c57a"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.4.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "d36c21b9e7c172a44a10484125024495e2625ac0"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.1+1"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "97bbca976196f2a1eb9607131cb108c69ec3f8a6"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.41.3+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "f04133fe05eff1667d2054c53d59f9122383fe05"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.2+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d0205286d9eceadc518742860bf23f703779a3d6"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.41.3+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f00544d95982ea270145636c181ceda21c4e2575"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.2.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "8785729fa736197687541f7053f6d8ab7fc44f92"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.10"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.1010+0"

[[deps.Measures]]
git-tree-sha1 = "b513cedd20d9c914783d8ad83d08120702bf2c77"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.3"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.12.2"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6aa4566bb7ae78498a5e68943863fa8b5231b59"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.6+0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+5"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.5+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "NetworkOptions", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "1d1aaa7d449b58415f97d2839c318b70ffb525a0"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.6.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c9cbeda6aceffc52d8a0017e71db27c7a7c0beaf"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e2bb57a313a74b8104064b7efd01406c0a50d2ff"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.6.1+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0662b083e11420952f2e62e17eddae7fc07d5997"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.57.0+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "db76b1ecd5e9715f3d043cec13b2ec93ce015d53"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.44.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "41031ef3a1be6f5bbbf3e8073f210556daeae5ca"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.3.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "26ca162858917496748aad52bb5d3be4d26a228a"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "cb20a4eacda080e517e4deb9cfb6c7c518131265"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.41.6"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "fbc875044d82c113a9dee6fc14e16cf01fd48872"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.80"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "8b770b60760d4451834fe79dd483e318eee709c4"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PtrArrays]]
git-tree-sha1 = "4fbbafbc6251b883f4d2705356f3641f3652a7fe"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.4.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "d7a4bff94f42208ce3cf6bc8e4e7d1d663e7ee8b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.10.2+1"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll", "Qt6Svg_jll"]
git-tree-sha1 = "d5b7dd0e226774cbd87e2790e34def09245c7eab"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.10.2+1"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "4d85eedf69d875982c46643f6b4f66919d7e157b"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.10.2+1"

[[deps.Qt6Svg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "81587ff5ff25a4e1115ce191e36285ede0334c9d"
uuid = "6de9746b-f93d-5813-b365-ba18ad4a9cf3"
version = "6.10.2+0"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "672c938b4b4e3e0169a07a5f227029d4905456f2"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.10.2+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "9b81b8393e50b7d4e6d0a9f14e192294d3b7c109"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.3.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "64d974c2e6fdf07f8155b5b2ca2ffa9069b608d9"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.2"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "4f96c596b8c8258cc7d3b19797854d368f243ddc"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "178ed29fd5b2a2cfc3bd31c13375ae925623ff36"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.8.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "IrrationalConstants", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "aceda6f4e598d331548e04cc6b2124a6148138e3"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.10"

[[deps.StructUtils]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "fa95b3b097bcef5845c142ea2e085f1b2591e92c"
uuid = "ec057cc2-7a8d-4b58-b3b3-92acb9f63b42"
version = "2.7.1"

    [deps.StructUtils.extensions]
    StructUtilsMeasurementsExt = ["Measurements"]
    StructUtilsStaticArraysCoreExt = ["StaticArraysCore"]
    StructUtilsTablesExt = ["Tables"]

    [deps.StructUtils.weakdeps]
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "96478df35bbc2f3e1e791bc7a3d0eeee559e60e9"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.24.0+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "9cce64c0fdd1960b597ba7ecda2950b5ed957438"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.2+0"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a3ea76ee3f4facd7a64684f9af25310825ee3668"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.2+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "9c7ad99c629a44f81e7799eb05ec2746abb5d588"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.6+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "808090ede1d41644447dd5cbafced4731c56bd2f"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.13+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aa1261ebbac3ccc8d16558ae6799524c450ed16b"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.13+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c74ca84bbabc18c4547014765d194ff0b4dc9da"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.4+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "52858d64353db33a56e13c341d7bf44cd0d7b309"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.6+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "1a4a26870bf1e5d26cd585e38038d399d7e65706"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.8+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "75e00946e43621e09d431d9b95818ee751e6b2ef"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.2+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "a376af5c7ae60d29825164db40787f15c80c7c54"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.3+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "0ba01bc7396896a4ace8aab67db31403c71628f4"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.7+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c174ef70c96c76f4c3f4d3cfbe09d018bcd1b53"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.6+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "7ed9347888fac59a618302ee38216dd0379c480d"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.12+0"

[[deps.Xorg_libpciaccess_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "4909eb8f1cbf6bd4b1c30dd18b2ead9019ef2fad"
uuid = "a65dc6b1-eb27-53a1-bb3e-dea574b5389e"
version = "0.18.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "ed756a03e95fff88d8f738ebc2849431bdd4fd1a"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.2.0+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "9750dc53819eba4e9a20be42349a6d3b86c7cdf8"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.6+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "f4fc02e384b74418679983a97385644b67e1263b"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll"]
git-tree-sha1 = "68da27247e7d8d8dafd1fcf0c3654ad6506f5f97"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "44ec54b0e2acd408b0fb361e1e9244c60c9c3dd4"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "5b0263b6d080716a02544c55fdff2c8d7f9a16a0"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.10+0"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "f233c83cad1fa0e70b7771e0e21b061a116f2763"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.2+0"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "801a858fc9fb90c11ffddee1801bb06a738bda9b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.7+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "00af7ebdc563c9217ecc67776d1bbf037dbcebf4"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.44.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a63799ff68005991f9d9491b6e95bd3478d783cb"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.6.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c3b0e6196d50eab0c5ed34021aaa0bb463489510"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.14+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6a34e0e0960190ac2a4363a1bd003504772d631"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.61.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "371cc681c00a3ccc3fbc5c0fb91f58ba9bec1ecf"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.13.1+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "125eedcb0a4a0bba65b657251ce1d27c8714e9d6"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.17.4+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[deps.libdrm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libpciaccess_jll"]
git-tree-sha1 = "63aac0bcb0b582e11bad965cef4a689905456c03"
uuid = "8e53e030-5e6c-5a89-a30b-be5b7263a166"
version = "2.4.125+1"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "56d643b57b188d30cccc25e331d416d3d358e557"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.13.4+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "646634dd19587a56ee2f1199563ec056c5f228df"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.4+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "91d05d7f4a9f67205bd6cf395e488009fe85b499"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.28.1+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e2a7072fc0cdd7949528c1455a3e5da4122e1153"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.56+0"

[[deps.libva_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll", "Xorg_libXfixes_jll", "libdrm_jll"]
git-tree-sha1 = "7dbf96baae3310fe2fa0df0ccbb3c6288d5816c9"
uuid = "9a156e7d-b971-5f62-b2c9-67348b8fb97c"
version = "2.23.0+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll"]
git-tree-sha1 = "11e1772e7f3cc987e9d3de991dd4f6b2602663a5"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.8+0"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b4d631fd51f2e9cdd93724ae25b2efc198b059b1"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.7+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.6.1+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "14cc7083fc6dff3cc44f2bc435ee96d06ed79aa7"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "10164.0.1+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e7b67590c14d487e734dcb925924c5dc43ec85f3"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "4.1.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "a1fc6507a40bf504527d0d4067d718f8e179b2b8"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.13.0+0"
"""

# ╔═╡ Cell order:
# ╠═20000000-0000-0000-0000-000000000001
# ╟─20000000-0000-0000-0000-000000000002
# ╠═20000000-0000-0000-0000-000000000003
# ╟─20000000-0000-0000-0000-000000000004
# ╠═20000000-0000-0000-0000-000000000005
# ╠═20000000-0000-0000-0000-000000000006
# ╟─20000000-0000-0000-0000-000000000007
# ╠═20000000-0000-0000-0000-000000000008
# ╠═20000000-0000-0000-0000-000000000009
# ╠═20000000-0000-0000-0000-00000000000a
# ╠═20000000-0000-0000-0000-00000000000b
# ╠═20000000-0000-0000-0000-00000000000c
# ╠═20000000-0000-0000-0000-00000000000d
# ╠═7432cb50-2c14-11f1-0782-bb0955e7e3be
# ╠═7432cb50-2c14-11f1-3706-cfc2bf585c3e
# ╟─7432cb50-2c14-11f1-2711-bb93150db1a5
# ╠═7432cb50-2c14-11f1-34e7-9d937f68c211
# ╠═7432cb50-2c14-11f1-0bf9-6d40bf0a96eb
# ╠═7432cb50-2c14-11f1-0baa-e9387f0e2977
# ╠═7432cb50-2c14-11f1-0341-cb58ebe4566c
# ╟─7432cb50-2c14-11f1-3f48-5ba8dba96179
# ╠═7432cb50-2c14-11f1-131e-43bfb162fb99
# ╠═7432cb50-2c14-11f1-1074-074d0e9f2aae
# ╠═7432cb50-2c14-11f1-191e-2fb891d8667e
# ╟─7432cb50-2c14-11f1-389e-25ddbe3a9e44
# ╠═7432cb50-2c14-11f1-1c91-d766eb081efa
# ╠═7432cb50-2c14-11f1-1051-f1db8af70b75
# ╟─7432cb50-2c14-11f1-1613-910ac2505963
# ╠═7432cb50-2c14-11f1-041b-758015c9ffd8
# ╠═7432cb50-2c14-11f1-12d8-a36e0820afa7
# ╟─7432cb50-2c14-11f1-1388-4bdba9409b42
# ╠═7432cb50-2c14-11f1-0c33-f987b0dbd07c
# ╠═7432f260-2c14-11f1-2290-c702f4db17a1
# ╟─7432f260-2c14-11f1-1c6a-031899a399eb
# ╠═7432f260-2c14-11f1-2c67-71e7d63a301f
# ╠═7432f260-2c14-11f1-0321-75fe853beda1
# ╟─7432f260-2c14-11f1-352d-f55876d1856f
# ╟─7432f260-2c14-11f1-2cde-49aed6cf8e53
# ╠═20000000-0000-0000-0000-00000000000e
# ╟─20000000-0000-0000-0000-00000000000f
# ╠═20000000-0000-0000-0000-000000000010
# ╠═20000000-0000-0000-0000-000000000011
# ╟─20000000-0000-0000-0000-000000000012
# ╠═20000000-0000-0000-0000-000000000013
# ╠═20000000-0000-0000-0000-000000000014
# ╟─20000000-0000-0000-0000-000000000015
# ╠═20000000-0000-0000-0000-000000000016
# ╠═4d641635-10c1-4432-83b7-a13a55668a8c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
