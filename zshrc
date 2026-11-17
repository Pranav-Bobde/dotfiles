eval "$(/opt/homebrew/bin/brew shellenv zsh)"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(gh macos bun npm fzf-tab)
source $ZSH/oh-my-zsh.sh

# fzf-tab: Tab opens a searchable fzf list with descriptions; < and > switch groups
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-flags --height=50%
zstyle ':fzf-tab:*' prefix ''

eval "$(uv generate-shell-completion zsh)"

export EDITOR="nvim"
export VISUAL="nvim"
export TERM=xterm

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

#agent-clis
alias cc="IS_DEMO=1 claude --dangerously-skip-permissions"

#dir
alias remove="rm -rf"
alias dus="du -sh * --exclude='.git' | sort -hr"
alias mkd="mkdir"

#term
alias ll="eza -l -g --icons --git"
alias llt="eza -1 --icons --tree --git-ignore"
alias lla="ll -a"
alias cls="clear"
alias config="nvim ~/.zshrc"
alias update="source ~/.zshrc"

#fzf
alias f="fzf | xargs -o nvim"
alias lz="ll | f"

#brew
alias bs="brew search"
alias bi="brew install"

#git
alias g="git"
alias gst="git stash"
alias gc="git checkout"
alias ga="git add ."
alias glog='git log --graph --topo-order --date=format:"%d %b %Y, %I:%M%p" --pretty=format:"%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ad (%ar) %C(green)%an%n%C(bold)%C(white)%s %N" --abbrev-commit'
alias gnoedit="git commit --amend --no-edit"
alias gacm="git add . && git commit -m"
alias gpush="git push"
alias gpull="git pull"
alias gw="git worktree"
alias gwa="git worktree add"
alias gwr="git worktree remove"
alias lg="lazygit"

#npm
alias nr="npm run"
alias nrs="npm run start"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"

#bun
alias br="bun run"
alias brs="bun run start"
alias brd="bun run dev"
alias brb="bun run build"

#nvim
alias v="nvim"
# vh: nvim in cwd; quit with Q (oil) or :Qcd to cd the shell to where you ended up
function vh() {
    local tmp="$(mktemp -t "nvim-cwd.XXXXXX")"
    NVIM_CWD_FILE="$tmp" nvim "${@:-.}"
    local cwd="$(cat -- "$tmp")"
    if [[ -n "$cwd" ]] && [[ -d "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

#sesh
alias shs='sesh connect $(sesh list | fzf)'

eval "$(fnm env --use-on-cd)"
source <(fzf --zsh)

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$HOME/.local/bin:$PATH"

# Machine-only settings and secrets: never committed.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# zoxide must be initialized last (zoxide doctor)
eval "$(zoxide init --cmd cd zsh)"
