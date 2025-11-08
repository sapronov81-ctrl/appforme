#!/usr/bin/env bash
set -euo pipefail
REPO_SSH="${1:-git@github.com:yourorg/yourrepo.git}"

git init
git add .
git commit -m "Initial Barista Pro (Flutter)"
git branch -M main
git remote add origin "$REPO_SSH"
git push -u origin main
