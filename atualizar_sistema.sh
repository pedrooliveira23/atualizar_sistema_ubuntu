#!/bin/bash

# Definindo o nome do arquivo de log com a data e hora atual
LOG_FILE="update_log_$(date +'%Y-%m-%d_%H-%M-%S').log"

# Diretório onde os logs serão armazenados (caminho relativo)
LOG_DIR="./update_logs"

# Criar o diretório de logs se não existir
mkdir -p "$LOG_DIR"

# Redirecionando toda a saída do script para o arquivo de log
exec > >(tee -a "$LOG_DIR/$LOG_FILE") 2>&1

echo "Atualizando a lista de pacotes..."
sudo /usr/bin/apt update

echo "Pacotes que podem ser atualizados:"
/usr/bin/apt list --upgradable

echo "Atualizando pacotes com apt..."
sudo /usr/bin/apt upgrade -y

echo "Verificando e atualizando pacotes do snap..."
sudo /usr/bin/snap refresh

echo "Removendo pacotes desnecessários..."
sudo /usr/bin/apt autoremove -y

echo "Atualização concluída!"

# Manter apenas os últimos 3 logs
cd "$LOG_DIR" || exit
ls -t update_log_*.log | tail -n +4 | xargs rm -f