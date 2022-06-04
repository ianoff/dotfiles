# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

HOSTNAME=$(hostname)

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

ZSH_THEME="kaer-morhen"

# Comment this out to disable bi-weekly auto-update checks
#DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"
plugins=(git python ianoff vscode npm emoji-clock 1password)
mypath=/usr/local/bin

#Some plugins for home, some for work
if [[ $HOSTNAME == 'Zireael' ]]; then
    print "Setting up for Home..."
    plugins+=(flutter)
else
    print "Setting up for Work..."
    plugins+=(healthvana docker)
fi

source $ZSH/oh-my-zsh.sh

export PATH=PATH:$mypath:$PATH

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

DJANGO_ENVIRONMENT="dev"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

NODE_OPTIONS="$NODE_OPTIONS --openssl-legacy-provider --max-old-space-size=8192"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
