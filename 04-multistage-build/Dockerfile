# --- ESTÁGIO 1: Builder (O Canteiro de Obras) ---
# Usamos uma imagem com o compilador Go (pesada, ~300MB+)
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copiamos o código fonte
COPY converter.go .

# Inicializamos o módulo Go
RUN go mod init converter

# Compilamos o código para um binário estático chamado "app"
# CGO_ENABLED=0: Garante que o binário não dependa de bibliotecas do sistema (portabilidade total)
# -ldflags="-s -w": Remove informações de debug para deixar o binário menor
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o app converter.go

# --- ESTÁGIO 2: Final (A Entrega Limpa) ---
# Usamos uma imagem Alpine limpa (leve, ~5MB)
FROM alpine:latest

# Instalamos apenas o necessário para rodar (FFmpeg)
RUN apk add --no-cache ffmpeg

WORKDIR /app

# A MÁGICA: Copiamos APENAS o binário compilado do estágio anterior
# Todo o código fonte e o compilador Go ficam para trás e não entram na imagem final
COPY --from=builder /app/app .

# Definimos o ponto de entrada
ENTRYPOINT ["./app"]
