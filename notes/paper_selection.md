# Paper Selection

## Purpose

Choose one paper that is academically respectable, implementable in a workshop setting, and suitable for Codex-assisted Julia reproduction plus a benchmark extension.

## Selection Criteria

Scores use a 1-5 scale, where 1 is poor and 5 is strong.
Weighted total = sum(score x weight) across all criteria, with a maximum of 150.

| Criterion | Weight | What Good Looks Like |
| --- | ---: | --- |
| Numerical experiment clarity | 5 | The paper states inputs, parameters, outputs, and evaluation metrics clearly enough to reproduce one target result without avoidable guesswork. |
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
| `Ibrahim2023 spectral three-term derivative-free` | `refs/Ibrahim et al. - 2023 - Two classes of spectral three-term derivative-free.pdf` | Julia reproduction scaffold anchored on Experiment 1's large-scale monotone-equation suite, using the paper's stated algorithmic parameters and the local helper definitions in `refs/problems.jl` and `refs/projections.jl` to stay as close as possible to the manuscript. | Medium | High | The manuscript reports Experiment 1 mainly through performance profiles, so the notebook must distinguish paper-fixed parameters from still-open benchmark-case mapping choices. | Keep |
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

- Problem type: derivative-free projection methods for large-scale systems of nonlinear equations with convex constraints.
- Core algorithmic ingredients: STTDFPM and ISTTDFPM, line search, projection, sufficient-descent and trust-region properties, and comparison against MOPCG, CGDFPM, and AHDFPM.
- Numerical experiment metadata grounded in the paper:
  - The implementation was written in Julia `1.8.5` and run on an Intel i9-9900K with 32 GB RAM.
  - Experiment 1 evaluates 12 named benchmark problems across dimensions `n = 10^3, 10^4, 10^5`.
  - The paper specifies 14 initial-point families, a stopping tolerance `epsilon = 10^-11`, a `k > 2000` safeguard, and explicit STTDFPM/ISTTDFPM parameter values: `t = 0.11`, `beta = 0.5`, `sigma = 0.01`, `gamma = 1.8`, `alpha_min = 10^-10`, `alpha_max = 10^30`, `r = 0.1`, `psi = 0.2`, `eta_1 = 0.001`, `eta_2 = 0.6`.
  - The manuscript reports Experiment 1 primarily through performance profiles and points readers to an external repository for detailed numerical experiments.
- Local availability update that changes the workshop calculus:
  - `refs/problems.jl` and `refs/projections.jl` now exist inside the active branch under the repository `refs/` directory.
  - Those helper files materially reduce setup risk because they provide local problem and projection definitions that align with the monotone-equation benchmark family used by the paper.
  - The helpers are strong enough to anchor notebook 02 on Experiment 1 without pretending that every manuscript problem name has already been crosswalked one-to-one inside the workshop repo.
- Validation surface: strong enough for a workflow-first scaffold. The notebook can record the paper-fixed suite structure, load the helper-backed definitions, verify helper availability, and make the remaining benchmark-case choice explicit rather than hidden.
- Workshop fit assessment: best match for the workshop. The notebook can stay close to Experiment 1, teach disciplined assumption extraction, and leave later runtime or profile comparisons as extensions once the base scaffold is stable.
- Canonical-target assessment: Experiment 1 should be the anchor. The honest boundary is that the paper fixes the suite, dimensions, stopping rules, and algorithm parameters, while the exact local benchmark-case mapping still needs verification against the helper names.

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
| `Ibrahim2023 spectral three-term derivative-free` | 4 | 4 | 4 | 4 | 3 | 4 | 5 | 121 |
| `NMS_DEED_MPSGrid_DR` | 4 | 1 | 4 | 5 | 5 | 1 | 1 | 85 |

## Recommended Paper

**Choice:** `Two classes of spectral three-term derivative-free method for solving nonlinear equations with application`

### Why This Fits

- It preserves the workshop's workflow-first shape: extract assumptions, load the relevant helper definitions, implement a compact numerical method, and only then extend into broader benchmarking.
- The paper is already grounded in Julia, which lowers translation overhead for a Codex-assisted workshop.
- The paper's Experiment 1 is now practical as the notebook 02 anchor because the local helper files provide directly usable problem and projection definitions.
- Validation can stay lightweight and explicit: helper availability, parameter capture, suite-definition honesty, and benchmark-case mapping notes are all visible in the notebook artifact itself.

### Bounded Workshop Claim

The workshop should use `Ibrahim2023` with **Experiment 1 as notebook 02's anchor**.

Notebook 02 should:

- define the paper, the experiment, and the algorithm parameters exactly as stated in the manuscript
- load `refs/problems.jl` and `refs/projections.jl` from the branch-local repository `refs/` path instead of reaching outside the checkout
- record the helper-backed benchmark inventory that is available locally
- state explicitly which parts of Experiment 1 are fixed by the paper and which remaining choices still need verification against the local helper naming

Benchmark extension work can still follow later, but the primary framing is no longer a compressed-sensing reproduction.

## Rejected Candidates

### Bramble-Pasciak-Type Conjugate Gradient Method for Darcy's Equations

- Rejected because the implementation burden lands in the wrong place for this workshop: RT0 mixed FEM assembly, H(div) data structures, and custom preconditioning would dominate the schedule before participants reach the benchmarking workflow.
- The paper's experiments are credible and measurable, but they sit on top of specialized numerical infrastructure that is too heavy for a four-hour, workflow-first session.

### A Stackelberg Game for Multi-Objective Demand Response in Dynamic Economic Emission Dispatch

- Rejected because the model surface is too large: the paper combines bilevel game structure, multi-objective dispatch, DC-OPF constraints, scaling studies, Pareto analysis, and a regional case study.
- Even though the paper has excellent benchmark and sensitivity material, a faithful reproduction would require too many assumptions, parameters, and solver details for the intended workshop scope.

## Workshop Experiment Target

### Canonical Target Selection

The primary workshop reproduction target is selected from the paper text plus the helper definitions now available in the repository.

Current grounded position:

- `Ibrahim2023` is the correct paper to build around.
- Notebook 02 should anchor on Experiment 1, not on the compressed-sensing application from Experiment 2.
- The paper fixes the suite-level structure: 12 benchmark problems, dimensions `10^3`, `10^4`, `10^5`, 14 initial-point families, stopping tolerance `10^-11`, the `k > 2000` safeguard, and the reported STTDFPM/ISTTDFPM parameters.
- `refs/problems.jl` and `refs/projections.jl` are committed inside the branch and are the local bridge that makes this anchor practical.
- The exact one-to-one mapping from manuscript problem names to local helper names should remain explicit in the notebook until it is verified, rather than being silently guessed.

### Later Extensions

- add one or more verified helper-backed benchmark cases once the paper-to-helper mapping is checked carefully
- extend from the notebook scaffold into runtime, function-evaluation, or profile comparisons after the core Experiment 1 framing is stable

## Selection Verification

- Workshop-fit check: the recommendation stays aligned with the approved workflow-first, mixed hands-on format by anchoring notebook 02 on Experiment 1 and using the helper files to keep setup bounded.
- Paper-evidence check: `Ibrahim2023` explicitly reports Julia implementation details, benchmark-suite dimensions, stopping rules, and algorithm parameters.
- Helper-availability check: the branch now contains `refs/problems.jl` and `refs/projections.jl`, which changes Experiment 1 from a speculative benchmark extension into a realistic notebook anchor.
- Honesty check: the note no longer treats Experiment 2 as the primary target, and it does not overclaim a fully verified paper-to-helper benchmark-case mapping where that mapping still needs confirmation.
