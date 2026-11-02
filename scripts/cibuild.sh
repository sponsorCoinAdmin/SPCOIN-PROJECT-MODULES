#!/usr/bin/env bash
# cibuild -- start the CI "build-and-deploy" job on GitHub (builds, then deploys to sponsorcoin.org).
# A push only runs the checks; the deploy is manual (2026-11-01, see .github/workflows/ci.yml). This is the manual trigger.
#   cibuild              ask first, start the run on GitHub main, then follow it until it finishes
#   cibuild -y           no question
#   cibuild --no-watch   start it and return at once
# It deploys what is on GitHub's main, not your local files: push first.
set -euo pipefail
cd "$(dirname "$0")/../spcoin-nextjs-front-end"
REF=main
YES=0; WATCH=1
for a in "$@"; do case "$a" in -y|--yes) YES=1;; --no-watch) WATCH=0;; *) echo "unknown option: $a"; exit 2;; esac; done

git fetch origin "$REF" --quiet
LOCAL=$(git rev-parse "$REF" 2>/dev/null || true); REMOTE=$(git rev-parse "origin/$REF")
echo "GitHub $REF is at: $(git log -1 --format='%h %s' "origin/$REF")"
if [ -n "$LOCAL" ] && [ "$LOCAL" != "$REMOTE" ]; then echo "NOTE: local $REF ($(git rev-parse --short "$LOCAL")) is not what GitHub has; only GitHub's main is deployed."; fi
if [ "$YES" -ne 1 ]; then read -r -p "Start the CI build and DEPLOY to sponsorcoin.org? [y/N] " ans; case "$ans" in y|Y|yes) ;; *) echo "cancelled"; exit 1;; esac; fi

gh workflow run CI --ref "$REF"
echo "started; waiting for the run to appear..."
sleep 6
RUN=$(gh run list --workflow CI --branch "$REF" --event workflow_dispatch --limit 1 --json databaseId --jq '.[0].databaseId')
echo "run: https://github.com/sponsorCoinAdmin/spcoin-nextjs-front-end/actions/runs/$RUN"
if [ "$WATCH" -eq 1 ]; then gh run watch "$RUN" --exit-status; fi
