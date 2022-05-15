function cdls() {
  builtin cd $argv;
  ls;
}

###### Git ######

# open the files that were modified in a specified commit
function gedit() {
  vim -O (git show --pretty=format: --name-only $1 | sed '$!N; s/\n/ /;')
}

is_in_git_repo() {
    # git rev-parse HEAD > /dev/null 2>&1
    git rev-parse HEAD > /dev/null
}

# https://cocktailmake.github.io/posts/improvement-of-git-commands-with-fzf/
function fgs() { # fshow - git commit browser
	is_in_git_repo || return

	_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
	_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always %'"
	git log --graph --color=always \
		--format="%C(auto)%h%d [%an] %s %C(black)%C(bold)%cr" "$@" |
		fzf --ansi --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
		--preview="$_viewGitLogLine" \
		--bind "ctrl-m:execute:
		(grep -o '[a-f0-9]\{7\}' | head -1 |
			xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
				{}
				FZF-EOF"
}

###### Docker ######

# https://github.com/jesseduffield/lazydocker/blob/master/README.md
function drmii() {
  docker rmi -f (docker images $1 -q | uniq)
}
function dsh() { # run a shell from an image
    docker run -ti --entrypoint="" $1 sh
  }
function dcsh() {
    docker-compose exec $1 sh
  }

###### Kubernetes ######
function ksh() {
  kubectl exec -ti $1 sh
}

if which hub > /dev/null; then
  eval $(hub alias -s)
  alias git=hub
fi

###### Ruby ######
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
