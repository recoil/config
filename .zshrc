#!/bin/zsh
#
# .zshrc
# for zsh 3.1.6 and newer (may work OK with earlier versions)
#
# by Adam Spiers <adam@spiers.net>
# Edited pretty heavily by Mark Hulme-Jones <mark@markhj.com>
#
# $Id: .zshrc,v 1.32 2005/12/01 10:03:31 mark Exp $
#

zshrc_load_status () {
    if [[ "$TERM" != "dumb" ]]; then
        echo -n "\r.zshrc load: $* ... \e[0K"
    fi
}

## What version are we running?
zshrc_load_status 'checking version'

if [[ $ZSH_VERSION == 3.0.<->* ]]; then ZSH_STABLE_VERSION=yes; fi
if [[ $ZSH_VERSION == 3.1.<->* ]]; then ZSH_DEVEL_VERSION=yes;  fi

ZSH_VERSION_TYPE=old
if [[ $ZSH_VERSION == 3.1.<6->* ||
      $ZSH_VERSION == 3.2.<->*  ||
      $ZSH_VERSION == 4.<->* ]]
then
  ZSH_VERSION_TYPE=new
fi

## Options
zshrc_load_status 'setting options'

setopt \
     NO_all_export \
        always_last_prompt \
     NO_always_to_end \
        append_history \
     NO_auto_cd \
        auto_list \
        auto_menu \
     NO_auto_name_dirs \
        auto_param_keys \
        auto_param_slash \
        auto_pushd \
        auto_remove_slash \
     NO_auto_resume \
        bad_pattern \
        bang_hist \
     NO_beep \
        brace_ccl \
     NO_bsd_echo \
        cdable_vars \
     NO_chase_links \
     NO_clobber \
        complete_aliases \
        complete_in_word \
        csh_junkie_history \
     NO_csh_junkie_loops \
     NO_csh_junkie_quotes \
     NO_csh_null_glob \
        equals \
        extended_glob \
        extended_history \
        function_argzero \
        glob \
     NO_glob_assign \
     NO_glob_complete \
        glob_dots \
     NO_glob_subst \
        hash_cmds \
        hash_dirs \
        hash_list_all \
        hist_allow_clobber \
        hist_beep \
        hist_ignore_dups \
        hist_ignore_space \
     NO_hist_no_store \
     NO_hist_save_no_dups \
     NO_hist_verify \
     NO_hup \
     NO_ignore_braces \
     NO_ignore_eof \
        interactive_comments \
     NO_list_ambiguous \
     NO_list_beep \
        list_types \
        long_list_jobs \
        magic_equal_subst \
     NO_mail_warning \
     NO_mark_dirs \
     NO_menu_complete \
        multios \
        nomatch \
        notify \
     NO_null_glob \
        numeric_glob_sort \
     NO_overstrike \
        path_dirs \
        posix_builtins \
     NO_print_exit_value \
     NO_prompt_cr \
        prompt_subst \
        pushd_ignore_dups \
     NO_pushd_minus \
     NO_pushd_silent \
        pushd_to_home \
        rc_expand_param \
     NO_rc_quotes \
     NO_rm_star_silent \
     NO_sh_file_expansion \
        sh_option_letters \
        short_loops \
     NO_sh_word_split \
     NO_single_line_zle \
     NO_sun_keyboard_hack \
        unset \
     NO_verbose \
    zle
    #NO_xtrace \

# Don't want auto-correction to happen when we're running under emacs tramp.
if [[ "$TERM" != "dumb" ]]; then
    setopt \
        NO_correct \
        correct_all
fi

if [[ $ZSH_VERSION_TYPE == 'new' ]]; then
  setopt \
        hist_expire_dups_first \
        hist_ignore_all_dups \
     NO_hist_no_functions \
     NO_hist_save_no_dups \
        inc_append_history \
        list_packed \
     NO_rm_star_wait
fi

if [[ $ZSH_VERSION == 3.0.<6->* || $ZSH_VERSION_TYPE == 'new' ]]; then
  setopt \
        hist_reduce_blanks
fi

## Environment
zshrc_load_status 'setting environment'

## Some programs might find this handy.  Shouldn't do any harm.
export COLUMNS

## Variables used by zsh
## Function path

## Choose word delimiter characters in line editor
WORDCHARS=''

## Save a large history
HISTFILE=~/.zshhistory
HISTSIZE=5000
SAVEHIST=5000

## Maximum size of completion listing
## Only ask if line would scroll off screen
LISTMAX=0

## Watching for other users
LOGCHECK=60
WATCHFMT="%n has %a %l from %M"

## Prompts

#local _find_promptinit
#_find_promptinit=( $^fpath/promptinit(N) )
#if (( $#_find_promptinit == 1 )) && [[ -r $_find_promptinit[1] ]]; then
#  zshrc_load_status 'prompt system'
#
#  autoload -U promptinit
#  promptinit
#
#  PS4="trace %N:%i> "
#  #RPS1="$bold_colour$bg_red              $reset_colour"
#
#  # Default prompt style
#  if [[ -r /proc/$PPID/cmdline ]] && egrep -q 'Eterm|nexus|vga' /proc/$PPID/cmdline; then
#    # probably OK for fancy graphic prompt
#    prompt adam2
#  else
#    prompt adam2 plain
#  fi
#else
#  PS1='%n@%m %B%3~%b %# '
#fi
#

## Load the prompt stuff
if [[ "$TERM" != "dumb" ]]; then
    autoload -U promptinit
    promptinit
    prompt adam2
fi

export PS1="[%n@%m %~/]\$ "

## Completions
zshrc_load_status 'completion system'

## New advanced completion system things

# Reset keybindings to emacs defaults
bindkey -e

if [[ "$ZSH_VERSION_TYPE" == 'new' ]]; then
  autoload -U compinit
  compinit -u # don't perform security check
else 
  print "No advanced completion stuff"
  function zstyle { }
  function compdef { }

  # an antiquated, barebones completion system is better than nowt
  zmodload zsh/compctl
fi

## Enable the way cool bells and whistles.

## General completion technique
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

## Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands
#zstyle ':completion::complete:*' \
#  tag-order 'globbed-files directories' all-files
#zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'
# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

## Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

## Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

## Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

## Simulate my old dabbrev-expand 3.0.5 patch
zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes

## Common usernames
# users=( tom dick harry )

my_accounts=(
)


zshrc_load_status 'aliases and functions'

bash () {
  NO_ZSH="yes" command bash "$@"
}

restart () {
  exec $SHELL "$@"
}

## Reloading .zshrc or functions
reload () {
  if [[ "$#*" -eq 0 ]]; then
    . ~/.zshrc
  else
    local fn
    for fn in "$@"; do
      unfunction $fn
      autoload -U $fn
    done
  fi
}
compdef _functions reload

# Miscellaneous aliases
alias du1='du --max-depth=1'
alias dsn='du | sort -n'
alias dh='df -h'
alias clean='rm *~(N) >&/dev/null'
alias more='less'
alias lock='xscreensaver-command -lock'
alias nskill='killall -9 netscape-communicator'
alias mpage='mpage -bA4'
alias pss="ps aux | more"
alias psw="ps auxw | more"
alias enw="emacs -nw"
alias bash="NO_SWITCH=t /bin/bash"
alias k9='kill -9'
alias igrep='grep -i'

# Global Aliases that I use a lot.
alias -g L="| less"
alias -g SN="| sort -n"
alias -g SU="| sort | uniq"
alias -g WC="| wc -l"
alias -g G="| grep "
alias -g GV="| grep -v"

# Use my version of the ctags command if available.
[[ -f $HOME/usr/bin/ctags ]] && alias ctags="$HOME/usr/bin/ctags"

if which gnuclient >&/dev/null; then
    alias ec='gnuclient'
elif which emacsclient >&/dev/null; then
    alias ec='emacsclient'
else
    alias ec='emacs'
fi

which vim >&/dev/null && alias vi='vim'
which vim >&/dev/null || alias vim='vi'
alias bcd='byte_compile_directory'

## CVS-related aliases
alias up='cvs update'

# Huh??
#which cx >&/dev/null || cx () { }
if [[ "$TERM" == xterm* ]]; then
  # Could also look at /proc/$PPID/cmdline ...
  cx
fi

# Bc annoyingly doesn't load an rc file by default, and
# I want to do things like set the scale.
[[ -f $HOME/.bcrc ]] && alias bc='bc -l $HOME/.bcrc'

# Function for auto-adding my ssh keys to the ssh-agent
addkeys() {
    [ -f $HOME/.ssh/id_rsa ] && ssh-add $HOME/.ssh/id_rsa
    [ -f $HOME/.ssh/id_dsa ] && ssh-add $HOME/.ssh/id_dsa
}

## ls aliases
alias ls='ls --color=tty -F'
alias l='ls -l'
alias ll='ls -la'
alias lh='ls -lh'
alias lt='ls -lt'
alias ltr='ls -ltr'
alias lth='ls -ltrh'
alias lll='ls -la | less'
alias lsa='ls -a'
alias lsd='ls -ld'
alias lss='ls -lr --sort=size'
alias lsh='ls -lrh --sort=size'
alias lr='ls -lr'
alias lsr='ls -lR'

## File management
alias dirs='dirs -v'
alias d=dirs
alias pu=pushd
alias po=popd
alias pwd='pwd -r'

# Run a find, then carry out some action on the first result found.
find_action() {
    local action=$1
    local file=$2
    local is_dir_action=$3

    if [[ -z "$file" ]]; then 
        echo "Usage: $0 filename"
        return -1
    fi

    for found_file in $(find . -name $file -print); do
        echo $found_file
        if [[ -f "$found_file" && -n "$is_dir_action" ]]; then
            eval "$action $(dirname $found_file)"
        else
            eval "$action $found_file"
        fi
        return 0
    done

    echo "File not found: $file"
}

fcd() { find_action cd $1 yes }
fless() { find_action less $1 }

# Wait until the given text is found in named file, occasionally
# echoing "waiting" until that time.
# FIXME - Might be nifty to add a timeout
waitfile () {
    if [[ $# < 2 ]]; then
        echo "Usage: $0 expression file" >&2
        return -1
    elif [[ ! -r $2 ]]; then
        echo "Error: file does not exist $2" >&2
        return -1
    fi

    until grep $1 $2; do
        sleep 2
        echo "Waiting..."
    done
}

# CVS related - This is pretty horrible for now, but it's a start
quickstat () {
    if [[ -n "$1" && "-m" = "$1" ]]; then
        cvs status 2>|/dev/null | grep '^File' | grep 'Modified'
    elif [[ -n "$1" && "-u" = "$1" ]]; then
        cvs status 2>|/dev/null | grep '^File' | grep -v "Up-to-date"
    else
        cvs status 2>|/dev/null | grep '^File'
    fi
}

# Tomcat-related functions
check_tomcat_home () {
    if [[ -z "$TOMCAT_HOME" ]]; then
        echo "You must set the TOMCAT_HOME environment variable" >&2
        return -1
    fi

    return 0
}
 
shutdown_tomcat () {
    check_tomcat_home || return -1
    cd $TOMCAT_HOME
    bin/shutdown.sh
    cd -
}

startup_tomcat () {
    check_tomcat_home || return -1
    cd $TOMCAT_HOME
    bin/startup.sh
    cd -
}

restart_tomcat () {
    check_tomcat_home || return -1
    shutdown_tomcat
    sleep 2
    startup_tomcat
}

alias rt=restart_tomcat
alias st=shutdown_tomcat
alias ut=startup_tomcat


# Some simple functions
psg () { 
  ps aux | grep $1 | more
}

## Remove the run-help alias
alias run-help='' >&/dev/null && unalias run-help
autoload run-help

## fbig
fbig () {
  ls -alFR $* | sort -rn -k5 | less -r
}

# fbigrpms (no idea what this does!)
alias fbigrpms='rpm --qf "%{SIZE}\t%{NAME}\n" -qa | sort -n | less'

## Job/process control
alias j='jobs -l'
alias mps='ps -o user,pcpu,command'
pst () {
  pstree -p $* | less -S
}
alias gps='gitps -p afx; cx'
alias ra='ps auxww | grep -vE "(^($USER|nobody|root|bin))|login"'
rj () {
  ps auxww | grep -E "($*|^USER)"
}
ru () {
  ps auxww | grep -E "^($*|USER)" | grep -vE "^$USER|login"
}
compdef _users ru

## Changing terminal type
alias v1='export TERM=vt100'
alias v2='export TERM=vt220'
alias vx='export TERM=xterm-color'


alias f=finger

# su to root and change window title
alias root='echo -n "\e]0;root@${HOST}\a"; su -; cx'

# No spelling correction for the man command
alias man='nocorrect man'

# Make sure to run ocaml with rlwrap
if which rlwrap >&/dev/null; then
  alias ocaml='rlwrap ocaml'
  alias scala='rlwrap scala'
fi

## Set up the appropriate ftp program
if which lftp >&/dev/null; then
  alias ftp=lftp
elif which ncftp >&/dev/null; then
  alias ftp=ncftp
fi

## Key bindings
zshrc_load_status 'key bindings'
bindkey -s '^X^Z' '%-^M'
bindkey '^[e' expand-cmd-path
bindkey -s '^X?' '\eb=\ef\C-x*'
bindkey '^[^I' reverse-menu-complete
bindkey '^X^N' accept-and-infer-next-history
bindkey '^[p' history-beginning-search-backward
bindkey '^[n' history-beginning-search-forward
bindkey '^[P' history-beginning-search-backward
bindkey '^[N' history-beginning-search-forward
bindkey '^[b' emacs-backward-word
bindkey '^[f' emacs-forward-word

## Fix weird sequence that rxvt produces
bindkey -s '^[[Z' '\t'

## Miscellaneous

zshrc_load_status 'miscellaneous'

## Hash named directories
hash -d I3=/usr/src/redhat/RPMS/i386
hash -d I6=/usr/src/redhat/RPMS/i686
hash -d SR=/usr/src/redhat/SRPMS
hash -d SP=/usr/src/redhat/SPECS
hash -d SO=/usr/src/redhat/SOURCES
hash -d BU=/usr/src/redhat/BUILD

## ls colours

if [[ $ZSH_VERSION > 3.1.5 ]]; then
  zmodload -i zsh/complist

  zstyle ':completion:*' list-colors ''
  zstyle ':completion:*:*:kill:*:processes' list-colors \
    '=(#b) #([0-9]#)*=0=01;31'

  ZLS_COLOURS=${LS_COLORS-${LS_COLOURS-''}}
fi  

## Specific to hosts
if [[ -r ~/.zshrc.local ]]; then
  zshrc_load_status '.zshrc.local'
  . ~/.zshrc.local
fi

# Run host-specific .zshrc files
if [[ -r ~/.zshrc.${HOST%%.*} ]]; then
  zshrc_load_status ".zshrc.${HOST%%.*}"
  . ~/.zshrc.${HOST%%.*}
fi

## Ensure that we're using sensible shell key bindings
bindkey -e

## Clear up after status display
echo -n "\r"
