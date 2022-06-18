#ianoff additions
alias gcm='git commit -m'
alias gbd='git branch -d'
alias gbdd='git branch -D'
alias gcma='git commit -am'
alias grd='git rm $(git ls-files --deleted)'
function gbc(){
  git branch $1;
  git checkout $1;
}