#!/bin/bash

# Script completo para deploy do projeto Laravel no Railway MCP
# Este script executa todas as etapas necessárias para o deploy

set -e

echo "=== Iniciando deploy completo do projeto Laravel no Railway MCP ==="

# 1. Configurar variáveis de ambiente
echo "1. Configurando variáveis de ambiente..."
bash scripts/railway-mcp-env-config.sh

# 2. Fazer o deploy do projeto
echo "2. Fazendo o deploy do projeto..."
railway up

# 3. Migrar o banco de dados
echo "3. Migrando o banco de dados..."
bash scripts/railway-mcp-database-migrate.sh

# 4. Substituir a instância problemática
echo "4. Substituindo a instância problemática..."
bash scripts/railway-mcp-replace-instance.sh

echo "=== Deploy completo concluído com sucesso ==="
