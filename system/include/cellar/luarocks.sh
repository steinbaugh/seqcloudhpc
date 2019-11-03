#!/usr/bin/env bash

_koopa_help "$@"
_koopa_assert_has_no_args "$@"
_koopa_assert_is_installed lua



# Notes                                                                     {{{1
# ==============================================================================

# Debian:
# > sudo apt install build-essential libreadline-dev

# Fedora:
# > install-lua

# > install-cellar-lua



# Variables                                                                 {{{1
# ==============================================================================

name="luarocks"
version="$(_koopa_variable "$name")"
prefix="$(_koopa_cellar_prefix)/${name}/${version}"
tmp_dir="$(_koopa_tmp_dir)/${name}"
exe_file="${prefix}/bin/${name}"



# Script                                                                    {{{1
# ==============================================================================

_koopa_message "Installing ${name} ${version}."

(
    rm -frv "$prefix"
    rm -fr "$tmp_dir"
    mkdir -pv "$tmp_dir"
    cd "$tmp_dir" || exit 1
    file="${name}-${version}.tar.gz"
    wget "https://luarocks.org/releases/${file}"
    _koopa_extract "$file"
    cd "${name}-${version}" || exit 1
    ./configure --prefix="$prefix"
    make build
    make install
    rm -fr "$tmp_dir"
)

_koopa_link_cellar "$name" "$version"

# > build_prefix="$(_koopa_build_prefix)
# > export LUAROCKS_PREFIX="$build_prefix"

# Install Lmod dependencies.
luarocks install luaposix
luarocks install luafilesystem

_koopa_link_cellar "$name" "$version"

"$exe_file" --version
command -v "$exe_file"

lua -e 'print(package.path)'
