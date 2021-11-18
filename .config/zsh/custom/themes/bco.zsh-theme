#!/usr/bin/env sh

# Modified version of robbyrussell

PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT+=' %{$fg_bold[magenta]%}%* %{$fg[cyan]%}%2~%{$reset_color%} $(git_prompt_info)%(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
