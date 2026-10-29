local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
# Path and input use the terminal's default foreground (set per light/dark mode
# in colors.zsh) so the prompt stays legible on either background.
PROMPT='
${ret_status} %{$reset_color%}%~%<<
%{$reset_color%} $(virtualenv_prompt_info) $(git_prompt_info)%{$fg[green]%}> %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
