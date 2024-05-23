setopt autocd

source "$HOME/antigen.zsh"
antigen init "$HOME/.config/antigenrc"

bindkey '^P' autosuggest-accept

# history and browsing history config
# https://zsh.sourceforge.io/Doc/Release/Options.html#History
# https://github.com/ohmyzsh/ohmyzsh/issues/1720#issuecomment-286366959
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY


#Rangernvm
export RANGER_LOAD_DEFAULT_RC=false
# Aliases
alias ls='ls --color=always'
alias ll='ls -lath --color=auto'
alias grep='grep --color=auto'
alias pc='sudo protonvpn c'
alias pd='sudo protonvpn d'
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
alias diff='diff --color=auto'
export PATH=$PATH:$HOME/.local/bin
export VISUAL=vim  
export DEFAULT_USER="$(whoami)" 
#My Github Config
git config --global user.email "winvmlliam.pring@pm.me"
git config --global user.name "William Pring"

#rxvt half-screen spacing on launch  https://bugs.archlinux.org/task/77062
if [[ `ps ho command $(ps ho ppid $$)` == 'urxvt' ]]; then
  clear
fi

eval "$(starship init zsh)"
source /usr/share/nvm/init-nvm.sh
# source host/bin/activate
