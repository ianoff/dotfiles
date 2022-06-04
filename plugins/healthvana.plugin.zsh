alias hv="cd ~/Sites/h/"
alias hvnext="cd ~/Sites/hvnext/"
alias helpscout="cd ~/Sites/fetch-help-scout/"
alias wch="yarn watch"
alias githooks="cd ~/Sites/h/.git/hooks/ && code ."
alias calc="dc"
alias dc="docker compose"

alias hvdestroy="docker-compose down -v"
alias hvbuild="docker-compose build"
alias hvup="docker-compose up -d"
alias hvinit="./dc-afterup.sh"
alias dcrebuild="./dc-rebuild.sh"
alias resetdb="docker-compose exec -T django /data/h/etc/deployments/dev/docker/reset_database.sh"
alias resetdevdb="docker-compose exec -T django ./etc/deployments/common/tasks/reset_dev_database.sh"
alias staticsh="docker-compose exec django bash -c 'etc/deployments/common/tasks/static.sh'"
alias tc="yarn rm-reports; yarn testcafe"
alias tc-all="yarn rm-reports; resetdb; yarn testcafe-all"

alias destroydangles="docker rmi $(docker images -f dangling=true -q)"

alias all_containers="$(docker ps -a --format {{.Names}})"

alias notify="curl -X POST --data-urlencode 'payload={\"channel\": \"@ian\", \"username\": \"Startup Complete\", \"text\": \"Your machine startup has finished!\", \"icon_emoji\": \":purple_heart:\"}' $SLACK_HOOK_URL"

alias hvspin="./dc-rebuild.sh&&notify"
alias hvspinall="hvdestroy&&hvbuild&&hvup&&hvinit&&notify"

alias sha_currentbranch="git rev-parse --short $(git rev-parse --abbrev-ref HEAD)"
alias sha_prod="git rev-parse --short production"
alias fl="git diff ${sha_prod} ${sha_currentbranch} | flake8 --diff"

function pypc() {
    pc_header="\x1b[30;45m PRE-COMMIT \x1b[0m\n"
    flake8_header="\x1b[30;45m FLAKE8 \x1b[0m\n"

    echo ${pc_header}
    pre-commit run --all-files
    echo ${flake8_header}
    if [[ $(fl) ]]; then
        fl
    else
        echo "All good ✅"
    fi
}

alias 1phv="op signin --account healthvana"
