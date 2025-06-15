---
description: Hylo-Builders Windsurf Workflow
---

# Hylo-Builders Development Environment Startup

This workflow starts the complete Hylo-Builders development environment with Docker-based services.

First, ask the user if they have run steps 1-3 recently -- most of the time we will skip to steps 4/5/6.

## Step 1: Start Docker containers for PostgreSQL and Redis
// turbo
```bash
cd /mnt/d/code/hylo-builders && docker-compose up -d
```

## Step 2: Verify Docker containers are running
// turbo
```bash
docker ps | grep hylo
```

## Step 3: Fix environment variables if needed
// turbo
```bash
cd /mnt/d/code/hylo-builders/archive && powershell -ExecutionPolicy Bypass -File fix-env-variables.ps1
```

## Step 4: Start the backend server
```bash
cd /mnt/d/code/hylo-builders && ./start-backend-official.sh
```

## Step 5: Start the frontend server (in a new terminal)
```bash
cd /mnt/d/code/hylo-builders && ./start-frontend-official.sh
```

## Step 6: Open the application in browser
```bash
start http://localhost:3000
```

## Troubleshooting

If you encounter issues:

1. **Docker container issues**:
   ```bash
   docker ps
   docker logs hylo_postgres
   docker logs hylo_redis
   ```

2. **Database connection issues**:
   ```bash
   cd /mnt/d/code/hylo-builders/apps/backend
   export PGPASSWORD=hylo_password
   psql -h localhost -U hylo_user -d hylo_dev -c "\dt"
   ```

3. **Redis connection issues**:
   ```bash
   redis-cli -h localhost -p 6379 ping
   ```

4. **Backend initialization issues**:
   - Check backend logs for errors
   - Increase hook timeout in `apps/backend/config/env/development.js`

5. **Frontend connection issues**:
   - Verify API_HOST and SOCKET_HOST have http:// prefix
   - Check browser console for connection errors
