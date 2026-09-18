# Tiering Designs Registry

Each design below is a **named, defined, claim-paired, runnable unit**, so a contributor knows exactly
what they are testing and confirming, independent of git branches. All designs measure against the
committed sample corpus in `benchmark/sample/` (real gpt2-BPE), reproducible by anyone.

## Two benchmark families (DIFFERENT metric axes - do not mix)
There are TWO axes. A design belongs to exactly one. Their numbers are NOT comparable (different units).

| Axis | Question | Metric / unit | Registry | Runner |
|---|---|---|---|---|
| **Token-cost** | How many tokens load every turn? Do rules still fire? | always-on tokens; firing integrity (count) | `benchmark/designs.json` | `run_designs.py` |
| **Fidelity** | Does deferral/compression lose the facts a task needs? | grounding retention (fraction of needed facts) vs token saving | `benchmark/designs_fidelity.json` | `run_fidelity.py` |

LABEL DISCIPLINE (important when comparing designs with different labels): a token-cost result (in
tokens) and a fidelity result (fraction of facts retained) answer different questions and MUST NOT be
put in the same column or compared directly. "Design A saves more tokens" and "Design B retains more
facts" are on different axes; the honest comparison reports each axis separately and, if trading off,
states the tradeoff explicitly (e.g. "F4 saves 98% tokens but retains only 20% of needed facts").

## How to test (one command per axis)
```sh
pip install transformers
# TOKEN-COST axis (always-on tokens + rule firing):
python benchmark/run_designs.py               # all token-cost designs
python benchmark/run_designs.py --design L2_3location
# FIDELITY axis (grounding retention vs token saving):
python benchmark/run_fidelity.py              # all fidelity designs
python benchmark/run_fidelity.py --design F3_summarized_L050
```
Each prints, per design: NAME, DEFINITION, CLAIM, MEASURED, and SAFE.

## Token-cost designs (run_designs.py)
| Design | Definition | Claim |
|---|---|---|
| **L0_monolithic** | No tiering; full rule detail + all project bodies always-on. | Baseline: highest per-turn tokens. |
| **L1_2location** | Steering always-on (full detail) + skills (metadata always, one body on demand). | Lower than monolithic; steering still full detail. |
| **L2_3location** | Lean steering + on-demand tier (governance/formatting/cross-links deferred, stubs kept) + skills. | Lower always-on; all must-fire rules still fire. |
| **L3_depth_safe_frontier** | 3-location plus protection-track detail deferred. | Lowest always-on among SAFE designs; firing integrity full. |

Measured (sample corpus): L0 3853 -> L1 2842 (26.2%) -> L2/L3 585 (84.8%), firing 12/12, all safe.
Best safe: L2/L3 (lowest tokens with full firing integrity).

## Fidelity designs (run_fidelity.py)
| Design | Definition | Claim |
|---|---|---|
| **F1_lossless_grounding** | Lossless deferral (level 0.0); grounding null-control. | Retention = 1.0 (identical to monolithic); no fact lost. |
| **F2_summarized_L033** | Lossy summarization level 0.33. | Retention still 1.0; modest saving. |
| **F3_summarized_L050** | Lossy summarization level 0.50 (measured safe frontier). | Retention 1.0; max safe compression. |
| **F4_summarized_L066** | Lossy summarization level 0.66 (past frontier). | Retention DROPS below 1.0; large saving but UNSAFE (the cliff). |

Measured (sample corpus): F1 ret 1.0/save 0.0 -> F2/F3 ret 1.0/save ~0.87 (safe) -> F4 ret 0.20/save 0.98 (UNSAFE cliff).
Best safe fidelity: F2/F3 (max token saving while retention == 1.0).

## What "confirming a design" means
Run the design's runner; check MEASURED against the stated CLAIM and that SAFE is true. "Better" is
axis-specific: token-cost = lowest always-on tokens with full firing integrity; fidelity = max token
saving with retention == 1.0. Never the biggest saving if it breaks the safe condition (a rule that is
not loaded does not bind; a fact that is dropped is not recalled).

## Scope
MEASURED structure/cost, firing integrity, and grounding retention on the sample corpus. NOT task
quality; whether tiering changes agent task success needs a real-agent SWE-bench run
(research/harness/contribute_run.py). Per-branch write-ups (RULE_TIERING.md, THREE_LOCATION_TIERING.md,
TIERING_DEPTH.md, TOKEN_MODEL_COMPARISON.md, FINDINGS_summarization_fidelity.md) document each design's
story; this registry is the single reproducible test surface.

## Adding a design (contributors)
Token-cost design: add to `benchmark/designs.json` (always_on/on_demand file lists + claim), run
`run_designs.py`. Fidelity design: add to `benchmark/designs_fidelity.json` (compression_level + claim),
run `run_fidelity.py`. No new branch needed: a design is data + a claim + the shared runner for its axis.
EOF
