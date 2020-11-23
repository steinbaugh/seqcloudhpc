#!/usr/bin/env bash

koopa::find_app_version() { # {{{1
    # """
    # Find the latest application version.
    # @note Updated 2020-11-22.
    # """
    local name prefix x
    koopa::assert_has_args "$#"
    name="${1:?}"
    prefix="$(koopa::app_prefix)"
    koopa::assert_is_dir "$prefix"
    prefix="${prefix}/${name}"
    koopa::assert_is_dir "$prefix"
    x="$( \
        find "$prefix" \
            -mindepth 1 \
            -maxdepth 1 \
            -type d \
        | sort \
        | tail -n 1 \
    )"
    koopa::assert_is_dir "$x"
    x="$(basename "$x")"
    koopa::print "$x"
    return 0
}

# FIXME RENAME THIS TO INSTALL APP.
# FIXME CREATE LINK INTO OPT PREFIX AND THEN SYMLINK INTO MAKE PREFIX FROM THERE.
# FIXME REAPPROACH THIS USING EXPORTED GLOBALS.

koopa::install_app() { # {{{1
    # """
    # Install application into a versioned directory structure.
    # @note Updated 2020-11-23.
    # """
    local gnu_mirror include_dirs jobs link_args link_app make_prefix name \
        name_fancy prefix reinstall script script_name script_prefix \
        tmp_dir version
    koopa::assert_has_args "$#"
    koopa::assert_has_no_envs
    koopa::is_macos && koopa::assert_is_installed brew
    include_dirs=
    # FIXME Simply rename to 'link' here?
    link_app=1
    if koopa::is_macos
    then
        koopa::note 'App links are not supported on macOS.'
        link_app=0
    fi
    name_fancy=
    reinstall=0
    script_name=
    script_prefix="$(koopa::prefix)/include/build"
    version=
    while (("$#"))
    do
        case "$1" in
            --include-dirs=*)
                include_dirs="${1#*=}"
                shift 1
                ;;
            --name=*)
                name="${1#*=}"
                shift 1
                ;;
            --name-fancy=*)
                name_fancy="${1#*=}"
                shift 1
                ;;
            --no-link)
                link_app=0
                shift 1
                ;;
            --reinstall|--force)
                reinstall=1
                shift 1
                ;;
            --script-name=*)
                script_name="${1#*=}"
                shift 1
                ;;
            --script-prefix=*)
                script_prefix="${1#*=}"
                shift 1
                ;;
            --version=*)
                version="${1#*=}"
                shift 1
                ;;
            "")
                shift 1
                ;;
            *)
                koopa::invalid_arg "$1"
                ;;
        esac
    done
    koopa::assert_has_no_args "$#"
    [[ -z "$name_fancy" ]] && name_fancy="$name"
    [[ -z "$script_name" ]] && script_name="$name"
    [[ -z "$version" ]] && version="$(koopa::variable "$name")"
    prefix="$(koopa::app_prefix)/${name}/${version}"
    make_prefix="$(koopa::make_prefix)"
    if [[ "$reinstall" -eq 1 ]]
    then
        koopa::sys_rm "$prefix"
        koopa::delete_broken_symlinks "$make_prefix"
    fi
    [[ -d "$prefix" ]] && return 0
    koopa::install_start "$name_fancy" "$version" "$prefix"
    tmp_dir="$(koopa::tmp_dir)"
    (
        # shellcheck disable=SC2034
        gnu_mirror="$(koopa::gnu_mirror)"
        # shellcheck disable=SC2034
        jobs="$(koopa::cpu_count)"
        koopa::cd "$tmp_dir"
        script="${script_prefix}/${script_name}.sh"
        koopa::assert_is_file "$script"
        # shellcheck source=/dev/null
        . "$script"
    ) 2>&1 | tee "$(koopa::tmp_log_file)"
    koopa::rm "$tmp_dir"
    koopa::sys_set_permissions -r "$prefix"
    if [[ "$link_app" -eq 1 ]]
    then
        link_args=(
            "--name=${name}"
            "--version=${version}"
        )
        if [[ -n "$include_dirs" ]]
        then
            link_args+=("--include-dirs=${include_dirs}")
        fi
        koopa::link_app "${link_args[@]}"
    fi
    koopa::install_success "$name_fancy" "$prefix"
    return 0
}

# FIXME REWORK, SYMLINKING FROM OPT (LIKE HOMEBREW) INSTEAD.

koopa::link_app() { # {{{1
    # """
    # Symlink cellar into build directory.
    # @note Updated 2020-11-18.
    #
    # If you run into permissions issues during link, check the build prefix
    # permissions. Ensure group is not 'root', and that group has write access.
    #
    # This can be reset easily with 'koopa::sys_set_permissions'.
    #
    # Note that Debian symlinks 'man' to 'share/man', which is non-standard.
    # This is currently corrected in 'install-debian-base', but top-level
    # symlink checks may need to be added here in a future update.
    #
    # @section cp flags:
    # * -f, --force
    # * -R, -r, --recursive
    # * -s, --symbolic-link
    #
    # @examples
    # koopa::link_cellar emacs 26.3
    # """
    local cellar_prefix cellar_subdirs cp_flags include_dirs make_prefix name \
        pos version
    if koopa::is_macos
    then
        koopa::note 'Cellar links are not supported on macOS.'
        return 0
    fi
    include_dirs=
    version=
    pos=()
    while (("$#"))
    do
        case "$1" in
            --include-dirs=*)
                include_dirs="${1#*=}"
                shift 1
                ;;
            --name=*)
                name="${1#*=}"
                shift 1
                ;;
            --version=*)
                version="${1#*=}"
                shift 1
                ;;
            --)
                shift 1
                break
                ;;
            --*|-*)
                koopa::invalid_arg "$1"
                ;;
            *)
                pos+=("$1")
                shift 1
                ;;
        esac
    done
    [[ "${#pos[@]}" -gt 0 ]] && set -- "${pos[@]}"
    [[ -n "${1:-}" ]] && name="$1"
    koopa::assert_has_no_envs
    make_prefix="$(koopa::make_prefix)"
    koopa::assert_is_dir "$make_prefix"
    cellar_prefix="$(koopa::cellar_prefix)"
    koopa::assert_is_dir "$cellar_prefix"
    cellar_prefix="${cellar_prefix}/${name}"
    koopa::assert_is_dir "$cellar_prefix"
    [[ -z "$version" ]] && version="$(koopa::find_app_version "$name")"
    cellar_prefix="${cellar_prefix}/${version}"
    koopa::assert_is_dir "$cellar_prefix"
    koopa::h2 "Linking '${cellar_prefix}' in '${make_prefix}'."
    koopa::sys_set_permissions -r "$cellar_prefix"
    koopa::delete_broken_symlinks "$cellar_prefix"
    koopa::delete_broken_symlinks "$make_prefix"
    cellar_subdirs=()
    if [[ -n "$include_dirs" ]]
    then
        IFS=',' read -r -a cellar_subdirs <<< "$include_dirs"
        cellar_subdirs=("${cellar_subdirs[@]/^/${cellar_prefix}}")
        for i in "${!cellar_subdirs[@]}"
        do
            cellar_subdirs[$i]="${cellar_prefix}/${cellar_subdirs[$i]}"
        done
    else
        readarray -t cellar_subdirs <<< "$( \
            find "$cellar_prefix" \
                -mindepth 1 \
                -maxdepth 1 \
                -type d \
                -print \
            | sort \
        )"
    fi
    # Copy as symbolic links.
    cp_flags=(
        '-s'
        '-t' "${make_prefix}"
    )
    koopa::is_shared_install && cp_flags+=('-S')
    koopa::cp "${cp_flags[@]}" "${cellar_subdirs[@]}"
    if koopa::is_linux && koopa::is_shared_install
    then
        koopa::update_ldconfig
    fi
    koopa::success "Successfully linked '${name}'."
    return 0
}

koopa::list_app_versions() { # {{{1
    # """
    # List installed application versions.
    # @note Updated 2020-11-23.
    # """
    local prefix
    koopa::assert_has_no_args "$#"
    prefix="$(koopa::cellar_prefix)"
    if [[ ! -d "$prefix" ]]
    then
        koopa::note 'No cellar programs are installed.'
        return 0
    fi
    # This approach doesn't work well when only a single cellar program
    # is installed.
    # > ls -1 -- "${prefix}/"*
    find "$prefix" -mindepth 2 -maxdepth 2 -type d | sort
    return 0
}

# FIXME NEED TO UPDATE THIS IN R KOOPA.
koopa::prune_apps() { # {{{1
    # """
    # Prune applications.
    # @note Updated 2020-11-22.
    # """
    if koopa::is_macos
    then
        koopa::note 'App pruning not yet supported on macOS.'
        return 0
    fi
    koopa::rscript 'prune-apps' "$@"
    return 0
}

# FIXME NEED TO UPDATE R FUNCTION in R-KOOPA.
koopa::unlink_app() { # {{{1
    # """
    # Unlink an application.
    # @note Updated 2020-11-22.
    # """
    if koopa::is_macos
    then
        koopa::note 'App links are not supported on macOS.'
        return 0
    fi
    koopa::rscript 'unlink-app' "$@"
    return 0
}