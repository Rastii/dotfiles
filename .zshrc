#!/bin/zsh

. ~/.zsh/alias
. ~/.zsh/function
. ~/.zsh/autotime
. ~/.zsh/prompt.small
# PURE_PROMPT_SYMBOL="➜" . ~/.zsh/pure.zsh
# . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. /home/guilherme/build/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Because /etc/profile may have overriden our ~/.zshenv setting
export PATH=node_modules/.bin:/bin:/sbin:/usr/local/bin:/usr/bin:/usr/sbin:$HOME/bin:/opt/anaconda/bin
