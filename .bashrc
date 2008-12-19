
# Aliases
alias more='less'
alias ls='ls -F --color=tty'
alias l='ls -l'
alias ll="ls -al"
alias lll="ls -la | more"
alias clean='rm *~'
alias enw="emacs -nw"

# Environment vars
export PS1='\u@\h:\w \$ '
export PAGER="less"
export VISUAL="emacs"
export EDITOR="emacs"
export CVS_RSH=ssh
export RSYNC_RSH=ssh
export LESS=-Mi

export PATH=$PATH:/usr/local/bin:/sbin:/usr/sbin

# Key bindings
bind '"\ep":history-search-backward'
bind '"\en":history-search-forward'
