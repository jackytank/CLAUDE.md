# CLAUDE.md Sync Script
# Syncs any root subfolder's CLAUDE.md to ~/.claude/CLAUDE.md
# Usage: ./sync-claude.sh [--dry-run] [folder-name]
#   - Lists available folders containing CLAUDE.md, defaults to coding/ if present
#   - With an arg, picks that folder using fuzzy/substring matching
#   - Prompts for override if ~/.claude/CLAUDE.md already exists
#   - With --dry-run, prints what would happen without copying or prompting
#   - Side effects: overwrites ~/.claude/CLAUDE.md after confirmation
#   - Requires: bash, cp

set -euo pipefail

CONFIG_SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DEST_DIR="$HOME/.claude"
CONFIG_DEST_FILE="$CONFIG_DEST_DIR/CLAUDE.md"

dry_run=0
choice=""
for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=1 ;;
    -*) echo "Error: Unknown option '$arg'" >&2; exit 1 ;;
    *) choice="$arg" ;;
  esac
done

folders=()
for f in "$CONFIG_SRC_DIR"/*/CLAUDE.md; do
  [ -f "$f" ] || continue
  name=$(basename "$(dirname "$f")")
  folders+=("$name")
done

if [ ${#folders[@]} -eq 0 ]; then
  echo "Error: No CLAUDE.md found in any subfolder." >&2
  echo "Checked: $CONFIG_SRC_DIR/*/CLAUDE.md" >&2
  exit 1
fi

# No folder given: default to coding/ if present, otherwise list and prompt.
if [ -z "$choice" ]; then
  if printf '%s\n' "${folders[@]}" | grep -q '^coding$'; then
    choice="coding"
    echo "Defaulted to: coding/"
  else
    echo "Available folders with CLAUDE.md:"
    for f in "${folders[@]}"; do
      echo "  $f"
    done
    if [ -t 0 ]; then
      printf "Choose one: "
      read -r choice
    else
      echo "Error: No folder given and stdin is not a terminal." >&2
      exit 1
    fi
  fi
fi

# Fuzzy/substring match against the requested name.
matches=()
for f in "${folders[@]}"; do
  case "$f" in
    *"$choice"*) matches+=("$f") ;;
  esac
done

if [ ${#matches[@]} -eq 0 ]; then
  echo "Error: No folder matches '$choice'. Available: ${folders[*]}" >&2
  exit 1
fi

if [ ${#matches[@]} -gt 1 ]; then
  echo "Multiple matches for '$choice':"
  if [ -t 0 ]; then
    for i in "${!matches[@]}"; do
      echo "  $((i+1)). ${matches[$i]}"
    done
    printf "Pick a number: "
    read -r idx
    if ! [ "$idx" -ge 1 ] 2>/dev/null || [ "$idx" -gt "${#matches[@]}" ]; then
      echo "Error: Invalid selection '$idx'." >&2
      exit 1
    fi
    choice="${matches[$((idx-1))]}"
  else
    echo "Error: Ambiguous input '$choice' and stdin is not a terminal." >&2
    exit 1
  fi
else
  choice="${matches[0]}"
fi

src_file="$CONFIG_SRC_DIR/$choice/CLAUDE.md"

if [ "$dry_run" -eq 1 ]; then
  echo "[dry-run] Would copy $choice/CLAUDE.md -> $CONFIG_DEST_FILE"
  if [ -f "$CONFIG_DEST_FILE" ]; then
    echo "[dry-run] Existing file would be overwritten: $CONFIG_DEST_FILE"
  fi
  exit 0
fi

mkdir -p "$CONFIG_DEST_DIR"

if [ -f "$CONFIG_DEST_FILE" ]; then
  echo "File already exists: $CONFIG_DEST_FILE"
  if [ -t 0 ]; then
    read -p "Override? (y/N): " confirm
    case "$confirm" in
      [yY]|[yY][eE][sS]) ;;
      *)
        echo "Aborted."
        exit 0
        ;;
    esac
  else
    echo "Error: Destination exists and stdin is not a terminal." >&2
    exit 1
  fi
fi

cp "$src_file" "$CONFIG_DEST_FILE"
echo "Done. Copied $choice/CLAUDE.md -> $CONFIG_DEST_FILE"
