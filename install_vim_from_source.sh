#!/bin/bash
# this builds vim from source to home directory

# install dependencies

echo "Installing dependencies"
sudo apt-get -y --force-yes install libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    ruby-dev mercurial cmake build-essential python-dev \
    checkinstall git

echo "Removing existing vims"
sudo apt-get -y --force-yes remove vim vim-runtime gvim vim-tiny vim-common vim-gui-common

cd ~
echo "Fetching vim source"
hg clone https://code.google.com/p/vim/
cd vim

echo "Configuring vim install"
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib/python2.7/config \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-gui=gtk2 --enable-cscope --prefix=/usr
            
make VIMRUNTIMEDIR=/usr/share/vim/vim74

echo "Installing vim now"
cd vim
sudo checkinstall

# set as default editor
echo "Setting vim as default editor"
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1

sudo update-alternatives --set vi /usr/bin/vim
echo "All done"

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cat <<EOT > ~/.vimrc

filetype plugin on
filetype indent on
set nocompatible

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'gmarik/Vundle.vim'
    Plugin 'tpope/vim-fugitive'
    Plugin 'scrooloose/syntastic'
    Plugin 'flazz/vim-colorschemes'
    Plugin 'Valloric/YouCompleteMe'

call vundle#end()
filetype plugin indent on

EOT

vim +BundleInstall +qall
cd ~/.vim/bundle/YouCompleteMe
./install.sh

cat <<EOT > ~/.vimrc

filetype plugin on
filetype indent on
syntax on

set nocompatible
set nobackup
set noswapfile
set backspace=indent,eol,start
set ruler
set cmdheight=2
set ignorecase
set noerrorbells
set novisualbell
set encoding=utf8
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set ai
set si
set wrap
set laststatus=2
set statusline=\ %F%m%r%h\ %w\ \ \ \ Line:\ %l
set t_Co=256
set mouse=a

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'gmarik/Vundle.vim'
    Plugin 'tpope/vim-fugitive'
    Plugin 'scrooloose/syntastic'
    Plugin 'flazz/vim-colorschemes'
    Plugin 'Valloric/YouCompleteMe'

call vundle#end()
filetype plugin indent on

colorscheme wombat256i

" deletes trailing whitespace on python files
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s+$//ge
    exe "normal \`z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

EOT

exit
