#!/usr/bin/env bash
# Scaffold a new project into the context system: creates a skill from the
# example template and prints the registry row to add.
set -euo pipefail

KIRO_HOME="${KIRO_HOME:-$HOME/.kiro}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/templates/skills/_example/SKILL.md"

NAME="${1:-}"
if [ -z "$NAME" ]; then
  echo "usage: add-project.sh <project-name>" >&2
  exit 1
fi

DEST_DIR="$KIRO_HOME/skills/$NAME"
DEST="$DEST_DIR/SKILL.md"
if [ -e "$DEST" ]; then
  echo "skill already exists: ${DEST#$HOME/}" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
# seed the skill from the example, renaming the trigger to this project
sed "s/example-project/$NAME/g" "$SRC" > "$DEST"
echo "created skill: ${DEST#$HOME/}"

echo ""
echo "Add this row to ~/.kiro/steering/context-registry.md (Active table):"
echo "| ✅ | $NAME | you/$NAME | /$NAME-context | Projects/$NAME |"
echo ""
echo "Then refresh your knowledge base on ~/.kiro/steering and ~/.kiro/skills."
