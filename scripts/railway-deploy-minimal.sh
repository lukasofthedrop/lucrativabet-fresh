#!/bin/bash

# Script mínimo para deploy no Railway
# Este script deve ser executado localmente antes do deploy

set -e

echo "=== Preparando projeto para deploy no Railway (versão mínima) ==="

# Verificar se os arquivos necessários existem
if [ ! -f "railway.toml" ]; then
    echo "ERRO: Arquivo railway.toml não encontrado"
    exit 1
fi

if [ ! -f "Dockerfile" ]; then
    echo "ERRO: Arquivo Dockerfile não encontrado"
    exit 1
fi

if [ ! -f "env.railway.example" ]; then
    echo "ERRO: Arquivo env.railway.example não encontrado"
    exit 1
fi

# Verificar se o backup do banco de dados existe
if [ ! -f "rail_backups/backup_antes_limpeza_20250910_111140.sql" ]; then
    echo "ERRO: Backup do banco de dados não encontrado em rail_backups/backup_antes_limpeza_20250910_111140.sql"
    exit 1
fi

# Verificar se o Railway CLI está instalado
if ! command -v railway &> /dev/null; then
    echo "AVISO: Railway CLI não encontrado. Instale o Railway CLI para fazer o deploy."
    echo "Instalação: npm install -g @railway/cli"
fi

echo "=== Projeto preparado para deploy no Railway ==="
echo ""
echo "Próximos passos:"
echo "1. Faça login no Railway: railway login"
echo "2. Inicialize o projeto: railway init"
echo "3. Faça o upload do backup do banco de dados para o Railway"
echo "4. Execute o script de migração: railway run bash scripts/migrate-database.sh"
echo "5. Faça o deploy: railway up"
