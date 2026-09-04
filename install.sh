#!/usr/bin/env bash
# kiro-context-kit installer — non-destructive.
# Copies templates into ~/.kiro/ without overwriting existing files.
set -euo pipefail

KIRO_HOME="${KIRO_HOME:-$HOME/.kiro}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/templates"

echo "kiro-context-kit → installing into $KIRO_HOME (non-destructive)"
mkdir -p "$KIRO_HOME/steering" "$KIRO_HOME/skills"

copy_if_absent() {
  local src="$1" dst="$2"
  if [ -e "$dst" ]; then
    echo "  skip (exists): ${dst#$HOME/}"
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  add:           ${dst#$HOME/}"
  fi
}

for f in "$SRC"/steering/*.md; do
  copy_if_absent "$f" "$KIRO_HOME/steering/$(basename "$f")"
done

# example skill
copy_if_absent "$SRC/skills/_example/SKILL.md" "$KIRO_HOME/skills/_example/SKILL.md"

cat <<'EOF'

Installed. Next steps:
  1. Edit ~/.kiro/steering/00-rules.md          (your working rules + visibility policy)
  2. Edit ~/.kiro/steering/context-registry.md  (add your projects; flip ✅/⬜)
  3. Scaffold a project:  ./scripts/add-project.sh <project-name>
  4. (Optional) Index ~/.kiro/steering and ~/.kiro/skills into your agent's knowledge base.

Start a new session — steering files auto-load. Verify with: /context show
EOF
