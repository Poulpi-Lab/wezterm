#!/usr/bin/env bash
# Poulpi-Lab fork: bring `main` and `pointer-shapes` up to date with upstream wezterm/wezterm.
#
#   scripts/sync-upstream.sh           # check only: fast-forward main locally, try the rebase, report
#   scripts/sync-upstream.sh --push    # same, then push main (fast-forward only) and pointer-shapes
#
# Never forces `main`. `pointer-shapes` is rebased, so it is pushed with --force-with-lease,
# and only after a clean rebase. On a conflict the rebase is aborted and the files are listed.
set -euo pipefail

push=0
[ "${1:-}" = "--push" ] && push=1

upstream_url=https://github.com/wezterm/wezterm.git
git remote get-url upstream >/dev/null 2>&1 || git remote add upstream "$upstream_url"

if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  echo "error: the work tree has uncommitted changes" >&2
  exit 2
fi

git fetch -q upstream main
git fetch -q origin

# main mirrors upstream: fast-forward only.
if ! git merge-base --is-ancestor origin/main upstream/main; then
  echo "error: origin/main has commits that upstream/main does not; refusing to touch main" >&2
  exit 3
fi

start=$(git rev-parse --abbrev-ref HEAD)
# Works from origin/pointer-shapes: unpushed local pointer-shapes commits are not kept.
git checkout -q -B pointer-shapes origin/pointer-shapes
old_base=$(git merge-base HEAD upstream/main)
new_base=$(git rev-parse upstream/main)

if [ "$old_base" = "$new_base" ]; then
  echo "pointer-shapes is already based on upstream main ($(git rev-parse --short=8 "$new_base"))"
else
  if ! git rebase -q upstream/main; then
    echo "CONFLICT while rebasing pointer-shapes onto upstream main $(git rev-parse --short=8 "$new_base"):" >&2
    git diff --name-only --diff-filter=U >&2
    git rebase --abort
    git checkout -q "$start"
    exit 1
  fi
  echo "rebased pointer-shapes: $(git rev-parse --short=8 "$old_base") -> $(git rev-parse --short=8 "$new_base")"
fi

last=$(git ls-remote --tags origin 'pointer-shapes-r*' | sed -n 's#.*refs/tags/pointer-shapes-r\([0-9]*\)$#\1#p' | sort -n | tail -1)
echo "upstream base: $(git rev-parse --short=8 "$new_base") ($(git show -s --format=%cs "$new_base"))"
echo "next release tag: pointer-shapes-r$(( ${last:-0} + 1 ))"

if [ "$push" = 1 ]; then
  git push origin "upstream/main:refs/heads/main"   # fast-forward only, never forced
  git push --force-with-lease=pointer-shapes:origin/pointer-shapes origin pointer-shapes
fi
git checkout -q "$start"
