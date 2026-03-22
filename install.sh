#!/usr/bin/env bash
# install.sh — Install claude-team-cli profiles and CLI
# Usage: bash install.sh
#
# What this does:
#   1. Copies team member profiles to ~/.claude/team/
#   2. Installs the claude-team CLI to ~/.local/bin/
#   3. Checks that ~/.local/bin is on your PATH
#   4. Optionally enables the coordinator (proactive team check-ins)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILES_SRC="$REPO_DIR/profiles"
PROFILES_DST="$HOME/.claude/team"
COMMANDS_SRC="$REPO_DIR/commands"
COMMANDS_DST="$HOME/.claude/commands"
BIN_SRC="$REPO_DIR/bin/claude-team"
BIN_DST="$HOME/.local/bin/claude-team"

bold()  { printf '\033[1m%s\033[0m' "$*"; }
green() { printf '\033[32m%s\033[0m' "$*"; }
yellow(){ printf '\033[33m%s\033[0m' "$*"; }
dim()   { printf '\033[2m%s\033[0m' "$*"; }

echo ""
echo "$(bold "claude-team-cli installer")"
echo "────────────────────────────────────"
echo ""

# 1. Install profiles
echo "Installing profiles to $PROFILES_DST ..."
mkdir -p "$PROFILES_DST"
cp "$PROFILES_SRC"/*.md "$PROFILES_DST/"
echo "$(green "✓") Profiles installed:"
for f in "$PROFILES_DST"/*.md; do
  echo "    $(dim "$f")"
done
echo ""

# 2. Install slash commands
echo "Installing slash commands to $COMMANDS_DST ..."
mkdir -p "$COMMANDS_DST"
cp "$COMMANDS_SRC"/*.md "$COMMANDS_DST/"
echo "$(green "✓") Slash commands installed:"
for f in "$COMMANDS_DST"/*.md; do
  echo "    $(dim "$f")"
done
echo ""

# 3. Install CLI (symlink so updates in the repo take effect immediately)
echo "Installing CLI to $BIN_DST ..."
mkdir -p "$(dirname "$BIN_DST")"
ln -sf "$BIN_SRC" "$BIN_DST"
chmod +x "$BIN_SRC"
echo "$(green "✓") CLI symlinked: $(dim "$BIN_DST → $BIN_SRC")"
echo ""

# 4. PATH check
if echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo "$(green "✓") ~/.local/bin is already on your PATH."
else
  echo "$(yellow "!") ~/.local/bin is not on your PATH."
  echo ""
  echo "  Add it by appending one of the following to your shell config:"
  echo ""
  echo "    $(dim "# ~/.zshrc or ~/.bashrc")"
  echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
  echo "  Then reload your shell:"
  echo "    source ~/.zshrc   $(dim "# or ~/.bashrc")"
fi

# 5. Coordinator setup
echo ""
echo "$(bold "Coordinator") — proactive team check-ins"
echo ""
echo "  When enabled, Claude will ask which team member to use at the start of"
echo "  each task, and suggest switching when the conversation changes domain."
echo ""
printf "  Enable the coordinator now? [Y/n] "
read -r coord_answer
coord_answer="${coord_answer:-Y}"

CLAUDE_MD="$HOME/.claude/CLAUDE.md"
COORD_START="<!-- CLAUDE-COORDINATOR:START -->"
COORD_END="<!-- CLAUDE-COORDINATOR:END -->"
COORD_FILE="$PROFILES_DST/coordinator.md"

if [[ "$(echo "$coord_answer" | tr '[:lower:]' '[:upper:]')" == "Y" ]]; then
  touch "$CLAUDE_MD"
  content=$(cat "$COORD_FILE")
  block=$(printf '%s\n%s\n%s' "$COORD_START" "$content" "$COORD_END")

  if grep -qF "$COORD_START" "$CLAUDE_MD"; then
    tmp=$(mktemp)
    awk "/$COORD_START/{exit} {print}" "$CLAUDE_MD" > "$tmp"
    printf '%s\n%s\n%s\n' "$COORD_START" "$content" "$COORD_END" >> "$tmp"
    awk "/$COORD_END/{found=1; next} found{print}" "$CLAUDE_MD" >> "$tmp"
    mv "$tmp" "$CLAUDE_MD"
  else
    printf '\n%s\n' "$block" >> "$CLAUDE_MD"
  fi
  echo "  $(green "✓") Coordinator enabled."
else
  echo "  $(dim "Skipped. Enable later with: claude-team coordinator on")"
fi

echo ""
echo "$(bold "Done!") Your Claude dev team is ready."
echo ""
echo "Quick start:"
echo "  claude-team list                   $(dim "# see your team")"
echo "  claude-team use robin              $(dim "# activate Robin (Testing)")"
echo "  claude-team use akira              $(dim "# activate Akira (Backend)")"
echo "  claude-team use sasha              $(dim "# activate Sasha (Frontend)")"
echo "  claude-team use toni               $(dim "# activate Toni (Product Marketing)")"
echo "  claude-team use river              $(dim "# activate River (Product)")"
echo "  claude-team use sage               $(dim "# activate Sage (Business Advisor)")"
echo "  claude-team coordinator on|off     $(dim "# toggle proactive check-ins")"
echo "  claude-team reset                  $(dim "# return to default Claude")"
echo ""
echo "Slash commands $(dim "(switch personas mid-session, no restart needed)"):"
echo "  /robin   /akira   /sasha   /toni   /river   /sage   /team"
echo ""
