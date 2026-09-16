# Precision-Aware Context: Empirical Basis

> This module connects Consistent Context Kit's cost-tiering thesis to MEASURED evidence from the
> companion study `quant-memorization-study`. Same core principle on two axes:
> **spend the expensive resource only where it changes model behavior.**

## The shared principle
Consistent Context Kit tiers *context* by access pattern: always-on (cheap, every turn) vs on-demand
(loaded only when a task needs it) vs zero-cost (searchable). The goal is to stop paying for context
that doesn't change the outcome.

The quantization study asks the analogous question on the *precision* axis: when you compress a model
(FP16 → INT8 → INT4), what behavior actually changes? If aggregate factual recall is unaffected by
INT4 but verbatim memorization degrades, then "how much precision to spend" should depend on the
workload — exactly like "how much context to load" depends on the task.

## Measured evidence (from quant-memorization-study, real models)
- **Factuality is robust to INT4** (N=100 PopQA): INT4 statistically indistinguishable from FP16,
  McNemar p=1.0, accuracy-diff CI [−0.10, +0.08]. → aggressive quantization is *safe* for
  factual-recall-style workloads.
- **Memorization declines with precision** (N=40, 3 precisions): reconstruction GAP
  FP16 0.025 → INT8 0.017 → INT4 0.000 (monotonic; directional, underpowered at 0.5B scale).
  → verbatim recall is the behavior that erodes first under compression.
- **Methodology:** an N=8 pilot showed a factuality drop that vanished at N=100 — a corrected false
  positive. Same discipline this kit applies to context-cost claims: measure, don't assert.

## Design implication for context provisioning
Both axes say the same thing: **match resource spend to whether it changes behavior.**
- Factual-lookup / synthesis tasks → tolerate aggressive compression AND lean (on-demand) context.
- Verbatim / exact-recall tasks → preserve precision AND load the specific source context.

The `precision_advisor.py` tool operationalizes this: it reads the study's real analysis JSON and
emits a workload-aware recommendation grounded in the measured CIs — no hardcoded claims.
