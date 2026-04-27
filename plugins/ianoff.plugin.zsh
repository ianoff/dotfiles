
# Universal
alias yanr="yarn"
alias profile="cd ~/Dev/dotfiles && cursor ."
alias ianoff="cd ~/Dev/_sites/ianoff-nobelium && cursor ."
alias dc="docker compose"

function serve() {
  local port="${1:-8000}"

  python3 -m http.server "$port" >/dev/null 2>&1 &
  local pid=$!

  sleep 0.4
  open "http://localhost:$port"

  echo "Serving on http://localhost:$port (pid $pid)"
}

### HOME ###
alias npm-do='PATH=$(npm bin):$PATH'

alias restartFinder='killall Finder /System/Library/CoreServices/Finder.app'

export PATH=/Users/ianoff/flutter/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:/Applications/calibre.app/Contents/MacOS/:/Applications/calibre.app/Contents/MacOS/:$PATH

#--track=javascript --exercise=list-ops
function exgo() {
    EX_PATH=~/Dev/_learning/exercism
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

function advent() {
    AD_PATH=~/Dev/_learning/advent_of_code
    DAY=$2
    YEAR=$1
    cd $AD_PATH
    cd $YEAR
    mkdir $DAY
    cd $DAY
    cp -i $AD_PATH/template/* ./
    for file in *.js
    do
        mv "$file" "${file/day/$DAY}"
    done
    code .
}

alias normalize="~/Movies/scripts/normalize.sh"