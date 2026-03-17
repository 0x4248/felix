#!/usr/bin/env bash
set -euo pipefail


REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$REPO_DIR/home"
DEST_DIR="$HOME"
SERVICE_SRC="$REPO_DIR/systend/felix.service"

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

if [ -f "$SERVICE_SRC" ]; then
  echo "Installing systemd unit (requires root privileges)"
  cp "$SERVICE_SRC" /etc/systemd/system/felix.service
  systemctl daemon-reload
  systemctl enable --now felix.service
fi

if [ "$(id -u)" -eq 0 ]; then
  if [ -f "$REPO_DIR/systend/tty-console.sh" ]; then
    echo "Installing tty console script to /usr/local/bin"
    install -m 0755 "$REPO_DIR/systend/tty-console.sh" /usr/local/bin/tty-console.sh
  fi

  installed_count=0
  for i in 1 2 3 4 5; do
    src="$REPO_DIR/systend/getty@tty${i}.override.conf"
    if [ -f "$src" ]; then
      echo "Installing getty@tty${i} override"
      mkdir -p "/etc/systemd/system/getty@tty${i}.service.d"
      cp "$src" "/etc/systemd/system/getty@tty${i}.service.d/override.conf"
      installed_count=$((installed_count+1))
    fi
  done

  if [ "$installed_count" -gt 0 ]; then
    systemctl daemon-reload
    for i in 1 2 3 4 5; do
      if [ -d "/etc/systemd/system/getty@tty${i}.service.d" ]; then
        systemctl restart getty@tty${i}.service || true
      fi
    done
  fi
else
  echo "Service file not found: $SERVICE_SRC"
fi

echo "Done."
