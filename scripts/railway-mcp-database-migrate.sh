#!/bin/bash

# Script para automação da migração do banco de dados no Railway MCP
# Este script deve ser executado pelo Railway MCP durante o processo de deploy

set -e

echo "=== Iniciando migração do banco de dados no Railway MCP ==="

# Verificar se o script de migração existe
if [ ! -f "scripts/migrate-database.sh" ]; then
    echo "ERRO: Script de migração não encontrado em scripts/migrate-database.sh"
    exit 1
fi

# Tornar o script de migração executável
echo "Tornando o script de migração executável..."
chmod +x scripts/migrate-database.sh

# Verificar se o backup do banco de dados existe
BACKUP_FILE="backups/backup_antes_limpeza_20250910_111140.sql"
if [ ! -f "$BACKUP_FILE" ] && [ ! -f "rail_backups/backup_antes_limpeza_20250910_111140.sql" ]; then
    echo "AVISO: Arquivo de backup não encontrado em $BACKUP_FILE"
    echo "Criando diretório de backups..."
    mkdir -p backups
    
    echo "Por favor, faça o upload do backup do banco de dados para o Railway"
    echo "Você pode fazer isso usando o comando:"
    echo "railway run mkdir -p backups"
    echo "railway run scp /caminho/local/do/backup.sql backups/"
    
    # Se não houver backup, apenas executar as migrações do Laravel
    echo "Executando apenas as migrações do Laravel..."
    php artisan migrate --force
else
    if [ -f "$BACKUP_FILE" ]; then
        echo "Arquivo de backup encontrado em $BACKUP_FILE"
    else
        echo "Arquivo de backup encontrado em rail_backups/backup_antes_limpeza_20250910_111140.sql"
    fi
    
    # Executar o script de migração
    echo "Executando script de migração..."
    bash scripts/migrate-database.sh
fi

# Limpar cache após a migração
echo "Limpando cache após a migração..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Otimizar o banco de dados
echo "Otimizando o banco de dados..."
php artisan db:optimize

echo "=== Migração do banco de dados concluída com sucesso ==="