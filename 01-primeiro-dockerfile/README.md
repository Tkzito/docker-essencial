# Rota42 - Página Institucional Docker

## 📋 Descrição
Página institucional da Rota42 containerizada com Docker e NGINX.

## 🚀 Como usar

### 1. Adicionar o conteúdo da página
Baixe o arquivo do Google Drive e extraia o conteúdo neste diretório.

### 2. Build da imagem
```bash
docker compose build
```

### 3. Executar o container
```bash
docker compose up -d
```

### 4. Acessar a página
Abra o navegador em: http://localhost:8080

### 5. Parar o container
```bash
docker compose down
```

## 📦 Características da Imagem

- **Imagem base**: `nginx:alpine` (menor tamanho possível)
- **Tamanho**: ~25MB (dependendo do conteúdo da página)
- **Porta exposta**: 80 (mapeada para 8080 no host)

## 📁 Estrutura de Arquivos

```
07-rota42/
├── Dockerfile          # Definição da imagem Docker
├── compose.yaml        # Configuração do Docker Compose
├── .dockerignore       # Arquivos ignorados no build
├── index.html          # Página principal (adicionar conteúdo)
└── README.md           # Este arquivo
```

## ✅ Requisitos Atendidos

- ✅ Dockerfile criado
- ✅ Copia conteúdo para a imagem
- ✅ Imagem de menor tamanho possível (nginx:alpine)
- ✅ Docker Compose configurado
- ✅ Porta 8080 mapeada
- ✅ Suporte a `docker compose build`
