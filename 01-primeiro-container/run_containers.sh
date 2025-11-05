#!/bin/bash

# Baixar a imagem nginx
echo "Baixando a imagem nginx..."
docker pull nginx

# Iniciar um contêiner nginx
echo "Iniciando o contêiner meu-servidor..."
docker run -d --name meu-servidor -p 8081:80 nginx

# Listar todos os contêineres em execução
echo "Listando os contêineres em execução..."
docker ps

# Parar o contêiner
echo "Parando o contêiner meu-servidor..."
docker stop meu-servidor

# Remover o contêiner
echo "Removendo o contêiner meu-servidor..."
docker rm meu-servidor

# Listar todos os contêineres
echo "Listando todos os contêineres..."
docker ps -a --filter "name=meu-servidor"