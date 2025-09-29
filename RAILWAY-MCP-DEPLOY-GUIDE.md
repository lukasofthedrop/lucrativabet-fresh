# Guia de Deploy do LucrativaBet usando Railway MCP

## Pré-requisitos

1. Conta no Railway com acesso ao projeto
2. Railway CLI instalado e configurado com autenticação
3. Backup do banco de dados disponível em `backups/backup_antes_limpeza_20250910_111140.sql`

## Configuração do Projeto

O projeto já está configurado com os seguintes arquivos:

- `railway.toml`: Configuração do build e deploy
- `nixpacks.toml`: Configuração do ambiente PHP
- `docker-entrypoint.sh`: Script de inicialização do container
- `docker/supervisord.conf`: Configuração do supervisord para gerenciar serviços
- `.railwayignore`: Arquivos a serem ignorados no deploy

## Scripts de Automação

O projeto inclui os seguintes scripts para automação do deploy:

### 1. Configuração de Variáveis de Ambiente

- `scripts/railway-mcp-env-config.sh`: Configura as variáveis de ambiente no Railway
- `scripts/railway-mcp-env-config-mcp.sh`: Versão para Railway MCP (exibe apenas as variáveis)

### 2. Scripts de Banco de Dados

- `scripts/migrate-database.sh`: Executa a migração do banco de dados
- `scripts/railway-mcp-database-migrate.sh`: Script para Railway MCP que executa a migração

### 3. Scripts de Deploy

- `scripts/railway-mcp-full-deploy.sh`: Script completo de deploy (requer Railway CLI autenticado)
- `scripts/railway-mcp-full-deploy-mcp.sh`: Versão para Railway MCP (simulação apenas)

### 4. Script de Substituição de Instância

- `scripts/railway-mcp-replace-instance.sh`: Substitui a instância problemática

## Passos para o Deploy

### Usando o Railway CLI (recomendado)

1. Faça login no Railway CLI:
   ```bash
   railway login
   ```

2. Navegue até o diretório do projeto:
   ```bash
   cd /Users/rkripto/Downloads/lucrativabet-1
   ```

3. Execute o script completo de deploy:
   ```bash
   bash scripts/railway-mcp-full-deploy.sh
   ```

### Usando o Railway MCP

1. Navegue até o diretório do projeto:
   ```bash
   cd /Users/rkripto/Downloads/lucrativabet-1
   ```

2. Execute o script de configuração de variáveis de ambiente:
   ```bash
   bash scripts/railway-mcp-env-config-mcp.sh
   ```

3. Copie as variáveis de ambiente exibidas e configure-as manualmente no painel do Railway

4. Faça o deploy usando o painel do Railway ou o Railway CLI com autenticação

5. Execute a migração do banco de dados usando o painel do Railway ou o Railway CLI com autenticação

6. Execute o script de substituição de instância usando o painel do Railway ou o Railway CLI com autenticação

## Variáveis de Ambiente Necessárias

### Variáveis Básicas

- `APP_NAME=LucrativaBet`
- `APP_ENV=production`
- `APP_DEBUG=false`
- `LOG_CHANNEL=stack`
- `LOG_LEVEL=error`
- `APP_ROLE=web`
- `RUN_MIGRATIONS=1`
- `SCHEDULER_INTERVAL=60`

### Banco de Dados

- `DB_CONNECTION=mysql`
- `DB_HOST=${{MYSQLHOST}}`
- `DB_PORT=${{MYSQLPORT}}`
- `DB_DATABASE=${{MYSQLDATABASE}}`
- `DB_USERNAME=${{MYSQLUSER}}`
- `DB_PASSWORD=${{MYSQLPASSWORD}}`

### Cache e Sessões

- `CACHE_DRIVER=redis`
- `SESSION_DRIVER=redis`
- `QUEUE_CONNECTION=redis`
- `REDIS_CLIENT=phpredis`
- `REDIS_HOST=${{REDISHOST}}`
- `REDIS_PASSWORD=${{REDISPASSWORD}}`
- `REDIS_PORT=${{REDISPORT}}`
- `REDIS_PREFIX=lucrativabet_`

### Armazenamento de Arquivos

- `FILESYSTEM_DISK=s3`
- `AWS_ACCESS_KEY_ID=${{AWS_ACCESS_KEY_ID}}`
- `AWS_SECRET_ACCESS_KEY=${{AWS_SECRET_ACCESS_KEY}}`
- `AWS_DEFAULT_REGION=auto`
- `AWS_BUCKET=lucrativa-storage`
- `AWS_ENDPOINT=${{AWS_ENDPOINT}}`
- `AWS_USE_PATH_STYLE_ENDPOINT=true`
- `CDN_URL=${{CDN_URL}}`

### JWT e Segurança

- `JWT_SECRET=UEG52HCZ4N8WKDQMNX7VLIP3J9C8A2NNB78PTFQ3E1LK4VPNIMOP5X8YMGD1PXWB`

### Frontend (Vite)

- `VITE_BASE_URL=${{RAILWAY_PUBLIC_DOMAIN}}`
- `VITE_APP_NAME=LucrativaBet`

## Solução de Problemas

### Instância Problemática

O projeto inclui um script para substituir a instância problemática com ID `d9d6d330-c2ae-4cef-8063-5e4fe1cae5cc`. Para executar este script:

```bash
bash scripts/railway-mcp-replace-instance.sh
```

### Backup do Banco de Dados

O backup do banco de dados deve estar disponível em `backups/backup_antes_limpeza_20250910_111140.sql`. O script de migração irá verificar se este arquivo existe antes de tentar importá-lo.

### Permissões de Arquivos

Certifique-se de que todos os scripts de shell tenham permissão de execução:

```bash
chmod +x scripts/*.sh
```

## Conclusão

Este guia fornece todas as informações necessárias para fazer o deploy do projeto LucrativaBet no Railway usando o Railway MCP. Se você tiver alguma dúvida ou encontrar algum problema, por favor, verifique os scripts de automação e as configurações do projeto.