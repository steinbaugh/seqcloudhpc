#!/usr/bin/env bash

_koopa_help "$@"
_koopa_assert_has_no_args "$@"



# Variables                                                                 {{{1
# ==============================================================================

name="neofetch"
version="$(_koopa_variable "$name")"
prefix="$(_koopa_cellar_prefix)/${name}/${version}"
tmp_dir="$(_koopa_tmp_dir)/${name}"
exe_file="${prefix}/bin/${name}"



# Script                                                                    {{{1
# ==============================================================================

_koopa_message "Installing ${name} ${version}."

(
    rm -frv "$prefix"
    rm -frv "$tmp_dir"
    mkdir -pv "$tmp_dir"
    cd "$tmp_dir" || exit 1
    wget "https://github.com/dylanaraps/${name}/archive/${version}.tar.gz"
    _koopa_extract "${version}.tar.gz"
    cd "${name}-${version}" || exit 1
    mkdir -pv "$prefix"
    make PREFIX="$prefix" install
    rm -fr "$tmp_dir"
)

_koopa_link_cellar "$name" "$version"

"$exe_file" --version
command -v "$exe_file"
