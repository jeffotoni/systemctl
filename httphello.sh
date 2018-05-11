#!/bin/bash
# Exemplo de script para inicializar no boot do linux
# Usando Systemctl 
# Este script tem que está em: /etc/init.d
# 
# @package     httphello
# @author      @jeffotoni
# @size        05/2018

### BEGIN INIT INFO
# Provides:          httphello
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

echo "#######################"
echo "    httphello     "
echo "#######################"

# Usando as funções lsb para executar as operações.
. /lib/lsb/init-functions

# Nome processo
NAME=httphello

# Nome do daemon onde irá executar
DAEMON=/usr/bin/httphello

# pid do arquivo para o daemon
PIDFILE=/var/run/httphello.pid

# Se o daemon não estiver lá, saia.
test -x $DAEMON || exit 5

# funcao start
d_start () 
{ 

    # Verificado o arquivo PID existe e verificar o status atual do processo
    if [ -e $PIDFILE ]; then
       status_of_proc -p $PIDFILE $DAEMON "$NAME process" && status="0" || status="$?"
       
       # Se o status for SUCESSO, não será necessário iniciar novamente.
       if [ $status = "0" ]; then
          exit # Exit
       fi
    fi
    
    # Start o daemon.
    log_daemon_msg "Starting the process" "$NAME"

    # Inicie o daemon com a ajuda de start-stop-daemon
    # Registre a mensagem apropriadamente
    if start-stop-daemon --start --quiet --oknodo --pidfile $PIDFILE --exec $DAEMON ; then
       log_end_msg 0
    else
       log_end_msg 1
    fi
}

# funcao stop
d_stop ()  
{ 
     # Verificado o arquivo PID existe
     if [ -e $PIDFILE ]; then
        status_of_proc -p $PIDFILE $DAEMON "Stoppping the $NAME process" && status="0" || status="$?"
     if [ "$status" = 0 ]; then
        start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE
        /bin/rm -rf $PIDFILE
     fi
     else
       log_daemon_msg "$NAME process is not running"
       log_end_msg 0
     fi
 }

#funcao status
 d_status ()
 {  
    # Verificado o arquivo PID existe
    if [ -e $PIDFILE ]; then
     status_of_proc -p $PIDFILE $DAEMON "$NAME process" && exit 0 || exit $?
    else
      log_daemon_msg "$NAME Process is not running"
      log_end_msg 0
    fi

    #ps  -ef  |  grep httphello | grep  -v  grep
    #echo  "PID indicate indication file" 
}

# funcao restart
d_restart ()
{
  # Restart o daemon.
  $0 stop && sleep 2 && $0 start
}

# reload
d_reload ()
{
    # Recarregue o processo. 
    # Basicamente enviando algum sinal 
    # para um daemon para recarregar
    # configurações.
    if [ -e $PIDFILE ]; then
      start-stop-daemon --stop --signal USR1 --quiet --pidfile $PIDFILE --name $NAME
      log_success_msg "$NAME process reloaded successfully"
    else
      log_failure_msg "$PIDFILE does not exists"
    fi
}

# Instruções de 
# gerenciamento 
# do serviço
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
        reload)
            d_reload
            ;;
        status)
            d_status
            ;;
        *)
        echo  "Usage: $0 {start|stop|restart|reload|status}"
        exit 1 
        ;; 
esac
