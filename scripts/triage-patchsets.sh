#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/triage-patchsets.sh [options]

Options:
  --presets LIST         Comma-separated presets to run.
                         Supported: mac80211,kernel-alpine
                         Default: mac80211
  --remove-stale         Delete patches classified as stale-already-applied.
  --show-fail-log        Show first 8 lines of apply/reverse dry-run failures.
  --limit N              Only process first N patches per preset.
  -h, --help             Show help.

Classification:
  still-applicable       patch --dry-run -p1 succeeds
  stale-already-applied  apply dry-run fails, reverse dry-run succeeds
  needs-rebase           both apply and reverse dry-run fail

Notes:
  - Each preset uses a different prepared source tree.
  - Run target preparation first (e.g. run make once) so build_dir trees exist.
USAGE
}

err() {
  printf 'ERROR: %s\n' "$*" >&2
}

find_newest_tree_by_name() {
  local name="$1"
  local path_filter="${2:-}"
  local out
  if [[ -n "$path_filter" ]]; then
    out=$(find build_dir -type d -name "$name" -path "$path_filter" -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | awk '{print $2}') || true
  else
    out=$(find build_dir -type d -name "$name" -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | awk '{print $2}') || true
  fi
  printf '%s\n' "${out:-}"
}

collect_patches() {
  local root="$1"
  local groups="$2"
  local -n out_arr_ref=$3
  out_arr_ref=()

  if [[ ! -d "$root" ]]; then
    return 0
  fi

  if [[ -z "$groups" ]]; then
    while IFS= read -r p; do
      out_arr_ref+=("$p")
    done < <(find "$root" -maxdepth 1 -type f -name '*.patch' | sort)
    return 0
  fi

  IFS=',' read -r -a group_arr <<< "$groups"
  for g in "${group_arr[@]}"; do
    g="${g//[[:space:]]/}"
    [[ -n "$g" ]] || continue
    local dir="$root/$g"
    [[ -d "$dir" ]] || continue
    while IFS= read -r p; do
      out_arr_ref+=("$p")
    done < <(find "$dir" -maxdepth 1 -type f -name '*.patch' | sort)
  done
}

triage_one() {
  local name="$1"
  local tree="$2"
  local patch_root="$3"
  local groups="$4"
  local limit="$5"
  local remove_stale="$6"
  local show_fail="$7"

  if [[ -z "$tree" || ! -d "$tree" ]]; then
    err "[$name] source tree not found: $tree"
    return 1
  fi
  if [[ ! -d "$patch_root" ]]; then
    err "[$name] patch root not found: $patch_root"
    return 1
  fi

  local patches=()
  collect_patches "$patch_root" "$groups" patches

  if [[ ${#patches[@]} -eq 0 ]]; then
    err "[$name] no patches found under $patch_root${groups:+ (groups: $groups)}"
    return 1
  fi

  if [[ "$limit" -gt 0 && ${#patches[@]} -gt "$limit" ]]; then
    patches=("${patches[@]:0:$limit}")
  fi

  echo "=== $name ==="
  echo "Tree:       $tree"
  echo "Patch root: $patch_root"
  [[ -n "$groups" ]] && echo "Groups:     $groups" || echo "Groups:     (root only)"
  echo "Count:      ${#patches[@]}"
  echo

  local still=0 stale=0 rebase=0 removed=0

  for patch in "${patches[@]}"; do
    local apply_log rev_log status
    apply_log=$(mktemp)
    rev_log=$(mktemp)

    if (cd "$tree" && patch --batch --dry-run -p1 < "$OLDPWD/$patch" >"$apply_log" 2>&1); then
      status="still-applicable"
      ((still+=1))
    else
      if (cd "$tree" && patch --batch --dry-run -R -p1 < "$OLDPWD/$patch" >"$rev_log" 2>&1); then
        status="stale-already-applied"
        ((stale+=1))
        if [[ "$remove_stale" -eq 1 ]]; then
          rm -f "$patch"
          ((removed+=1))
        fi
      else
        status="needs-rebase"
        ((rebase+=1))
      fi
    fi

    printf '%-22s %s\n' "$status" "$patch"

    if [[ "$status" == "needs-rebase" && "$show_fail" -eq 1 ]]; then
      echo "  apply dry-run excerpt:"
      sed -n '1,8p' "$apply_log" | sed 's/^/    /'
      echo "  reverse dry-run excerpt:"
      sed -n '1,8p' "$rev_log" | sed 's/^/    /'
    fi

    rm -f "$apply_log" "$rev_log"
  done

  echo
  echo "Summary ($name):"
  echo "  still-applicable:      $still"
  echo "  stale-already-applied: $stale"
  echo "  needs-rebase:          $rebase"
  if [[ "$remove_stale" -eq 1 ]]; then
    echo "  removed stale patches: $removed"
  fi
  echo
}

PRESETS="mac80211"
REMOVE_STALE=0
SHOW_FAIL_LOG=0
LIMIT=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --presets)
      [[ $# -ge 2 ]] || { err "--presets needs a value"; exit 2; }
      PRESETS="$2"
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
    --limit)
      [[ $# -ge 2 ]] || { err "--limit needs a value"; exit 2; }
      LIMIT="$2"
      shift 2
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

IFS=',' read -r -a preset_arr <<< "$PRESETS"

for p in "${preset_arr[@]}"; do
  p="${p//[[:space:]]/}"
  [[ -n "$p" ]] || continue

  case "$p" in
    mac80211)
      tree=$(find_newest_tree_by_name 'backports-*' '*/mac80211-*/*')
      triage_one "mac80211" "$tree" "package/kernel/mac80211/patches" "build,subsys" "$LIMIT" "$REMOVE_STALE" "$SHOW_FAIL_LOG"
      ;;
    kernel-alpine)
      tree=$(find_newest_tree_by_name 'linux-6.*' '*/linux-*/*')
      triage_one "kernel-alpine" "$tree" "target/linux/alpine/patches-6.6" "" "$LIMIT" "$REMOVE_STALE" "$SHOW_FAIL_LOG"
      ;;
    *)
      err "unknown preset: $p"
      exit 2
      ;;
  esac
done

echo "Tip: run with --remove-stale only after reviewing output once."
