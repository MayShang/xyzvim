#!/bin/bash

function compile_vim_and_install()
{
    sudo apt-get remove -y vim vim-runtime gvim
    sudo apt-get remove -y vim-tiny vim-common vim-gui-common vim-nox
    sudo rm -rf /usr/bin/vim*
    sudo rm -rf /usr/local/bin/vim*
    sudo rm -rf /usr/share/vim/vim*
    sudo rm -rf /usr/local/share/vim/vim*
    rm -rf ~/vim

    sudo apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
        libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev python3-dev ruby-dev lua5.1 lua5.1-dev

    git clone https://github.com/vim/vim.git ~/vim
    cd ~/vim
    ./configure --with-features=huge \
        --enable-multibyte \
        --enable-rubyinterp \
        --enable-pythoninterp \
        --with-python-config-dir=/usr/lib/python2.7/config \
        --enable-perlinterp \
        --enable-luainterp \
        --enable-gui=gtk2 \
        --enable-cscope \
        --prefix=/usr
    make
    sudo make install
    cd -
}

function compile_fasd_and_install()
{
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/clvv/fasd.git ~/fasdxyz
    cd ~/fasdxyz
    make
    sudo make install
    cd -
}

function install_package()
{
    sudo apt-get install -y ctags build-essential cmake python-dev python3-dev fontconfig curl libfile-next-perl ack-grep 
    sudo apt-get install -y tmux silversearcher-ag zsh awesome
    
    # chsh -s $(which zsh)

    compile_vim_and_install

    compile_fasd_and_install
}


function copy_files()
{
    rm -rf ~/.vimrc
    ln -s ${PWD}/.vimrc ~

    rm -rf ~/.vimrc.local
    cp ${PWD}/.vimrc.local ~

    rm -rf ~/.ycm_extra_conf.py
    ln -s ${PWD}/.ycm_extra_conf.py ~

    mkdir ~/.vim
    rm -rf ~/.vim/colors
    ln -s ${PWD}/colors ~/.vim

    rm -rf ~/.tmux.conf
    cp ${PWD}/.tmux.conf ~

    mkdir -p ~/.config/awesome
    cp ${PWD}/rc.lua ~/.config/awesome

    rm -rf ~/.zshrc
    cp ${PWD}/.zshrc ~
}

function install_fonts()
{
    mkdir ~/.fonts
    rm -rf ~/.fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf
    cp ./fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf ~/.fonts

    fc-cache -vf ~/.fonts
}

function install_vim_plugin()
{
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    vim -c "PlugInstall" -c "q" -c "q"
}

function compile_ycm_on_linux()
{
    cd ~/.vim/plugged/YouCompleteMe
    ./install.py --clang-completer
}

function install_xyzvim()
{
    install_package
    copy_files
    install_fonts
    install_vim_plugin
    compile_ycm_on_linux

    chsh -s $(which zsh)
}

install_xyzvim

