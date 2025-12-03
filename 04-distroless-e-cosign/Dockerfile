# ETAPA 1: BUILDER - Configura o ambiente de build completo
# Usamos uma imagem Node.js completa e otimizada (Alpine) para instalar as dependências.
# A imagem Node.js completa é necessária porque o NPM (Node Package Manager) não está na imagem final Distroless.
FROM node:20-alpine AS builder

# Define o diretório de trabalho dentro deste contêiner temporário.
WORKDIR /app

# Copia os arquivos de manifesto do Node.js (package.json e package-lock.json).
# O caminho é relativo à raiz do repositório (o contexto do build).
COPY 01-identificando-vulnerabilidades/kube-news/src/package*.json ./

# Instala as dependências, omitindo pacotes de desenvolvimento (--omit=dev).
# Esta é uma boa prática essencial para reduzir a superfície de ataque na imagem de produção.
RUN npm install --omit=dev

# Copia o restante do código-fonte da aplicação (servidor, views, etc.).
COPY 01-identificando-vulnerabilidades/kube-news/src/ .


# ETAPA 2: PRODUTION - Imagem Distroless da Chainguard (Leve e Segura)
# Esta imagem contém APENAS o runtime essencial do Node.js, sem shell, sem gerenciador de pacotes, e sem ferramentas que um atacante poderia usar.
FROM gcr.io/distroless/nodejs20

# Define o diretório de trabalho no ambiente final.
WORKDIR /app

# Copia APENAS o essencial do estágio 'builder' para a imagem final:
# 1. As dependências instaladas (node_modules).
# 2. O código-fonte da aplicação.
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/. .

# Define o comando de inicialização.
# Como é uma imagem Distroless, o CMD deve chamar o binário 'node' diretamente para iniciar a aplicação.
CMD ["node", "server.js"]

# Documenta a porta que a aplicação Node.js espera (8080 é um padrão comum).
EXPOSE 8080
