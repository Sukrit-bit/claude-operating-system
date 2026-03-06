#!/bin/bash
# install.sh — Installs the Claude Operating System framework globally
#
# What it does:
#   1. Symlinks skills to ~/.claude/skills/ for global access
#   2. Symlinks hooks to ~/.claude/hooks/ for global access
#   3. Adds hook config to ~/.claude/settings.json (merges, doesn't overwrite)
#
# Usage: ./install.sh
# Run this after cloning the repo or after adding new skills/hooks.
# Existing symlinks are overwritten. Originals in ~/.claude/ are NOT affected
# unless they have the same name as entries in this repo.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

# Create skills directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

echo "Installing skills from: $REPO_DIR/skills/"
echo "Target directory: $SKILLS_DIR"
echo ""

installed=0
for skill_dir in "$REPO_DIR/skills"/*/; do
  # Skip if no skill directories exist
  [ -d "$skill_dir" ] || continue

  skill_name=$(basename "$skill_dir")

  # Check that SKILL.md exists in the skill directory
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "  SKIP: $skill_name (no SKILL.md found)"
    continue
  fi

  # Remove existing symlink or directory if it exists
  if [ -L "$SKILLS_DIR/$skill_name" ] || [ -d "$SKILLS_DIR/$skill_name" ]; then
    rm -rf "$SKILLS_DIR/$skill_name"
  fi

  # Create symlink
  ln -s "$skill_dir" "$SKILLS_DIR/$skill_name"
  echo "  OK: $skill_name → $SKILLS_DIR/$skill_name"
  installed=$((installed + 1))
done

echo ""
echo "Installed $installed skills."

# --- Hooks Installation ---
HOOKS_DIR="$HOME/.claude/hooks"
mkdir -p "$HOOKS_DIR"

echo ""
echo "Installing hooks from: $REPO_DIR/hooks/"
echo "Target directory: $HOOKS_DIR"
echo ""

hooks_installed=0
for hook_file in "$REPO_DIR/hooks"/*.sh; do
  # Skip if no hook files exist
  [ -f "$hook_file" ] || continue

  hook_name=$(basename "$hook_file")

  # Remove existing symlink if it exists
  if [ -L "$HOOKS_DIR/$hook_name" ] || [ -f "$HOOKS_DIR/$hook_name" ]; then
    rm -f "$HOOKS_DIR/$hook_name"
  fi

  # Create symlink
  ln -s "$hook_file" "$HOOKS_DIR/$hook_name"
  echo "  OK: $hook_name → $HOOKS_DIR/$hook_name"
  hooks_installed=$((hooks_installed + 1))
done

echo ""
echo "Installed $hooks_installed hooks."

# --- Settings.json Hook Configuration ---
SETTINGS_FILE="$HOME/.claude/settings.json"
echo ""
echo "Configuring hooks in: $SETTINGS_FILE"

# Define the hooks config we want to ensure exists
HOOKS_CONFIG='{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/context-monitor.sh"
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/pre-compact.sh"
          }
        ]
      }
    ]
  }
}'

if command -v python3 &>/dev/null; then
  # Merge hooks config into existing settings.json using python3
  python3 << PYTHON_EOF
import json

settings_path = "$SETTINGS_FILE"
hooks_config = {
    "PostToolUse": [
        {
            "hooks": [
                {
                    "type": "command",
                    "command": "bash ~/.claude/hooks/context-monitor.sh"
                }
            ]
        }
    ],
    "PreCompact": [
        {
            "hooks": [
                {
                    "type": "command",
                    "command": "bash ~/.claude/hooks/pre-compact.sh"
                }
            ]
        }
    ]
}

try:
    with open(settings_path, "r") as f:
        settings = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    settings = {}

settings["hooks"] = hooks_config

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")
PYTHON_EOF
  echo "  OK: Hook config added to $SETTINGS_FILE"
else
  echo "  SKIP: python3 not found — add hook config to $SETTINGS_FILE manually"
  echo "  Required config:"
  echo "$HOOKS_CONFIG"
fi

echo ""
echo "Verify with:"
echo "  ls -la $SKILLS_DIR/"
echo "  ls -la $HOOKS_DIR/"
echo "  cat $SETTINGS_FILE"
