# 🔒 Desafio 07: Geração do SBOM (Software Bill of Materials)

## 🎯 Missão

Gerar um SBOM detalhado da imagem Docker do **Kube News** para garantir transparência e rastreabilidade sobre os componentes e dependências presentes na imagem. O relatório deveria ser gerado no formato JSON, utilizando a ferramenta **Docker Scout**, e salvo no arquivo `sbom-report.json`.

---

## ⚙️ Contexto de Execução

**Sistema Operacional:** BigLinux (Baseado em Arch/Manjaro).

### 💡 Problema e Solução Encontrada

Devido à arquitetura do ambiente e possíveis incompatibilidades de versões, a ferramenta nativa **Docker Scout** (acessada via `docker scout`) não estava funcional, resultando em erros.

A solução foi utilizar uma ferramenta *open source* e padrão da indústria que realiza a mesma função com alta precisão: o **Syft**.

### 🛠️ Construção Detalhada da Imagem Kube-News

A imagem foi construída utilizando um `Dockerfile` de outro módulo, resultando numa imagem que, embora não seja funcional como aplicação Node.js (por ter o Nginx como base), pôde ser catalogada para o desafio do SBOM.

1.  **Comando de Build Executado (na raiz do repositório):**

    ```bash
    docker build -t kube-news:latest -f 01-primeiro-dockerfile/Dockerfile 01-identificando-vulnerabilidades/kube-news
    ```
    * `-t kube-news:latest`: Define a tag para a imagem final.
    * `-f 01-primeiro-dockerfile/Dockerfile`: **Define o caminho para o Dockerfile a ser usado.**
    * `01-identificando-vulnerabilidades/kube-news`: **Define o contexto de build.** Esta pasta, que contém o código-fonte da aplicação Node.js (Kube News), foi enviada ao Docker Daemon.

2.  **Instruções do Dockerfile (`01-primeiro-dockerfile/Dockerfile`):**

    | Linha | Instrução                 | Observação Crítica                                      |
    | :---- | :------------------------ | :------------------------------------------------------ |
    | 1     | `FROM nginx:alpine`       | Imagem base de um servidor web estático (Nginx), e não Node.js. |
    | 3     | `COPY . /usr/share/nginx/html/` | O código Node.js do Kube News foi copiado para o diretório de arquivos estáticos do Nginx. |

3.  **Resultado da Construção:**
    A imagem **`kube-news:latest`** foi criada com sucesso, contendo o ambiente Nginx (as dependências catalogadas pelo Syft) e os arquivos-fonte do Kube News.

### 🛠️ Geração do SBOM com Syft

1.  **Instalação do Syft (BigLinux/Arch):**
    ```bash
    yay -S syft
    ```

2.  **Geração do SBOM:**
    O SBOM foi gerado analisando a imagem recém-construída no formato **CycloneDX JSON**.

    ```bash
    syft kube-news:latest -o cyclonedx-json > sbom-report.json
    ```

---

## ✅ Entrega

O arquivo `sbom-report.json` contém o SBOM completo da imagem `kube-news:latest`.

---

### 4. Salvar e Enviar para o GitHub

Após salvar o conteúdo no `README.md` (`Ctrl + O`, `Enter` e depois `Ctrl + X`):

1.  **Voltar para a raiz do repositório:**
    ```bash
    cd ..
    ```

2.  **Adicionar todas as alterações (incluindo o README.md e o sbom-report.json):**
    ```bash
    git add 07-seguranca-sbom/
    ```

3.  **Criar o commit:**
    ```bash
    git commit -m "Desafio 07: Adiciona SBOM e documentação detalhada da solução (Syft) e processo de build"
    ```

4.  **Enviar para o GitHub (Push):**
    ```bash
    git push
    ```

**Pronto! Seu repositório estará atualizado com todos os detalhes necessários.**
