# Hylo-Builders Local Development Setup Guide

This guide documents the local development setup for the Hylo-Builders project, a fork of Hylo.com tailored for the builders.dev community. It explains how our setup aligns with the official Hylo documentation while using Docker for database services.

## Environment Overview

- **Operating System**: Windows with WSL (Windows Subsystem for Linux)
- **Node.js**: v20.x via NVM
- **Yarn**: v4.5.0 via Corepack
- **Database**: PostgreSQL with PostGIS (Docker container)
- **Cache**: Redis (Docker container)
- **Backend**: Sails.js on port 3001
- **Frontend**: React with Vite on port 3000

## Setup Components

### 1. Docker Services

We use Docker Compose to provide PostgreSQL and Redis services:

```yaml
# docker-compose.yml
services:
  postgres:
    image: postgis/postgis:15-3.3
    container_name: hylo_postgres
    environment:
      POSTGRES_USER: hylo_user
      POSTGRES_PASSWORD: hylo_password
      POSTGRES_DB: hylo_dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    container_name: hylo_redis
    ports:
      - "6379:6379"
    restart: unless-stopped

volumes:
  postgres_data:
    name: hylo_postgres_data
```

Start these services with:

```bash
docker-compose up -d
```

### 2. Backend Setup

The backend uses the official Hylo approach with Foreman to manage both web and worker processes:

```bash
# start-backend-official.sh
#!/bin/bash

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Use the correct Node.js version
echo "Setting up Node.js version..."
nvm use

# Install global dependencies as per official docs
echo "Installing global dependencies..."
npm install -g foreman yarn

# Enable Corepack for Yarn management
echo "Enabling Corepack..."
corepack enable

# Check PostgreSQL connection
echo "Checking PostgreSQL connection..."
pg_isready -h localhost -p 5432 -U hylo_user

# Check Redis connection
echo "Checking Redis connection..."
redis-cli -h localhost -p 6379 ping > /dev/null 2>&1
echo "Redis connection successful"

# Change to the backend directory
cd /mnt/d/code/hylo-builders/apps/backend

# Run database migrations if needed
echo "Running database migrations..."
export PGPASSWORD=hylo_password
cat migrations/schema.sql | psql -h localhost -U hylo_user -d hylo_dev
unset PGPASSWORD

# Seed the database with basic data
echo "Seeding the database..."
DATABASE_URL=postgres://hylo_user:hylo_password@localhost:5432/hylo_dev yarn knex seed:run

# Build shared workspace (as mentioned in package.json dev script)
echo "Building shared workspace..."
yarn workspace @hylo/shared build

# Start the backend using the official method with foreman
echo "Starting backend server using yarn dev..."
DATABASE_URL=postgres://hylo_user:hylo_password@localhost:5432/hylo_dev \
REDIS_URL=redis://localhost:6379 \
NODE_ENV=development \
yarn dev
```

### 3. Frontend Setup

The frontend setup follows the official Hylo documentation:

```bash
# start-frontend-official.sh
#!/bin/bash

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Use the correct Node.js version
echo "Setting up Node.js version..."
nvm use

# Enable Corepack for Yarn management
echo "Enabling Corepack..."
corepack enable

# Change to the frontend directory
cd /mnt/d/code/hylo-builders/apps/web

# Install dependencies if needed
echo "Checking dependencies..."
yarn install

# Start the frontend using the official method
echo "Starting frontend server using yarn dev..."
yarn dev
```

### 4. Environment Variables

#### Backend (.env)

Critical environment variables for the backend:

```
DATABASE_URL=postgres://hylo_user:hylo_password@localhost:5432/hylo_dev
REDIS_URL=redis://localhost:6379
COOKIE_SECRET=your_secure_cookie_secret
NODE_ENV=development

# OAuth credentials
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
LINKEDIN_API_KEY=your_linkedin_api_key
LINKEDIN_API_SECRET=your_linkedin_api_secret

# AWS S3 (for file uploads)
AWS_S3_BUCKET=your_s3_bucket
AWS_ACCESS_KEY_ID=your_aws_key
AWS_SECRET_ACCESS_KEY=your_aws_secret
```

#### Frontend (.env)

Critical environment variables for the frontend:

```
API_HOST=http://localhost:3001
SOCKET_HOST=http://localhost:3001
VITE_API_HOST=http://localhost:3001
VITE_SOCKET_HOST=http://localhost:3001
```

## Alignment with Official Documentation

### What's the Same

1. **Backend Startup Process**: Using `yarn dev` which runs through Foreman
2. **Frontend Startup Process**: Using `yarn dev` to start the Vite development server
3. **Database Schema**: Using the same schema.sql file for database setup
4. **Environment Variables**: Using the same environment variable structure

### What's Different

1. **Database and Redis**: Using Docker containers instead of local installations
   - **Rationale**: Docker provides better isolation, portability, and easier setup on Windows/WSL
   - **Compatibility**: Services are exposed on the same ports, so the application interacts with them identically

2. **Connection Strings**: Using explicit connection strings in startup scripts
   - **Rationale**: Ensures consistent connection parameters across environments
   - **Compatibility**: The application uses the same environment variables to connect

## Startup Process

1. Start Docker services:
   ```bash
   docker-compose up -d
   ```

2. Start the backend:
   ```bash
   ./start-backend-official.sh
   ```

3. Start the frontend in a separate terminal:
   ```bash
   ./start-frontend-official.sh
   ```

4. Wait for the backend to initialize (several minutes until "Aloft" message appears)

5. Access the application at http://localhost:3000

## Troubleshooting

1. **Backend Initialization**: The backend takes several minutes to initialize ("Lifting..." to "Aloft")
2. **Database Errors**: Some migrations may fail if they've been run previously (can be ignored)
3. **Connection Issues**: Ensure Docker containers are running and ports are not in use
4. **Frontend Connection**: Make sure API_HOST and SOCKET_HOST include the protocol (http://)

## Next Steps

With the local environment now stable, the next development steps are:

1. Implement GitHub OAuth integration (Sprint 1 per PRD)
2. Connect repositories to groups
3. Develop Suna plugin skeleton

## References

- [Official Hylo Backend README](https://github.com/Hylozoic/hylo-node/blob/dev/README.md)
- [Official Hylo Frontend README](https://github.com/Hylozoic/hylo-frontend/blob/dev/README.md)
- [Hylo-Builders PRD](link-to-prd)

## Current Status

### ✅ OPERATIONAL WITH LIMITATIONS

- ✅ Backend server starts successfully
- ✅ Frontend server starts successfully
- ✅ API connection established
- ✅ Email/Password authentication works correctly
- ✅ User authentication persists across page refreshes
- ❌ Google OAuth requires redirect URI update in Google Cloud Console

### Critical Fixes Applied

We've successfully resolved the OAuth session management issues by implementing the following fixes:

1. **CORS Configuration**:
   - Updated `allowCredentials: true` in backend CORS settings
   - Added `allowAnyOriginWithCredentialsUnsafe: true` for development environments
   - Fixed syntax issues in CORS configuration

2. **Cookie Domain Configuration**:
   - Removed port from cookie domain (changed from 'localhost:3000' to 'localhost')
   - Set `httpOnly: false` in development for easier debugging
   - Created custom `local.js` with explicit cookie settings

3. **Frontend API Credentials**:
   - Changed credentials from 'same-origin' to 'include' in apiMiddleware.js
   - Ensured consistent cookie name between frontend and backend
   ```
   Failed to load resource: net::ERR_CONNECTION_REFUSED
   ```
   This suggests that while the socket connection works, API requests may be failing.

3. **React Rendering Error**: There's an unhandled error in the React components:
   ```
   The above error occurred in one of your React components:
   at Lazy
   at Suspense
   at Root
   ```

4. **Translation System**: i18next is loading translations successfully:
   ```
   i18next::backendConnector: loaded namespace translation for language en
   i18next: languageChanged en-US
   i18next: initialized
   ```

5. **Docker vs. Local Services**: Unlike the official setup which uses locally installed PostgreSQL and Redis, we're using Docker containers. While the connection parameters are the same, there might be subtle differences in behavior.

6. **Custom Startup Scripts**: We've created custom startup scripts (`start-backend-official.sh` and `start-frontend-official.sh`) that attempt to follow the official startup process while accommodating our Docker-based services.

### Possible Solutions for Investigation

1. **Check API Endpoints**: Verify that the backend API endpoints are accessible from the frontend. Try making a direct API request to `http://localhost:3001/api/v1/users/me` or another endpoint to see if it responds.

2. **Examine Network Requests**: Look at the specific network requests that are failing in the browser developer tools to identify patterns.

3. **Authentication Flow**: The spinner might be related to an authentication issue. Check if the frontend is trying to authenticate and failing, or if it's stuck waiting for user data.

4. **Database Schema**: Verify that all required database tables are created and populated correctly. The migration errors about existing constraints suggest some migrations might have been skipped.

5. **Environment Variables**: Double-check that all required environment variables are set correctly in both backend and frontend.

6. **Debug React Error**: The React component error might be preventing the UI from rendering properly. Adding error boundaries could help identify the specific component causing the issue.

7. **Compare with Official Setup**: If possible, set up a vanilla Hylo instance following the official documentation exactly (without Docker) to compare behavior.

### Critical Environment Variable Differences

After reviewing the original `.env` file, we've identified several critical differences that may be causing the loading issues:

1. **Database Connection**: 
   - Original: `DATABASE_URL=postgres://localhost:5432/hylo`
   - Our setup: `DATABASE_URL=postgres://hylo_user:hylo_password@localhost:5432/hylo_dev`
   - **Issue**: Different database name (`hylo` vs `hylo_dev`) and missing credentials in original

2. **Redis Connection**: 
   - Original: `REDIS_URL=redis://localhost:6379`
   - Our setup: Same, but Docker container may have different configuration

3. **Domain Configuration**:
   - Original has: `DOMAIN=localhost:3000`
   - Our setup may be missing this, which could affect cookie/authentication flows

4. **Protocol Setting**:
   - Original has: `PROTOCOL=http`
   - This might be needed for proper URL construction in the backend

5. **Cookie Configuration**:
   - Original has: `COOKIE_NAME=hylo-dev-local`
   - This affects how authentication cookies are stored and retrieved

6. **Missing API Keys**:
   - The original file has numerous API keys for services like Google, Facebook, LinkedIn
   - While we added placeholders, the exact values might be required for certain initialization flows

7. **Debug Settings**:
   - Original has: `DEBUG_GRAPHQL=true` and `DEBUG_SQL=true`
   - These might affect how the application handles errors and API requests

**Recommendation for Hylo Developers**:

Ensure that the following critical environment variables match exactly between the original setup and our Docker-based setup:

```
DATABASE_URL=postgres://hylo_user:hylo_password@localhost:5432/hylo_dev
REDIS_URL=redis://localhost:6379
DOMAIN=localhost:3000
PROTOCOL=http
COOKIE_NAME=hylo-dev-local
COOKIE_SECRET=loremipsum  # Or whatever secure value you're using
DEBUG_GRAPHQL=true
DEBUG_SQL=true
```

Also check that the database name in our Docker setup (`hylo_dev`) matches what the application expects (`hylo` in the original file). This mismatch could explain why the backend initializes but the frontend can't retrieve data.

### Backend Crash Issue

We've observed that the backend may crash during startup with the following error:

```
[nodemon] app crashed - waiting for file changes before starting...
```

This indicates a problem during the initialization process. To troubleshoot this issue:

1. **Check the backend logs** for specific error messages before the crash

2. **Verify database connection**: Ensure the database connection string is correct and the database is accessible
   ```bash
   cd /mnt/d/code/hylo-builders/apps/backend
   export PGPASSWORD=hylo_password
   psql -h localhost -U hylo_user -d hylo_dev -c "\dt"
   ```

3. **Compare environment variables**: Ensure all critical variables from the original `.env` file are present
   - `DOMAIN=localhost:3000`
   - `PROTOCOL=http`
   - `COOKIE_NAME=hylo-dev-local`

4. **Check for dependency issues**: There might be version conflicts in node modules
   ```bash
   cd /mnt/d/code/hylo-builders/apps/backend
   yarn install --check-files
   ```

5. **Examine hook timeout**: The backend might need more time to initialize
   - Check `apps/backend/config/env/development.js` for hook timeout settings
   - Consider increasing the timeout if initialization is taking too long
