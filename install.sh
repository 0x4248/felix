#!/usr/bin/env bash
set -euo pipefail


REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$REPO_DIR/home"
DEST_DIR="$HOME"

echo "Copying contents of $SRC_DIR to $DEST_DIR"

shopt -s dotglob nullglob
for src in "$SRC_DIR"/* "$SRC_DIR"/.[!.]*; do
  [ -e "$src" ] || continue
  echo "Copying $(basename "$src") -> $DEST_DIR/"
  cp -a -- "$src" "$DEST_DIR/"
done
shopt -u dotglob nullglob

if [ -d "$DEST_DIR/felix" ]; then
  echo "Setting +x on .sh files in $DEST_DIR/felix"
  find "$DEST_DIR/felix" -type f -name '*.sh' -exec chmod +x {} \;

  echo "Setting +x on files with a shebang in $DEST_DIR/felix"
  find "$DEST_DIR/felix" -type f -print0 | while IFS= read -r -d '' f; do
    if head -n1 "$f" 2>/dev/null | grep -q '^#!'; then
      chmod +x "$f" || true
    fi
  done
fi


chmod +x /root/felix/scripts/*

echo "Done."
