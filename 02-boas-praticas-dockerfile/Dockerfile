# 1. BOAS PRÁTICAS: IMAGEM BASE
# Usamos uma versão específica (3.12) e a variante 'slim' em vez de 'latest'.
# - 'slim': Imagem muito menor (reduz de ~1GB para ~150MB), mais segura (menos vulnerabilidades) e rápida para baixar/construir.
# - Versão fixa (3.12): Garante que o ambiente seja sempre o mesmo, evitando quebras se o Python atualizar.
FROM python:3.12-slim

# 2. BOAS PRÁTICAS: DIRETÓRIO DE TRABALHO
# Define o diretório onde os comandos serão executados.
# Isso organiza os arquivos da aplicação em um lugar específico, evitando misturar com arquivos do sistema raiz.
WORKDIR /app

# 3. BOAS PRÁTICAS: CACHE DE CAMADAS (LAYER CACHING)
# Copiamos APENAS o requirements.txt primeiro.
# Por que? O Docker faz cache de cada linha. Se copiarmos tudo (COPY . .), qualquer alteração no código
# invalidaria o cache do 'pip install', fazendo o build demorar muito mais.
# Copiando só o requirements antes, o Docker reutiliza o cache da instalação se as dependências não mudaram.
COPY requirements.txt .

# 4. BOAS PRÁTICAS: INSTALAÇÃO DE DEPENDÊNCIAS
# --no-cache-dir: Não salva o cache do pip na imagem, reduzindo o tamanho final.
# --upgrade: Garante que o pip esteja atualizado.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 5. BOAS PRÁTICAS: CÓDIGO FONTE
# Agora sim copiamos o restante do código.
# Como essa linha muda frequentemente (sempre que você edita o código), ela fica DEPOIS das dependências pesadas.
COPY . .

# 6. BOAS PRÁTICAS: USUÁRIO NÃO-ROOT (SEGURANÇA)
# Por padrão o container roda como root. Criar um usuário comum limita o impacto caso o container seja invadido.
# Aqui criamos um usuário 'appuser' e mudamos para ele.
RUN useradd -m appuser
USER appuser

# 7. BOAS PRÁTICAS: COMANDO DE INICIALIZAÇÃO
# Usamos o formato JSON ["exec", "param"] (exec form) em vez de string (shell form).
# Isso garante que o processo receba sinais do sistema (como SIGTERM para parar graciosamente).
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
