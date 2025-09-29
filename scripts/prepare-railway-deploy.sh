#!/bin/bash

# Script de preparação para deploy no Railway
# Este script deve ser executado localmente antes do deploy

set -e

echo "=== Preparando projeto para deploy no Railway ==="

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

# Verificar se os backups do banco de dados existem
BACKUP_DIR="/Users/rkripto/Downloads/lucrativabet-1"
if [ ! -f "$BACKUP_DIR/backup_antes_limpeza_20250910_111140.sql" ]; then
    echo "ERRO: Backup do banco de dados não encontrado em $BACKUP_DIR/backup_antes_limpeza_20250910_111140.sql"
    exit 1
fi

# Criar diretório para backups no projeto
mkdir -p rail_backups

# Copiar backup para o diretório do projeto
echo "Copiando backup do banco de dados..."
cp "$BACKUP_DIR/backup_antes_limpeza_20250910_111140.sql" rail_backups/

# Verificar se o cliente mysql está instalado
if ! command -v mysql &> /dev/null; then
    echo "AVISO: Cliente MySQL não encontrado. Instale o cliente MySQL para importar o banco de dados."
fi

# Verificar se o Railway CLI está instalado
if ! command -v railway &> /dev/null; then
    echo "AVISO: Railway CLI não encontrado. Instale o Railway CLI para fazer o deploy."
    echo "Instalação: npm install -g @railway/cli"
fi

# Verificar dependências do projeto
echo "Verificando dependências do projeto..."
if [ ! -f "composer.json" ]; then
    echo "ERRO: Arquivo composer.json não encontrado"
    exit 1
fi

if [ ! -f "package.json" ]; then
    echo "ERRO: Arquivo package.json não encontrado"
    exit 1
fi

# Instalar dependências do PHP
echo "Instalando dependências do PHP..."
composer install --no-dev --optimize-autoloader

# Instalar dependências do Node.js
echo "Instalando dependências do Node.js..."
npm ci

# Compilar assets
echo "Compilando assets..."
npm run build

# Limpar cache
echo "Limpando cache..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Otimizar autoloader
echo "Otimizando autoloader..."
composer dump-autoload --optimize

echo "=== Projeto preparado para deploy no Railway ==="
echo ""
echo "Próximos passos:"
echo "1. Faça login no Railway: railway login"
echo "2. Inicialize o projeto: railway init"
echo "3. Faça o upload do backup do banco de dados para o Railway"
echo "4. Execute o script de migração: railway run bash scripts/migrate-database.sh"
echo "5. Faça o deploy: railway up"