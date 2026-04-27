# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

HOSTNAME=$(hostname)

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

ZSH_THEME="pygmalion"

# Comment this out to disable bi-weekly auto-update checks
#DISABLE_AUTO_UPDATE="true"

COMPLETION_WAITING_DOTS="true"
plugins=(git git-extras ianoff vscode npm emoji-clock font-install kelpie)
mypath=/usr/local/bin

source $ZSH/oh-my-zsh.sh
export PATH=/usr/bin/python3:/opt/homebrew/bin:$mypath:$PATH

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

DJANGO_ENVIRONMENT="dev"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

NODE_OPTIONS="$NODE_OPTIONS --openssl-legacy-provider --max-old-space-size=8192"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
PATH=$(pyenv root)/shims:$PATH

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# pnpm
export PNPM_HOME="/Users/ianoff/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
alias pn=pnpm
# Created by `pipx` on 2025-01-04 16:36:39
export PATH="$PATH:/Users/ianoff/.local/bin"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk && export PATH=$PATH:$ANDROID_HOME/emulator && export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/.maestro/bin
