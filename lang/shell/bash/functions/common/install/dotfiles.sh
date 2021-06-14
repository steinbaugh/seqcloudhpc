#!/usr/bin/env bash

# [2021-05-27] Linux success.
# [2021-05-27] macOS success.

koopa::install_dotfiles() { # {{{1
    koopa::install_app \
        --name='dotfiles' \
        --version='rolling' \
        "$@"
}

koopa:::install_dotfiles() { # {{{1
    # """
    # Install dotfiles.
    # @note Updated 2021-06-14.
    # """
    local prefix script
    name='dotfiles'
    name_fancy='dotfiles'




    if [[ ! -d "$prefix" ]]
    then
        # FIXME Rework this, doesn't need to be a separate function...
        koopa::git_clone_dotfiles
    fi
    koopa::link_into_opt "$prefix" "$name"


    # FIXME Ensure this gets called every time per user...
    koopa::add_koopa_config_link "$prefix" "$name"
    script="${prefix}/install"
    koopa::assert_is_file "$script"
    "$script"
    koopa::install_success "$name_fancy" "$prefix"


    return 0
}

koopa::uninstall_dotfiles() { # {{{1
    # """
    # Uninstall dot files.
    # @note Updated 2020-07-05.
    # """
    local name name_fancy prefix script
    koopa::assert_has_no_args "$#"
    name='dotfiles'
    name_fancy='dotfiles'
    prefix="$(koopa::dotfiles_prefix)"
    if [[ ! -d "$prefix" ]]
    then
        koopa::alert_is_not_installed "$name_fancy" "$prefix"
        return 0
    fi
    script="${prefix}/uninstall"
    koopa::assert_is_file "$script"
    "$script"
    koopa::uninstall_app \
        --name-fancy="$name_fancy" \
        --name="$name" \
        "$@"
    return 0
}

koopa::update_dotfiles() { # {{{1
    # """
    # Update dotfiles repo and run install script, if defined.
    # @note Updated 2021-05-05.
    # """
    local config_prefix repo repos script
    if [[ "$#" -eq 0 ]]
    then
        config_prefix="$(koopa::config_prefix)"
        repos=(
            "${config_prefix}/dotfiles"
            "${config_prefix}/dotfiles-private"
        )
    else
        repos=("$@")
    fi
    for repo in "${repos[@]}"
    do
        [[ -d "$repo" ]] || continue
        (
            koopa::update_start "$repo"
            koopa::cd "$repo"
            # Run the updater script, if defined.
            script="${repo}/update"
            if [[ -x "$script" ]]
            then
                "$script"
            else
                koopa::git_reset
                koopa::git_pull
            fi
            # Run the install script, if defined.
            script="${repo}/install"
            [[ -x "$script" ]] && "$script"
            koopa::update_success "$repo"
        )
    done
    return 0
}
