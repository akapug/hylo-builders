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
