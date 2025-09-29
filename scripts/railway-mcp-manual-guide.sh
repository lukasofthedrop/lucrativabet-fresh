#!/bin/bash

# Script para guiar o usuário através do processo manual de deploy no Railway MCP
# Este script fornece instruções passo a passo para o usuário seguir

set -e

echo "=== Guia para Deploy Manual no Railway MCP ==="

# Verificar se o Railway CLI está instalado
if ! command -v railway &> /dev/null; then
    echo "ERRO: Railway CLI não encontrado. Instale o Railway CLI com: npm install -g @railway/cli"
    exit 1
fi

# Verificar se está logado no Railway
echo "Verificando se está logado no Railway..."
if ! railway whoami &> /dev/null; then
    echo "Você não está logado no Railway."
    echo "Por favor, execute o seguinte comando para fazer login:"
    echo "railway login"
    echo ""
    echo "Após fazer login, execute este script novamente."
    exit 1
fi

echo "Login no Railway bem-sucedido!"

# Verificar se o projeto está inicializado
echo "Verificando se o projeto está inicializado..."
if [ ! -f ".railway/project.json" ]; then
    echo "O projeto não está inicializado no Railway."
    echo "Por favor, execute o seguinte comando para inicializar o projeto:"
    echo "railway init"
    echo ""
    echo "Após inicializar o projeto, execute este script novamente."
    exit 1
fi

echo "Projeto inicializado no Railway!"

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
echo "1. Configurar variáveis de ambiente:"
echo "   bash scripts/railway-mcp-env-config.sh"
echo ""
echo "2. Configurar banco de dados e Redis:"
echo "   bash scripts/railway-mcp-database-setup.sh"
echo ""
echo "3. Executar o build:"
echo "   bash scripts/railway-mcp-build.sh"
echo ""
echo "4. Fazer o deploy inicial:"
echo "   railway up"
echo ""
echo "5. Migrar o banco de dados:"
echo "   bash scripts/railway-mcp-database-migrate.sh"
echo ""
echo "6. Substituir a instância problemática (se necessário):"
echo "   bash scripts/railway-mcp-replace-instance.sh"
echo ""
echo "Ou execute o script de automação completo:"
echo "   bash scripts/railway-mcp-automation.sh"
echo ""
echo "Para mais informações, consulte o arquivo RAILWAY-MCP-GUIDE.md"
echo ""
echo "=== Fim do Guia ==="
