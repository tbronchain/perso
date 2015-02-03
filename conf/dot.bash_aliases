# Alias
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias em='emacs -nw'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -v'
alias ls='ls --color=auto -Fh'
alias ll='ls -l'
alias lla='ls -la'
alias clean='rm -rfv *~ .*~ \#*\# .\#*\#'
alias j='jobs'
alias rm='rm -i'
alias cp='cp -v'
alias mv='mv -v'

# Prompt
#PS1='\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;34m\]\h\[\e[0m\]:\[\e[0;33m\]\w\[\e[0m\]\$ '

# Colors and Git prompt
PMT=""; if [  $UID -eq 0 ];then PMT="#" ;else PMT="$" ; fi
WHITE="\[\033[0m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32;40m\]"
BLUE="\[\033[1;34m\]"
export PS1="[$GREEN\u@\h $BLUE\W$WHITE:$YELLOW\$(git branch 2>/dev/null | grep '^*' | colrm 1 2)$WHITE]"$PMT

# Git completion
if [ -f ~/git-completion.bash ]; then
   source ~/git-completion.bash
fi
if [ -f ~/.bash_complete ]; then
   source ~/.bash_complete
fi

# Sbt options
SBT_OPTS="-XX:MaxPermSize=512m -XX:+CMSClassUnloadingEnabled"
