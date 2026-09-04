# Context Loader Registry

> Controls which projects are in the ACTIVE agent context.
> Edit this table to add/remove projects. Enablement is decided HERE, not by file presence.

## Active context (only these feed the agent's reasoning)
| Enabled | Project | Origin | Skill | Repo path |
|---|---|---|---|---|
| ✅ | example-project | you/example-project | /example-project-context | Projects/example-project |
<!-- Add your projects above. Copy scripts/add-project.sh to scaffold new rows + skills. -->

## Inactive (present on disk, NOT in context unless enabled)
| Enabled | Project | Reason inactive |
|---|---|---|
| ⬜ | some-fork | upstream fork — enable on demand |

## Loader rule (enforced by bootstrap.md)
- ONLY rows marked ✅ are treated as active context.
- cross-links.md and cross-project reasoning draw ONLY from enabled projects.
- A skill may exist on disk without being active — the registry decides.

## After editing this file
1. If adding: create `~/.kiro/skills/<name>/SKILL.md` (use scripts/add-project.sh).
2. Refresh the knowledge base on `~/.kiro/steering` and `~/.kiro/skills`.
3. Set your own visibility/privacy policy in 00-rules.md.
