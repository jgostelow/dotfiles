# plugins
# https://github.com/zsh-users/antigen
source ~/antigen.zsh
antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle git
antigen bundle dirhistory
antigen bundle jsontools
antigen bundle rbenv
antigen bundle bundler
antigen bundle rake
antigen theme raziel1121/env zsh-themes/jono
antigen apply

ZSH_THEME="jono"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
plugins=(dirhistory jsontools git bundler rake)
