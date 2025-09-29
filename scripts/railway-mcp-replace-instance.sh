#!/bin/bash

# Script para substituir a instância problemática no Railway MCP
# ID da instância problemática: d9d6d330-c2ae-4cef-8063-5e4fe1cae5cc
# Este script deve ser executado pelo Railway MCP após o deploy bem-sucedido

set -e

echo "=== Iniciando processo de substituição da instância problemática ==="

# ID da instância problemática
PROBLEMATIC_INSTANCE_ID="d9d6d330-c2ae-4cef-8063-5e4fe1cae5cc"

# Verificar se a instância problemática existe
echo "Verificando se a instância problemática existe..."
if railway service list | grep -q "$PROBLEMATIC_INSTANCE_ID"; then
    echo "Instância problemática encontrada: $PROBLEMATIC_INSTANCE_ID"
    
    # Obter o nome da instância problemática
    INSTANCE_NAME=$(railway service list | grep "$PROBLEMATIC_INSTANCE_ID" | awk '{print $2}')
    echo "Nome da instância problemática: $INSTANCE_NAME"
    
    # Obter a URL da instância problemática
    INSTANCE_URL=$(railway domain list | grep "$PROBLEMATIC_INSTANCE_ID" | awk '{print $2}')
    echo "URL da instância problemática: $INSTANCE_URL"
    
    # Remover a instância problemática
    echo "Removendo a instância problemática..."
    railway service remove "$PROBLEMATIC_INSTANCE_ID"
    
    echo "Instância problemática removida com sucesso"
else
    echo "AVISO: Instância problemática não encontrada: $PROBLEMATIC_INSTANCE_ID"
fi

# Criar uma nova instância
echo "Criando uma nova instância..."
railway service add web

# Obter o ID da nova instância
NEW_INSTANCE_ID=$(railway service list | tail -n 1 | awk '{print $1}')
echo "ID da nova instância: $NEW_INSTANCE_ID"

# Obter a URL da nova instância
NEW_INSTANCE_URL=$(railway domain list | tail -n 1 | awk '{print $2}')
echo "URL da nova instância: $NEW_INSTANCE_URL"

# Configurar as variáveis de ambiente para a nova instância
echo "Configurando variáveis de ambiente para a nova instância..."
railway variable set "APP_URL"="$NEW_INSTANCE_URL"
railway variable set "VITE_BASE_URL"="$NEW_INSTANCE_URL"

# Atualizar o arquivo railway.toml com a nova URL
echo "Atualizando o arquivo railway.toml com a nova URL..."
sed -i.bak "s|VITE_BASE_URL = .*|VITE_BASE_URL = \"$NEW_INSTANCE_URL\"|g" railway.toml

# Fazer o deploy da nova instância
echo "Fazendo o deploy da nova instância..."
railway up

echo "=== Instância substituída com sucesso ==="
echo "Nova URL: $NEW_INSTANCE_URL"
echo "ID da nova instância: $NEW_INSTANCE_ID"