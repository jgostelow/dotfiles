CYAN='\033[0;36m'
GREEN='\033[0;32m'
ORANGE='\033[38;5;214m'
NC='\033[0m' # No Color
export HOMEBREW_NO_INSTALL_CLEANUP=1

function h2 {
  printf "${GREEN}############################################################# $1${NC}\n"
}

function h3 {
  printf "${CYAN}---------------------------------------------- $1${NC}\n"
}

function binstall {
  h3 "BREW: Installing $1"
  NONINTERACTIVE=1 brew install --quiet $1
}

function install {
  h3 "APT : Installing $1"
  sudo apt-get -qq install $1 -y > /dev/null
}

function checkout_or_update_git_repo {
  repo=$1
  dir=$2
  main_branch=$3
  if [ ! -d $dir ] ; then
    h3 "Git : Cloning $repo into $dir"
    git clone --single-branch $repo $dir
  else
    h3 "Git : Updating $repo into $dir"
    git -C $dir pull origin $main_branch
  fi
}

function add_to_file_unique {
  line=$1
  file=$2
  touch $file
  grep -qF "$line" $file || echo "$line" >> $file
}

function cleanup() {
  sudo apt-get autoremove -y
}
