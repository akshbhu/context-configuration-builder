#!/bin/sh
# Remove a project's skill from the context system.
# Does NOT touch context-registry.md (edit that by hand to flip the row).
# Usage: ./scripts/remove-project.sh <project-name> [--force]
set -eu

KIRO_HOME="${KIRO_HOME:-${HOME}/.kiro}"
NAME="${1:-}"
FORCE="${2:-}"

if [ -z "$NAME" ]; then
  echo "usage: remove-project.sh <project-name> [--force]" >&2
  exit 2
fi

DEST_DIR="$KIRO_HOME/skills/$NAME"
if [ ! -d "$DEST_DIR" ]; then
  echo "no skill found for '$NAME' at ${DEST_DIR#"$HOME"/}" >&2
  exit 1
fi

if [ "$FORCE" != "--force" ]; then
  printf "remove skill '%s' (%s)? [y/N] " "$NAME" "${DEST_DIR#"$HOME"/}"
  read -r ans
  case "$ans" in y|Y|yes|YES) ;; *) echo "aborted"; exit 0 ;; esac
fi

rm -rf "$DEST_DIR"
echo "removed skill: ${DEST_DIR#"$HOME"/}"
echo "Remember to: (1) flip the row to [ ] (or delete it) in context-registry.md,"
echo "             (2) refresh the knowledge base."
