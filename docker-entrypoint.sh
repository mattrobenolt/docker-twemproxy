#!/bin/sh
set -e

if [ "${1#-}" != "$1" ] ; then
    set -- nutcracker "$@"
fi

if [ "$1" = 'nutcracker' -a "$(id -u)" = '0' ]; then
    mkdir -p $NUTCRACKER_RUNDIR
    chown nutcracker:nutcracker -R $NUTCRACKER_RUNDIR
    chmod 755 $NUTCRACKER_RUNDIR
    exec su-exec nutcracker "$0" "$@"
fi

exec "$@"
