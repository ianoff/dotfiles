# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

HOSTNAME=$(hostname)

ZSH_THEME="montague_st"

# Comment this out to disable bi-weekly auto-update checks
#DISABLE_AUTO_UPDATE="true"

COMPLETION_WAITING_DOTS="true"
plugins=(git git-extras ianoff kelpie)
mypath=/usr/local/bin

source $ZSH/oh-my-zsh.sh
export PATH=/usr/bin/python3:/opt/homebrew/bin:$mypath:$PATH

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# export PATH=$PATH:$HOME/.maestro/bin
