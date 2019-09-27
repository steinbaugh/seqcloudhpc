#!/usr/bin/env bash

usage() {
cat << EOF
usage: install-cellar-vim [--help|-h]

Install Vim.

details:
    Compiling with Python 3 support.

see also:
    - https://github.com/vim/vim

note:
    Bash script.
    Updated 2019-09-23.
EOF
}

_koopa_help "$@"

name="vim"
version="$(_koopa_variable "$name")"
prefix="$(_koopa_cellar_prefix)/${name}/${version}"
tmp_dir="$(_koopa_tmp_dir)/${name}"
build_os_string="$(_koopa_build_os_string)"
exe_file="${prefix}/bin/${name}"

# Using this to set Python 3 flags automatically below.
build_prefix="$(_koopa_build_prefix)"
python3_exe="${build_prefix}/bin/python3"
python3_config_exe="${python3_exe}-config"
python3_config_dir="$("$python3_config_exe" --configdir)"

printf "Installing %s %s.\n" "$name" "$version"

(
    rm -frv "$prefix"
    rm -frv "$tmp_dir"
    mkdir -pv "$tmp_dir"
    cd "$tmp_dir" || exit 1
    wget "https://github.com/vim/vim/archive/v${version}.tar.gz"
    tar -xzvf "v${version}.tar.gz"
    cd "vim-${version}" || exit 1
    ./configure \
        --build="$build_os_string" \
        --prefix="$prefix" \
        --enable-python3interp="yes" \
        --with-python3-command="${python3_exe}" \
        --with-python3-config-dir="${python3_config_dir}"
    make --jobs="$CPU_COUNT"
    # > make test
    make install
    rm -fr "$tmp_dir"
)

_koopa_link_cellar "$name" "$version"

"$exe_file" --version
command -v "$exe_file"
