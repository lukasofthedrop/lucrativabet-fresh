#!/bin/bash

# Script para configuração automática das variáveis de ambiente no Railway MCP
# Este script deve ser executado pelo Railway MCP durante o processo de deploy

set -e

echo "=== Configurando variáveis de ambiente no Railway MCP ==="

# Variáveis de ambiente críticas do arquivo .env.railway.example
ENV_VARS=(
    "APP_NAME=LucrativaBet"
    "APP_ENV=production"
    "APP_DEBUG=false"
    "LOG_CHANNEL=stack"
    "LOG_LEVEL=error"
    "APP_ROLE=web"
    "RUN_MIGRATIONS=1"
    "SCHEDULER_INTERVAL=60"
    "QUEUE_WORK_OPTIONS=--sleep=3 --tries=3 --max-time=3600"
    "DB_CONNECTION=mysql"
    "CACHE_DRIVER=redis"
    "SESSION_DRIVER=redis"
    "QUEUE_CONNECTION=redis"
    "REDIS_CLIENT=phpredis"
    "REDIS_PREFIX=lucrativabet_"
    "FILESYSTEM_DISK=s3"
    "AWS_DEFAULT_REGION=auto"
    "AWS_BUCKET=lucrativa-storage"
    "AWS_USE_PATH_STYLE_ENDPOINT=true"
    "MAIL_MAILER=smtp"
    "MAIL_PORT=587"
    "MAIL_ENCRYPTION=tls"
    "MAIL_FROM_ADDRESS=no-reply@lucrativabet.com"
    "MAIL_FROM_NAME=LucrativaBet"
    "VIEW_COMPILED_PATH=/tmp/views"
    "CACHE_STORE=redis"
    "CREATE_TEST_USERS_ON_BOOT=0"
    "USE_CUSTOM_AFFILIATE_PANEL=false"
)

# Configurar variáveis de ambiente no Railway MCP
echo "Configurando variáveis de ambiente..."
for var in "${ENV_VARS[@]}"; do
    key="${var%%=*}"
    value="${var#*=}"
    
    # Pular variáveis que serão definidas pelo Railway (MYSQL*, REDIS*)
    if [[ $key == MYSQL* ]] || [[ $key == REDIS* ]]; then
        echo "Pulando variável $key (será definida automaticamente pelo Railway)"
        continue
    fi
    
    # Configurar variável de ambiente
    echo "Configurando $key..."
    railway variable set "$key"="$value"
done

# Configurar variáveis de ambiente específicas para o banco de dados
echo "Configurando variáveis de ambiente do banco de dados..."
railway variable set "DB_HOST"="\${{MYSQLHOST}}"
railway variable set "DB_PORT"="\${{MYSQLPORT}}"
railway variable set "DB_DATABASE"="\${{MYSQLDATABASE}}"
railway variable set "DB_USERNAME"="\${{MYSQLUSER}}"
railway variable set "DB_PASSWORD"="\${{MYSQLPASSWORD}}"

# Configurar variáveis de ambiente para o Redis
echo "Configurando variáveis de ambiente do Redis..."
railway variable set "REDIS_HOST"="\${{REDISHOST}}"
railway variable set "REDIS_PASSWORD"="\${{REDISPASSWORD}}"
railway variable set "REDIS_PORT"="\${{REDISPORT}}"

# Configurar variáveis de ambiente para o Cloudflare R2
echo "Configurando variáveis de ambiente do Cloudflare R2..."
railway variable set "AWS_ACCESS_KEY_ID"="\${{AWS_ACCESS_KEY_ID}}"
railway variable set "AWS_SECRET_ACCESS_KEY"="\${{AWS_SECRET_ACCESS_KEY}}"
railway variable set "AWS_ENDPOINT"="\${{AWS_ENDPOINT}}"
railway variable set "CDN_URL"="\${{CDN_URL}}"

# Configurar variáveis de ambiente para o JWT
echo "Configurando variáveis de ambiente do JWT..."
railway variable set "JWT_SECRET"="UEG52HCZ4N8WKDQMNX7VLIP3J9C8A2NNB78PTFQ3E1LK4VPNIMOP5X8YMGD1PXWB"

# Configurar variáveis de ambiente para o Vite
echo "Configurando variáveis de ambiente do Vite..."
railway variable set "VITE_BASE_URL"="\${{RAILWAY_PUBLIC_DOMAIN}}"
railway variable set "VITE_APP_NAME"="LucrativaBet"
railway variable set "VITE_STRIPE_KEY"=""

echo "=== Variáveis de ambiente configuradas com sucesso ==="