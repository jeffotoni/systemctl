#!/bin/bash
# @autor jeff.otoni@gmail.com
# @date  05/2018
# Script Exemplo para iniciar nosso Daemon

echo "#######################"
echo "    cron-httphello     "
echo "#######################"

# Process name ( For display )
NAME=httphello

# Daemon name, where is the actual executable
DAEMON=/usr/bin/httphello
# pid file for the daemon
PIDFILE=/var/run/httphello.pid

# If the daemon is not there, then exit.
test -x $DAEMON || exit 5

# start
d_start () 
{ 

    echo  "cron-httphello: starting service" 
    cd /usr/bin
    httphello > /tmp/cron-httphello.log &
    sleep  1
    echo "Executando cron-httphello sucesso"
}

# stop
d_stop ()  
{ 
    echo  "httphello: stopping Service (PID=$(ps aux | grep httphello | awk '{print $2}'))"
    killall -9 httphello
 }

# status
d_status ()
 {
    ps  -ef  |  grep httphello | grep  -v  grep
    #echo  "PID indicate indication file" 
}

# restart
d_restart ()
{
  # Restart the daemon.
  $0 stop && sleep 2 && $0 start
}

# Management instructions of the service 
case  "$1"  in 
        start)
            d_start
            ;; 

        stop)
            d_stop
            ;;

        restart)
            d_restart
            ;;
        status)
            d_status
            ;;
            
        *)
        echo  "Usage: $0 {start|stop|restart|status}" 
        exit 1 
        ;; 
esac
