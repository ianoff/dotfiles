# Setup 1password completion
if [[ $(op) ]]; then
    eval "$(op completion zsh)"
else
    echo "Install 1password cli: https://app-updates.agilebits.com/product_history/CLI2"
fi

# Bootstrap env variables from 1Password to a tmp dir
# That is not committed to the repo
ENV_FILE=~/Sites/dotfiles/dev.env
SECRETS_FILE=~/Sites/dotfiles/.tmp/secrets.zsh

function loadsecrets() {
    if [ -f "$SECRETS_FILE" ]; then
        source "$SECRETS_FILE"
        echo "Secrets sourced."
    else
        echo "Secrets file not found; secrets not loaded. Run savesecrets to inject file."
    fi
}

alias savesecrets="cat ${ENV_FILE} | op inject -f -o ${SECRETS_FILE}"
alias killsecrets="rm -rf ${SECRETS_FILE}"