#
# Dircolors...
#eval `dircolors -b ~/.dircolors`

# Kill flow control
if tty -s ; then
  stty -ixon
  stty -ixoff
fi

# Exports
export PATH=/bin:/sbin:/usr/local/bin:/usr/bin:/usr/sbin:$HOME/bin/opt/anaconda/bin
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LOCALE=en_US.UTF-8
export BROWSER='chromium'
export OOO_FORCE_DESKTOP='gnome'
export EDITOR='emacsclient -a "" -t'
export VISUAL='emacsclient -a ""'
export HISTCONTROL=ignoredups
export IGNOREEOF=3
export EMAIL="guilhermeaugustosg@gmail.com"
export NAME="Guilherme Gonçalves"
export SMTPSERVER="smtp.gmail.com"

# Schemas required for building website-user
export LL_DB_SCHEMAS_DIR=$HOME/lastline/db-schemas

if [ "$TERM" = "linux" ]; then
  echo -en "\e]P0000000" #black
  echo -en "\e]P8505354" #darkgrey
  echo -en "\e]P1f92672" #darkred
  echo -en "\e]P9ff5995" #red
  echo -en "\e]P282b414" #darkgreen
  echo -en "\e]PAb6e354" #green
  echo -en "\e]P3fd971f" #brown
  echo -en "\e]PBfeed6c" #yellow
  echo -en "\e]P456c2d6" #darkblue
  echo -en "\e]PC8cedff" #blue
  echo -en "\e]P58c54fe" #darkmagenta
  echo -en "\e]PD9e6ffe" #magenta
  echo -en "\e]P6465457" #darkcyan
  echo -en "\e]PE899ca1" #cyan
  echo -en "\e]P7ccccc6" #lightgrey
  echo -en "\e]PFf8f8f2" #white
  clear # back to default input colours
fi

bindkey -e
bindkey "\e[1~" beginning-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[3~" delete-char

bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history

bindkey '^R' history-incremental-search-backward

fpath=(~/.zfunctions ~/.zsh/completion $fpath)
autoload -U compinit
compinit

## SSH Agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;

    }
else
    start_agent;
fi

