#!/bin/sh
# Scaffold a new project into the context system.
# Creates a skill from the example template and prints the registry row.
# Usage: ./scripts/add-project.sh <project-name> [origin]
set -eu

KIRO_HOME="${KIRO_HOME:-${HOME}/.kiro}"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SRC="${SCRIPT_DIR}/templates/skills/_example/SKILL.md"

NAME="${1:-}"
ORIGIN="${2:-you}"

if [ -z "$NAME" ]; then
  echo "usage: add-project.sh <project-name> [origin]" >&2
  exit 2
fi

# Validate name: skill/slash-command names allow alphanum, hyphen, underscore
case "$NAME" in
  *[!A-Za-z0-9_-]*) echo "error: name may contain only letters, digits, - and _" >&2; exit 2 ;;
esac

[ -f "$SRC" ] || { echo "error: example template missing at $SRC" >&2; exit 1; }

DEST_DIR="$KIRO_HOME/skills/$NAME"
DEST="$DEST_DIR/SKILL.md"
if [ -e "$DEST" ]; then
  echo "skill already exists: ${DEST#"$HOME"/}" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
sed "s/example-project/$NAME/g" "$SRC" > "$DEST"
echo "created skill: ${DEST#"$HOME"/}"
echo
echo "Add this row to ~/.kiro/steering/context-registry.md (Active table):"
echo "| [x] | $NAME | $ORIGIN/$NAME | /$NAME-context | Projects/$NAME |"
echo
echo "Then refresh your knowledge base on ~/.kiro/steering and ~/.kiro/skills."
