#!/bin/sh

# https://github.com/willyrgf/vimfiles

OS="$(uname -s | tr 'A-Z' 'a-z')"

_pre_install() {
    # pre-requisites
    needed="vim git ctags curl make"
    if [ "${OS}" == "freebsd" ]; then
        needed="${needed} gmake"
        cp -v /usr/bin/make /tmp/
        cp -v /usr/local/bin/gmake /usr/bin/make
    fi

    # pre-requisites
    needed="vim git ctags curl make"
    for b in $(echo "${needed}" | xargs -n 1) ; do
        if ! command -v "${b}" 2> /dev/null; then
            echo "command ${b} is not found"
            return 1
        fi
    done
}

_install() {
    # copy vimrc's
    if ! cp -av rcs/.vimrc* ~/; then
        echo "error on copy the vimrcs to home"
        return 1
    fi

    mkdir -p ~/.vim
    # copy plugins_settings
    if ! cp -av plugins_settings/* ~/.vim/; then
        echo "error on copy the plugins_settings to ~/.vim/"
        return 1
    fi

    if ! vim +:PlugInstall +q +q && vim +:VimBootstrapUpdate +q +q; then
        echo "error on install vim plugins"
        return 1
    fi

    if ! mkdir -p ~/.vim/backup/; then
        echo "error on create vim backup directory"
        return 1
    fi
}

_post_install() {
    if [ "${OS}" == "freebsd" ]; then
        cp -v /tmp/make /usr/bin/make
    fi
}

_main() {
    _pre_install &&
        _install
    _post_install
}

_main
