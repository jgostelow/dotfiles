CYAN='\033[0;36m'
NC='\033[0m' # No Color
export HOMEBREW_NO_INSTALL_CLEANUP=1

function binstall {
  printf "${CYAN}-------------------------------------------------------------- BREW: Installing $1${NC}\n"
  NONINTERACTIVE=1 brew install --quiet $1
}

function install {
  printf "${CYAN}-------------------------------------------------------------- APT : Installing $1${NC}\n"
  sudo apt-get -qq install $1 -y > /dev/null
}

function checkout_or_update_git_repo {
  repo=$1
  dir=$2
  main_branch=$3
  if [ ! -d $dir ] ; then
    printf "${CYAN}-------------------------------------------------------------- Git : Cloning $repo into $dir ${NC}\n"
    git clone --single-branch $repo $dir
  else
    printf "${CYAN}-------------------------------------------------------------- Git : Updating $repo into $dir ${NC}\n"
    git -C $dir pull origin $main_branch
  fi
}

function add_to_file_unique {
  line=$1
  file=$2
  grep -q $line $file || echo $line >> $file
}

function cleanup() {
  sudo apt-get autoremove -y
}
