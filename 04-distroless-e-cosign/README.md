# 📦 Desafio 04: Imagem Distroless e Assinatura Cosign

Este documento detalha os desafios técnicos e as soluções implementadas para refatorar o Dockerfile e assinar a imagem Distroless, conforme exigido pelo Desafio 04.

---

## 1. 🖼️ Desafio na Construção da Imagem Distroless (Dockerfile)

O objetivo principal era criar uma imagem final minimalista (`kube-news-distroless`) para a aplicação Node.js.

| Problema | Detalhe | Solução Implementada |
| :--- | :--- | :--- |
| **Erro de Caminho do COPY** | O Dockerfile usava `../` (caminhos relativos incorretos) para o contexto de build definido na raiz do repositório. | Corrigimos o caminho no Dockerfile, removendo o `../` e usando o caminho completo (ex: `COPY 01-identificando-vulnerabilidades/...`). |
| **Acesso Negado (FORBIDDEN)** | A tentativa de puxar a imagem base `FROM cgr.dev/chainguard/node-lite` falhou devido a problemas de autenticação/acesso. | Substituímos a base por uma alternativa pública e acessível que atende ao requisito Distroless: `FROM gcr.io/distroless/nodejs20`. |
| **Instruções do Build** | O código-fonte Node.js exigia um multi-stage build preciso para copiar apenas o necessário. | Uso da etapa `AS builder` (`node:20-alpine`) para instalar dependências e a etapa final `gcr.io/distroless/nodejs20` para copiar apenas o código e `node_modules`. |

---

## 2. 🔑 Desafio na Publicação (Docker Push)

Para que a imagem pudesse ser assinada com Cosign, ela precisava ser publicada no Docker Hub.

| Problema | Detalhe | Solução Implementada |
| :--- | :--- | :--- |
| **Credenciais Desconhecidas** | O login falhou devido à falta da senha ou PAT. | Utilizamos o `docker login` via navegador, garantindo que o Docker recebesse um token de acesso de escopo completo. |
| **Permissão de Escrita Negada** | O `docker push` falhou com `insufficient scopes` porque o usuário logado (`hodrick`) não tinha permissão de escrita no namespace alvo (`tkzito`). | Taggeamos a imagem para o namespace do usuário logado: `docker tag ... hodrick/kube-news-distroless:latest` e fizemos o push para o namespace `hodrick`. |

---

## 3. 🔐 Desafio na Assinatura (Cosign)

A imagem foi assinada e o artefato de segurança foi gerado.

| Problema | Detalhe | Solução Implementada |
| :--- | :--- | :--- |
| **Ferramenta cosign não encontrada** | O comando `cosign generate-key-pair` não foi reconhecido. | Instalamos o Cosign no BigLinux/Manjaro usando `yay -S cosign`. |
| **Assinatura Incorreta (Efêmera)** | A primeira assinatura usou chaves temporárias do Sigstore em vez das chaves locais (`cosign.key`) requeridas pelo desafio. | Corrigimos o comando para usar a chave privada local: `cosign sign --key secure_cosign.key hodrick/...` |
| **Segurança da Chave** | Questionamento sobre a inclusão da chave privada no Git. | A chave privada (`secure_cosign.key`) e a passphrase **NÃO** foram compartilhadas. Adicionamos a chave privada ao `.gitignore` para garantir que apenas a chave pública fosse enviada. |

---

## ⏫ Comandos Finais (Commit e Push)

Volte para a raiz do repositório (`cd ..`) e finalize a entrega:

1.  **Adicionar a Chave Pública Segura e Modificações:**
    ```bash
    git add 04-distroless-e-cosign/secure_cosign.pub 04-distroless-e-cosign/README.md 04-distroless-e-cosign/.gitignore
    ```
2.  **Commit Final:**
    ```bash
    git commit -m "Desafio 04: Finaliza documentação, adiciona nova chave pública segura e .gitignore"
    ```
3.  **Push Final:**
    ```bash
    git push
    ```
