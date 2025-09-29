#!/bin/bash

# Script principal para automação do Railway MCP
# Este script orquestra todas as etapas críticas de configuração e deploy no Railway

set -e

echo "=== Iniciando automação do Railway MCP ==="

# Verificar se o Railway CLI está instalado
if ! command -v railway &> /dev/null; then
    echo "ERRO: Railway CLI não encontrado. Instale o Railway CLI com: npm install -g @railway/cli"
    exit 1
fi

# Verificar se está logado no Railway
echo "Verificando se está logado no Railway..."
if ! railway whoami &> /dev/null; then
    echo "Por favor, faça login no Railway: railway login"
    exit 1
fi

# Verificar se o projeto está inicializado
echo "Verificando se o projeto está inicializado..."
if [ ! -f ".railway/project.json" ]; then
    echo "Inicializando o projeto no Railway..."
    railway init
fi

# 1. Configurar variáveis de ambiente
echo "=== 1. Configurando variáveis de ambiente ==="
chmod +x scripts/railway-mcp-env-config.sh
bash scripts/railway-mcp-env-config.sh

# 2. Configurar banco de dados e Redis
echo "=== 2. Configurando banco de dados e Redis ==="
chmod +x scripts/railway-mcp-database-setup.sh
bash scripts/railway-mcp-database-setup.sh

# 3. Executar o build
echo "=== 3. Executando o build ==="
chmod +x scripts/railway-mcp-build.sh
bash scripts/railway-mcp-build.sh

# 4. Fazer o deploy inicial
echo "=== 4. Fazendo o deploy inicial ==="
railway up

# 5. Migrar o banco de dados
echo "=== 5. Migrando o banco de dados ==="
chmod +x scripts/railway-mcp-database-migrate.sh
bash scripts/railway-mcp-database-migrate.sh

# 6. Substituir a instância problemática (opcional)
echo "=== 6. Verificando necessidade de substituir instância problemática ==="
read -p "Deseja substituir a instância problemática d9d6d330-c2ae-4cef-8063-5e4fe1cae5cc? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    chmod +x scripts/railway-mcp-replace-instance.sh
    bash scripts/railway-mcp-replace-instance.sh
fi

echo "=== Automação do Railway MCP concluída com sucesso ==="
echo ""
echo "Próximos passos:"
echo "1. Verifique se a aplicação está funcionando corretamente"
echo "2. Monitore os logs: railway logs"
echo "3. Verifique as métricas no dashboard do Railway"
echo "4. Configure as variáveis de ambiente restantes se necessário"