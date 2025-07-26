PROMPT_END='❯'
PROMPT_START='➜'
PROMPT_PATH='%~'
PROMPT='%{$fg[green]%}${PROMPT_START} %{$fg[cyan]%}${PROMPT_PATH} $(git_prompt_info)%(?:%{$fg_bold[green]%}${PROMPT_END} :%{$fg_bold[red]%}${PROMPT_END} )'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}●"
