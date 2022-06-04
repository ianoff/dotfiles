
# Universal
alias sb="code"
alias vs="code"
alias yanr="yarn"
alias profile="cd ~/Sites/dotfiles && code ."
alias update_profile="~/dotfiles/install"
alias runserver="python manage.py runserver"
alias py="python manage.py"
alias jsw="jekyll serve --watch"

function npmse(){
  npm install $1 --save --save-exact;
}

#shouldn't really need this anymore
alias zsh="cd ~/.oh-my-zsh"

#quickly serve the current directory
alias easyserver="python -m SimpleHTTPServer"

### HOME ###
alias uber="cd ~/Sites/ubersicht-ianoff/ && subl ~/Sites/ubersicht-ianoff/"

alias npm-do='PATH=$(npm bin):$PATH'

alias restartFinder='killall Finder /System/Library/CoreServices/Finder.app'

alias showHidden='defaults write com.apple.finder AppleShowAllFiles YES; restartFinder'
alias hideHidden='defaults write com.apple.finder AppleShowAllFiles NO; restartFinder'

export PATH=PATH:/Users/ianoff/flutter/bin:$PATH