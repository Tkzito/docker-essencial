# 📚 Documentação: Multistage Build com Go

Este exercício demonstra como criar imagens Docker extremamente otimizadas separando o processo de **construção** (build) do processo de **execução** (runtime).

## 1. O Problema
Linguagens compiladas como Go (ou C, C++, Rust, Java) precisam de ferramentas pesadas para transformar o código fonte em um executável.
- **Compilador Go**: ~300MB+
- **Código Fonte**: Vários MBs
- **Ferramentas de Build**: Vários MBs

Se usarmos uma imagem padrão (`FROM golang:alpine`) para rodar a aplicação, levaremos todo esse "peso morto" para a produção, resultando em imagens de **400MB a 800MB**.

## 2. A Solução: Multistage Build
O `Dockerfile` deste projeto usa dois estágios:

### Estágio 1: `builder` (O Canteiro de Obras)
- **Base**: `golang:1.22-alpine`
- **O que faz**:
  1. Copia o código `converter.go`.
  2. Baixa dependências (`go mod init`).
  3. Compila o binário estático (`go build`).
- **Resultado**: Um arquivo executável chamado `app`.

### Estágio 2: `final` (A Entrega)
- **Base**: `alpine:latest` (apenas ~5MB!)
- **O que faz**:
  1. Instala apenas o necessário para rodar: `ffmpeg`.
  2. Copia **APENAS** o arquivo `app` do estágio anterior.
- **Resultado**: Uma imagem contendo apenas o Linux básico, o FFmpeg e nosso executável.

## 3. Análise de Tamanho
No seu teste, a imagem ficou com **~140MB**. Vamos entender a matemática:

| Componente | Tamanho Estimado |
|------------|------------------|
| Alpine Linux (Base) | ~5 MB |
| FFmpeg + Dependências | ~130 MB |
| Nosso Executável Go | ~5 MB |
| **TOTAL** | **~140 MB** |

### E se NÃO usássemos Multistage?
A conta seria:
| Componente | Tamanho Estimado |
|------------|------------------|
| Imagem Golang (Base) | ~300 MB |
| FFmpeg + Dependências | ~130 MB |
| Código Fonte + Build | ~10 MB |
| **TOTAL** | **~440 MB** |

**Conclusão**: O Multistage Build economizou cerca de **300MB** de espaço! 📉

## 4. Arquivos do Projeto
- `converter.go`: O código da aplicação em Go.
- `Dockerfile`: A receita otimizada em 2 estágios.
- `compose.yaml`: Automação para rodar o container mapeando volumes.
