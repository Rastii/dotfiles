#!/bin/zsh

. ~/.zsh/alias
. ~/.zsh/function
. ~/.zsh/autotime
PURE_PROMPT_SYMBOL="➜" . ~/.zsh/pure.zsh
# . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. /home/guilherme/build/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Because /etc/profile may have overriden our ~/.zshenv setting
export PATH=/bin:/sbin:/usr/local/bin:/usr/bin:/usr/sbin:$HOME/bin:/opt/anaconda/bin

## Use `npm -g` without root access
export NPM_PACKAGES="/home/guilherme/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
export PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

export NVM_DIR="/home/guilherme/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
