#!/usr/bin/env bash
set -euo pipefail

REMOTE="${REMOTE:-dovarfloresjr-site}"
BRANCH="${BRANCH:-main}"
MESSAGE="${1:-Website update $(date +%Y-%m-%d\ %H:%M)}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: run this script from inside the git repository."
  exit 1
fi

# Stage only the website files that should be deployed.
git add index.html styles.css script.js CNAME

if compgen -G "assets/docs/*.pdf" >/dev/null; then
  git add assets/docs/*.pdf
fi

STAGED_FILES="$(git diff --cached --name-only)"
if [[ -z "${STAGED_FILES}" ]]; then
  echo "No website changes staged."
  echo "Edit files first, then run ./publish-live.sh again."
  exit 0
fi

echo "Staged files:"
echo "${STAGED_FILES}"

git commit -m "${MESSAGE}"
git push "${REMOTE}" "${BRANCH}"

echo "Published to ${REMOTE}/${BRANCH}."
