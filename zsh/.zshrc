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

# ---- Load shh-agent for git authentications
eval `keychain --eval ed_github --eval ed_saint-gobain --eval id_opnsense --eval rsa_dhl --eval rsa_ext-molndal --eval rsa_ideo`

alias pn="pnpm"
alias pni="pnpm run install"
alias pnd="pnpm run dev"
alias npd="npm run dev"
alias npi="npm install"
alias nps="npm run start"
alias npb="npm run build"
alias npp="npm run prod"
alias sd="sudo systemctl start docker"
alias jdu="just dev-up"
alias jdl="just dev-logs"
alias jdr="just dev-rebuild"
alias code="codium"

# --- Setup volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

export PATH=$PATH:/home/nightmare/.spicetify
export PATH=$PATH:/home/nightmare/.tmux/plugins/tmuxifier/bin

export GOPATH=$HOME/go  
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
# pnpm
export PNPM_HOME="/home/nightmare/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH=$HOME/.local/bin:$PATH
