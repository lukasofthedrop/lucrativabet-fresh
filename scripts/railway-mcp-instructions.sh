#!/bin/bash

# Script com instruções para deploy no Railway MCP
# Este script fornece instruções passo a passo para o usuário seguir

set -e

echo "=== Instruções para Deploy no Railway MCP ==="

# Verificar se o Railway CLI está instalado
if ! command -v railway &> /dev/null; then
    echo "ERRO: Railway CLI não encontrado. Instale o Railway CLI com: npm install -g @railway/cli"
    exit 1
fi

# Tornar todos os scripts executáveis
echo "Tornando scripts executáveis..."
chmod +x scripts/railway-mcp-automation.sh
chmod +x scripts/railway-mcp-env-config.sh
chmod +x scripts/railway-mcp-database-setup.sh
chmod +x scripts/railway-mcp-build.sh
chmod +x scripts/railway-mcp-database-migrate.sh
chmod +x scripts/railway-mcp-replace-instance.sh

echo ""
echo "=== Instruções para Deploy no Railway MCP ==="
echo ""
echo "Siga estas etapas para fazer o deploy do projeto no Railway:"
echo ""
echo "1. Fazer login no Railway:"
echo "   railway login"
echo ""
echo "2. Inicializar o projeto no Railway:"
echo "   railway init"
echo ""
echo "3. Configurar variáveis de ambiente:"
echo "   bash scripts/railway-mcp-env-config.sh"
echo ""
echo "4. Configurar banco de dados e Redis:"
echo "   bash scripts/railway-mcp-database-setup.sh"
echo ""
echo "5. Executar o build:"
echo "   bash scripts/railway-mcp-build.sh"
echo ""
echo "6. Fazer o deploy inicial:"
echo "   railway up"
echo ""
echo "7. Migrar o banco de dados:"
echo "   bash scripts/railway-mcp-database-migrate.sh"
echo ""
echo "8. Substituir a instância problemática (se necessário):"
echo "   bash scripts/railway-mcp-replace-instance.sh"
echo ""
echo "Ou execute o script de automação completo após fazer login:"
echo "   bash scripts/railway-mcp-automation.sh"
echo ""
echo "Para mais informações, consulte o arquivo RAILWAY-MCP-GUIDE.md"
echo ""
echo "=== Fim das Instruções ==="
