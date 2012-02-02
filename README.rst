Installation:
::
    git clone git://github.com/troydm/dotvim.git ~/.vim

Create symlinks:
::
    ln -s ~/.vim/.vimrc ~/.vimrc
    ln -s ~/.vim/.gvimrc ~/.gvimrc

If you use vim in bash console and want to have Ctrl-S and Ctrl-Q to work properly Add this to your ~/.bashrc or ~/.bash_profile
::
    # vim wrapper for bash to make ctrl-s and ctrl-q work in terminal
    source ~/.vim/.bashrc

Notes:

Most modifications i keep in .vimrc file, other plugins are not modified anyhow except bclose plugin
which is slightly modified with fixes for use in fugitive, help and viewdoc windows (it closes window too not only buffer)
