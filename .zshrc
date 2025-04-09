# completion
zmodload zsh/complist
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
bindkey -M menuselect '^[[Z' reverse-menu-complete

precmd() { tmux setenv -g LAST_EXIT "$?" }

# prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{green}%~%f %F{blue}${vcs_info_msg_0_}%f'
# PROMPT='%F{blue}%n@%m%f%b %F{green}%~%f %F{red}${vcs_info_msg_0_}%f'

# history
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# variables
export VISUAL='vim'
export EDITOR='vim'
export CLICOLOR=1
export LSCOLORS=gxFxCxDxBxegedabagaced
export GREP_OPTIONS='-R -n --ignore-case --color=auto'

# alias
alias lss='ls -lah'
alias gst='git status'
alias gaa='git add .'
alias gc='git commit'
alias gp='git push'

# resume with ctrl-z
function Resume { fg; zle push-input; BUFFER=""; zle accept-line } 
zle -N Resume; bindkey "^Z" Resume

# copy text content of folder to clipboard
function llm { find "$1" -type f | while IFS= read -r file; do file "$file" | grep -qE 'text|ASCII' && echo -e "\n--- $file ---\n$(cat "$file")"; done | pbcopy; }
