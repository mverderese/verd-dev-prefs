local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
# PROMPT='${ret_status} %{$fg[cyan]%}%25<...<%~%<< %{$fg[green]%}>%{$reset_color%} $(git_prompt_info)'
PROMPT='
${ret_status} %{$fg[cyan]%}%~%<<
<<<<<<< HEAD
%{$reset_color%} $(virtualenv_prompt_info) $(git_prompt_info)%{$fg[green]%}> %{$fg[white]%}'
=======
%{$reset_color%}$(virtualenv_prompt_info) $(git_prompt_info)%{$fg[green]%}> %{$fg[white]%}'
>>>>>>> b4550cc9421914bacb956f4d54d3df89a4ee6065

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
