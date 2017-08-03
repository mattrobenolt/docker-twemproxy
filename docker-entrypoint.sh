#!/bin/sh
set -e

if [ "${1#-}" != "$1" ] ; then
    set -- nutcracker "$@"
fi

if [ "$1" = 'nutcracker' -a "$(id -u)" = '0' ]; then
    exec su-exec nutcracker "$0" "$@"
fi

exec "$@"
