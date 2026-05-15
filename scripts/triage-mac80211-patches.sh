#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/triage-mac80211-patches.sh [options]

Options:
  --tree PATH            Backports source tree root to test against.
                         Default: auto-detect newest under build_dir/*/mac80211-*/backports-*
  --patch-root PATH      Patch root directory.
                         Default: package/kernel/mac80211/patches
  --groups LIST          Comma-separated groups under patch-root.
                         Default: build,subsys
  --remove-stale         Delete patches classified as stale-already-applied.
  --show-fail-log        Show first 8 lines of failed dry-run output for needs-rebase.
  -h, --help             Show this help.

Classification:
  still-applicable       patch --dry-run -p1 succeeds
  stale-already-applied  apply dry-run fails, reverse dry-run succeeds
  needs-rebase           both apply and reverse dry-run fail
USAGE
}

err() {
  printf 'ERROR: %s\n' "$*" >&2
}

find_default_tree() {
  local found
  found=$(find build_dir -type d -path '*/mac80211-*/backports-*' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | awk '{print $2}') || true
  if [[ -z "${found:-}" ]]; then
    return 1
  fi
  printf '%s\n' "$found"
}

TREE=""
PATCH_ROOT="package/kernel/mac80211/patches"
GROUPS="build,subsys"
REMOVE_STALE=0
SHOW_FAIL_LOG=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tree)
      [[ $# -ge 2 ]] || { err "--tree needs a value"; exit 2; }
      TREE="$2"
      shift 2
      ;;
    --patch-root)
      [[ $# -ge 2 ]] || { err "--patch-root needs a value"; exit 2; }
      PATCH_ROOT="$2"
      shift 2
      ;;
    --groups)
      [[ $# -ge 2 ]] || { err "--groups needs a value"; exit 2; }
      GROUPS="$2"
      shift 2
      ;;
    --remove-stale)
      REMOVE_STALE=1
      shift
      ;;
    --show-fail-log)
      SHOW_FAIL_LOG=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      err "unknown option: $1"
      usage
      exit 2
      ;;
  esac
done

if [[ -z "$TREE" ]]; then
  if ! TREE=$(find_default_tree); then
    err "could not auto-detect backports tree. pass --tree"
    exit 1
  fi
fi

if [[ ! -d "$TREE" ]]; then
  err "tree does not exist: $TREE"
  exit 1
fi

if [[ ! -d "$PATCH_ROOT" ]]; then
  err "patch root does not exist: $PATCH_ROOT"
  exit 1
fi

IFS=',' read -r -a group_arr <<< "$GROUPS"

# Collect patches in deterministic order
patches=()
for g in "${group_arr[@]}"; do
  g_trimmed="${g//[[:space:]]/}"
  [[ -n "$g_trimmed" ]] || continue
  dir="$PATCH_ROOT/$g_trimmed"
  if [[ -d "$dir" ]]; then
    while IFS= read -r p; do
      patches+=("$p")
    done < <(find "$dir" -maxdepth 1 -type f -name '*.patch' | sort)
  fi
done

if [[ ${#patches[@]} -eq 0 ]]; then
  err "no patches found under selected groups"
  exit 1
fi

printf 'Backports tree: %s\n' "$TREE"
printf 'Patch root:     %s\n' "$PATCH_ROOT"
printf 'Groups:         %s\n' "$GROUPS"
printf 'Patch count:    %d\n\n' "${#patches[@]}"

still=0
stale=0
rebase=0
removed=0

status_file=$(mktemp)
trap 'rm -f "$status_file"' EXIT

for patch in "${patches[@]}"; do
  apply_log=$(mktemp)
  rev_log=$(mktemp)

  if (cd "$TREE" && patch --batch --dry-run -p1 < "$OLDPWD/$patch" >"$apply_log" 2>&1); then
    status="still-applicable"
    ((still+=1))
  else
    if (cd "$TREE" && patch --batch --dry-run -R -p1 < "$OLDPWD/$patch" >"$rev_log" 2>&1); then
      status="stale-already-applied"
      ((stale+=1))
      if [[ $REMOVE_STALE -eq 1 ]]; then
        rm -f "$patch"
        ((removed+=1))
      fi
    else
      status="needs-rebase"
      ((rebase+=1))
    fi
  fi

  printf '%-22s %s\n' "$status" "$patch" | tee -a "$status_file"

  if [[ "$status" == "needs-rebase" && $SHOW_FAIL_LOG -eq 1 ]]; then
    echo "  apply dry-run excerpt:"
    sed -n '1,8p' "$apply_log" | sed 's/^/    /'
    echo "  reverse dry-run excerpt:"
    sed -n '1,8p' "$rev_log" | sed 's/^/    /'
  fi

  rm -f "$apply_log" "$rev_log"
done

echo
echo "Summary:"
printf '  still-applicable:      %d\n' "$still"
printf '  stale-already-applied: %d\n' "$stale"
printf '  needs-rebase:          %d\n' "$rebase"
if [[ $REMOVE_STALE -eq 1 ]]; then
  printf '  removed stale patches: %d\n' "$removed"
fi

echo
echo "Tip: run with --show-fail-log to get first failure lines for needs-rebase patches."
