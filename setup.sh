basedir=$(pwd)

ln -sf $basedir/.aliases ~/
ln -sf $basedir/.bash_profile ~/
ln -sf $basedir/.gitconfig.groupon ~/.gitconfig
ln -sf $basedir/.screenrc ~/
ln -sf $basedir/.vim ~/
ln -sf $basedir/.vimrc ~/
git submodule init
git submodule update
