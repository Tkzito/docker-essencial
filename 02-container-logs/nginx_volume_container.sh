#!/bin/bash

# 1. Criar um volume Docker chamado nginx_logs
echo "Criando o volume nginx_logs..."
docker volume create nginx_logs

# Pre-criar os arquivos de log no volume para garantir que o Nginx possa escrever neles
echo "Preparando o volume com arquivos de log vazios..."
docker run --rm -v nginx_logs:/var/log/nginx busybox sh -c "touch /var/log/nginx/access.log /var/log/nginx/error.log"

# 2. Executar um contêiner nginx
echo "Iniciando o primeiro contêiner nginx (nginx-logs-1)..."
docker run -d --name nginx-logs-1 -p 8080:80 -v nginx_logs:/var/log/nginx nginx

# 3. Gerar logs
echo "Gerando logs de acesso..."
sleep 2 # Dando um tempo para o Nginx iniciar
curl http://localhost:8080

# 4. Parar e remover o contêiner
echo "Parando e removendo o contêiner nginx-logs-1..."
docker stop nginx-logs-1
docker rm nginx-logs-1

# 5. Validar que os logs existem no volume (passo intermediário de verificação)
echo "Verificando o conteúdo do log diretamente no volume..."
docker run --rm -v nginx_logs:/var/log/nginx busybox cat /var/log/nginx/access.log

# 6. Criar um novo contêiner
echo "Iniciando o segundo contêiner nginx (nginx-logs-2)..."
docker run -d --name nginx-logs-2 -p 8080:80 -v nginx_logs:/var/log/nginx nginx

# 7. Validar que os logs antigos ainda existem no novo contêiner
echo "Validando a persistência dos logs no novo contêiner..."
sleep 2 # Dando um tempo para o Nginx iniciar
docker exec nginx-logs-2 cat /var/log/nginx/access.log

# Limpeza final
echo "Limpando o ambiente..."
docker stop nginx-logs-2
docker rm nginx-logs-2
docker volume rm nginx_logs

echo "Script concluído!"