export RSYNC_RSH=ssh
export CVS_RSH=ssh

export PAGER=less
export LESS="-RMi"
export LD_LIBRARY_PATH=$HOME/usr/lib

# Standard PATH (roughly)
BASE_PATH="/sbin:/usr/sbin:/usr/local/bin:/usr/bin:/usr/games"
# Make sure local path comes first
BASE_PATH="$HOME/bin:$HOME/usr/bin:$BASE_PATH"
# Make sure /bin is *very* first
BASE_PATH="/bin:$BASE_PATH"

# Manual path - Might want to do the BASE_MAN_PATH thing at some future point.
MANPATH="$MANPATH:$HOME/usr/man"

## Only add this path in X
if [ -n "$DISPLAY" ]; then
    BASE_PATH="$BASE_PATH:/usr/X11R6/bin"
    MANPATH="$MANPATH:/usr/X11R6/man"
fi

# Needs to be turned on for some of the globs below to work
setopt extended_glob

# Hackish...
zdotdir=$HOME
export zdotdir

# Set up the function path and autoload all the functions in
# there. (Basically cribbed from adam, but not quite the same..  Probably
# soom room for improvement).
fpath=(
       $fpath
       $zdotdir/{lib/zsh,.zsh}/{functions,scripts}(N)
      )
typeset -U fpath

# Autoload shell functions from all directories in $fpath.  Restrict
# functions from $zdotdir/.zsh to ones that have the executable bit
# on.  (The executable bit is not necessary, but gives you an easy way
# to stop the autoloading of a particular shell function).
#
# The ':t' is a history modifier to produce the tail of the file only,
# i.e. dropping the directory path.  The 'x' glob qualifier means
# executable by the owner (which might not be the same as the current
# user).
# 
# (remove the aforementioned "x", because that means it doesn't work
#  on cygwin, which doesn't support an executable flag for scripts)
for dirname in $fpath; do
  case "$dirname" in
    $zdotdir/.zsh*) fns=( $dirname/*~*~(N.:t) ) ;;
    *) fns=( $dirname/*~*~(N.:t) ) ;;
  esac
  (( $#fns )) && autoload "$fns[@]"
done

# This works no matter what the platform, but it's turned off for the moment.
#
#for file in $HOME/.zsh/functions/*; do
#    [ -r $file ] && autoload ${file:t}
#done

## Common hostnames
hosts=(
    dahmer.vistech.net

    # Home
    81.5.166.232
    {,www.}markhj.com

    # frottage
    {ipx,ipy,newipy,ipz}.frottage.org
)

# Sometimes emacs isn't there, so set it as EDITOR conditionally,
# falling back on vim, which also isn't there sometimes.  Also, we
# want to do this AFTER the local .zshenv has been run, so that it's
# possible for emacs/vim to be added to the PATH locally somewhere
# before looking for it.
if which emacs >&/dev/null; then
    EDITOR="emacs"
elif which vim >&/dev/null; then
    EDITOR="vim"
    alias emacs='vim'
else
    EDITOR="vi"
    alias emacs='vi'
fi

# Conditionally
# Bit of a foul hack this...
if [[ "$EDITOR" = "emacs" ]]; then
    VISUAL="$EDITOR -nw"
else
    VISUAL="$EDITOR"
fi

## Set a var when screen is being run
case "$TERM" in 
    screen*) IN_SCREEN=yes; export IN_SCREEN ;;
esac

# Site-specific PATH bits can be included here
localenv=$HOME/.zshenv.local
if [[ -r $localenv ]]; then
  . $localenv
fi

localenv=$HOME/.zshenv.${HOST%%.*}
if [[ -r $localenv ]]; then
  . $localenv
fi

# Tune completion *after* local env file is read, so local hosts can
# be added.
zstyle ':completion:*' hosts $hosts

# Re-export these, as they may have been alterred in the local config
export hosts LANG
export EDITOR VISUAL
export PATH=$BASE_PATH:$LOCAL_PATH
export MANPATH
