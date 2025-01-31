# Set path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set the default editor
export EDITOR="nvim"

# History settings

# Install Zinit if not installed
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -U compinit && compinit
# Initialize Zinit completions and async loading
zinit cdreplay -q
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Zsh plugins
zinit wait lucid light-mode for \
zsh-users/zsh-completions \
zdharma-continuum/fast-syntax-highlighting \
  OMZP::git \
  OMZP::thefuck \
  OMZP::dnf \
  OMZP::extract \
  OMZP::universalarchive \

# Custom fpath for completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Aliases
alias lzd='lazydocker'
alias ext='extract'
alias cd='z'
alias data1='cd /mnt/data1'
alias data2='cd /mnt/data2'
alias home="cd $HOME"
alias sdn="shutdown now"
alias man="tldr"
alias q="exit"
alias cls="clear"
alias fzf-ui="fzf --preview 'bat --color=always {}' | xargs -r nvim"
alias lzg="lazygit"
alias pn="pnpm"
alias dlx="pnpm dlx"
alias connect="warp-cli connect"
alias disconnect="warp-cli disconnect"
alias ff="fastfetch"

# Enable command auto-correction
ENABLE_CORRECTION="true"

# Zoxide 
zinit light ajeetdsouza/zoxide

#Starship

zinit light starship/starship

#zsh-autosuggestions
zinit light zsh-users/zsh-autosuggestions 

eval "$(thefuck --alias fk)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# FZF Configuration
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Use fd for completion
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# Aliases and functions for file management
alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions --all"

function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# bun completions
[ -s "/home/khauvannam/.bun/_bun" ] && source "/home/khauvannam/.bun/_bun"

# FZF theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# flutter
export PATH="$HOME/.flutter/flutter/bin:$PATH"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# pnpm
export PNPM_HOME="/home/khauvannam/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# fnm
FNM_PATH="/home/khauvannam/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/khauvannam/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# Export paths
export PATH=$HOME/.local/bin:$PATH
setopt APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=$HOME/.zsh_history
SAVEHIST=1000
HISTSIZE=999
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

# History need space to work
setopt auto_cd

