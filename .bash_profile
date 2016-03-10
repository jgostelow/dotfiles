export CLICOLOR=1

export LSCOLORS=GxFxCxDxBxegedabagaced

#RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

export RUBY_GC_HEAP_INIT_SLOTS=500000
export RUBY_HEAP_SLOTS_INCREMENT=250000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=50000000

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1="\[\e[01;32m\]\u@\h\[\e[m\]:\[\e[01;34m\]\t\[\e[m\]:\[\e[01;31m\]\w\[\e[m\]\n\[\e[01;33m\]\$(parse_git_branch)\[\e[m\] $ "

#set -o vi
source $HOME/.aliases
