#!/usr/bin/env bash
# tests/run.sh — Test suite for claude-team CLI
#
# Usage: bash tests/run.sh
#
# Uses a temporary HOME to avoid touching ~/.claude/CLAUDE.md.
# No external dependencies required.

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLI="$REPO_DIR/bin/claude-team"
PROFILES_DIR="$REPO_DIR/profiles"

# ─── Test state ──────────────────────────────────────────────────────────────

PASS=0
FAIL=0
ERRORS=()

# ─── Temp environment ────────────────────────────────────────────────────────

TEST_HOME=$(mktemp -d)
CLAUDE_MD="$TEST_HOME/.claude/CLAUDE.md"
mkdir -p "$TEST_HOME/.claude"
trap 'rm -rf "$TEST_HOME"' EXIT

run_cmd() {
  CLAUDE_TEAM_PROFILES="$PROFILES_DIR" HOME="$TEST_HOME" "$CLI" "$@"
}

# ─── Assertion helpers ───────────────────────────────────────────────────────

ok()   { PASS=$((PASS + 1)); printf "  \033[32m✓\033[0m %s\n" "$1"; }
fail() { FAIL=$((FAIL + 1)); ERRORS+=("$1"); printf "  \033[31m✗\033[0m %s\n" "$1"; }

assert_contains() {
  local name="$1" pattern="$2" output="$3"
  if echo "$output" | grep -q "$pattern"; then ok "$name"
  else fail "$name (expected: '$pattern')"; fi
}

assert_not_contains() {
  local name="$1" pattern="$2" output="$3"
  if ! echo "$output" | grep -q "$pattern"; then ok "$name"
  else fail "$name (must not contain: '$pattern')"; fi
}

assert_file_has() {
  local name="$1" file="$2" pattern="$3"
  if grep -q "$pattern" "$file" 2>/dev/null; then ok "$name"
  else fail "$name (file missing: '$pattern')"; fi
}

assert_file_lacks() {
  local name="$1" file="$2" pattern="$3"
  if ! grep -q "$pattern" "$file" 2>/dev/null; then ok "$name"
  else fail "$name (file must not contain: '$pattern')"; fi
}

assert_count() {
  local name="$1" file="$2" pattern="$3" expected="$4"
  local count
  count=$(grep -c "$pattern" "$file" 2>/dev/null || echo 0)
  if [[ "$count" -eq "$expected" ]]; then ok "$name"
  else fail "$name (expected $expected x '$pattern', got $count)"; fi
}

assert_exits_nonzero() {
  local name="$1"; shift
  if CLAUDE_TEAM_PROFILES="$PROFILES_DIR" HOME="$TEST_HOME" "$@" >/dev/null 2>&1; then
    fail "$name (expected non-zero exit)"
  else
    ok "$name"
  fi
}

# ─── Tests ───────────────────────────────────────────────────────────────────

echo ""
echo "claude-team test suite"
echo "────────────────────────────────"
echo ""

# help
echo "help"
out=$(run_cmd help)
assert_contains     "shows tool name"            "claude-team"       "$out"
assert_contains     "lists use command"          "use <name>"        "$out"
assert_contains     "lists install-commands"     "install-commands"  "$out"
echo ""

# list
echo "list"
out=$(run_cmd list)
assert_contains     "shows Robin"        "Robin"       "$out"
assert_contains     "shows Akira"        "Akira"       "$out"
assert_contains     "shows Sasha"        "Sasha"       "$out"
assert_contains     "shows Toni"         "Toni"        "$out"
assert_contains     "shows River"        "River"       "$out"
assert_not_contains "excludes Coordinator" "Coordinator" "$out"
echo ""

# show
echo "show"
out=$(run_cmd show robin)
assert_contains "shows Robin profile"       "Robin — QA" "$out"
out=$(run_cmd show ROBIN)
assert_contains "case-insensitive show"     "Robin — QA" "$out"
assert_exits_nonzero "invalid name exits nonzero" "$CLI" show nobody
echo ""

# use — basic injection
echo "use"
run_cmd use robin >/dev/null
assert_file_has  "use injects CLAUDE-TEAM block"  "$CLAUDE_MD" "CLAUDE-TEAM:START"
assert_file_has  "use injects Robin profile"       "$CLAUDE_MD" "Robin — QA"
assert_count     "use creates exactly 1 block"     "$CLAUDE_MD" "CLAUDE-TEAM:START" 1
echo ""

# use — persona switch
echo "use (switch)"
run_cmd use akira >/dev/null
assert_file_has     "switch updates profile to Akira"  "$CLAUDE_MD" "Akira — Backend"
assert_file_lacks   "switch removes Robin content"     "$CLAUDE_MD" "Robin — QA"
assert_count        "switch leaves exactly 1 block"    "$CLAUDE_MD" "CLAUDE-TEAM:START" 1
echo ""

# use — idempotency (same member twice)
echo "use (idempotency)"
run_cmd use akira >/dev/null
assert_count "same member twice stays 1 block" "$CLAUDE_MD" "CLAUDE-TEAM:START" 1
echo ""

# coordinator block survives persona switch
echo "coordinator block survives persona switch"
printf '\n<!-- CLAUDE-COORDINATOR:START -->\nFake coordinator\n<!-- CLAUDE-COORDINATOR:END -->\n' >> "$CLAUDE_MD"
run_cmd use robin >/dev/null
assert_count "coordinator block survives use"         "$CLAUDE_MD" "CLAUDE-COORDINATOR:START" 1
assert_count "team block still present alongside coordinator" "$CLAUDE_MD" "CLAUDE-TEAM:START" 1
echo ""

# reset
echo "reset"
run_cmd reset >/dev/null
assert_file_lacks "reset removes CLAUDE-TEAM block"       "$CLAUDE_MD" "CLAUDE-TEAM:START"
assert_file_has   "reset preserves coordinator block"     "$CLAUDE_MD" "CLAUDE-COORDINATOR:START"
# clean up coordinator for next tests
awk '/CLAUDE-COORDINATOR:START/{found=1} found && /CLAUDE-COORDINATOR:END/{found=0; next} !found{print}' \
  "$CLAUDE_MD" > "${CLAUDE_MD}.tmp" && mv "${CLAUDE_MD}.tmp" "$CLAUDE_MD"
out=$(run_cmd reset)
assert_contains "reset when none active shows message" "No team member" "$out"
echo ""

# coordinator on/off
echo "coordinator on/off"
run_cmd coordinator on >/dev/null
assert_file_has "coordinator on injects block"       "$CLAUDE_MD" "CLAUDE-COORDINATOR:START"
assert_count    "coordinator on: exactly 1 block"    "$CLAUDE_MD" "CLAUDE-COORDINATOR:START" 1
out=$(run_cmd coordinator on)
assert_contains "coordinator on twice shows refresh" "refreshed" "$out"
assert_count    "coordinator on twice stays 1 block" "$CLAUDE_MD" "CLAUDE-COORDINATOR:START" 1
run_cmd coordinator off >/dev/null
assert_file_lacks "coordinator off removes block"    "$CLAUDE_MD" "CLAUDE-COORDINATOR:START"
out=$(run_cmd coordinator off)
assert_contains "coordinator off when already off"   "already off" "$out"
echo ""

# status
echo "status"
run_cmd use toni >/dev/null
out=$(run_cmd status)
assert_contains "status shows active member" "Toni" "$out"
run_cmd coordinator on >/dev/null
out=$(run_cmd status)
assert_contains "status shows coordinator on"  "on"  "$out"
run_cmd coordinator off >/dev/null
out=$(run_cmd status)
assert_contains "status shows coordinator off" "off" "$out"
echo ""

# error handling
echo "error handling"
assert_exits_nonzero "unknown command exits nonzero" "$CLI" badcommand
assert_exits_nonzero "use without name exits nonzero" "$CLI" use
assert_exits_nonzero "show without name exits nonzero" "$CLI" show
echo ""

# ─── Summary ─────────────────────────────────────────────────────────────────

echo "────────────────────────────────"
TOTAL=$((PASS + FAIL))
printf "%d/%d tests passed" "$PASS" "$TOTAL"
if [[ "$FAIL" -gt 0 ]]; then
  printf " — \033[31m%d failed\033[0m\n" "$FAIL"
  echo ""
  for err in "${ERRORS[@]}"; do
    printf "  \033[31m✗\033[0m %s\n" "$err"
  done
  echo ""
  exit 1
else
  printf " — \033[32mall passed\033[0m\n"
  echo ""
  exit 0
fi
