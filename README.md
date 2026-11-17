# dotfiles

One command sets up a new Mac: apps, shell, WezTerm, tmux, nvim, and Claude Code's instructions and skills.

## 1. In the admin (sudo) window

These need an admin password. Do them first.

1. Install Homebrew:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

Everything after this runs without admin rights. Apps install to `~/Applications`.

## 2. Run setup

```bash
git clone https://github.com/Pranav-Bobde/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

It installs the Brewfile apps, bun, Node (fnm), oh-my-zsh, and clones the WezTerm, tmux and nvim configs into `~/.config`. It also links `CLAUDE.md`, the skills and subagents into `~/.claude` and `~/.agents`.

## 3. After setup

- Install Claude Code with its own installer: `curl -fsSL https://claude.ai/install.sh | bash`
- Open each app once and grant what macOS asks for. On a managed Mac some of these need an admin:
  - Raycast and Alfred: Accessibility
  - Hex: Microphone and Accessibility
  - OBS: Screen Recording, Camera, Microphone
- Put machine-only settings and secrets in `~/.zshrc.local`. It is never committed.
