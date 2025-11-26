package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	// Verifica se os argumentos foram passados (programa + entrada + formato)
	if len(os.Args) < 3 {
		fmt.Println("Uso: converter <arquivo_entrada> <formato_saida>")
		fmt.Println("Exemplo: converter video.mp4 avi")
		os.Exit(1)
	}

	inputFile := os.Args[1]
	outputFormat := os.Args[2]
	outputFile := fmt.Sprintf("output.%s", outputFormat)

	fmt.Printf("Iniciando conversão de '%s' para '%s'...\n", inputFile, outputFile)

	// Verifica se o arquivo de entrada existe
	if _, err := os.Stat(inputFile); os.IsNotExist(err) {
		fmt.Printf("Erro: O arquivo '%s' não foi encontrado!\n", inputFile)
		os.Exit(1)
	}

	// Executa o comando FFmpeg
	cmd := exec.Command("ffmpeg", "-i", inputFile, "-preset", "fast", outputFile)
	
	// Redireciona a saída do FFmpeg para o terminal
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		fmt.Println("Erro na conversão do arquivo.")
		os.Exit(1)
	}

	fmt.Printf("Conversão concluída com sucesso! Arquivo gerado: %s\n", outputFile)
}
