# kiro-context-kit

**Persistent, token-efficient, cross-project memory for AI coding agents.**

Your AI agent forgets everything between sessions and re-reads your whole codebase to catch up. kiro-context-kit gives it durable memory it loads once and updates as you work — with an explicit token-cost model so context stays cheap.

> License: Business Source License 1.1 (source-available). Free for personal/internal use. Commercial redistribution or hosted resale requires a license until the Change Date, when it converts to Apache-2.0. See [LICENSE](LICENSE).

## The problem

- Agents lose context every session → you re-explain your projects.
- Dumping everything into always-on context is expensive (tokens every turn).
- Multi-project work has cross-links (a result in project A matters to paper B) that nothing tracks.

## The approach: three tiers by access pattern

| Tier | Mechanism | Token cost | Holds |
|---|---|---|---|
| Always-on | steering (`file://`) | small × every turn | rules + lean indexes |
| On-demand | skills (`skill://`) | ~0 until invoked | per-project deep context |
| Zero-cost | knowledge base | 0 until queried | searchable full mirror |

An editable **registry** decides which projects are active — add/remove with a one-line edit.

## Install

```bash
git clone <your-repo> kiro-context-kit && cd kiro-context-kit
./install.sh            # non-destructive: won't overwrite an existing ~/.kiro
```

Then:
1. Edit `~/.kiro/steering/00-rules.md` — your rules + visibility policy.
2. Edit `~/.kiro/steering/context-registry.md` — add your projects.
3. `./scripts/add-project.sh my-project` — scaffold a project skill.
4. Index `~/.kiro/steering` and `~/.kiro/skills` into your agent's knowledge base.

Start a new session; steering auto-loads. Verify with `/context show`.

## Verified behavior

These are behaviors confirmed in a working Kiro CLI environment (not marketing claims):
- Steering files placed in `~/.kiro/steering/` auto-load into a fresh session's context.
- A project skill loads its full body only when invoked (`/<name>-context`).
- Flipping ✅/⬜ in the registry changes which projects the agent treats as active, verified by querying a fresh session.

Your mileage depends on your agent version and configuration.

## What's included

- `templates/steering/` — rules, bootstrap protocol, registry, portfolio, cross-links (all generic, no personal data)
- `templates/skills/_example/` — the skill format
- `install.sh`, `scripts/add-project.sh`
- `docs/ARCHITECTURE.md` — the token-cost design

## Compatibility

Built on documented Kiro CLI extension points (steering files, skills, agent resources). Concepts port to other agent frameworks with a steering/context-file mechanism.
