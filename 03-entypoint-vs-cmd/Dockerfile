# Usamos Alpine Linux por ser extremamente leve e seguro (aprox. 5MB)
FROM alpine:latest

# Instala o FFmpeg e bash.
# O FFmpeg é a ferramenta que fará a conversão dos vídeos.
# --no-cache: Evita guardar arquivos de cache do gerenciador de pacotes (apk), mantendo a imagem pequena.
RUN apk add --no-cache ffmpeg

# Define o diretório de trabalho dentro do container.
# Todos os comandos subsequentes (COPY, ENTRYPOINT, CMD) serão executados a partir daqui.
WORKDIR /app

# Copia o script de conversão do seu computador para dentro da imagem.
COPY convert.sh .

# Garante que o script tenha permissão de execução (+x).
# Sem isso, o container falharia ao tentar rodar o script.
RUN chmod +x convert.sh

# ENTRYPOINT: Define o comando "fixo" do container.
# O container SEMPRE executará "./convert.sh" ao iniciar.
# Isso transforma o container em um "executável" que roda nosso script.
ENTRYPOINT ["./convert.sh"]

# CMD: Define os argumentos "padrão" para o ENTRYPOINT.
# Se o usuário rodar "docker run imagem", o comando final será: "./convert.sh --help".
# Se o usuário rodar "docker run imagem arg1 arg2", o CMD é ignorado e o comando será: "./convert.sh arg1 arg2".
CMD ["--help"]
