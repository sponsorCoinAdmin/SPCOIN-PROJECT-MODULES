#!/usr/bin/env bash
# File: scripts/syncNodeSource.sh
#
# Keeps the two physical copies of the shared @sponsorcoin/* libs identical.
# The web app's node_source is the source of truth; the extension's is mirrored
# from it. Each app imports a lib's built dist/, not its src/, so syncing src
# alone leaves the extension running the old build — this script also rebuilds
# dist in both apps, in dependency order.
#
# Usage:
#   scripts/syncNodeSource.sh --check    report drift only, change nothing
#   scripts/syncNodeSource.sh            mirror src, rebuild dist (both apps)
#   scripts/syncNodeSource.sh --vite     ... and then `vite build` the extension
#
# package.json is never copied: the two apps' dependency lines differ on
# purpose (see the spcoin-panels node_source sync notes). Files that exist only
# in the extension's src (stale compiled .js/.d.ts) are deleted, since Vite
# resolves .js before .ts and they would shadow the real sources.

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEB="$ROOT/spcoin-nextjs-front-end/node_source"
EXT="$ROOT/spCoinExtension/node_source"

# Dependency order: a lib is built after the libs it imports.
LIBS=(spCoinCommon spCoinFeeds spCoinExchangeEngine spCoinOnChain spCoinHooks spCoinLib spCoinAccess spCoinPanels meritWallet)

MODE=sync
RUN_VITE=0
for arg in "$@"; do
  case "$arg" in
    --check) MODE=check ;;
    --vite)  RUN_VITE=1 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

pkg_dir() { ls -d "$1/$2/packages/@sponsorcoin"/*/ 2>/dev/null | head -1; }

drift=0
for lib in "${LIBS[@]}"; do
  a="$(pkg_dir "$WEB" "$lib")"; b="$(pkg_dir "$EXT" "$lib")"
  if [ -z "$a" ] || [ -z "$b" ] || [ ! -d "${a}src" ] || [ ! -d "${b}src" ]; then
    echo "skip   $lib (no src in one of the apps)"; continue
  fi
  if diff -rq "${a}src" "${b}src" >/dev/null; then
    echo "same   $lib"
    continue
  fi
  drift=1
  if [ "$MODE" = check ]; then
    echo "DRIFT  $lib"; diff -rq "${a}src" "${b}src" | sed 's/^/         /'
    continue
  fi
  # Delete extension-only files first, then copy everything over.
  diff -rq "${a}src" "${b}src" | sed -nE "s#^Only in (${b}src[^:]*): (.*)#\1/\2#p" | while read -r f; do rm -rf "$f"; done
  cp -r "${a}src/." "${b}src/"
  diff -rq "${a}src" "${b}src" >/dev/null && echo "synced $lib" || echo "FAILED $lib (still differs)"
done

if [ "$MODE" = check ]; then
  [ "$drift" = 0 ] && echo "node_source src is identical in both apps." || echo "Drift found. Run without --check to fix."
  exit "$drift"
fi

# tsc exits non-zero on type errors yet still emits dist (e.g. missing
# @types/node in a copy's node_modules), so a failing build is reported, not fatal.
build_dist() {
  local app="$1" base="$2" lib dir
  for lib in "${LIBS[@]}"; do
    dir="$(pkg_dir "$base" "$lib")"
    [ -n "$dir" ] && grep -q '"build"' "${dir}package.json" 2>/dev/null || continue
    if (cd "$dir" && npm run build >/dev/null 2>&1); then
      echo "built  [$app] $lib"
    else
      echo "WARN   [$app] $lib build reported errors (dist may still have been emitted)"
    fi
  done
}
build_dist web "$WEB"
build_dist ext "$EXT"

if [ "$RUN_VITE" = 1 ]; then
  (cd "$ROOT/spCoinExtension" && npx vite build 2>&1 | grep -E "built in|rror")
  echo "Reload the extension at chrome://extensions to pick up the new build."
fi
echo "If the web dev server is running, restart it and clear .next (webpack caches the old dist)."
