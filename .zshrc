# ~/.zshrc
setopt autocd
eval "$(starship init zsh)"

# Fast completion system
autoload -Uz compinit
compinit -C -d ~/.cache/zcompdump

eval "$(starship init zsh)"

# Antigen plugin manager
source "$HOME/antigen.zsh"

# ----------------------------
# Antigen Core Start 
# bundles 
# ----------------------------

# Extra completions
antigen bundle zsh-users/zsh-completions

# Syntax highlighting and suggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search lazy

# Alias suggestions
antigen bundle djui/alias-tips lazy

# Fuzzy finder
antigen bundle junegunn/fzf lazy

# Git helpers & aliases
antigen bundle ohmyzsh/ohmyzsh path:plugins/git lazy

# Directory jumping
#antigen bundle wting/autojump lazy

antigen apply
# ----------------------------
# Antigen end 
# ----------------------------





# Autosuggest keybinding
bindkey '^P' autosuggest-accept

# History settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

# Aliases
alias ls='ls --color=always'
alias ll='ls -lath --color=auto'
alias fm='yazi'
alias grep='grep --color=auto'
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias ta='tmux a -t'
alias tn='tmux new -s'
alias tl='tmux list-sessions'
alias xl='xrdb -load ~/.Xresources'
alias dc='docker'
alias nb='newsboat'
alias reload-shell='source ~/.zshrc'
alias cbg='feh --bg-scale /media/background/$(ls /media/background | shuf -n 1)'
alias diff='diff --color=auto'
alias :q='exit'

# Paths and editor
export PATH=$PATH:$HOME/.local/bin
export VISUAL=vim  
export DEFAULT_USER="$(whoami)" 

export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm
  source /usr/share/nvm/init-nvm.sh
  nvm "$@"
}

