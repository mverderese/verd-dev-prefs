local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
# PROMPT='${ret_status} %{$fg[cyan]%}%25<...<%~%<< %{$fg[green]%}>%{$reset_color%} $(git_prompt_info)'
PROMPT='
${ret_status} %{$fg[cyan]%}%~%<<
%{$reset_color%} $(git_prompt_info)%{$fg[green]%}> %{$fg[white]%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
