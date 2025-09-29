#!/bin/bash

# Script para iniciar o processo de automação do Railway MCP
# Este script verifica se o usuário está logado no Railway e inicia o processo de automação

set -e

echo "=== Iniciando processo de automação do Railway MCP ==="

# Verificar se o Railway CLI está instalado
if ! command -v railway &> /dev/null; then
    echo "ERRO: Railway CLI não encontrado. Instale o Railway CLI com: npm install -g @railway/cli"
    exit 1
fi

# Verificar se está logado no Railway
echo "Verificando se está logado no Railway..."
if ! railway whoami &> /dev/null; then
    echo "Por favor, faça login no Railway:"
    railway login
fi

# Verificar se o login foi bem-sucedido
if ! railway whoami &> /dev/null; then
    echo "ERRO: Falha ao fazer login no Railway. Por favor, tente novamente."
    exit 1
fi

echo "Login no Railway bem-sucedido!"

# Tornar o script de automação executável
echo "Tornando o script de automação executável..."
chmod +x scripts/railway-mcp-automation.sh

# Perguntar se deseja executar o script de automação
read -p "Deseja executar o script de automação do Railway MCP agora? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo "Executando script de automação do Railway MCP..."
    bash scripts/railway-mcp-automation.sh
else
    echo "Você pode executar o script de automação mais tarde com: bash scripts/railway-mcp-automation.sh"
fi

echo "=== Processo de inicialização do Railway MCP concluído ==="
