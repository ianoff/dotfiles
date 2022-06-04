# Oh-my-Zsh prompt created by meaganoff, based on gianu
#
# github.com/meaganoff

PROMPT='[%{$fg_bold[white]%}%n%{$reset_color%}@%{$fg_bold[magenta]%}%m%{$reset_color%} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)%{$reset_color%}] ☕️  '

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%} %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"

