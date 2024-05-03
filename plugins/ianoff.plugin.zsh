
# Universal
alias sb="code"
alias vs="code"
alias yanr="yarn"
alias profile="cd ~/Sites/dotfiles && code ."
alias ianoff="cd ~/Sites/ianoff-nobelium && code ."
alias dc="docker compose"

### HOME ###
alias npm-do='PATH=$(npm bin):$PATH'

alias restartFinder='killall Finder /System/Library/CoreServices/Finder.app'



export PATH=PATH:/Users/ianoff/flutter/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

#--track=javascript --exercise=list-ops
function exgo() {
    EX_PATH=~/Sites/_learning/exercism
    # cd "$EX_PATH"
    # echo "Moved to $PWD ▶"
    # echo "exercism download $1 $2 --force"
    exercism download $1 $2 --force;
    wait
    
    TRACK=${1:8}
    EXERCISE=${2:11}
    
    # echo "$EX_PATH/$TRACK/$EXERCISE"
    cd "$EX_PATH/$TRACK/$EXERCISE";
    
    code .;
    
    case $TRACK in
        javascript)
            npm i;
            npm run watch;
        ;;
        typescript)
            touch yarn.lock;
            yarn;
            yarn test --watch;
        ;;
        *)
            echo "Other track type; please perform a manual install."
        ;;
    esac
}