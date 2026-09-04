# I gave my AI persistent memory across 15 projects — and kept the token bill flat

*Launch post / Show HN draft.*

## The problem

I work across many repositories at once — model training, a hardware paper, a couple of shipping products. Every time I opened my AI coding agent, it started from zero. It re-read files to figure out what a project was, forgot decisions from yesterday, and had no idea that a result in one repo was the missing data for a paper in another.

The naive fix — dump everything into the agent's always-on context — just moves the pain to your token bill. Context that loads every single turn gets expensive fast.

## The idea: split context by *access pattern*

Not by topic — by **how often it's needed**:

- **Always-on** (tiny): the rules and a lean index of projects + cross-links. Loaded every turn, so it stays small.
- **On-demand**: each project's deep context loads only when I actually work on that project. Near-zero cost until then.
- **Zero-cost**: a searchable knowledge-base mirror, costing nothing until I query it.

A one-line **registry** decides which projects are "active." Flip a marker, and a project enters or leaves the agent's working memory.

## Does it actually work?

Yes — and I checked, rather than assumed. In a fresh agent session (no prior chat), it correctly answered:
- which projects are in the active context,
- a *measured* cross-project fact (a quantization result) and which papers it feeds,
- which of two repo clones was canonical and why.

All from loaded context, no tools, in one turn.

## What it did for my work

It turned a pile of disconnected repos into one queryable research graph. When I needed validation data for a hardware paper, the system already knew another project had measured it — and flagged what was still missing. That's the difference between an agent that autocompletes and one that remembers.

## Try it

`kiro-context-kit` is source-available (BSL 1.1 — free for personal/internal use). Install is non-destructive, one command, and it never overwrites an existing setup.

```sh
git clone <repo> && cd kiro-context-kit && ./install.sh
```

Feedback welcome — especially from anyone juggling many repos with an AI agent.

*(Claims above reflect behavior verified in a working Kiro CLI environment; your results depend on your agent version and setup.)*
