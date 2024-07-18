# ---- ZSH HOME -----
export ZSH=$HOME/.zsh

# ---- autocompletions ----
fpath=(~/.zsh/site-functions $fpath)
autoload -Uz compinit && compinit

# ---- Completion options and styling ----
zstyle ':completion:*' menu select # selectable menu
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'  # case insensitive completion
zstyle ':completion:*' special-dirs true # Complete . and .. special directories
zstyle ':completion:*' list-colors '' # colorize completion lists
export WORDCHARS=${WORDCHARS//[\/]}

# ---- Source other configs ----
[[ -f $ZSH/config/history.zsh ]] && source $ZSH/config/history.zsh
[[ -f $ZSH/config/aliases.zsh ]] && source $ZSH/config/aliases.zsh

# ---- GPG Client setup ----
#if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
#    source ~/.gnupg/.gpg-agent-info
#    export GPG_AGENT_INFO
#else
#    eval $(gpg-agent --daemon ~/.gnupg/.gpg-agent-info)
#fi

# ---- Source plugins -----
[[ -f $ZSH/plugins/plugins.zsh ]] && source $ZSH/plugins/plugins.zsh
source $ZSH/plugins/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh 

# add local bin to path
export PATH=$HOME/bin:$PATH

# ---- Load Starship ----
eval "$(starship init zsh)"

# ---- zsh-synrax-highlighting ----
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ---- Set star ship config env variable
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
