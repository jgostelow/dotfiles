# plugins
# https://github.com/zsh-users/antigen
source ~/antigen.zsh
antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle git
antigen bundle dirhistory
#antigen bundle jsontools
#antigen bundle rbenv
antigen theme raziel1121/env zsh-themes/jono
antigen apply

ZSH_THEME="jono"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
plugins=(dirhistory jsontools git zsh-autosuggestions zsh-syntax-highlighting)

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Do not share history across sessions
unsetopt share_history

source ~/bin/tmuxinator.zsh
