basedir=$(pwd)/base

ln -s $basedir/.aliases ~/
ln -s $basedir/.bash_profile ~/
ln -s $basedir/.gitconfig ~/
ln -s $basedir/.screenrc ~/
ln -s $basedir/.vim ~/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
ln -s $basedir/.vimrc ~/
