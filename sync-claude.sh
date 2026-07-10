# CLAUDE.md Sync Script
# Syncs any root subfolder's CLAUDE.md to ~/.claude/CLAUDE.md
# Usage: ./sync-claude.sh [folder-name]
#   - Lists available folders containing CLAUDE.md, defaults to coding/ if present
#   - With an arg, picks that folder directly
#   - Prompts for override if ~/.claude/CLAUDE.md already exists

CONFIG_SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DEST_DIR="$HOME/.claude"
CONFIG_DEST_FILE="$CONFIG_DEST_DIR/CLAUDE.md"

folders=()
for f in "$CONFIG_SRC_DIR"/*/CLAUDE.md; do
  [ -f "$f" ] || continue
  name=$(basename "$(dirname "$f")")
  folders+=("$name")
done

if [ ${#folders[@]} -eq 0 ]; then
  echo "Error: No CLAUDE.md found in any subfolder."
  echo "Checked: $CONFIG_SRC_DIR/*/CLAUDE.md"
  exit 1
fi

choice="$1"
if [ -z "$choice" ]; then
  if printf '%s\n' "${folders[@]}" | grep -q '^coding$'; then
    choice="coding"
    echo "Defaulted to: coding/"
  else
    echo "Available folders with CLAUDE.md:"
    for f in "${folders[@]}"; do
      echo "  $f"
    done
    printf "Choose one: "
    read -r choice
  fi
fi

valid=0
for f in "${folders[@]}"; do
  [ "$f" = "$choice" ] && valid=1 && break
done

if [ "$valid" -eq 0 ]; then
  echo "Invalid choice '$choice'. Available: ${folders[*]}"
  exit 1
fi

src_file="$CONFIG_SRC_DIR/$choice/CLAUDE.md"
mkdir -p "$CONFIG_DEST_DIR"

if [ -f "$CONFIG_DEST_FILE" ]; then
  echo "File already exists: $CONFIG_DEST_FILE"
  read -p "Override? (y/N): " confirm
  case "$confirm" in
    [yY]|[yY][eE][sS]) ;;
    *)
      echo "Aborted."
      exit 0
      ;;
  esac
fi

cp "$src_file" "$CONFIG_DEST_FILE"
echo "Done. Copied $choice/CLAUDE.md -> $CONFIG_DEST_FILE"