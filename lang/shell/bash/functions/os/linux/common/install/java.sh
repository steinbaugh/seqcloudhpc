#!/usr/bin/env bash

koopa::linux_install_openjdk() { # {{{1
    koopa::linux_install_app \
        --name='openjdk' \
        --name-fancy='OpenJDK' \
        --no-link \
        "$@"
}

koopa:::linux_install_openjdk() { # {{{1
    # """
    # Install OpenJDK.
    # @note Updated 2021-05-05.
    #
    # Don't early return if directory exists here.
    # We need to ensure alternatives code runs (see below).
    #
    # @seealso
    # - https://www.oracle.com/java/technologies/javase-downloads.html#JDK16
    #
    # Legacy java.net links (now down):
    # - https://jdk.java.net/archive/
    # - https://jdk.java.net/15/
    # - https://openjdk.java.net/
    # """
    local file name prefix version unique url
    prefix="${INSTALL_PREFIX:?}"
    version="${INSTALL_VERSION:?}"
    name='openjdk'
    case "$version" in
        16.0.1)
            unique='7147401fd7354114ac51ef3e1328291f/9'
            ;;
        16)
            unique='7863447f0ab643c585b9bdebf67c69db/36'
            ;;
        15.0.2)
            unique='0d1cfde4252546c6931946de8db48ee2/7'
            ;;
        15.0.1)
            unique='51f4f36ad4ef43e39d0dfdbaf6549e32/9'
            ;;
        15)
            unique='779bf45e88a44cbd9ea6621d33e33db1/36'
            ;;
        14.0.2)
            unique='205943a0976c4ed48cb16f1043c5c647/12'
            ;;
        14.0.1)
            unique='664493ef4a6946b186ff29eb326336a2/7'
            ;;
        14)
            unique='076bab302c7b4508975440c56f6cc26a/36'
            ;;
        13.0.2)
            unique='d4173c853231432d94f001e99d882ca7/8'
            ;;
        13.0.1)
            unique='cec27d702aa74d5a8630c65ae61e4305/9'
            ;;
        13)
            unique='5b8a42f3905b406298b72d750b6919f6/33'
            ;;
        *)
            koopa::stop "Unsupported version: '${version}'."
    esac
    # Platform suffixes:
    # - Linux/AArch64: 'linux-aarch64'
    # - Linux/x64: 'linux-x64'
    # - macOS/x64: 'osx-x64'
    file="${name}-${version}_linux-x64_bin.tar.gz"
    url="https://download.java.net/java/GA/jdk${version}/\
${unique}/GPL/${file}"
    koopa::download "$url"
    koopa::extract "$file"
    koopa::mv "jdk-${version}" "$prefix"
    # This step will skip for non-shared install.
    koopa::linux_java_update_alternatives "$prefix"
}
