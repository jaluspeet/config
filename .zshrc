export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="simple"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# variables
export VISUAL='vim'
export EDITOR='vim'

# better ls
alias lss='ls -lah'

# resume with ctrl-z
function Resume { fg; zle push-input; BUFFER=""; zle accept-line } 
zle -N Resume; bindkey "^Z" Resume

# copy text content of folder to clipboard
function llm { find "$1" -type f | while IFS= read -r file; do file "$file" | grep -qE 'text|ASCII' && echo -e "\n--- $file ---\n$(cat "$file")"; done | pbcopy; }
