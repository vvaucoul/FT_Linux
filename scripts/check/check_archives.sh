# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    check_archives.sh                                  :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/14 11:56:00 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/14 11:59:01 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

function is_valid {
    printf "Check $1 ... "
    ls $1 > /dev/null 2>&1
    res=$?
    TOTAL=$((TOTAL + 1))
    if [ $res != 0 ]; then
        printf "\e[1;31mNot found !\e[0m\n"
    else
        printf "\e[1;32mFound !\e[0m\n"
        SUCCESS=$((SUCCESS + 1))
    fi
}

function end {
    RESULT=$((100 * SUCCESS / TOTAL))
    printf "======================\nResults: $SUCCESS/$TOTAL\n"
    printf "\e[1;38mValid: $RESULT%% \e[0m\n"
}

export TOTAL=0
export SUCCESS=0

cd /mnt/lfs/sources

is_valid "acl-2.3.1.tar.xz"
is_valid "lfs-bootscripts-20210608.tar.xz"
is_valid "attr-2.5.1.tar.gz"
is_valid "libcap-2.63.tar.xz"
is_valid "autoconf-2.71.tar.xz"
is_valid "libffi-3.4.2.tar.gz"
is_valid "automake-1.16.5.tar.xz"
is_valid "libpipeline-1.5.5.tar.gz"
is_valid "bash-5.1.16.tar.gz"
is_valid "libtool-2.4.6.tar.xz"
is_valid "bc-5.2.2.tar.xz"
is_valid "linux-5.16.9.tar.xz"
is_valid "binutils-2.38-lto_fix-1.patch"
is_valid "m4-1.4.19.tar.xz"
is_valid "binutils-2.38.tar.xz"
is_valid "make-4.3.tar.gz"
is_valid "bison-3.8.2.tar.xz"
is_valid "man-db-2.10.1.tar.xz"
is_valid "bzip2-1.0.8-install_docs-1.patch"
is_valid "man-pages-5.13.tar.xz"
is_valid "bzip2-1.0.8.tar.gz"
is_valid "MarkupSafe-2.0.1.tar.gz"
is_valid "check-0.15.2.tar.gz"
is_valid "md5sums"
is_valid "coreutils-9.0-chmod_fix-1.patch"
is_valid "meson-0.61.1.tar.gz"
is_valid "coreutils-9.0-i18n-1.patch"
is_valid "mpc-1.2.1.tar.gz"
is_valid "coreutils-9.0.tar.xz"
is_valid "mpfr-4.1.0.tar.xz"
is_valid "dbus-1.12.20.tar.gz"
is_valid "ncurses-6.3.tar.gz"
is_valid "dejagnu-1.6.3.tar.gz"
is_valid "ninja-1.10.2.tar.gz"
is_valid "diffutils-3.8.tar.xz"
is_valid "openssl-3.0.1.tar.gz"
is_valid "e2fsprogs-1.46.5.tar.gz"
is_valid "patch-2.7.6.tar.xz"
is_valid "elfutils-0.186.tar.bz2"
is_valid "perl-5.34.0.tar.xz"
is_valid "eudev-3.2.11.tar.gz"
is_valid "perl-5.34.0-upstream_fixes-1.patch"
is_valid "expat-2.4.6.tar.xz"
is_valid "pkg-config-0.29.2.tar.gz"
is_valid "expect5.45.4.tar.gz"
is_valid "procps-ng-3.3.17.tar.xz"
is_valid "file-5.41.tar.gz"
is_valid "psmisc-23.4.tar.xz"
is_valid "findutils-4.9.0.tar.xz"
is_valid "python-3.10.2-docs-html.tar.bz2"
is_valid "flex-2.6.4.tar.gz"
is_valid "Python-3.10.2.tar.xz"
is_valid "gawk-5.1.1.tar.xz"
is_valid "readline-8.1.2.tar.gz"
is_valid "gcc-11.2.0.tar.xz"
is_valid "sed-4.8.tar.xz"
is_valid "gdbm-1.23.tar.gz"
is_valid "shadow-4.11.1.tar.xz"
is_valid "gettext-0.21.tar.xz"
is_valid "sysklogd-1.5.1.tar.gz"
is_valid "glibc-2.35-fhs-1.patch"
is_valid "systemd-250.tar.gz"
is_valid "glibc-2.35.tar.xz"
is_valid "systemd-250-upstream_fixes-1.patch"
is_valid "gmp-6.2.1.tar.xz"
is_valid "systemd-man-pages-250.tar.xz"
is_valid "gperf-3.1.tar.gz"
is_valid "sysvinit-3.01-consolidated-1.patch"
is_valid "grep-3.7.tar.xz"
is_valid "sysvinit-3.01.tar.xz"
is_valid "groff-1.22.4.tar.gz"
is_valid "tar-1.34.tar.xz"
is_valid "grub-2.06.tar.xz"
is_valid "tcl8.6.12-html.tar.gz"
is_valid "gzip-1.11.tar.xz"
is_valid "tcl8.6.12-src.tar.gz"
is_valid "iana-etc-20220207.tar.gz"
is_valid "texinfo-6.8.tar.xz"
is_valid "inetutils-2.2.tar.xz"
is_valid "tzdata2021e.tar.gz"
is_valid "intltool-0.51.0.tar.gz"
is_valid "udev-lfs-20171102.tar.xz"
is_valid "iproute2-5.16.0.tar.xz"
is_valid "util-linux-2.37.4.tar.xz"
is_valid "Jinja2-3.0.3.tar.gz"
is_valid "vim-8.2.4383.tar.gz"
is_valid "kbd-2.4.0-backspace-1.patch"
is_valid "XML-Parser-2.46.tar.gz"
is_valid "kbd-2.4.0.tar.xz"
is_valid "xz-5.2.5.tar.xz"
is_valid "kmod-29.tar.xz"
is_valid "zlib-1.2.12.tar.xz"
is_valid "less-590.tar.gz"
is_valid "zstd-1.5.2.tar.gz"

end ;
unset TOTAL
unset SUCESS