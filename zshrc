#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
setopt NOBGNICE

## restart running processes on exit
#setopt HUP

## history
# History configuration
HISTFILE=$HOME/.zhistory       # enable history saving on shell exit
setopt APPEND_HISTORY          # append rather than overwrite history file.
HISTSIZE=1200                  # lines of history to maintain memory
SAVEHIST=1000                  # lines of history to maintain in history file.
setopt HIST_EXPIRE_DUPS_FIRST  # allow dups, but expire old ones when I hit HISTSIZE
setopt EXTENDED_HISTORY        # save timestamp and runtime information

## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
MAILCHECK=0

# autoload -U colors
#colors

###
#
# vcs_info for git branch in prompt
#

autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

#set the prompt and right prompt.
setopt PROMPT_SUBST  #enable $variable expansion in prompt.
PROMPT="[%n@%m] %h%# "
#RPROMPT='%? ${vcs_info_msg_0_}%~'
# Right prompt with green/red smiley/frowny
RPROMPT='%(?,%F{green}:%),%F{yellow}%? %F{red}:()%f ${vcs_info_msg_0_}%~'


#note, vcs_info is also added to precmd

### end vcs_info


#vi keybindings + ctrl-r to search backward.
bindkey -v
bindkey "^r" history-incremental-search-backward

export EDITOR=vim

###
# local::lib config
#

if [ -d /apps/perl5 ]; then
    eval $( perl -Mlocal::lib=/apps/perl5 )
fi
if [ -d $HOME/perl5 ]; then
    eval $( perl -Mlocal::lib )
fi
#
###

###
#add toast directories
#

LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$HOME/.toast/armed/lib
PATH=${PATH:+$PATH:}$HOME/.toast/armed/bin:$HOME/.toast/armed/sbin:$HOME/mybin/:$HOME/bin/:$HOME/open42/adblender/trunk/adblender/bin:$HOME/trunk/adblender/bin

#
###

###
# begin function definitions
#

#
# Build ctags file, skipping .svn directories, from here down the tree.
#
function ctagit ()
{
        ctags -f tags --recurse --totals \
        --exclude=blib --exclude=.svn    \
        --exclude=.git --exclude='*~'    \
        --extra=q                        \
        --languages=Perl,Python --langmap=Perl:+.t
}

# end functions
###

###
# begin: Xterm and Screen title update
#

xterm_title()
{
    builtin print -n -P -- "\e]0;$@\a"
}
screen_title()
{
    builtin print -n -P -- "\ek$@\e\\"
    xterm_title "$@"
}

case $TERM in
    screen|screen-w|screen-256color|screen-256color-bce)
        alias titlecmd="screen_title"
    ;;
    xterm|xterm-256color)
        alias titlecmd="xterm_title"
    ;;
    *)
        alias titlecmd=":"
    ;;
esac

## autoset title based on location and process

function preexec () {
    titlecmd "%m %4~" ":" "\"$1\""
}

function precmd () {
    vcs_info
    titlecmd "%m %4~"
}

ssh() {
    titlecmd "$1";
    command ssh $*;
    titlecmd "$HOSTNAME";
}

#
# end: Xterm and Screen title update
###

#Functions & autoload
#FPATH=$HOME/.zfunc
#autoload function names here via:
#autoload foo bar baz


# export this for skype to function with my microphone.
export PULSE_SERVER=127.0.0.1

#ibus? what is this?
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# fink setup for macosx
if [ -f /sw/bin/init.sh ]; then
    source /sw/bin/init.sh
fi


#named directories.  Access as ~u, etc.
s=$HOME/src
h=$HOME/src/herbie
setopt AUTO_CD
setopt CDABLE_VARS

###
# EC2 configuration for AWS/IAM keys
#
#export EC2_PRIVATE_KEY=~/.aws/private-key.pem
#export EC2_CERT=~/.aws/cert.pem
#export EC2_URL='https://ec2.us-west-1.amazonaws.com'

#export AWS_CREDENTIAL_FILE=~/.aws/$USER-credential-file
#export AWS_IAM_HOME=~/contrib/IAMCli-1.2.0
#export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
#export PATH=$PATH:$AWS_IAM_HOME/bin

#
###

alias h=history

export PYTHONDONTWRITEBYTECODE=1
