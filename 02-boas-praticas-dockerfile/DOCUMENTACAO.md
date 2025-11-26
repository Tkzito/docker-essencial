# 📚 Documentação do Projeto Docker

Este documento explica a função de cada arquivo neste projeto e como eles interagem para criar nossa aplicação containerizada.

## 1. `app.py` (A Aplicação)
Este é o código-fonte da nossa aplicação Python.
- **O que faz**: Utiliza o framework **FastAPI** para criar um servidor web simples.
- **Conteúdo**: Define uma rota raiz (`/`) que retorna uma mensagem JSON `{"message": "Hello, FastAPI with Docker!"}`.
- **Execução**: É executado pelo servidor `uvicorn` (definido no Dockerfile).

## 2. `requirements.txt` (As Dependências)
Lista todas as bibliotecas externas que o Python precisa para rodar o `app.py`.
- **Importância**: Garante que o ambiente dentro do Docker tenha exatamente as mesmas versões das bibliotecas que você usou no desenvolvimento.
- **Principais itens**:
  - `fastapi`: O framework web usado no código.
  - `uvicorn`: O servidor ASGI que roda a aplicação FastAPI.
- **Uso no Docker**: É lido pelo comando `pip install -r requirements.txt` para instalar tudo automaticamente.

## 3. `Dockerfile` (A Receita da Imagem)
É o manual de instruções que o Docker usa para construir a imagem da sua aplicação. Pense nele como uma receita de bolo.

### Passo a Passo Explicado:

1.  **`FROM python:3.12-slim`**
    *   **Base**: Começa com um sistema Linux mínimo que já tem o Python 3.12 instalado.
    *   **Por que Slim?**: É muito mais leve (~150MB) que a imagem padrão (~1GB), economizando espaço e internet.

2.  **`WORKDIR /app`**
    *   **Organização**: Cria e entra na pasta `/app` dentro do container. Tudo o que fizermos a seguir acontecerá lá dentro.

3.  **`COPY requirements.txt .`**
    *   **Estratégia**: Copia *apenas* a lista de dependências primeiro.
    *   **Cache**: Isso permite que o Docker memorize (cache) a instalação das bibliotecas. Se você mudar só o código (`app.py`), ele não precisa reinstalar tudo de novo.

4.  **`RUN pip install ...`**
    *   **Instalação**: Baixa e instala o FastAPI, Uvicorn, etc.
    *   **Otimização**: Usamos `--no-cache-dir` para não guardar arquivos temporários de download, mantendo a imagem pequena.

5.  **`COPY . .`**
    *   **Código**: Agora sim, copia o `app.py` e outros arquivos do projeto para dentro do container.

6.  **`RUN useradd ... USER appuser`**
    *   **Segurança**: Cria um usuário comum (`appuser`) e troca para ele.
    *   **Por que?**: Rodar como `root` (administrador) é perigoso. Se alguém invadir o container, teria poder total. Com usuário comum, o dano é limitado.

7.  **`CMD ["uvicorn", ...]`**
    *   **Start**: O comando final que faz a aplicação rodar quando você dá `docker run`. Ele inicia o servidor na porta 8000.
