# Deploy Manual para Railway - LucrativaBet

## ✅ Serviços Já Criados no Projeto 'lucrativabet-fresh':
- MySQL (ID: 501865cc-72b3-4a6f-a1de-0d090d2c4910) - ✅ Rodando
- Redis (ID: 6a929cd5-57d6-457a-8b6c-d3ea1bd02f21) - ✅ Rodando

## 📝 Próximos Passos Manuais:

### 1. Via Dashboard Railway:
1. Acesse: https://railway.app/project/7b881c54-fea6-4195-83f1-7cc95e9c5e12
2. Clique em 'New Service' → 'GitHub Repo'
3. Conecte: https://github.com/lukasofthedrop/lucrativabet-fresh.git
4. Configure Build Command:
   ```
   composer install --no-dev --optimize-autoloader
   ```
5. Configure Start Command:
   ```
   php artisan serve --host=0.0.0.0 --port=$PORT
   ```
6. Configure Health Check Path: ```/```

### 2. Variáveis de Ambiente (copiar e colar):
```
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:Tq10ZYNF64apwpe8e9vFaTFMW1wvM0BGMU1mgmfKL0I=
APP_URL=https://[seu-domínio-railway]
LOG_CHANNEL=stack
LOG_LEVEL=error
APP_ROLE=web
RUN_MIGRATIONS=1

# Filament Admin
FILAMENT_BASE_URL=admin

# Database (conectar com o MySQL existente)
DB_CONNECTION=mysql
DB_HOST=${{MYSQLHOST}}
DB_PORT=${{MYSQLPORT}}
DB_DATABASE=${{MYSQLDATABASE}}
DB_USERNAME=${{MYSQLUSER}}
DB_PASSWORD=${{MYSQLPASSWORD}}

# Redis (conectar com o Redis existente)
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
REDIS_CLIENT=phpredis
REDIS_HOST=${{REDISHOST}}
REDIS_PASSWORD=${{REDISPASSWORD}}
REDIS_PORT=${{REDISPORT}}
REDIS_PREFIX=lucrativabet_

# JWT
JWT_SECRET=UEG52HCZ4N8WKDQMNX7VLIP3J9C8A2NNB78PTFQ3E1LK4VPNIMOP5X8YMGD1PXWB
```

### 3. Após Deploy:
1. Acesse sua URL: https://[seu-domínio].up.railway.app
2. Teste: / (home) e /admin (painel admin)
3. Rode migrations se necessário via Railway Console

## 🔗 Links Úteis:
- Projeto Railway: https://railway.app/project/7b881c54-fea6-4195-83f1-7cc95e9c5e12
- GitHub: https://github.com/lukasofthedrop/lucrativabet-fresh.git

