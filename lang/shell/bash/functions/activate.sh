#!/usr/bin/env bash

_koopa_activate_bash_aliases() { # {{{1
    # """
    # Alias definitions.
    # @note Updated 2021-06-04.
    # See /usr/share/doc/bash-doc/examples in the bash-doc package.
    # """
    local user_aliases
    [[ "$#" -eq 0 ]] || return 1
    user_aliases="${HOME}/.bash_aliases"
    if [[ -f "$user_aliases" ]]
    then
        # shellcheck source=/dev/null
        source "$user_aliases"
    fi
    return 0
}

_koopa_activate_bash_completion() { # {{{1
    # """
    # Activate Bash completion.
    # @note Updated 2020-11-24.
    # Add tab completion for many commands.
    # """
    local brew_prefix nounset script
    [[ "$#" -eq 0 ]] || return 1
    if _koopa_is_installed 'brew'
    then
        brew_prefix="$(_koopa_homebrew_prefix)"
        # Ensure existing Homebrew v1 completions continue to work.
        export BASH_COMPLETION_COMPAT_DIR="${brew_prefix}/etc/bash_completion.d"
        # shellcheck source=/dev/null
        script="${brew_prefix}/etc/profile.d/bash_completion.sh"
    else
        script='/etc/bash_completion'
    fi
    [[ -r "$script" ]] || return 0
    nounset="$(_koopa_boolean_nounset)"
    if [[ "$nounset" -eq 1 ]]
    then
        set +e
        set +u
    fi
    # shellcheck source=/dev/null
    source "$script"
    if [[ "$nounset" -eq 1 ]]
    then
        set -e
        set -u
    fi
    return 0
}

_koopa_activate_bash_extras() { # {{{1
    # """
    # Activate Bash extras.
    # @note Updated 2021-06-16.
    # """
    [[ "$#" -eq 0 ]] || return 1
    _koopa_is_interactive || return 0
    _koopa_activate_bash_completion
    _koopa_activate_bash_readline
    _koopa_activate_bash_aliases
    _koopa_activate_bash_prompt
    _koopa_activate_bash_reverse_search
    _koopa_activate_completion
    return 0
}

_koopa_activate_bash_prompt() { # {{{1
    # """
    # Activate Bash prompt.
    # @note Updated 2020-11-24.
    # """
    [[ "$#" -eq 0 ]] || return 1
    if _koopa_is_installed 'starship'
    then
        _koopa_activate_starship
        return 0
    fi
    PS1="$(_koopa_prompt)"
    export PS1
    return 0
}

_koopa_activate_bash_readline() { # {{{1
    # """
    # Readline input options.
    # @note Updated 2020-11-24.
    # """
    local input_rc
    [[ "$#" -eq 0 ]] || return 1
    [[ -n "${INPUTRC:-}" ]] && return 0
    input_rc="${HOME}/.inputrc"
    [[ -r "$input_rc" ]] || return 0
    export INPUTRC="${HOME}/.inputrc"
    return 0
}

_koopa_activate_bash_reverse_search() { # {{{1
    # """
    # Activate reverse search for Bash.
    # @note Updated 2021-06-16.
    # """
    if _koopa_is_installed 'mcfly'
    then
        _koopa_activate_mcfly
    fi
    return 0
}
