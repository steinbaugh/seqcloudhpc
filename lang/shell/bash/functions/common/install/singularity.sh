#!/usr/bin/env bash

koopa::install_singularity() { # {{{1
    koopa::install_app \
        --name='singularity' \
        "$@"
}

koopa:::install_singularity() { # {{{1
    # """
    # Install Singularity.
    # @note Updated 2021-04-27.
    # """
    local file name prefix url version
    koopa::assert_is_installed go
    koopa::assert_is_admin
    prefix="${INSTALL_PREFIX:?}"
    version="${INSTALL_VERSION:?}"
    name='singularity'
    file="${name}-${version}.tar.gz"
    url="https://github.com/sylabs/${name}/releases/download/\
v${version}/${file}"
    koopa::download "$url"
    koopa::extract "$file"
    koopa::cd "$name"
    ./mconfig --prefix="$prefix"
    make -C builddir
    sudo make -C builddir install
    return 0
}
