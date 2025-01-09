function cdls() {
  builtin cd $argv && ls
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

function safe_delete_branch() {
  local branch_name=$1
  local main_branch=${2:-origin/main}

  # Check if branch exists
  if ! git rev-parse --verify "$branch_name" >/dev/null 2>&1; then
    echo "Branch '$branch_name' does not exist."
    return 1
  fi

  # Check for diffs between the branch and the main branch
  if [[ -n $(git diff "$main_branch"..."$branch_name") ]]; then
    echo "Error: Differences detected between '$branch_name' and '$main_branch'."
    return 1
  fi

  # Delete the branch
  git branch -D "$branch_name" && echo "Branch '$branch_name' deleted successfully."
}

# Switches from a feature branch back to the main branch and deletes the feature branch
function git_delete_current_branch() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ $current_branch == $(gm) ]]; then #Do not attempt on the main branch
    echo "Currently on main branch. Skipping"
    return 1
  fi
  gpm       # merge latest main into the feature branch
  gc $(gm)  # checkout the main branch
  gu        # pull latest main branch
  echo "Deleting $current_branch"
  safe_delete_branch $current_branch "origin/$(gm)"
}

function fgbd() {
  safe_delete_branch $(fb) "origin/$(gm)"
}

eval "$(mcfly init zsh)"

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
