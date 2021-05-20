#!/usr/bin/env bash

koopa::sra_prefetch_parallel() { # {{{1
    # """
    # Prefetch files from SRA in parallel.
    # @note Updated 2021-05-20.
    # """
    koopa::assert_is_gnu 'find' 'parallel'
    koopa::assert_is_installed 'ascp' 'prefetch'
    file="${1:-}"
    [ -z "$file" ] && file='SraAccList.txt'
    koopa::assert_is_file "$file"
    jobs="$(koopa::cpu_count)"
    # Delete any temporary files that may have been created by previous run.
    find . \(-name '*.lock' -o -name '*.tmp'\) -delete
    sort -u "$file" \
        | parallel -j "$jobs" \
            'prefetch --verbose {}'
    return 0
}
