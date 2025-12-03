📄 Histórico de Problemas e Soluções (Desafio 04)

Este documento detalha os desafios técnicos e as soluções implementadas para refatorar o Dockerfile e assinar a imagem Distroless, conforme exigido pelo Desafio 04.

1. 🖼️ Desafio na Construção da Imagem Distroless (Dockerfile)
O objetivo principal era criar uma imagem final minimalista (kube-news-distroless) para a aplicação Node.js, utilizando o conceito de multi-stage build.

Problema,Detalhe,Solução Implementada
Erro de Caminho do COPY,O Dockerfile usava ../ (caminhos relativos incorretos) para o contexto de build definido na raiz do repositório.,"Corrigido o caminho no Dockerfile, removendo o ../ e usando o caminho completo (ex: COPY 01-identificando-vulnerabilidades/...)."
Acesso Negado (FORBIDDEN),A tentativa de puxar a imagem base FROM cgr.dev/chainguard/node-lite falhou devido a problemas de autenticação/acesso ao registro Chainguard.,Substituímos a base por uma alternativa pública e acessível que atende ao requisito Distroless: FROM gcr.io/distroless/nodejs20.
Instruções do Build,O código-fonte Node.js exigia um multi-stage build preciso para copiar as dependências e o código.,Uso da etapa AS builder (node:20-alpine) para instalar dependências (npm install) e a etapa final gcr.io/distroless/nodejs20 para copiar apenas o código e node_modules.

2. 🔑 Desafio na Publicação (Docker Push)
Para que a imagem pudesse ser assinada com Cosign, ela precisava ser publicada no Docker Hub.

Problema,Detalhe,Solução Implementada
Credenciais Desconhecidas,O login falhou devido à falta da senha ou PAT.,"Utilizamos o docker login via navegador, garantindo que o Docker recebesse um token de acesso de escopo completo."
Permissão de Escrita Negada,O docker push falhou com insufficient scopes porque o usuário logado (hodrick) não tinha permissão de escrita no namespace alvo (tkzito).,Taggeamos a imagem para o namespace do usuário logado: docker tag ... hodrick/kube-news-distroless:latest e fizemos o push para o namespace hodrick.

3. 🔐 Desafio na Assinatura (Cosign)
A imagem foi assinada e o artefato de segurança foi gerado.

Problema,Detalhe,Solução Implementada
Ferramenta cosign não encontrada,O comando cosign generate-key-pair não foi reconhecido.,Instalamos o Cosign no BigLinux/Manjaro usando yay -S cosign.
Assinatura Incorreta (Efêmera),A primeira assinatura usou chaves temporárias do Sigstore em vez das chaves locais (cosign.key) requeridas pelo desafio.,Corrigimos o comando para usar a chave privada local: `cosign sign --key cosign.key hodrick/...
Segurança da Chave,Questionamento sobre a inclusão da senha e chave privada no Git.,A chave privada (cosign.key) e a passphrase NÃO foram compartilhadas. Adicionamos a chave privada ao .gitignore para garantir que apenas a chave pública (cosign.pub) fosse enviada.

   rodrigo  ~/Documentos/Cursos/docker-essencial/04-distroless-e-cosign    main   1  09:55:40
❯ cosign sign --key cosign.key hodrick/kube-news-distroless:latest | tee cosign-signature.txt
WARNING: Image reference hodrick/kube-news-distroless:latest uses a tag, not a digest, to identify the image to sign.
    This can lead you to sign a different image than the intended one. Please use a
    digest (example.com/ubuntu@sha256:abc123...) rather than tag
    (example.com/ubuntu:latest) for the input to cosign. The ability to refer to
    images by tag will be removed in a future release.

Enter password for private key: 

        The sigstore service, hosted by sigstore a Series of LF Projects, LLC, is provided pursuant to the Hosted Project Tools Terms of Use, available at https://lfprojects.org/policies/hosted-project-tools-terms-of-use/.
        Note that if your submission includes personal data associated with this signed artifact, it will be part of an immutable record.
        This may include the email address associated with the account with which you authenticate your contractual Agreement.
        This information will be used for signing this artifact and will be stored in public transparency logs and cannot be removed later, and is subject to the Immutable Record notice at https://lfprojects.org/policies/hosted-project-tools-immutable-records/.

By typing 'y', you attest that (1) you are not submitting the personal data of any other person; and (2) you understand and agree to the statement and the Agreement terms at the URLs listed above.
Are you sure you would like to continue? [y/N] y
tlog entry created with index: 738077532
Pushing signature to: index.docker.io/hodrick/kube-news-distroless
