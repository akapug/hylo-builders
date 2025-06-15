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
if [ $? -ne 0 ]; then
  echo "PostgreSQL is not running or not accessible. Make sure Docker containers are running."
  exit 1
fi

# Check Redis connection
echo "Checking Redis connection..."
# Use a simple ping to check if Redis is running
redis-cli -h localhost -p 6379 ping > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Redis is not running or not accessible. Make sure Docker containers are running."
  exit 1
fi
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

# Start the backend using the official method with increased hook timeout
echo "Starting backend using yarn dev with increased hook timeout..."
cd apps/backend
# Set the hook timeout to 120000ms (2 minutes) to allow for slower initialization
export NODE_OPTIONS="--max-old-space-size=4096"
DATABASE_URL=postgres://hylo_user:hylo_password@localhost:5432/hylo_dev \
REDIS_URL=redis://localhost:6379 \
NODE_ENV=development \
SAILS_HOOK_TIMEOUT=120000 \
yarn dev
