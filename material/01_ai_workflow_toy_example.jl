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

It is intentionally a bridge notebook. The point is to practice the workflow on a toy problem before moving to the Ibrahim 2023 paper and its paper-specific assumptions.
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
md"""
## Prompt

Use this exact prompt to ask Codex for the first code unit:

```text
Restate the scalar root-finding task in plain language.
Write a minimal Newton solver for F(x) = 0 in Julia.
Keep the first version small enough to validate on F(x) = x^2 - 2.
Return the iterate history and residuals.
Do not introduce paper-specific details yet.
```

That prompt stays narrow on purpose. It asks for one unit, one equation, and one validation target.
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
toy_validation = (
    expected_root = sqrt(2),
    close_to_root = isapprox(toy_run.final_x, sqrt(2); atol = 1e-10),
    residual_small = toy_run.final_residual <= 1e-12,
    converged = toy_run.converged,
)

# ╔═╡ 10000000-0000-0000-0000-000000000006a
toy_verification_summary = (
    root_check_passed = toy_validation.close_to_root,
    residual_check_passed = toy_validation.residual_small,
    converged = toy_validation.converged,
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
- This notebook is only the bridge into the Ibrahim 2023 workflow. The later paper notebook will replace the toy equation with the paper's actual numerical problem and stopping criteria.
"""

# ╔═╡ 10000000-0000-0000-0000-000000000009
md"""
## Workflow Discipline

The same loop from notebook 00 applies here:

1. state the math in plain language
2. ask for the smallest useful Julia unit
3. run it on a tiny known example
4. validate the result before adding complexity

That discipline matters even for a toy example, because it is the same habit we need when we move to the Ibrahim paper.
"""

# ╔═╡ 10000000-0000-0000-0000-00000000000a
md"""
## Notebook Verification

This notebook is valid if all of the following are true:

- the prompt is written explicitly in the notebook
- the Newton solver cell runs on a known scalar example
- the validation tuple reports `converged = true`
- the residual plot shows a downward trend on a log scale

The notebook does not claim paper reproduction. It only proves that the AI-assisted coding loop works on a small academic numerical task.
"""

# ╔═╡ 10000000-0000-0000-0000-00000000000b
PlutoUI.TableOfContents()
