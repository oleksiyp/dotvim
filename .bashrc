# Some vim hacks
vim()
{
    local STTYOPTS="$(stty --save)"
    stty stop '' start '' -ixoff
    command vim "$@"
    stty "$STTYOPTS"
}

alias vi=vim
