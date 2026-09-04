# A Three-Tier, Cost-Stratified Context Architecture for Persistent Multi-Project Memory in AI Coding Agents

**Author:** Purnima Pathak
**Status:** Working paper / preprint draft, v0.1 (2026-09-04)

## Abstract

AI coding agents lose project context between sessions, and the common remedy — loading all relevant context on every turn — scales token cost linearly with the amount of remembered information. We present a context architecture that **stratifies persistent memory by access pattern rather than by topic**, mapping three token-cost regimes to three loading mechanisms: (1) *always-on* content in continuously-loaded steering files, kept minimal; (2) *on-demand* per-project content in skills whose bodies load only when invoked; and (3) *zero-cost-until-queried* content in a semantic knowledge base. A single editable **registry** governs which projects are active, decoupling enablement from file presence. We further introduce an **incremental cross-project provenance graph** with explicit measured-vs-claim labeling. We report qualitative verification in a working agent environment and analyze the token-cost model that motivates the design. The novelty is not any single mechanism but their **cost-stratified composition plus registry-governed activation** for multi-project memory.

## 1. Introduction

Large-language-model coding agents operate within a bounded context window that is re-billed every turn. Practical "agent memory" schemes tend to either (a) re-derive context each session (expensive in latency and redundant reads) or (b) preload large context blocks that persist every turn (expensive in tokens). Neither addresses multi-project settings, where knowledge produced in one project is relevant to deliverables in another.

We ask: *can persistent, cross-project agent memory be made both durable and token-efficient?* Our answer separates the two concerns — durability (does the agent remember?) and cost (what does remembering cost per turn?) — and shows they can be optimized jointly by matching content to a loading tier by its access frequency.

## 2. Problem formulation

Let a session consist of $T$ turns. Content placed in the always-on tier of size $s$ incurs cost $\approx s \cdot T$. Content placed in an on-demand tier incurs a small fixed metadata cost $m$ plus a body cost $b$ only on the turns where it is invoked ($k \le T$): $\approx m \cdot T + b \cdot k$. Content in the query-only tier incurs cost only on explicit retrieval. For per-project detail where $k \ll T$, the on-demand tier is strictly cheaper than the always-on tier whenever $b \cdot k + mT < bT$, i.e. for large $T$ and infrequent access. This inequality is the design's core motivation.

## 3. Architecture

**Tier 1 — Always-on (steering).** Rules and lean indexes: a portfolio index (one line per project), a cross-links graph, and the registry. Held small by construction.

**Tier 2 — On-demand (skills).** One skill per project carrying deep context (what/why, debug approach, data plan, key facts). Metadata (name + trigger description) loads at startup; the body loads only when the project is engaged.

**Tier 3 — Query-only (knowledge base).** A semantic mirror of all tiers, contributing nothing to per-turn context until queried.

**Registry-governed activation.** An editable table marks each project active/inactive. Activation is decided by the registry, *not* by whether a skill file exists — enabling a large on-disk corpus with a small active working set.

**Cross-project provenance graph.** Shared facts are recorded once with origin and consumers, labeled `[MEASURED]` (verified) or `[CLAIM]` (unverified), so downstream reasoning inherits calibrated confidence.

## 4. Verification

In a fresh agent session (no prior conversation), with only the always-on tier loaded and tools disabled, the agent correctly (i) enumerated the active project set, (ii) recalled a measured cross-project quantitative result and named the deliverables it feeds, and (iii) resolved a repository-provenance ambiguity with justification. Enabling/disabling a project in the registry changed the agent's reported active set accordingly. These are qualitative confirmations of the loading and activation behavior; we do not claim quantitative token savings beyond the analytic model of §2, which we mark as analysis rather than measurement.

## 5. Related work and novelty

Retrieval-augmented generation, memory buffers, and project-instruction files each address parts of the problem. The contribution here is their **cost-stratified composition**: assigning content to a loading tier by access frequency, adding a **registry indirection** that separates activation from presence, and layering an **explicit provenance graph with confidence labels** for multi-project reasoning. To our knowledge this specific composition, framed by an explicit per-turn cost model, is not packaged elsewhere.

## 6. Limitations

Verification is qualitative and environment-specific; the cost model is analytic, not benchmarked. Tier behavior depends on the host agent's loading semantics. A controlled study measuring tokens-per-turn and task success versus a monolithic-context baseline is future work.

## 7. Conclusion

Separating agent memory by access pattern — and governing activation with a registry — yields durable, cross-project context whose per-turn cost need not grow with the amount remembered. We release the design as an open template (`kiro-context-kit`).

## Reproducibility

Templates, install scripts, and a clean-room demo accompany this paper. The verification in §4 is reproducible in any agent environment that supports always-on and on-demand context resources.
