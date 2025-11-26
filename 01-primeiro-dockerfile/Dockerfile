# Define a imagem base. Usamos 'alpine' por ser uma versão extremamente leve do Linux,
# ideal para containers menores e mais seguros.
FROM nginx:alpine

# Remove os arquivos padrão do NGINX que vêm na imagem original.
# Isso garante que apenas o nosso site esteja presente no diretório de hospedagem.
RUN rm -rf /usr/share/nginx/html/*

# Copia todos os arquivos do diretório atual (onde está o Dockerfile)
# para o diretório padrão onde o NGINX serve os arquivos estáticos.
COPY . /usr/share/nginx/html/

# Informa ao Docker que o container escuta na porta 80 em tempo de execução.
# Nota: Isso não publica a porta automaticamente, serve apenas como documentação.
EXPOSE 80

# O comando padrão para iniciar o NGINX já está definido na imagem base,
# então não precisamos redefini-lo aqui (CMD ["nginx", "-g", "daemon off;"]).
