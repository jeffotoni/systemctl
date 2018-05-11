# systemctl

Criando um script de inicialização em linux usando systemctl.

Existem formas diferentes conforme o sistema de inicialização em um sistema linux pode ser utilizado: Systemd ou System V (ou Sysvinit). Uma variação. Uma das principais razões para o Debian mudar do SysV para o systemd é a popularização de computadores com mais de um núcleo, de modo aproveitar melhor o paralelismo do que a tentativa realizada pelo Upstart (da Canonical, que mantém o Ubuntu).

O systemd é compatível com o SysV e Scripts de init LSB (Linux Standard Base), mas possui padrões diferentes para conter basicamente a mesma informação. O comando service é uma ferramenta de “compatibilidade” para ajudar as pessoas a migrar de sysvinit para systemd. 

O Systemd é um sistema init e gerenciador de sistemas que está se tornando amplamente o novo padrão para máquinas Linux. 
Embora existam opiniões consideráveis ​​sobre se o systemd é uma melhoria em relação aos sistemas init tradicionais do SysV que ele está substituindo, a maioria das distribuições planeja adotá-lo ou já o fez.

Neste guia, discutiremos o comando systemctl, que é a ferramenta central de gerenciamento para controlar o sistema init. Abordaremos como gerenciar serviços, verificar status, alterar estados do sistema e trabalhar com os arquivos de configuração.

Observe que, embora o systemd tenha se tornado o sistema init padrão para muitas distribuições do Linux, ele não é implementado universalmente em todas as distribuições. Conforme você passa por este tutorial, se o seu terminal gerar a mensagem de erro bash: systemctl não está instalado, é provável que sua máquina tenha um sistema init diferente instalado.

Para mais informações pode visitar o site [debina/LSBInitScripts](https://wiki.debian.org/LSBInitScripts).

### Alguns comandos do systemctl

Para iniciar um serviço systemd, use o comando start. Se você estiver executando como um usuário não-root, será necessário usar o sudo.

```sh

$ sudo systemctl start application.service

```

Como mencionamos acima, o systemd sabe procurar arquivos * .service para comandos de gerenciamento de serviço, para que o comando seja facilmente digitado assim:

```sh

$ sudo systemctl start application

```

Para parar um serviço atualmente em execução, você pode usar o comando stop:

```sh

$ sudo systemctl stop application.service

```

Para reiniciar um serviço em execução, você pode usar o comando restart:

```sh

$ sudo systemctl restart application.service

```

Se o aplicativo em questão puder recarregar seus arquivos de configuração (sem reiniciar), você poderá emitir o comando reload para iniciar o processo:

```sh

$ sudo systemctl reload application.service

```

Ativando e desativando serviços

Para dizer ao systemd para iniciar serviços automaticamente na inicialização, você deve ativá-los.

Para iniciar um serviço na inicialização, use o comando enable:

```sh

$ sudo systemctl enable application.service

```
Isso criará um link simbólico da cópia do sistema do arquivo de serviço (geralmente em /lib/systemd/system ou /etc/systemd/system) para o local no disco onde systemd procura por arquivos de autoinicialização (geralmente /etc/systemd/system/multi-user.target.wants).

#### Algumas Tags:

 - multi-user.target.wants
 - bluetooth.target.wants
 - default.target.wants
 - display-manager.service.wants
 - final.target.wants
 - getty.target.wants
 - timers.target.wants

Para desativar o serviço seja iniciado automaticamente, você pode digitar:

```sh

$ sudo systemctl disable application.service

```

Para verificar o status de um serviço no seu sistema, você pode usar o comando status:

```sh

$ sudo systemctl status application.service

```
Isso fornecerá o estado do serviço, a hierarquia do cgroup e as primeiras linhas de log.

Por exemplo, ao verificar o status do serviço "redis", você pode ver a saída assim:

```

➜  systemctl git:(master) ✗ sudo systemctl status redis
● redis-server.service - Advanced key-value store
   Loaded: loaded (/lib/systemd/system/redis-server.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2018-05-10 13:49:25 -03; 2h 32min ago
     Docs: http://redis.io/documentation,
           man:redis-server(1)
  Process: 1426 ExecStartPost=/bin/run-parts --verbose /etc/redis/redis-server.post-up.d (code=exited, status=0/SUCCESS)
  Process: 1321 ExecStart=/usr/bin/redis-server /etc/redis/redis.conf (code=exited, status=0/SUCCESS)
  Process: 1202 ExecStartPre=/bin/run-parts --verbose /etc/redis/redis-server.pre-up.d (code=exited, status=0/SUCCESS)
 Main PID: 1425 (redis-server)
    Tasks: 4 (limit: 4915)
   Memory: 3.8M
      CPU: 16.350s
   CGroup: /system.slice/redis-server.service
           └─1425 /usr/bin/redis-server 127.0.0.1:6379

mai 10 13:49:25 netcatc systemd[1]: Starting Advanced key-value store...
mai 10 13:49:25 netcatc run-parts[1202]: run-parts: executing /etc/redis/redis-server.pre-up.d/00_example
mai 10 13:49:25 netcatc run-parts[1426]: run-parts: executing /etc/redis/redis-server.post-up.d/00_example
mai 10 13:49:25 netcatc systemd[1]: Started Advanced key-value store.

```

Isso oferece uma boa visão geral do status atual do aplicativo, notificando você sobre quaisquer problemas e ações que possam ser necessárias.

Existem também métodos para verificar estados específicos. Por exemplo, para verificar se uma unidade está atualmente ativa (em execução), você pode usar o comando is-active:

```sh

$ sudo systemctl is-active application.service

```

Isso retornará o estado atual da unidade, que geralmente está ativo ou inativo. O código de saída será "activating" se estiver ativo.
Para ver se a unidade está ativada, você pode usar o comando is-enabled:

```sh

$ sudo systemctl is-enabled application.service

```
 O código de saída será "enabled" se o application estiver habilitado.

Temos também o is-failed retornará "activating" se estiver funcionando corretamente ou "inactive" se ocorrer um erro. Se a unidade foi parada intencionalmente, ela pode retornar unknown ou inactive. Um status de saída "0" indica que ocorreu uma falha e um status de saída "1" indica qualquer outro status.

```sh
 
 $ sudo systemctl is-failed application.service

 ```


### Listando Unidades do systemctl

Para ver uma lista de todas as unidades ativas que o systemd conhece, podemos usar o comando list-units:

```sh

$ sudo systemctl list-units

```

Você pode usar outros sinalizadores para filtrar esses resultados. Por exemplo, podemos usar o sinalizador --state = para indicar os estados LOAD, ACTIVE ou SUB que desejamos visualizar. Você terá que manter o sinalizador --all para que systemctl permita que unidades não ativas sejam exibidas:

```sh

$ sudo systemctl list-units --all --state=inactive

```

Outro filtro comum é o --type=filter. Podemos dizer ao systemctl para exibir apenas unidades do tipo em que estamos interessados. Por exemplo, para ver apenas unidades de serviço ativas, podemos usar:

```sh

$ sudo systemctl list-units --type=service

```

### Listando todos os arquivos da unidade

O comando list-units exibe apenas as unidades que o systemd tentou analisar e carregar na memória. Como o systemd só irá ler as unidades que julgar necessárias, isso não incluirá necessariamente todas as unidades disponíveis no sistema. Para ver todos os arquivos de unidade disponíveis dentro dos caminhos do systemd, incluindo aqueles que o systemd não tentou carregar, você pode usar o comando list-unit-files em vez disso:

```sh

$ sudo systemctl list-unit-files

```
### Criando e organizando nossos scripts e Daemon.

#### Programa 1 / Será um script bash

O arquivo do exemplo a seguir deve ser colocado dentro de **/etc/init.d/**.

Temos que criar nosso script para controlar todas as etapas de **start|stop|restart|reload|status** do nosso programa que será executado, iremos chama-lo de httphello.sh que irá ser responsável por gerenciar nosso executável que irá ser inicializado no boot do sistema. Para ficar mais bacana iremos renomer **httphello.sh** para **httphello**

#### System V (SysV ou sysvinit)

Vamos criar nosso script para gerenciar os eventos: **start|stop|restart|reload|status** não esqueça de coloca-lo em **/etc/init.d/**, **chmod +x httphello**

É possível colocar o script diretamente no diretório **/etc/init.d**. Para criar o link simbólico de modo a permitir a execução na inicialização para isto temos que rodar o seguinte comando **“sudo update-rc.d httphello defaults**, caso queira removê-lo, utilize **remove** em vez de **defaults**. Mais detalhes do boot do linux clique aqui [Boot linux](https://www.thegeekstuff.com/2011/02/linux-boot-process/)

Um script LSB (Linux Standard Base) Init tem como principal finalidade a execução de comandos na inicialização do sistema operacional seguindo uma padronização. Para isso, ele deve ter suporte para as seguintes ações: **start|stop|restart|reload|status**. 

Deverá ter saída de erros apropriada e ter as **run-time dependencies**: um cabeçalho padrão no início do script com as informações necessárias ao seu funcionamento.

Confira as funções que ficam comentadas no inicio do script são como annotations.

 - Provides:	 		especifica qual é a facility executada por este script Init (o nome deve ser único).

 - Required-start: 		especifica o conjunto de facilities que deve ser iniciado antes de começar este serviço. 
 						Existem alguns nomes todos iniciados por $: $local_fs, $remote_fs, $network, $named, $portmap, $syslog, $time e $all.

 - Required-Stop: 		especifica a lista de facilities que devem ser paradas depois de parar esta facility.

 - Default-Start:  		definem os níveis de execução ex: 2 3 4 5 em que o serviço deve ser iniciado.
 
 - Default-Stop: 		definem os níveis de execução ex: 0 1 6 em que o serviço deve ser parado.

 - Short-Description: 	apresentam a descrição do serviço.

 - Description:			apresentam a descrição do serviço.

Mais detalhes das funções de script confere aqui: [LSB Ini Script](http://refspecs.linuxbase.org/LSB_3.1.0/LSB-Core-generic/LSB-Core-generic/iniscrptfunc.html)

```sh
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

```

#### Programa 2 / Será um script bash service

O arquivo deve ser colocado dentro de **/etc/systemd/system/** (preferencialmente) ou **/usr/lib/systemd/system/** e ter a extensão **.service**, seu formato é:

```sh

[Unit]
# nome do servico
Description=httphello

#Serviço 
After=multi-user.target

[Service]

# Se for apenas um processo 
# use Type simple; 
# caso ele gere subprocessos 
# use forking
Type=forking

# Caso use forking, 
# convém guardar o número pid 
# do processo pai para o systemd 
# fazer o monitoramento
PIDFile=/var/run/httphello.pid

# inicia o processo aqui
# (caso use forking) 
ExecStart=/etc/init.d/httphello start

# usuario
# que irá
# executar
User=root

# diretorio 
WorkingDirectory=/etc/init.d

#Restart=no
Restart=always

# tempo para
# restart do 
# serviço
RestartSec=1s

# mantendo os logs no 
# syslog
StandardOutput=syslog

# logs de errros
StandardError=inherit

# Comando que para o serviço 
# (o próprio Systemd 
# se encarrega de acompanhar 
# o PID do serviço)
ExecStop=/bin/kill -TERM $MAINPID

[Install]

#Necessário para instalação do serviço
WantedBy=multi-user.target

```
### Systemd (systemctl)

É baseado na notação de sete tipos diferentes de unidades (ou units), cujo nome é composto de uma identificação e o seu tipo como sufixo (se não for especificado, o systemctl assumirá .service):

 - service – daemons que podem ser iniciados, parados, reiniciados e recarregados.

- socket – encapsula um socket no sistema de arquivos ou na Internet; sockets são programas responsaveis pela comunicação ou interligação de outros programas que atuam na camada de transporte, como os “Stream Sockets” (usado no telnet) e os “Datagram Sockets” (usam UDP em vez de TCP).

- device – encapsula um dispositivo na árvore de dispositivos do Linux; se é marcado através de regras no udev, ele será exposto a um dispositivo de unidade no systemd.

- mount – encapsula um ponto de montagem na hierarquia do sistema de arquivos.

- automount – encapsula um ponto de montagem automático na hierarquia do sistema de arquivos; cada unidade automount, tem uma unidade mount correspondente, que é iniciada(montada) assim que o diretório automount é acessado.

- target – usada para agrupamento lógico de unidades, referenciando outras unidades que podem ser controladas então de forma conjunta (por exemplo, “multi-user.target” é uma unidade que basicamente equivale a regra do run-level 5 no clássico SysV).

- snapshot – similar a unidade target, a unidade snapshot não faz nada por si so a não ser referenciar outras unidades.


#### Programa 3 / Será nosso Daemon

Nosso terceiro programa é o Daemon, será responsável por ficar escutando em uma porta 8080 e receberá uma solicitação POST como exemplo abaixo:

O httphello.go é nosso Daemon, iremos compilar e disponibilizar como um serviço, toda vez que iniciarmos nosso sistema operacional ele será iniciado e mantido como serviço pelo Linux.


```go

// nossa funcao
// principal
func main() {

	// show msg
	fmt.Println("Iniciando Hello...")

	// declarando nosso endpoint
	http.HandleFunc("/hello", Hello)

	// apresentando um log na saida caso
	// ocorra algo de errado
	log.Fatal(http.ListenAndServe(":"+PORT, nil))
}

```
### Um Client para testar nosso serviço

```sh

$ curl -vX POST \
	localhost:9999/hello \
	-d "name=jefferson"

```

### Crontab como Serviço

O serviço de agendamento de tarefas do Linux também pode ser usado para iniciar um script na inicialização. 

Através do comando “crontab -e” conseguiremos editar nosso crontab.

```sh

@reboot cd /usr/bin/ && httphello > /tmp/httphello.log 2>&1

```
