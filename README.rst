Installation::

    git clone --recursive https://github.com/troydm/dotvim.git ~/.vim

    Create symlinks::

    ln -s ~/.vim/.vimrc ~/.vimrc
    ln -s ~/.vim/.gvimrc ~/.gvimrc

    On windows::
    ln -s ~/.vim/.vimrc ~/_vimrc
    ln -s ~/.vim/.gvimrc ~/_gvimrc

    Start vim and type :BundleInstall, restart vim and enjoy!

If you use vim in bash console and want to have Ctrl-S and Ctrl-Q to work properly Add this to your ~/.bashrc or ~/.bash_profile::

    # vim wrapper for bash to make ctrl-s and ctrl-q work in terminal
    source ~/.vim/.bashrc

Notes:

bclose plugin is slightly modified with fixes for use in fugitive, help and other dialog windows (it closes window too, not only buffer)
