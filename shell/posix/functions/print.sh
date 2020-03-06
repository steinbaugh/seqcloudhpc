#!/bin/sh
# shellcheck disable=SC2039

_koopa_ansi_escape() {  # {{{1
    local color
    color="${1:?}"
    local escape
    case "$color" in
        nocolor)
            escape='0'
            ;;
        default)
            escape='0;39'
            ;;
        default-bold)
            escape='1;39'
            ;;
        black)
            escape='0;30'
            ;;
        black-bold)
            escape='1;30'
            ;;
        blue)
            escape='0;34'
            ;;
        blue-bold)
            escape='1;34'
            ;;
        cyan)
            escape='0;36'
            ;;
        cyan-bold)
            escape='1;36'
            ;;
        green)
            escape='0;32'
            ;;
        green-bold)
            escape='1;32'
            ;;
        magenta)
            escape='0;35'
            ;;
        magenta-bold)
            escape='1;35'
            ;;
        red)
            escape='0;31'
            ;;
        red-bold)
            escape='1;31'
            ;;
        yellow)
            escape='0;33'
            ;;
        yellow-bold)
            escape='1;33'
            ;;
        white)
            escape='0;97'
            ;;
        white-bold)
            escape='1;97'
            ;;
        *)
            >&2 _koopa_print "Unsupported color: ${color}"
            escape='0'
            ;;
    esac
    printf '\033[%sm' "$escape"
    return 0
}

_koopa_coffee_time() {  # {{{1
    # """
    # Coffee time.
    # @note Updated 2020-02-06.
    # """
    _koopa_note "This script takes a while. Time for a coffee! ☕☕"
    return 0
}

_koopa_dl() {
    # """
    # Koopa definition list.
    # @note Updated 2020-03-05.
    # """
    local c1 c2 emoji key value
    key="${1:?}"
    value="${2:?}"
    emoji="$(_koopa_emoji)"
    c1="$(_koopa_ansi_escape 'default')"
    c2="$(_koopa_ansi_escape 'default')"
    nc="$(_koopa_ansi_escape 'nocolor')"
    _koopa_print "${emoji} ${c1}${key}:${nc} ${c2}${value}${nc}"
    return 0
}

_koopa_emoji() {  # {{{1
    # """
    # Koopa turtle emoji.
    # @note Updated 2020-03-05.
    # """
    _koopa_print "🐢"
    return 0
}

_koopa_h() {  # {{{1
    # """
    # Koopa header.
    # @note Updated 2020-03-05.
    # """
    local c1 c2 emoji level nc pre str
    level="${1:?}"
    str="${2:?}"
    case "$level" in
        1)
            pre="=>"
            ;;
        2)
            pre="==>"
            ;;
        3)
            pre="===>"
            ;;
        4)
            pre="====>"
            ;;
        5)
            pre="=====>"
            ;;
        6)
            pre="======>"
            ;;
        7)
            pre="=======>"
            ;;
        *)
            _koopa_invalid_arg "$1"
            ;;
    esac
    emoji="$(_koopa_emoji)"
    c1="$(_koopa_ansi_escape "magenta")"
    c2="$(_koopa_ansi_escape "default")"
    nc="$(_koopa_ansi_escape "nocolor")"
    _koopa_print "\n${emoji} ${c1}${pre}${nc} ${c2}${str}${nc}"
    return 0
}

_koopa_h1() {  # {{{1
    _koopa_h 1 "$@"
    return 0
}

_koopa_h2() {  # {{{1
    _koopa_h 2 "$@"
    return 0
}

_koopa_h3() {  # {{{1
    _koopa_h 3 "$@"
    return 0
}

_koopa_h4() {  # {{{1
    _koopa_h 4 "$@"
    return 0
}

_koopa_h5() {  # {{{1
    _koopa_h 5 "$@"
    return 0
}

_koopa_h6() {  # {{{1
    _koopa_h 6 "$@"
    return 0
}

_koopa_h7() {  # {{{1
    _koopa_h 7 "$@"
    return 0
}

_koopa_info() {  # {{{1
    # """
    # General info.
    # @note Updated 2020-03-05.
    # """
    local c1 c2 nc emoji pre str
    str="${1:?}"
    emoji="$(_koopa_emoji)"
    pre="--"
    c1="$(_koopa_ansi_escape_code "default")"
    c2="$(_koopa_ansi_escape_code "default")"
    nc="$(_koopa_ansi_escape_code "nocolor")"
    _koopa_print "${emoji} ${c1}${pre}${nc} ${c2}${str}${nc}"
    return 0
}

_koopa_install_start() {  # {{{1
    # """
    # Inform the user about start of installation.
    # @note Updated 2020-02-20.
    # """
    local name
    name="${1:?}"
    local prefix
    prefix="${2:-}"
    local msg
    if [ -n "$prefix" ]
    then
        msg="Installing ${name} at '${prefix}'."
    else
        msg="Installing ${name}."
    fi
    _koopa_h1 "$msg"
    return 0
}

_koopa_install_success() {  # {{{1
    # """
    # Installation success message.
    # @note Updated 2020-02-20.
    # """
    local arg
    arg="${1:?}"
    _koopa_success "Installation of ${arg} was successful."
    return 0
}

_koopa_invalid_arg() {  # {{{1
    # """
    # Error on invalid argument.
    # @note Updated 2019-10-23.
    # """
    local arg
    arg="${1:?}"
    _koopa_stop "Invalid argument: '${arg}'."
    return 1
}

_koopa_missing_arg() {  # {{{1
    # """
    # Error on a missing argument.
    # @note Updated 2019-10-23.
    # """
    _koopa_stop "Missing required argument."
    return 1
}

_koopa_note() {  # {{{1
    # """
    # General note.
    # @note Updated 2020-03-05.
    # """
    local c1 c2 emoji nc pre str
    str="${1:?}"
    emoji="$(_koopa_emoji)"
    pre="**"
    c1="$(_koopa_ansi_escape_code "yellow")"
    c2="$(_koopa_ansi_escape_code "default")"
    nc="$(_koopa_ansi_escape_code "nocolor")"
    _koopa_print "${emoji} ${c1}${pre}${nc} ${c2}${str}${nc}"
    return 0
}

_koopa_print() {  # {{{1
    # """
    # Print a string.
    # @note Updated 2020-03-05.
    #
    # printf vs. echo
    # - http://www.etalabs.net/sh_tricks.html
    # - https://unix.stackexchange.com/questions/65803
    # - https://www.freecodecamp.org/news/
    #       how-print-newlines-command-line-output/
    # """
    printf '%b\n' "${1:-}"
    return 0
}

_koopa_print_ansi() {  # {{{1
    # """
    # Print a colored line in console.
    # @note Updated 2020-03-05.
    #
    # Currently using ANSI escape codes.
    # This is the classic 8 color terminal approach.
    #
    # - '0;': normal
    # - '1;': bright or bold
    #
    # (taken from Travis CI config)
    # - clear=\033[0K
    # - nocolor=\033[0m
    #
    # Alternative approach (non-POSIX):
    # echo command requires '-e' flag to allow backslash escapes.
    #
    # See also:
    # - https://en.wikipedia.org/wiki/ANSI_escape_code
    # - https://misc.flogisoft.com/bash/tip_colors_and_formatting
    # - https://stackoverflow.com/questions/5947742
    # - https://stackoverflow.com/questions/15736223
    # - https://bixense.com/clicolors/
    # """
    local color
    color="$(_koopa_ansi_escape "${1:?}")"
    local nocolor
    nocolor="$(_koopa_ansi_escape 'nocolor')"
    local string
    string="${2:?}"
    printf '%s%b%s\n' "$color" "$string" "$nocolor"
    return 0
}

_koopa_print_ansi_default() {  # {{{1
    _koopa_print_ansi 'default' "${1:?}"
    return 0
}

_koopa_print_ansi_default_bold() {  # {{{1
    _koopa_print_ansi 'default-bold' "${1:?}"
    return 0
}

_koopa_print_ansi_black() {  # {{{1
    _koopa_print_ansi 'black' "${1:?}"
    return 0
}

_koopa_print_ansi_black_bold() {  # {{{1
    _koopa_print_ansi 'black-bold' "${1:?}"
    return 0
}

_koopa_print_ansi_blue() {  # {{{1
    _koopa_print_ansi 'blue' "${1:?}"
    return 0
}

_koopa_print_ansi_blue_bold() {  # {{{1
    _koopa_print_ansi 'blue-bold' "${1:?}"
    return 0
}

_koopa_print_ansi_cyan() {  # {{{1
    _koopa_print_ansi 'cyan' "${1:?}"
    return 0
}

_koopa_print_ansi_cyan_bold() {  # {{{1
    _koopa_print_ansi 'cyan-bold' "${1:?}"
    return 0
}

_koopa_print_ansi_green() {  # {{{1
    _koopa_print_ansi 'green' "${1:?}"
    return 0
}

_koopa_print_ansi_green_bold() {  # {{{1
    _koopa_print_ansi 'green-bold' "${1:?}"
    return 0
}

_koopa_print_ansi_magenta() {  # {{{1
    _koopa_print_ansi 'magenta' "${1:?}"
    return 0
}

_koopa_print_magenta_bold() {  # {{{1
    _koopa_print_ansi 'magenta-bold' "${1:?}"
    return 0
}

_koopa_print_ansi_red() {  # {{{1
    _koopa_print_ansi 'red' "${1:?}"
    return 0
}

_koopa_print_ansi_red_bold() {  # {{{1
    _koopa_print_ansi 'red-bold' "${1:?}"
    return 0
}

_koopa_print_ansi_yellow() {  # {{{1
    _koopa_print_ansi 'yellow' "${1:?}"
    return 0
}

_koopa_print_ansi_yellow_bold() {  # {{{1
    _koopa_print_ansi 'yellow-bold' "${1:?}"
    return 0
}

_koopa_print_ansi_white() {  # {{{1
    _koopa_print_ansi 'white' "${1:?}"
    return 0
}

_koopa_print_ansi_white_bold() {  # {{{1
    _koopa_print_ansi 'white-bold' "${1:?}"
    return 0
}

_koopa_restart() {  # {{{1
    # """
    # Inform the user that they should restart shell.
    # @note Updated 2020-02-20.
    # """
    _koopa_note "Restart the shell."
    return 0
}

_koopa_status_fail() {  # {{{1
    # """
    # Status FAIL.
    # @note Updated 2020-03-05.
    # """
    local c1 nc pre str
    pre="      FAIL"
    str="${1:?}"
    c1="$(_koopa_ansi_escape_code "red")"
    nc="$(_koopa_ansi_escape_code "nocolor")"
    >&2 _koopa_print "${c1}${pre}${nc} | ${str}"
    return 0
}

_koopa_status_note() {  # {{{1
    # """
    # Status NOTE.
    # @note Updated 2020-03-05.
    # """
    local c1 nc pre str
    pre="      NOTE"
    str="${1:?}"
    c1="$(_koopa_ansi_escape_code "magenta")"
    nc="$(_koopa_ansi_escape_code "nocolor")"
    >&2 _koopa_print "${c1}${pre}${nc} | ${str}"
    return 0
}

_koopa_status_ok() {  # {{{1
    # """
    # Status OK.
    # @note Updated 2020-03-05.
    # """
    local c1 nc pre str
    pre="        OK"
    str="${1:?}"
    c1="$(_koopa_ansi_escape_code "green")"
    nc="$(_koopa_ansi_escape_code "nocolor")"
    _koopa_print "${c1}${pre}${nc} | ${str}"
    return 0
}

_koopa_stop() {  # {{{1
    # """
    # Stop with an error message, and exit.
    # @note Updated 2020-03-05.
    # """
    local c1 c2 emoji nc pre str
    str="ERROR: ${1:?}"
    emoji="$(_koopa_emoji)"
    pre="!!"
    c1="$(_koopa_ansi_escape_code "red-bold")"
    c2="$(_koopa_ansi_escape_code "red")"
    nc="$(_koopa_ansi_escape_code "nocolor")"
    >&2 _koopa_print "${emoji} ${c1}${pre}${nc} ${c2}${str}${nc}"
    exit 1
}

_koopa_success() {  # {{{1
    # """
    # Success message.
    # @note Updated 2020-03-05.
    # """
    local c1 c2 emoji nc pre str
    str="${1:?}"
    emoji="$(_koopa_emoji)"
    pre="OK"
    c1="$(_koopa_ansi_escape_code "green-bold")"
    c2="$(_koopa_ansi_escape_code "green")"
    nc="$(_koopa_ansi_escape_code "nocolor")"
    _koopa_print "${emoji} ${c1}${pre}${nc} ${c2}${str}${nc}"
    return 0
}

_koopa_uninstall_start() {  # {{{1
    # """
    # Inform the user about start of uninstall.
    # @note Updated 2020-02-20.
    # """
    local name
    name="${1:?}"
    local prefix
    prefix="${2:-}"
    local msg
    if [ -n "$prefix" ]
    then
        msg="Uninstalling ${name} at '${prefix}'."
    else
        msg="Uninstalling ${name}."
    fi
    _koopa_h1 "$msg"
    return 0
}

_koopa_uninstall_success() {  # {{{1
    # """
    # Uninstall success message.
    # @note Updated 2020-02-20.
    # """
    local arg
    arg="${1:?}"
    _koopa_success "Uninstallation of ${arg} was successful."
    return 0
}

_koopa_update_start() {  # {{{1
    # """
    # Inform the user about start of update.
    # @note Updated 2020-02-20.
    # """
    local name
    name="${1:?}"
    local prefix
    prefix="${2:-}"
    local msg
    if [ -n "$prefix" ]
    then
        msg="Updating ${name} at '${prefix}'."
    else
        msg="Updating ${name}."
    fi
    _koopa_h1 "$msg"
    return 0
}

_koopa_update_success() {  # {{{1
    # """
    # Update success message.
    # @note Updated 2020-02-20.
    # """
    local arg
    arg="${1:?}"
    _koopa_success "Update of ${arg} was successful."
    return 0
}

_koopa_warning() {  # {{{1
    # """
    # Warning message.
    # @note Updated 2020-03-05.
    # """
    local c1 c2 emoji nc pre str
    str="WARNING: ${1:?}"
    emoji="$(_koopa_emoji)"
    pre="!!"
    c1="$(_koopa_ansi_escape_code "yellow-bold")"
    c2="$(_koopa_ansi_escape_code "yellow")"
    nc="$(_koopa_ansi_escape_code "nocolor")"
    >&2 _koopa_print "${emoji} ${c1}${pre}${nc} ${c2}${str}${nc}"
    return 0
}
