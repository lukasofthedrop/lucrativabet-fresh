#!/bin/bash

# Script para automação da criação do banco de dados MySQL no Railway MCP
# Este script deve ser executado pelo Railway MCP durante o processo de deploy

set -e

echo "=== Configurando banco de dados MySQL no Railway MCP ==="

# Verificar se o serviço MySQL está disponível
echo "Verificando se o serviço MySQL está disponível..."
if ! railway service list | grep -q "MySQL"; then
    echo "Adicionando serviço MySQL..."
    railway service add mysql
fi

# Aguardar o serviço MySQL estar pronto
echo "Aguardando o serviço MySQL estar pronto..."
sleep 10

# Obter as variáveis de ambiente do MySQL
echo "Obtendo variáveis de ambiente do MySQL..."
MYSQL_HOST=$(railway variable get MYSQLHOST)
MYSQL_PORT=$(railway variable get MYSQLPORT)
MYSQL_DATABASE=$(railway variable get MYSQLDATABASE)
MYSQL_USER=$(railway variable get MYSQLUSER)
MYSQL_PASSWORD=$(railway variable get MYSQLPASSWORD)

# Verificar se as variáveis de ambiente do MySQL foram obtidas
if [ -z "$MYSQL_HOST" ] || [ -z "$MYSQL_PORT" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "ERRO: Não foi possível obter as variáveis de ambiente do MySQL"
    exit 1
fi

# Configurar variáveis de ambiente do banco de dados
echo "Configurando variáveis de ambiente do banco de dados..."
railway variable set "DB_HOST"="\${{MYSQLHOST}}"
railway variable set "DB_PORT"="\${{MYSQLPORT}}"
railway variable set "DB_DATABASE"="\${{MYSQLDATABASE}}"
railway variable set "DB_USERNAME"="\${{MYSQLUSER}}"
railway variable set "DB_PASSWORD"="\${{MYSQLPASSWORD}}"

# Verificar se o serviço Redis está disponível
echo "Verificando se o serviço Redis está disponível..."
if ! railway service list | grep -q "Redis"; then
    echo "Adicionando serviço Redis..."
    railway service add redis
fi

# Aguardar o serviço Redis estar pronto
echo "Aguardando o serviço Redis estar pronto..."
sleep 5

# Obter as variáveis de ambiente do Redis
echo "Obtendo variáveis de ambiente do Redis..."
REDIS_HOST=$(railway variable get REDISHOST)
REDIS_PORT=$(railway variable get REDISPORT)
REDIS_PASSWORD=$(railway variable get REDISPASSWORD)

# Verificar se as variáveis de ambiente do Redis foram obtidas
if [ -z "$REDIS_HOST" ] || [ -z "$REDIS_PORT" ] || [ -z "$REDIS_PASSWORD" ]; then
    echo "ERRO: Não foi possível obter as variáveis de ambiente do Redis"
    exit 1
fi

# Configurar variáveis de ambiente do Redis
echo "Configurando variáveis de ambiente do Redis..."
railway variable set "REDIS_HOST"="\${{REDISHOST}}"
railway variable set "REDIS_PORT"="\${{REDISPORT}}"
railway variable set "REDIS_PASSWORD"="\${{REDISPASSWORD}}"

echo "=== Banco de dados MySQL e Redis configurados com sucesso ==="