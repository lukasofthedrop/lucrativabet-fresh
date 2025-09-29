#!/bin/bash

# Script de migração do banco de dados para Railway
# Este script deve ser executado no ambiente Railway após o deploy

set -e

echo "=== Iniciando migração do banco de dados ==="

# Verificar se os backups estão disponíveis
BACKUP_DIR="/app/backups"
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Criando diretório de backups..."
    mkdir -p "$BACKUP_DIR"
fi

# Verificar se o arquivo de backup existe
BACKUP_FILE="$BACKUP_DIR/backup_antes_limpeza_20250910_111140.sql"
if [ ! -f "$BACKUP_FILE" ] && [ ! -f "rail_backups/backup_antes_limpeza_20250910_111140.sql" ]; then
    echo "AVISO: Arquivo de backup não encontrado em $BACKUP_FILE"
    echo "Por favor, faça o upload do backup do banco de dados para o Railway"
    exit 1
fi

# Aguardar o banco de dados estar disponível
echo "Aguardando o banco de dados estar disponível..."
until php artisan db:show 2>/dev/null; do
    echo "Aguardando o banco de dados..."
    sleep 5
done

# Importar o backup
if [ -f "$BACKUP_FILE" ]; then
    echo "Importando backup do banco de dados de $BACKUP_FILE..."
    mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USERNAME}" -p"${DB_PASSWORD}" "${DB_DATABASE}" < "$BACKUP_FILE"
else
    echo "Importando backup do banco de dados de rail_backups/backup_antes_limpeza_20250910_111140.sql..."
    mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USERNAME}" -p"${DB_PASSWORD}" "${DB_DATABASE}" < "rail_backups/backup_antes_limpeza_20250910_111140.sql"
fi

# Executar migrações do Laravel
echo "Executando migrações do Laravel..."
php artisan migrate --force

# Limpar cache
echo "Limpando cache..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Otimizar o banco de dados
echo "Otimizando o banco de dados..."
php artisan db:optimize

echo "=== Migração do banco de dados concluída ==="