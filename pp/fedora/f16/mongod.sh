#!/bin/sh
#
# mongodb      init file for starting up the MongoDB server
#
# chkconfig:   - 36 62
# description: Starts and stops the MongDB daemon that handles all \
#              database requests.

### BEGIN INIT INFO
# Provides: mongodb
# Required-Start: $local_fs $network
# Required-Stop: $local_fs $network
# Should-Start: $remote_fs
# Should-Stop: $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: start and stop MongoDB database server
# Description: MongoDB is a distributed, fault-tolerant and
#              schema-free document-oriented database
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

exec="/usr/bin/mongod"
prog="mongod"

options=" -f /etc/mongod.conf"

#[ -e /etc/sysconfig/$prog ] && . /etc/sysconfig/$prog

lockfile="/var/lock/subsys/mongod"

start() {
    [ -x $exec ] || exit 5
    echo -n $"Starting $prog: "
    echo $options
    daemon --user mongod "$exec $options run"
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    /usr/bin/pkill -2 $prog
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    stop
    start
}

reload() {
    restart
}

force_reload() {
    restart
}

rh_status() {
    # run checks to determine if the service is running or use generic status
    status $prog
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}


case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
exit $?
