### A Pluto.jl notebook ###

# v0.20.0

using Markdown
using InteractiveUtils
using PlutoUI
using Plots

# ╔═╡ 10000000-0000-0000-0000-000000000001
md"""
# AI Workflow Toy Example

This notebook teaches the AI-assisted coding loop on a small numerical task:
scalar Newton-based root finding for `F(x) = 0`.

It is intentionally a bridge notebook into the Ibrahim 2023 workflow. The point is to practice the loop on a toy problem before moving to the paper-specific assumptions.
"""

# ╔═╡ 10000000-0000-0000-0000-000000000002
md"""
## Problem Statement

We want to solve a scalar nonlinear equation `F(x) = 0` with Newton's method.

For the workshop toy example, use

```math
F(x) = x^2 - 2
```

because the true root is known (`\sqrt{2}`), which makes validation concrete and small. The task is not to reproduce the paper here. The task is to practice a disciplined prompt, a minimal implementation, and a quick check before any scaling or paper-specific adaptation.
"""

# ╔═╡ 10000000-0000-0000-0000-000000000003
task_restatement = (
    task = "Solve a scalar nonlinear equation F(x) = 0 with Newton's method.",
    example = "Use F(x) = x^2 - 2 so the root is known.",
    validation_target = "Check the final iterate against sqrt(2) and inspect the residual decay.",
)

# ╔═╡ 10000000-0000-0000-0000-000000000003a
md"""
## Workflow Artifacts

These cells make the AI-assisted loop visible:

- the task restatement is written down explicitly
- the first prompt is narrow enough to hand to Codex
- the returned Pluto cell is inspected against concrete outputs
- the next prompt after validation is recorded before any scaling
"""

# ╔═╡ 10000000-0000-0000-0000-000000000003b
first_prompt = raw"""
Write the next Pluto cell for a scalar Newton root-finding task.
Restate the problem in plain language.
Implement a minimal Newton solver for F(x) = 0 in Julia.
Keep the first version small enough to validate on F(x) = x^2 - 2.
Return the iterate history and residuals.
Do not introduce paper-specific details yet.
"""

# ╔═╡ 10000000-0000-0000-0000-000000000004
newton_trace(F, dF, x0; tol = 1e-12, maxiter = 8) = begin
    xs = Float64[x0]
    residuals = Float64[abs(F(x0))]
    x = float(x0)

    for _ in 1:maxiter
        fx = F(x)
        dfx = dF(x)
        iszero(dfx) && break

        x = x - fx / dfx
        push!(xs, x)
        push!(residuals, abs(F(x)))

        residuals[end] <= tol && break
    end

    (
        xs = xs,
        residuals = residuals,
        final_x = xs[end],
        final_residual = residuals[end],
        converged = residuals[end] <= tol,
        iterations = length(xs) - 1,
    )
end

# ╔═╡ 10000000-0000-0000-0000-000000000005
toy_F(x) = x^2 - 2
toy_dF(x) = 2x
toy_run = newton_trace(toy_F, toy_dF, 1.0)

# ╔═╡ 10000000-0000-0000-0000-000000000006
toy_code_unit_inspection = (
    inspected_unit = :newton_trace,
    observed_outputs = (
        xs = toy_run.xs,
        residuals = toy_run.residuals,
        final_x = toy_run.final_x,
        final_residual = toy_run.final_residual,
    ),
    inspection_focus = (
        "does the cell return the iterate history?",
        "does the cell return the residuals?",
        "does the update move toward the known root?",
    ),
)

# ╔═╡ 10000000-0000-0000-0000-000000000006a
toy_verification_summary = (
    root_check_passed = isapprox(toy_run.final_x, sqrt(2); atol = 1e-10),
    residual_check_passed = toy_run.final_residual <= 1e-12,
    converged = toy_run.converged,
)

# ╔═╡ 10000000-0000-0000-0000-000000000007
plot(
    0:length(toy_run.residuals) - 1,
    toy_run.residuals;
    marker = :circle,
    yscale = :log10,
    xlabel = "Iteration",
    ylabel = "|F(x_k)|",
    label = "residual",
    title = "Toy Newton residual decay",
)

# ╔═╡ 10000000-0000-0000-0000-000000000008
md"""
## Validation Notes

- The final iterate should be close to `sqrt(2)`.
- The residual should drop rapidly from the initial value.
- If the residual does not decrease, inspect the derivative, the update formula, or the starting guess before adding any extra features.
- The bridge to the Ibrahim 2023 notebook is deliberate, but the notebook stays toy-sized here.
"""

# ╔═╡ 10000000-0000-0000-0000-000000000009
md"""
## Workflow Discipline

The same loop from notebook 00 applies here:

1. state the math in plain language
2. ask for the smallest useful Julia unit
3. run it on a tiny known example
4. validate the result before adding complexity

That discipline matters even for a toy example.
"""

# ╔═╡ 10000000-0000-0000-0000-000000000009a
next_prompt_after_validation = raw"""
Now write the next Pluto cell that adapts this same Newton workflow to the paper's actual equation.
Keep the cell minimal.
Name the paper-specific assumptions explicitly before you code them.
Do not add benchmarking or extra abstractions yet.
"""

# ╔═╡ 10000000-0000-0000-0000-00000000000a
md"""
## Notebook Verification

This notebook is valid if all of the following are true:

- the prompt is written explicitly in the notebook
- the task restatement is written explicitly in the notebook
- the Newton solver cell runs on a known scalar example
- the verification summary reports `converged = true`
- the residual plot shows a downward trend on a log scale

The notebook does not claim paper reproduction. It only proves that the AI-assisted coding loop works on a small academic numerical task.
"""

# ╔═╡ 10000000-0000-0000-0000-00000000000b
PlutoUI.TableOfContents()
