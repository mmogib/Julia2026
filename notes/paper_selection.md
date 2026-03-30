# Paper Selection

## Purpose

Choose one paper that is academically respectable, implementable in a workshop setting, and suitable for Codex-assisted Julia reproduction plus a benchmark extension.

## Selection Criteria

Scores use a 1-5 scale, where 1 is poor and 5 is strong.
Weighted total = sum(score x weight) across all criteria, with a maximum of 150.

| Criterion | Weight | What Good Looks Like |
| --- | ---: | --- |
| Numerical experiment clarity | 5 | The paper states inputs, parameters, outputs, and evaluation metrics clearly enough to reproduce one target result without guesswork. |
| Implementation complexity | 5 | A clean baseline version can be coded during a two-session workshop without specialized infrastructure. |
| Validation tractability | 5 | Results can be checked with small tests, tables, plots, or known qualitative trends. |
| Benchmark extension potential | 4 | The implementation can be extended into runtime, accuracy, or scaling comparisons without redesigning the core method. |
| Sensitivity-analysis potential | 2 | Optional parameter variation is meaningful but not required for the main story. |
| Data/setup burden | 4 | No heavy external data pipeline, custom solver stack, or large preprocessing burden is needed. |
| Workshop fit | 5 | The core experiment fits the workshop's workflow-first narrative and four-hour teaching window. |

## Candidate Table

| Candidate | Source | Experiment Target | Complexity | Benchmark Potential | Risks | Decision |
| --- | --- | --- | --- | --- | --- | --- |
| `aFairagShahraniTawfiq2016SIAMJMATRIX` | `refs/895 - aFairagShahraniTawfiq2016SIAMJMATRIX.pdf` | Rectangular-grid Darcy mixed FEM experiments comparing the proposed block-triangular preconditioner against `Pdiv`, including eigenvalue clustering and GMRES/CG iteration counts. | High | High | Requires H(div) discretization, saddle-point assembly, preconditioner logic, and more linear-algebra machinery than is ideal for a short workshop. | Reject |
| `Ibrahim2023 spectral three-term derivative-free` | `refs/Ibrahim et al. - 2023 - Two classes of spectral three-term derivative-free.pdf` | Benchmark nonlinear-equation test set plus sparse-signal recovery application, with iteration counts, function evaluations, CPU time, and MSE. | Medium | High | Multiple test problems plus an application, but each piece is modular and the derivative-free structure is approachable in Julia. | Keep |
| `NMS_DEED_MPSGrid_DR` | `refs/NMS_DEED_MPSGrid_DR.pdf` | Multi-period Stackelberg DEED scenarios with customer-count scaling, IEEE 30-bus validation, sensitivity analysis, and Pareto-front studies. | Very High | High | Large coupled optimization model, many decision variables, solver-heavy implementation, and significant data/assumption surface area. | Reject |

## Candidate Reviews

### aFairagShahraniTawfiq2016SIAMJMATRIX

- Problem type: mixed finite element discretization of Darcy flow leading to a saddle-point linear system.
- Core algorithmic ingredients: Raviart-Thomas elements, block-triangular preconditioner, Bramble-Pasciak-type CG, GMRES comparison, eigenvalue bounds.
- Numerical experiment target: rectangular-grid Darcy problems on `[0, 1] x [0, 1]`, comparing spectral behavior and iteration counts against `Pdiv`.
- Inputs/data required: mesh generation, permeability field `K`, right-hand side data, and matrix assembly for the mixed FEM system.
- Figures/tables that appear reproducible: eigenvalue clustering plots, convergence curves, and iteration tables comparing preconditioners.
- Likely Julia package needs: finite-element tooling or custom sparse assembly, linear algebra, preconditioning, and iterative solvers.
- Main workshop risks: too much time spent on FEM plumbing instead of the AI-assisted workflow; preconditioner implementation is nontrivial for a short course.

### Ibrahim2023 spectral three-term derivative-free

- Problem type: large-scale nonlinear equations solved with derivative-free spectral three-term projection methods.
- Core algorithmic ingredients: projection method, spectral three-term update, trust-region and sufficient-descent logic, comparison against existing projection methods.
- Numerical experiment target: 12 benchmark test problems plus a sparse-signal recovery application with 100 trials and MSE reporting.
- Inputs/data required: benchmark nonlinear test functions, initial guesses, stopping rules, and synthetic sensing data for the signal recovery case.
- Figures/tables that appear reproducible: benchmark comparison tables for iterations/function evaluations/CPU time and the sparse-signal MSE table.
- Likely Julia package needs: nonlinear root-finding utilities, vector/matrix operations, benchmark timing, and lightweight plotting.
- Main workshop risks: the paper has several experiments, but each one can be scoped to a small reproducible unit; the main risk is trying to do too much rather than the method being inaccessible.

### NMS_DEED_MPSGrid_DR

- Problem type: multi-objective dynamic economic emission dispatch with Stackelberg game structure and demand response.
- Core algorithmic ingredients: bilevel optimization, customer/utility coupling, DC-OPF constraints, weighted-sum scalarization, interior-point solving.
- Numerical experiment target: customer-scaling studies, IEEE 30-bus validation, sensitivity sweeps, Pareto-front analysis, and a Saudi Eastern Province case study.
- Inputs/data required: generator coefficients, customer parameters, tariff assumptions, network topology, and scenario-specific data for multiple experiments.
- Figures/tables that appear reproducible: scaling tables, network-constraint comparison tables, sensitivity plots, and Pareto-front figures.
- Likely Julia package needs: nonlinear programming, power-flow or network-constraint modeling, and careful data orchestration.
- Main workshop risks: the model surface is too wide for a two-session workshop, and participants would spend more time understanding the optimization model than practicing the Codex workflow.

## Scored Comparison

| Candidate | Clarity (w=5) | Complexity (w=5) | Validation (w=5) | Benchmark (w=4) | Sensitivity (w=2) | Setup (w=4) | Fit (w=5) | Weighted Total |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `aFairagShahraniTawfiq2016SIAMJMATRIX` | 4 | 2 | 4 | 4 | 2 | 2 | 3 | 93 |
| `Ibrahim2023 spectral three-term derivative-free` | 4 | 4 | 5 | 4 | 4 | 4 | 5 | 130 |
| `NMS_DEED_MPSGrid_DR` | 3 | 1 | 4 | 4 | 4 | 1 | 1 | 73 |

## Recommended Paper

**Choice:** `Two classes of spectral three-term derivative-free method for solving nonlinear equations with application`

### Why This Fits

- It is workflow-first rather than derivation-heavy.
- The paper supports one bounded benchmark reproduction in the workshop and a separate extension path afterward.
- The implementation can stay modular in Julia, which matches the workshop's emphasis on small Codex prompts and explicit checks.
- The sparse-signal recovery application is a later extension, not part of the first-pass reproduction goal.

### Bounded Workshop Claim

The workshop will reproduce one representative benchmark comparison from the paper in Julia, verify it against the paper's reported trend and stopping tolerance, and leave the sparse-signal recovery application as a later extension if time remains.

## Rejected Candidates

### Bramble-Pasciak-Type Conjugate Gradient Method for Darcy's Equations

- The strongest issue is implementation heaviness: finite-element assembly, H(div) structure, and preconditioner machinery would consume the workshop's time budget.
- It is academically strong, but the teaching value would shift from disciplined AI-assisted coding to infrastructure work.

### A Stackelberg Game for Multi-Objective Demand Response in Dynamic Economic Emission Dispatch

- The strongest issue is scope: the model has too many coupled variables, constraints, and scenario families for a four-hour workshop arc.
- It is also setup-heavy, with a large optimization and data surface that would make validation fragile for participants.

## Workshop Experiment Target

### Primary Reproduction Target

- selected figure/table: one benchmark comparison table row for iterations, function evaluations, and CPU time.
- exact claim we want to reproduce: the Julia implementation matches the paper's reported trend on one representative benchmark problem under the stated stopping tolerance.
- required inputs and parameters: the chosen benchmark function, its initial guess, the stopping tolerance, and the algorithm parameters used for that one run.
- acceptance criteria for a successful workshop reproduction: one benchmark problem solves correctly and the comparison metrics are computed in Julia.

### Later Extensions

- sparse-signal recovery MSE table.
- optional expansion to multiple benchmark problems after the primary reproduction is stable.
- broader runtime comparisons once the single-case reproduction is verified.
