#!/usr/bin/env bash

koopa::link_dotfile() {
    local config dot_dir dot_repo force pos private source_name symlink_name
    koopa::assert_has_args "$#"
    config=0
    force=0
    private=0
    pos=()
    while (("$#"))
    do
        case "$1" in
            --config)
                config=1
                shift 1
                ;;
            --force)
                force=1
                shift 1
                ;;
            --private)
                private=1
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
    koopa::assert_has_args_le "$#" 2
    source_name="$1"
    symlink_name="${2:-}"
    if [[ "$private" -eq 1 ]]
    then
        dot_dir="$(koopa::dotfiles_private_config_link)"
    else
        # FIXME Can I remove and simplify this step?
        # e.g. ~/.config/koopa/dotfiles
        dot_dir="$(koopa::dotfiles_config_link)"
        # Note that this step automatically links into koopa config for users.
        if [[ ! -d "$dot_dir" ]]
        then
            dot_repo="$(koopa::dotfiles_prefix)"
            koopa::rm "$dot_dir"
            koopa::ln "$dot_repo" "$dot_dir"
        fi
    fi
    koopa::assert_is_dir "$dot_dir"
    source_path="${dot_dir}/${source_name}"
    koopa::assert_is_existing "$source_path"
    # Define optional target symlink name.
    if [[ -z "$symlink_name" ]]
    then
        symlink_name="$(basename "$source_path")"
    fi
    # Add link either in HOME (default) or XDG_CONFIG_HOME.
    if [[ "$config" -eq 1 ]]
    then
        # FIXME REQUIRE THIS. ERROR IF NOT SET.
        if [[ -z "${XDG_CONFIG_HOME:-}" ]]
        then
            XDG_CONFIG_HOME="${HOME}/.config"
        fi
        symlink_path="${XDG_CONFIG_HOME}/${symlink_name}"
    else
        symlink_path="${HOME}/.${symlink_name}"
    fi
    # Inform the user when nuking a broken symlink.
    if [[ "$force" -eq 1 ]] ||
        { [[ -L "$symlink_path" ]] && [[ ! -e "$symlink_path" ]]; }
    then
        rm -frv "$symlink_path"
    elif [[ -e "$symlink_path" ]]
    then
        koopa::stop "Existing dotfile: '${symlink_path}'."
        exit 1
    fi
    koopa::info "Symlinking '$(basename "$symlink_path")'."
    # Note that 'ln -fnsv' fails to create subdirectories automatically.
    symlink_dn="$(dirname "$symlink_path")"
    if [[ "$symlink_dn" != "$HOME" ]]
    then
        mkdir -pv "$symlink_dn"
    fi
    ln -fnsv "$source_path" "$symlink_path"
    return 0
}
