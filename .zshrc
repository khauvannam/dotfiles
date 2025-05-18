# Set path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set the default editor
export EDITOR="nvim"

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

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
  OMZP::dnf \
  OMZP::extract \
  OMZP::universalarchive \

# Custom fpath for completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Linux Brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

# Aliases
alias ext='extract'
alias projects='cd /mnt/projects'
alias externals='cd /mnt/externals'
alias home="cd $HOME"
alias sdn="shutdown now"
alias man="tldr"
alias q="exit"
alias cls="clear"
alias fzf-ui="fzf --preview 'bat --color=always {}' | xargs -r nvim"
alias lzg="lazygit"
alias ff="fastfetch"

# Enable command auto-correction
ENABLE_CORRECTION="true"

# eval
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
alias cd='z'

# Zoxide 
zinit light ajeetdsouza/zoxide

#Starship

zinit light starship/starship

#zsh-autosuggestions
zinit light zsh-users/zsh-autosuggestions 

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

# FZF theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

# Export paths
export PATH=$HOME/.local/bin:$PATH
setopt APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=$HOME/.zsh_history
SAVEHIST=1000
HISTSIZE=999
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY
ENABLE_CORRECTION="true"

# History need space to work
setopt auto_cd

# navicat run
# alias nv="./navicat/navicat17.AppImage"

# distrobox
# alias d-php="distrobox enter php-env"

# docker export
# DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.soc

# fix distrobox ghostty
export TERM=xterm-256color
