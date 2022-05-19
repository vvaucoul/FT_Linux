/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   compile-calculator.c                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/05/19 14:36:09 by vvaucoul          #+#    #+#             */
/*   Updated: 2022/05/19 15:51:11 by vvaucoul         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>

#define COLOR_RED "\x1b[31m"
#define COLOR_GREEN "\x1b[32m"
#define COLOR_YELLOW "\x1b[33m"
#define COLOR_BLUE "\x1b[34m"
#define COLOR_MAGENTA "\x1b[35m"
#define COLOR_CYAN "\x1b[36m"
#define COLOR_RESET "\x1b[0m"

#define BOLD "\x1b[1m"
#define UNDERLINE "\x1b[4m"
#define REVERSE "\x1b[7m"

#define BLINK "\x1b[5m"

typedef struct s_package_time
{
    char *name;
    float sbu;
    size_t size;
    size_t pass;
} t_ptime;

size_t n_packages = 0;
size_t ttsize = 0;
float tttime = 0.0f;

#define PT t_ptime

static int display_help(void)
{
    printf("Usage: ./compil-calculator [TIME-REFERENCE]\n");
    printf("\tTIME-REFERENCE: the time to compile the package 'binutils' pass1 (float in minutes)\n\n");
    printf("\t-h: display this help\n");
    printf("\t-v: display version\n");
    return (0);
}

static int is_digit(char *str)
{
    int i;

    i = 0;
    while (str[i])
    {
        if ((str[i] < '0' || str[i] > '9') && str[i] != '.')
            return (0);
        i++;
    }
    return (1);
}

static PT set_sbu(char *name, float sbu, size_t size, size_t pass)
{
    PT ptime;

    ptime.name = name;
    ptime.sbu = sbu;
    ptime.size = size;
    ptime.pass = pass;
    return (ptime);
}
static void insert_sbu(PT *p, char *name, float sbu, size_t size, size_t pass)
{
    size_t i = 0;

    while (p[i].name)
        ++i;
    p[i] = set_sbu(name, sbu, size, pass);
    p[i + 1] = (PT){NULL, 0, 0, 0};
}
static int init_sbu(PT *p)
{
    /*******************************************************************************
     *                                  PASS - 1                                   *
     ******************************************************************************/

    insert_sbu(p, "binutils-2.38", 1, 620, 1);
    insert_sbu(p, "GCC-11.2.0", 11, 3300, 1);
    insert_sbu(p, "Linux-5.16.9 API Headers", 0.1, 1200, 1);
    insert_sbu(p, "Glibc-2.35", 4.3, 818, 1);
    insert_sbu(p, "Libstdc++", 0.4, 818, 1);

    /*******************************************************************************
     *                                  PASS - 2                                   *
     ******************************************************************************/

    insert_sbu(p, "M4-1.4.19", 0.2, 31, 2);
    insert_sbu(p, "Ncurses-6.3", 0.7, 50, 2);
    insert_sbu(p, "Bash-5.1.16", 0.4, 64, 2);
    insert_sbu(p, "Coreutils-9.0", 0.6, 158, 2);
    insert_sbu(p, "Diffutils-3.8", 0.2, 27, 2);
    insert_sbu(p, "File-5.41", 0.1, 32, 2);
    insert_sbu(p, "Findutils-4.9.0", 0.2, 42, 2);
    insert_sbu(p, "Gawk-5.1.1", 0.2, 45, 2);
    insert_sbu(p, "Grep-3.7", 0.2, 26, 2);
    insert_sbu(p, "Gzip-1.11", 0.1, 11, 2);
    insert_sbu(p, "Make-4.3", 0.1, 15, 2);
    insert_sbu(p, "Patch-2.7.6", 0.1, 12, 2);
    insert_sbu(p, "Sed-4.8", 0.1, 20, 2);
    insert_sbu(p, "Tar-1.34", 0.2, 38, 2);
    insert_sbu(p, "Xz-5.2.5", 0.1, 15, 2);

    /*******************************************************************************
     *                                  PASS - 3                                   *
     ******************************************************************************/

    insert_sbu(p, "Binutils-2.38", 1.3, 520, 3);
    insert_sbu(p, "GCC-11.2.0", 11, 3300, 3);

    /*******************************************************************************
     *                                  PASS - 4                                   *
     ******************************************************************************/

    insert_sbu(p, "Gettext-0.21", 1.6, 280, 4);
    insert_sbu(p, "Bison-3.8.2", 0.3, 50, 4);
    insert_sbu(p, "Perl-5.34.0", 1.6, 272, 4);
    insert_sbu(p, "Python-3.10.2", 1.2, 359, 4);
    insert_sbu(p, "Texinfo-6.8", 0.2, 109, 4);
    insert_sbu(p, "Util-linux-2.37.4", 0.7, 129, 4);

    /*******************************************************************************
     *                                  PASS - 5                                   *
     ******************************************************************************/

    insert_sbu(p, "Man-pages-5.13", 0.1, 33, 5);
    insert_sbu(p, "Iana-Etc-20220207", 0.1, 47, 5);
    insert_sbu(p, "Glibc-2.35", 24, 2800, 5);
    insert_sbu(p, "Zlib-1.2.11", 0.1, 5, 5);
    insert_sbu(p, "Bzip2-1.0.8", 0.1, 7, 5);
    insert_sbu(p, "Xz-5.2.5", 0.2, 15, 5);
    insert_sbu(p, "Zstd-1.5.2", 1.1, 55, 5);
    insert_sbu(p, "File-5.41", 0.1, 15, 5);
    insert_sbu(p, "Readline-8.1.2", 0.1, 15, 5);
    insert_sbu(p, "M4-1.4.19", 0.7, 49, 5);
    insert_sbu(p, "Bc-5.2.2", 0.1, 7, 5);
    insert_sbu(p, "Flex-2.6.4", 0.4, 32, 5);
    insert_sbu(p, "Tcl-8.6.12", 3.4, 87, 5);
    insert_sbu(p, "Expect-5.45.4", 0.2, 4, 5);
    insert_sbu(p, "DejaGNU-1.6.3", 0.1, 7, 5);
    insert_sbu(p, "Binutils-2.38", 6.1, 4600, 5);
    insert_sbu(p, "GMP-6.2.1", 1.0, 52, 5);
    insert_sbu(p, "MPFR-4.1.0", 0.8, 38, 5);
    insert_sbu(p, "MPC-1.2.1", 0.3, 21, 5);
    insert_sbu(p, "Attr-2.5.1", 0.1, 4, 5);
    insert_sbu(p, "Acl-2.3.1", 0.1, 6, 5);
    insert_sbu(p, "Libcap-2.63", 0.1, 3, 5);
    insert_sbu(p, "Shadow-4.11.1", 0.2, 49, 5);
    insert_sbu(p, "GCC-11.2.0", 153, 4300, 5);
    insert_sbu(p, "Pkg-config-0.29.2", 0.3, 29, 5);
    insert_sbu(p, "Ncurses-6.3", 0.4, 45, 5);
    insert_sbu(p, "Sed-4.8", 0.4, 31, 5);
    insert_sbu(p, "Psmisc-23.4", 0.1, 5.6, 5);
    insert_sbu(p, "Gettext-0.21", 2.7, 233, 5);
    insert_sbu(p, "Bison-3.8.2", 6.3, 53, 5);
    insert_sbu(p, "Grep-3.7", 0.9, 36, 5);
    insert_sbu(p, "Bash-5.1.16", 1.5, 50, 5);
    insert_sbu(p, "Libtool-2.4.6", 1.5, 43, 5);
    insert_sbu(p, "GDBM-1.23", 0.1, 13, 5);
    insert_sbu(p, "Gperf-3.1", 0.1, 6, 5);
    insert_sbu(p, "Expat-2.4.6", 0.1, 12, 5);
    insert_sbu(p, "Inetutils-2.2", 0.3, 30, 5);
    insert_sbu(p, "Less-590", 0.1, 4, 5);
    insert_sbu(p, "Perl-5.34.0", 9.3, 226, 5);
    insert_sbu(p, "XML::Parser-2.46", 0.1, 2, 5);
    insert_sbu(p, "Intltool-0.51.0", 0.1, 2, 5);
    insert_sbu(p, "Autoconf-2.71", 6.8, 24, 5);
    insert_sbu(p, "Automake-1.16.5", 8.3, 115, 5);
    insert_sbu(p, "OpenSSL-3.0.1", 5.4, 474, 5);
    insert_sbu(p, "Kmod-29", 0.1, 12, 5);
    insert_sbu(p, "Libelf", 0.9, 116, 5);
    insert_sbu(p, "Libffi-3.4.2", 1.9, 10, 5);
    insert_sbu(p, "Python-3.10.2", 4.3, 275, 5);
    insert_sbu(p, "Ninja-1.10.2", 0.2, 64, 5);
    insert_sbu(p, "Meson-0.61.1", 0.1, 41, 5);
    insert_sbu(p, "Coreutils-9.0", 2.6, 153, 5);
    insert_sbu(p, "Check-0.15.2", 3.8, 12, 5);
    insert_sbu(p, "Diffutils-3.8", 0.6, 34, 5);
    insert_sbu(p, "Gawk-5.1.1", 0.4, 43, 5);
    insert_sbu(p, "Findutils-4.9.0", 0.9, 51, 5);
    insert_sbu(p, "Groff-1.22.4", 0.5, 88, 5);
    insert_sbu(p, "GRUB-2.06", 0.7, 158, 5);
    insert_sbu(p, "Gzip-1.11", 0.1, 20, 5);
    insert_sbu(p, "IPRoute2-5.16.0", 0.2, 15, 5);
    insert_sbu(p, "Kbd-2.4.0", 0.1, 33, 5);
    insert_sbu(p, "Libpipeline-1.5.5", 0.1, 10, 5);
    insert_sbu(p, "Make-4.3", 0.5, 13, 5);
    insert_sbu(p, "Patch-2.7.6", 0.2, 12, 5);
    insert_sbu(p, "Tar-1.34", 1.7, 40, 5);
    insert_sbu(p, "Texinfo-6.8", 0.6, 112, 5);
    insert_sbu(p, "Vim-8.2.4383", 2.4, 206, 5);
    insert_sbu(p, "Eudev-3.2.11", 0.2, 83, 5);
    insert_sbu(p, "Man-DB-2.10.1", 0.3, 39, 5);
    insert_sbu(p, "Procps-3.3.17", 0.4, 19, 5);
    insert_sbu(p, "Util-linux-2.37.4", 1.1, 261, 5);
    insert_sbu(p, "E2fsprogs-1.46.5", 4.4, 93, 5);
    insert_sbu(p, "Sysklogd-1.5.1", 0.1, 1, 5);
    insert_sbu(p, "Sysvinit-3.01", 0.1, 1, 5);
}

static inline float calculate_sbu(float sbu, float time)
{
    return (sbu * time);
}

static void display_sbu(PT *p, size_t pass, float time)
{
    printf(COLOR_CYAN BOLD "------------------- PASS: [%zu] -------------------\n\n" COLOR_RESET, pass);

    size_t size = 0;
    float ttime = 0;
    for (size_t i = 0; i < n_packages; i++)
    {
        if (p[i].pass == pass)
        {
            printf("  - " COLOR_GREEN "%s " COLOR_RESET ": %zu Mo - %.2f minutes\n", p[i].name, p[i].size, calculate_sbu(p[i].sbu, time));
            size += p[i].size;
            ttsize += p[i].size;
            ttime += calculate_sbu(p[i].sbu, time);
            tttime += calculate_sbu(p[i].sbu, time);
        }
    }
    printf("\n  - " COLOR_YELLOW "Total " COLOR_RESET ": %zu Mo - %.2f minutes\n", size, ttime);
    usleep(50000);
}

int main(int argc, char **argv)
{
    if (argc != 2)
        return (display_help());
    if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0)
        return (display_help());
    else if (strcmp(argv[1], "-v") == 0 || strcmp(argv[1], "--version") == 0)
        printf("compil-calculator version 1.0\n");
    else
    {
        if (is_digit(argv[1]) == 0)
            return (display_help());
        float time = atof(argv[1]);

        PT *p;

        n_packages = 101 + 1;
        if (!(p = malloc(sizeof(PT) * n_packages)))
        {
            perror("malloc");
            return (1);
        }
        init_sbu(p);
        display_sbu(p, 1, time);
        printf("\n");
        display_sbu(p, 2, time);
        printf("\n");
        display_sbu(p, 3, time);
        printf("\n");
        display_sbu(p, 4, time);
        printf("\n");
        display_sbu(p, 5, time);
        printf("\n");
        printf(COLOR_CYAN BOLD "-------------------------------------------------\n\n" COLOR_RESET);
        printf("  - " COLOR_MAGENTA "%s " COLOR_RESET": "COLOR_RED "%zu " COLOR_RESET "Mo - " COLOR_RED "%.2f " COLOR_RESET "minutes\n", "TOTAL", ttsize, tttime);
    }
}
