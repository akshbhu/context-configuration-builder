# Tiering Designs Registry

Each design below is a **named, defined, claim-paired, runnable unit**. This is how a contributor knows
exactly what they are testing and confirming, independent of git branches. Every design is measured
against the committed sample corpus in `benchmark/sample/` (real gpt2-BPE), so results are reproducible
by anyone, not tied to a private `~/.kiro/`.

## How to test (one command)
```sh
pip install transformers
python benchmark/run_designs.py               # all designs, comparison table + per-design claim check
python benchmark/run_designs.py --design L2_3location   # one design
```
Output per design: NAME, DEFINITION, CLAIM, MEASURED (always-on tokens, per-turn tokens, rule-firing
integrity), and whether the design is SAFE (all must-fire rules still bind).

## The designs
| Design | Definition | Claim |
|---|---|---|
| **L0_monolithic** | No tiering; full rule detail + all project bodies always-on. | Baseline: highest per-turn tokens. |
| **L1_2location** | Steering always-on (full detail) + per-project skills (metadata always, one body on demand). | Lower than monolithic (inactive bodies deferred); steering still carries full rule detail. |
| **L2_3location** | Lean steering + separate on-demand tier (governance/formatting/cross-links deferred, stubs kept) + skills. | Lower always-on than 2-location; all must-fire rules still fire via stubs. |
| **L3_depth_safe_frontier** | 3-location plus protection-track detail also deferred (compact list + stubs kept). | Lowest always-on among SAFE designs; firing integrity still full. |

## Measured on the sample corpus (real gpt2-BPE)
| Design | per-turn tokens | reduction vs L0 | firing | safe |
|---|---|---|---|---|
| L0_monolithic | 3853 | 0% | 12/12 | yes |
| L1_2location | 2842 | 26.2% | 12/12 | yes |
| L2_3location | 585 | 84.8% | 12/12 | yes |
| L3_depth_safe_frontier | 585 | 84.8% | 12/12 | yes |

Best SAFE design on this sample: L2/L3 (lowest per-turn tokens with full rule-firing integrity).
L2 and L3 coincide here because the sample protection-track detail is small; on a deployment with
larger track notes they diverge (the mechanism measures whatever the corpus contains).

## What "confirming a design" means
A contributor confirms a design by running `run_designs.py` and checking the MEASURED result against
the stated CLAIM, and that SAFE is true (firing integrity full). "Better" = lowest per-turn tokens with
full firing integrity, never the lowest number if it drops a must-fire rule (a rule that is not loaded
does not bind).

## Scope
MEASURED structure/cost + rule-firing integrity on the sample corpus. This is NOT task quality; whether
tiering changes agent task success requires a real-agent SWE-bench run (see research/harness/contribute_run.py).
Per-branch write-ups (RULE_TIERING.md, THREE_LOCATION_TIERING.md, TIERING_DEPTH.md, TOKEN_MODEL_COMPARISON.md)
document each design's story; this registry is the single reproducible test surface.

## Adding a design (contributors)
Add an entry to `benchmark/designs.json` (always_on / on_demand file lists + a claim), then run
`run_designs.py`. No new branch needed: a design is data + a claim + the shared runner.
EOF
