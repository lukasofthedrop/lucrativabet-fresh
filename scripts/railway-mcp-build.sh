#!/bin/bash

# Script para automação do processo de build no Railway MCP
# Este script deve ser executado pelo Railway MCP durante o processo de build

set -e

echo "=== Iniciando processo de build no Railway MCP ==="

# Verificar se as dependências do PHP estão instaladas
echo "Verificando dependências do PHP..."
if [ ! -f "composer.json" ]; then
    echo "ERRO: Arquivo composer.json não encontrado"
    exit 1
fi

# Verificar se as dependências do Node.js estão instaladas
echo "Verificando dependências do Node.js..."
if [ ! -f "package.json" ]; then
    echo "ERRO: Arquivo package.json não encontrado"
    exit 1
fi

# Instalar dependências do PHP
echo "Instalando dependências do PHP..."
composer install --no-dev --prefer-dist --no-interaction --no-progress --optimize-autoloader

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

# Verificar se o arquivo .env existe
if [ ! -f ".env" ]; then
    echo "Criando arquivo .env..."
    cp .env.example .env
fi

# Gerar chave da aplicação se necessário
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:" ]; then
    echo "Gerando chave da aplicação..."
    php artisan key:generate --force --no-interaction
fi

# Configurar permissões
echo "Configurando permissões..."
chmod -R 755 storage bootstrap/cache

# Criar link simbólico para storage
echo "Criando link simbólico para storage..."
php artisan storage:link

echo "=== Processo de build concluído com sucesso ==="