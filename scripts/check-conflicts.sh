#!/usr/bin/env bash
# check-conflicts.sh — Detect file conflicts between parallel agent worktrees
#
# Usage: bash scripts/check-conflicts.sh <worktree1> <worktree2> [worktree3 ...]
#
# Compares the changed files in each worktree against all others.
# Reports any files modified by more than one worktree (potential merge conflicts).

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <worktree1> <worktree2> [worktree3 ...]"
  echo "Example: $0 .worktrees/task-3 .worktrees/task-4 .worktrees/task-5"
  exit 1
fi

declare -A file_owners
conflicts=0

for worktree in "$@"; do
  if [ ! -d "$worktree" ]; then
    echo "WARNING: Worktree directory not found: $worktree"
    continue
  fi

  # Get the list of changed files in this worktree (relative to its merge-base with main)
  changed_files=$(cd "$worktree" && git diff --name-only "$(git merge-base HEAD main)..HEAD" 2>/dev/null || \
                  cd "$worktree" && git diff --name-only HEAD~1..HEAD 2>/dev/null || \
                  echo "")

  worktree_name=$(basename "$worktree")

  while IFS= read -r file; do
    [ -z "$file" ] && continue

    if [ -n "${file_owners[$file]:-}" ]; then
      echo "CONFLICT: $file modified by both '${file_owners[$file]}' and '$worktree_name'"
      conflicts=$((conflicts + 1))
    else
      file_owners[$file]="$worktree_name"
    fi
  done <<< "$changed_files"
done

echo ""
if [ "$conflicts" -gt 0 ]; then
  echo "Found $conflicts file conflict(s). These files were modified by multiple agents."
  echo "Manual merge resolution may be needed."
  exit 1
else
  echo "No file conflicts detected. Safe to merge all worktrees."
  exit 0
fi
