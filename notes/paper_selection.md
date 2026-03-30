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
| `aFairagShahraniTawfiq2016SIAMJMATRIX` | `refs/895 - aFairagShahraniTawfiq2016SIAMJMATRIX.pdf` | Lowest-order Raviart-Thomas Darcy discretization on rectangular grids, comparing the proposed block-triangular preconditioner with `Pdiv` through eigenvalue clustering, PHCG residual histories, and GMRES iteration counts. | High | Medium-High | Requires mixed FEM assembly, H(div) spaces, Schur-complement/preconditioner reasoning, and nonstandard-inner-product Krylov logic before the benchmarking story even starts. | Reject |
| `Ibrahim2023 spectral three-term derivative-free` | `refs/Ibrahim et al. - 2023 - Two classes of spectral three-term derivative-free.pdf` | Julia implementation of STTDFPM for large-scale nonlinear equations, validated against performance profiles over 12 benchmark problems and optionally against the compressed-sensing application with reported MSE. | Medium | High | The paper clearly supports a benchmark-suite workflow, but it does not pin one canonical in-paper row tightly enough to choose a single workshop target without leaning on external materials. | Keep |
| `NMS_DEED_MPSGrid_DR` | `refs/NMS_DEED_MPSGrid_DR.pdf` | SGSD-DEED model progression, IEEE 30-bus DC-OPF validation, customer-scaling studies, sensitivity analysis, Pareto fronts, and Saudi case-study comparisons. | Very High | High | Rich benchmarking, but the optimization model surface is too large for a workshop-first implementation and would push the session toward model comprehension rather than disciplined reproduction workflow. | Reject |

## Candidate Reviews

### aFairagShahraniTawfiq2016SIAMJMATRIX

- Problem type: linear saddle-point system from Darcy flow discretized with lowest-order Raviart-Thomas mixed finite elements on rectangular grids.
- Core algorithmic ingredients: block-triangular preconditioner `P(gamma1, gamma2)`, block-diagonal `Pdiv` baseline, PHCG in a nonstandard inner product, and GMRES for the nonsymmetric preconditioned system.
- Numerical experiment metadata grounded in the paper:
  - Section 6 studies eigenvalue clustering under uniform meshes.
  - Section 6.1 varies permeability, including discontinuous `K(x)` with `epsilon` ranging from `10^-6` to `10^6`.
  - Section 6.2 compares `P(gamma1, gamma2)` against `Pdiv` with PHCG residual reductions to `10^-10`.
  - Section 6.3 reports GMRES iterations for `K = I`, `f = 1`, and mesh sizes `h = 1/8, 1/16, 1/32, 1/64`; unpreconditioned counts grow from `101` to `983`, while the best triangular preconditioner stays at `3-4` iterations.
- Inputs/data required: mesh generation, RT0 finite-element spaces, Darcy operators, permeability fields, mass/divergence matrices, and preconditioner parameter selection satisfying the positive-definiteness condition.
- Validation surface: eigenvalue bounds, PHCG residual curves, and iteration tables are concrete once the FEM machinery exists.
- Workshop fit assessment: academically solid, but the first half of the workshop would be spent building FEM and preconditioning infrastructure rather than demonstrating a workflow-first Julia reproduction.

### Ibrahim2023 spectral three-term derivative-free

- Problem type: derivative-free projection methods for large-scale systems of nonlinear equations, with an optional compressed-sensing application.
- Core algorithmic ingredients: STTDFPM and ISTTDFPM, line search, projection, sufficient-descent and trust-region properties, and comparison against MOPCG, CGDFPM, and AHDFPM.
- Numerical experiment metadata grounded in the paper:
  - The implementation was written in Julia `1.8.5` and run on an Intel i9-9900K with 32 GB RAM.
  - Experiment 1 evaluates 12 named benchmark problems across dimensions `n = 10^3, 10^4, 10^5`.
  - The paper specifies 14 initial-point families, a stopping tolerance `epsilon = 10^-11`, a `k > 2000` safeguard, and explicit STTDFPM/ISTTDFPM parameter values: `t = 0.11`, `beta = 0.5`, `sigma = 0.01`, `gamma = 1.8`, `alpha_min = 10^-10`, `alpha_max = 10^30`, `r = 0.1`, `psi = 0.2`, `eta_1 = 0.001`, `eta_2 = 0.6`.
  - Experiment 1 reports only performance profiles in the manuscript; the paper explicitly points readers to an external repository for detailed numerical experiments.
  - Experiment 2 is more concrete in-paper: compressed sensing with randomly generated `A`, Gaussian noise `N(0, 0.01)`, `n = 2^11`, `m = 2^9`, `27` nonzeros in the original signal, `100` trials, and average MSE reported for four methods.
- Inputs/data required: benchmark-problem definitions or one application formulation, starting vectors, stopping rules, and comparison metrics.
- Validation surface: strong. Performance-profile trends, stopping behavior, and the compressed-sensing MSE table all support lightweight checks.
- Workshop fit assessment: best match for the approved design because the implementation can center on a compact numerical workflow in Julia, with benchmarking as the main narrative and sensitivity left secondary.
- Canonical-target assessment: keep deferred for now. The paper supports the shortlist decisively, but the exact single benchmark case for the workshop is not fully grounded inside the manuscript alone because Experiment 1 is suite-level and the detailed per-problem results are delegated to external materials.

### NMS_DEED_MPSGrid_DR

- Problem type: multi-period Stackelberg game for smart-grid demand response integrated with multi-objective dynamic economic emission dispatch.
- Core algorithmic ingredients: tri-objective weighted scalarization, customer curtailment/shifting/storage/local generation/grid exchange, interior-point optimization, DC power flow constraints, and Pareto analysis.
- Numerical experiment metadata grounded in the paper:
  - All models are solved in Julia `1.10` via JuMP and Ipopt.
  - Experiment 1 compares SGSD-DEED against DR-DEED on two scenarios: SC1 with `6` generators and `5` customers, and SC2 with `10` generators and `7` customers.
  - Experiment 3 adds IEEE 30-bus DC-OPF constraints and reports `2.8-4.9%` cost overhead and `12.6-15.1%` emission increases.
  - Experiment 4 shows model progression from DEED to DR-DEED to SGSD-DEED; in SC1 the paper reports cost dropping from `3.17302e5` to `1.40263e5` and emissions from `2.7743e4` to `7.869e3`.
  - Experiment 5 adds 64 weight combinations, willingness sweeps, customer scaling from `5` to `50`, storage-capacity analysis, and epsilon-constraint Pareto fronts.
  - Experiment 6 adds a Saudi Eastern Province case study with time-of-use tariff assumptions and repeated network/model-progression studies.
- Inputs/data required: generator coefficients, customer utility and budget parameters, network topology, dispatch horizon, tariff assumptions, and solver-ready nonlinear optimization formulations.
- Validation surface: very strong once implemented, but only after substantial modeling work.
- Workshop fit assessment: too broad for the approved workshop arc. The benchmarking story is attractive, but the setup burden and coupled optimization structure would dominate the session.

## Scored Comparison

| Candidate | Clarity (w=5) | Complexity (w=5) | Validation (w=5) | Benchmark (w=4) | Sensitivity (w=2) | Setup (w=4) | Fit (w=5) | Weighted Total |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `aFairagShahraniTawfiq2016SIAMJMATRIX` | 4 | 1 | 4 | 3 | 2 | 1 | 2 | 74 |
| `Ibrahim2023 spectral three-term derivative-free` | 4 | 4 | 5 | 4 | 3 | 4 | 5 | 126 |
| `NMS_DEED_MPSGrid_DR` | 4 | 1 | 4 | 5 | 5 | 1 | 1 | 85 |

## Recommended Paper

**Choice:** `Two classes of spectral three-term derivative-free method for solving nonlinear equations with application`

### Why This Fits

- It preserves the workshop's workflow-first shape: implement a compact numerical method, run it, inspect stopping behavior, and benchmark against a small comparison set.
- The paper is already grounded in Julia, which lowers translation overhead for a Codex-assisted workshop.
- Benchmarking is the core story in the manuscript itself: Experiment 1 is a benchmark-suite comparison, while the compressed-sensing application can remain optional or follow-on.
- Validation can stay lightweight and explicit, which matches the approved mixed hands-on format better than either FEM infrastructure or large nonlinear energy models.

### Bounded Workshop Claim

The workshop should use this paper for the shortlist and implementation direction, but it should not yet lock a single canonical benchmark row from the manuscript.

Reason:

- Experiment 1 is reported in-paper as performance profiles over 12 problems, 3 dimensions, and 14 initial-point families.
- The manuscript names the benchmark problems and stopping rules, but it does not provide a single clearly privileged table row to reproduce as the workshop anchor.
- The paper explicitly sends readers to external materials for detailed numerical experiments.

That is enough to justify the paper choice, but not enough to name the exact canonical workshop target without overcommitting.

## Rejected Candidates

### Bramble-Pasciak-Type Conjugate Gradient Method for Darcy's Equations

- Rejected because the implementation burden lands in the wrong place for this workshop: RT0 mixed FEM assembly, H(div) data structures, and custom preconditioning would dominate the schedule before participants reach the benchmarking workflow.
- The paper's experiments are credible and measurable, but they sit on top of specialized numerical infrastructure that is too heavy for a four-hour, workflow-first session.

### A Stackelberg Game for Multi-Objective Demand Response in Dynamic Economic Emission Dispatch

- Rejected because the model surface is too large: the paper combines bilevel game structure, multi-objective dispatch, DC-OPF constraints, scaling studies, Pareto analysis, and a regional case study.
- Even though the paper has excellent benchmark and sensitivity material, a faithful reproduction would require too many assumptions, parameters, and solver details for the intended workshop scope.

## Workshop Experiment Target

### Canonical Target Selection

Keep the Task 1 deferral in place.

The canonical workshop benchmark target is still **not selected** from the paper text alone.

Current grounded position:

- `Ibrahim2023` is the correct paper to build around.
- The exact single benchmark case should be fixed only after consulting the detailed benchmark artifacts or repository material referenced by the paper.
- If the workshop must remain paper-only, the safer bounded option is to treat the canonical target as "one representative benchmark case from Experiment 1" rather than naming a specific problem-number/dimension/initial-point tuple now.

### Later Extensions

- reproduce one compressed-sensing application run using the paper's in-text settings (`n = 2^11`, `m = 2^9`, `100` trials, MSE comparison) if the workshop needs a secondary application
- expand from one benchmark case to a small benchmark panel once the first implementation is stable
- add runtime and function-evaluation benchmarking against one or two baseline methods after the core reproduction is verified
