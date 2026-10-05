#!/bin/zsh
set -e

ROOT="${0:A:h}"
DEST="${HOME}/.terminal-animals"
mkdir -p "$DEST/bin" "$DEST/run"

if ! command -v swiftc >/dev/null; then
  echo "swiftc not found. Install Xcode Command Line Tools: xcode-select --install" >&2
  exit 1
fi

# Stop a running dog so the new build takes over.
if [[ -r "$DEST/run/pid" ]] && kill -0 "$(<"$DEST/run/pid")" 2>/dev/null; then
  echo quit >> "$DEST/run/events"
  sleep 0.5
fi

echo "Building overlay..."
swiftc -O -o "$DEST/bin/terminal-animals-overlay" \
  "$ROOT"/overlay/*.swift -framework AppKit

cp "$ROOT/terminal-animals.plugin.zsh" "$DEST/"

ZSHRC="${HOME}/.zshrc"
LINE='source "$HOME/.terminal-animals/terminal-animals.plugin.zsh"'
if ! grep -Fqx "$LINE" "$ZSHRC" 2>/dev/null; then
  printf '\n# Terminal Animals\n%s\n' "$LINE" >> "$ZSHRC"
fi

echo "🐾 Terminal Animals installed."
echo "Open a new terminal (or: source ~/.zshrc) and the dog will appear on your screen."
echo "Commands: shihtzu on | off | start | quit    shihtzu-chance 50"
echo "Pick a look: shihtzu list | random | reset | coat <name> | groom <name> | accessory <name>"
