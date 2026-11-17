#!/usr/bin/env bash
# Sets up a new Mac from this repo. Needs Homebrew installed first. Safe to re-run.
# SETUP_TEST=1 skips Homebrew packages and the LaunchAgent (for testing in a fake HOME).
set -euo pipefail

DOT="$(cd "$(dirname "$0")" && pwd)"
eval "$(/opt/homebrew/bin/brew shellenv)"

step() { printf '\n==> %s\n' "$*"; }

clone() {
  [ -d "$2/.git" ] && return
  git clone --quiet "$1" "$2"
}

# Symlink $2 -> $1. A real file already at $2 is kept as $2.bak.
link() {
  mkdir -p "$(dirname "$2")"
  if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.bak"; fi
  ln -sfn "$1" "$2"
}

if [ -z "${SETUP_TEST:-}" ]; then
  step "Homebrew packages and apps"
  brew bundle --file="$DOT/Brewfile"
fi

step "bun"
[ -x "$HOME/.bun/bin/bun" ] || curl -fsSL https://bun.com/install | bash
export PATH="$HOME/.bun/bin:$PATH"

step "Node (via fnm)"
eval "$(fnm env)"
fnm install --lts
fnm default lts-latest

step "zsh"
[ -d "$HOME/.oh-my-zsh" ] || RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
clone https://github.com/Aloxaf/fzf-tab "$HOME/.oh-my-zsh/custom/plugins/fzf-tab"
link "$DOT/zshrc" "$HOME/.zshrc"

step "WezTerm, tmux and nvim configs"
clone https://github.com/Pranav-Bobde/mywezconf.git "$HOME/.config/wezterm"
clone https://github.com/Pranav-Bobde/mytmuxconf.git "$HOME/.config/tmux"
clone https://github.com/Pranav-Bobde/mynvimconf.git "$HOME/.config/nvim"
mkdir -p "$HOME/wallpapers"
cp -n "$DOT"/wallpapers/* "$HOME/wallpapers/" || true
(cd "$HOME/.config/nvim/custom_tools/rayso" && bun install --frozen-lockfile)
nvim --headless "+Lazy! restore" +qa

step "tmux plugins"
clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
"$HOME/.config/tmux/plugins/tpm/bin/install_plugins"

step "tmux Cmd-hold helper"
swiftc -O -o "$HOME/.config/tmux/cmd-hold-watch" "$HOME/.config/tmux/cmd-hold-watch.swift"
if [ -z "${SETUP_TEST:-}" ]; then
  plist="$HOME/Library/LaunchAgents/xyz.pranavb.tmux-cmd-hold.plist"
  mkdir -p "$(dirname "$plist")"
  sed "s|__HOME__|$HOME|" "$HOME/.config/tmux/launchd/xyz.pranavb.tmux-cmd-hold.plist" > "$plist"
  launchctl bootout "gui/$(id -u)/xyz.pranavb.tmux-cmd-hold" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$plist"
fi

step "Claude Code: CLAUDE.md, skills, subagents"
link "$DOT/agents/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
for skill in "$DOT"/agents/skills/*/; do
  name="$(basename "$skill")"
  link "${skill%/}" "$HOME/.agents/skills/$name"
  link "../../.agents/skills/$name" "$HOME/.claude/skills/$name"
done
for agent in "$DOT"/agents/claude-agents/*.md; do
  link "$agent" "$HOME/.claude/agents/$(basename "$agent")"
done
grep -v '^#' "$DOT/skills.txt" | while read -r repo skills; do
  [ -n "$repo" ] || continue
  set -f
  args=()
  for s in $skills; do args+=(-s "$s"); done
  set +f
  bunx skills add "$repo" -g -y -a claude-code "${args[@]}" </dev/null
done

step "Done. Open a new terminal. Manual steps left: see README.md"
