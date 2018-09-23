#!/usr/bin/env bash

# koopa info box.
# 2018-09-23

# Can disable local message with `-n "$SSH_CLIENT"`.

# Padded strings in bash:
# https://stackoverflow.com/questions/4409399

# Check if program exists:
# https://stackoverflow.com/questions/592620

# Don't redisplay for HPC interactive session.
if [[ -n "$KOOPA_INTERACTIVE_JOB" ]]; then
    exit 0
fi

array=()
array+=("koopa v${KOOPA_VERSION} (${KOOPA_DATE})")
array+=("https://github.com/steinbaugh/koopa")

# Alternatively, can use `$( uname -mnrs )`.
array+=("System: $KOOPA_SYSTEM")

if [[ -n "$HPC_SCHEDULER" ]]; then
    array+=("Scheduler: ${HPC_SCHEDULER}")
fi

aspera="$( command -v asperaconnect 2>/dev/null )"
if [[ -f "$aspera" ]]; then
    array+=("Aspera: ${aspera}")
fi
unset -v aspera

bcbio="$( command -v bcbio_nextgen.py 2>/dev/null )"
if [[ -f "$bcbio" ]]; then
    array+=("bcbio: ${bcbio}")
fi
unset -v bcbio

conda="$( command -v conda 2>/dev/null )"
if [[ -f "${conda}" ]]; then
    array+=("Conda: ${conda}")
fi
unset -v conda

r="$( command -v R 2>/dev/null )"
if [[ -f "$r" ]]; then
    array+=("R: ${r}")
fi
unset -v r

python="$( command -v python 2>/dev/null )"
if [[ -f "${python}" ]]; then
    array+=("Python: ${python}")
fi
unset -v python

perl="$( command -v perl 2>/dev/null )"
if [[ -f "$perl" ]]; then
    array+=("Perl: ${perl}")
fi
unset -v perl

ruby="$( command -v ruby 2>/dev/null )"
if [[ -f "$ruby" ]]; then
    array+=("Ruby: ${ruby}")
fi
unset -v ruby

git="$( command -v git 2>/dev/null )"
if [[ -f "$git" ]]; then
    array+=("Git: ${git}")
fi
unset -v git

openssl="$( command -v openssl 2>/dev/null )"
if [[ -f "$openssl" ]]; then
    array+=("OpenSSL: ${openssl}")
fi
unset -v openssl

gpg="$( command -v gpg 2>/dev/null )"
if [[ -f "$gpg" ]]; then
    array+=("GPG: ${gpg}")
fi
unset -v gpg

# Using unicode box drawings here.
# Note that we're truncating lines inside the box to 68 characters.
barpad="$( printf "━%.0s" {1..70} )"
printf "\n  %s%s%s  \n"  "┏" "$barpad" "┓"
for i in "${array[@]}"; do
    printf "  ┃ %-68s ┃  \n"  "${i::68}"
done
printf "  %s%s%s  \n\n"  "┗" "$barpad" "┛"

unset -v array barpad
