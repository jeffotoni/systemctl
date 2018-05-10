# systemctl
Criando um script para iniciar em linux usando systemctl.

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
