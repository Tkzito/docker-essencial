# Relatório de Resolução de Problemas - Auditoria de Segurança

Este documento registra os desafios encontrados durante a auditoria de dependências do projeto **Kube News** e as soluções aplicadas.

## 1. Erro de Permissão no `npm install`
**Problema:** Ao tentar rodar `npm install` localmente, ocorreu erro `EACCES` (permissão negada), pois a pasta `node_modules` provavelmente pertencia ao root ou houve conflito de permissões.
**Solução:** Utilizamos um container Docker temporário para realizar a instalação de forma isolada, mapeando o diretório atual.
**Comando Utilizado:**
```bash
cd src
docker run --rm -v "$(pwd)":/app -w /app node:18-alpine npm install
```

## 2. Erro `package.json not found`
**Problema:** O comando Docker foi executado na raiz do projeto (`kube-news`), mas o arquivo de dependências estava dentro da pasta `src`.
**Solução:** Navegamos para o diretório correto antes de executar o comando.
**Ação:**
```bash
cd src
```

## 3. Plugin Docker Scout Ausente
**Problema:** O comando `docker scout` retornou `unknown command`, indicando que o plugin não estava instalado no ambiente Linux (ele vem padrão apenas no Docker Desktop).
**Solução:** Instalação manual do plugin via script oficial.
**Comando Utilizado:**
```bash
curl -fsSL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh
```

## 4. Erro de Sintaxe `unknown flag: --format`
**Problema:** Tentativa de usar `--format sarif` com o subcomando `fs` (`docker scout fs`), que não suporta essa flag diretamente ou tem sintaxe diferente para relatórios.
**Solução:** Ajuste para o comando correto `cves` apontando para o sistema de arquivos (`fs://.`).
**Comando Correto:**
```bash
docker scout cves fs://. --format sarif --output vulnerabilities-report.sarif
```

## 5. Autenticação Necessária
**Problema:** O Docker Scout exigiu login no Docker Hub para acessar a base de vulnerabilidades.
**Solução:** Autenticação via terminal.
**Comando Utilizado:**
```bash
docker login
```

---
**Resultado Final:**
Relatório de vulnerabilidades gerado com sucesso em `src/vulnerabilities-report.sarif`.
