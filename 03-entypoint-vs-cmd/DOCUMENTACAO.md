# 📚 Documentação do Conversor de Vídeos (ENTRYPOINT vs CMD)

Este projeto demonstra como criar um container Docker que funciona como uma ferramenta de linha de comando (CLI) para converter vídeos usando FFmpeg.

## 1. `convert.sh` (O Script de Automação)
Este script Shell é o "cérebro" da operação.
- **Função**: Recebe um arquivo de vídeo e um formato de saída, e usa o FFmpeg para converter.
- **Lógica**:
  1. Verifica se recebeu 2 argumentos (entrada e formato). Se não, mostra ajuda e sai.
  2. Verifica se o arquivo de entrada existe.
  3. Executa o comando `ffmpeg` para converter.
- **Uso**: `./convert.sh video.mp4 avi`

## 2. `Dockerfile` (A Receita da Imagem)
Configura o ambiente para rodar o script.

### Destaque: ENTRYPOINT vs CMD
A grande lição deste exercício é a combinação dessas duas instruções:

*   **`ENTRYPOINT ["./convert.sh"]`**: Define que este container **SEMPRE** rodará esse script. Ele não vai rodar um bash ou sh interativo por padrão, ele "é" o script de conversão.
*   **`CMD ["--help"]`**: Define o argumento **padrão**.
    *   Se você rodar sem argumentos, o Docker junta os dois: `./convert.sh --help`. O script recebe `--help`, vê que não são 2 argumentos válidos e mostra a mensagem de uso.
    *   Se você rodar COM argumentos (`video.mp4 avi`), o Docker substitui o CMD e executa: `./convert.sh video.mp4 avi`.

## 3. `compose.yaml` (Orquestração)
Facilita o uso da imagem.
- **Volumes**: Mapeia a pasta atual (`.`) para `/app/data`.
    - **Por que?** Para que o container consiga ler os vídeos que estão no seu computador e salvar o resultado de volta na sua pasta. Sem isso, o vídeo convertido ficaria preso dentro do container e seria perdido ao sair.

## 🚀 Como Usar

1.  **Ver a ajuda (Comportamento Padrão)**:
    ```bash
    docker compose run video-converter
    ```
    *O que acontece*: Executa `./convert.sh --help`.

2.  **Converter um vídeo**:
    Coloque um arquivo (ex: `meu-video.mp4`) nesta pasta e rode:
    ```bash
    docker compose run video-converter meu-video.mp4 avi
    ```
    *O que acontece*: Executa `./convert.sh meu-video.mp4 avi`.
