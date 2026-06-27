#!/bin/bash
# pull-all.sh — run from wolfthemes-dev/wolf-store-docker

for dir in themes/*/ plugins/*/ tools/*/ ; do
  echo "=== $dir ==="
  branch=$(git -C "$dir" branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    git -C "$dir" pull origin "$branch" 2>/dev/null && echo "✓ pulled $branch" || echo "✗ failed"
  else
    echo "skipped (not a git repo or detached HEAD)"
  fi
done
