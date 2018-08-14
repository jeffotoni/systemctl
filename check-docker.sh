#!/bin/bash

#
# autor: @jeffotoni
# about: Script to deploy our applications sqlserver, client sqlserver done in php
# date:  08/05/2018
# since: Version 0.1
#
DOCKER_NAME='NAME_DOCKER'

# nome da imagem
DOCKER_IMAGE="jeffotoni/$DOCKER_NAME"

# local beta
#DOCKER_NETWORK='--net s31'

# producao
DOCKER_NETWORK=''

# volume onde ira econtrar o projeto
# beta local
#DOCKER_VOLUME='/PATH'

# producao
DOCKER_VOLUME='/PATH_VOLUME'

# script php a ser executado
APP_PHP='PATH_APP'

# buscando o id da imagem se nao encontrar
# start o container e busca o id
CONTAINER_ID=$($SUDO docker ps -q --filter "ancestor=$DOCKER_IMAGE")

# ambiente devel
# $SUDO="sudo"
$SUDO=""

# debug test
# somente para 
# testar..
#CONTAINER_ID=''

if [ ! -z "$CONTAINER_ID" ]; then

echo ""
echo "Encontrando o ID do CONTAINER [$DOCKER_IMAGE]"
echo "CONTAINER ID = $CONTAINER_ID"
echo "Executando script php."

# executando script
$SUDO docker exec $CONTAINER_ID php -q $APP_PHP

else 
	
	# so tendo certeza, parando qualquer coisa que estiver na memoria
	echo "Docker stop em imagen {$DOCKER_IMAGE}"
	$SUDO docker stop $($SUDO docker ps -a -q --filter "ancestor=$DOCKER_IMAGE")	
	#$SUDO docker rm $($SUDO docker ps -q --filter "ancestor=$DOCKER_IMAGE")

	echo ""
	echo "Start no container agora."
	echo "Docker Run na Imagem [$DOCKER_IMAGE]"
	echo ""
	# executando docker run 
	$SUDO docker run $DOCKER_NETWORK -itd --rm --name $DOCKER_NAME -e "DOCKER_EXEC=true" -v $DOCKER_VOLUME $DOCKER_IMAGE

	# buscando o ID
	CONTAINER_ID=$($SUDO docker ps -q --filter "ancestor=$DOCKER_IMAGE")
	
	echo ""
	echo "Encontrando o ID do CONTAINER [$DOCKER_IMAGE]"
	echo "CONTAINER ID = $CONTAINER_ID"
	echo "Executando script PHP."

	# executando o script php para atualizar base
	$SUDO docker exec $CONTAINER_ID php -q $APP_PHP

	# mensagem de finalizacao
	echo "Execucao e atualizacao da base foi concluida"

	# aguardando um pouco
	sleep 2

	echo "Parando o serviço {$DOCKER_IMAGE}"
	# parando servico
	$SUDO docker stop $($SUDO docker ps -a -q --filter "ancestor=$DOCKER_IMAGE")

	#aguardando um pouco
	sleep 1

	CONTAINER_ID=$($SUDO docker ps -q --filter "ancestor=$DOCKER_IMAGE")

	if [ ! -z "$CONTAINER_ID" ]; then

		echo "Removendo container {$DOCKER_IMAGE}"
		# removendo servico
		$SUDO docker rm $($SUDO docker ps -a -q --filter "ancestor=$DOCKER_IMAGE")
	fi
fi

# executa o programa
# docker exec

# para o servico
# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q) 
