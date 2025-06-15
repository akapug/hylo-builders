# Hylo-Builders Official Setup Alignment

This document outlines how our setup aligns with the official Hylo documentation, highlighting key differences and our approach to resolving them.

## Key Alignment Points

### 1. Backend Startup Process
- **Official Method**: Uses `yarn dev` which runs through Foreman (specified in Procfile)
- **Our Aligned Approach**: Using `yarn dev` in `start-backend-official.sh`
- **Benefits**: Proper process management, consistent with official documentation

### 2. Database Setup
- **Official Method**: Direct PostgreSQL commands for schema setup
- **Our Aligned Approach**: Using the same schema.sql file but with Docker-hosted PostgreSQL
- **Compatibility**: Both approaches result in the same database schema

### 3. Environment Variables
- **Official Method**: Uses .env files with specific variables
- **Our Approach**: Same .env structure with additional variables for OAuth
- **Alignment**: All required variables are present in our setup

### 4. Frontend Startup
- **Official Method**: Uses `yarn dev` for frontend
- **Our Aligned Approach**: Using `yarn dev` in `start-frontend-official.sh`
- **Consistency**: Same development server configuration

## Maintained Differences

### 1. Docker for Services
- **Official Method**: Locally installed PostgreSQL and Redis
- **Our Approach**: Docker containers for these services
- **Rationale**: Docker provides better isolation, portability, and easier setup on Windows/WSL
- **Compatibility**: Services are exposed on the same ports, so the application interacts with them identically

### 2. Connection Configuration
- **Official Method**: Connects to local PostgreSQL and Redis
- **Our Approach**: Connects to Docker-hosted services via localhost
- **Alignment**: Connection strings in .env files point to the same ports

## Authentication Alignment

### 1. OAuth Configuration
- **Official Method**: Uses Google, Facebook, and LinkedIn OAuth
- **Our Implementation**: 
  - Email/Password authentication working correctly
  - Google OAuth partially configured (needs redirect URI update in Google Cloud Console)
- **Key Fixes**:
  - CORS configuration with `allowCredentials: true` and `allowAnyOriginWithCredentialsUnsafe: true`
  - Cookie domain set to 'localhost' without port
  - Frontend API credentials set to 'include' for cross-origin requests

### 2. Session Management
- **Official Method**: Uses Redis for session storage
- **Our Implementation**: Same Redis-based session storage with optimized cookie settings
- **Key Fixes**:
  - Created custom `local.js` with explicit cookie settings
  - Set `httpOnly: false` in development for easier debugging
  - Consistent cookie name between frontend and backend

## Performance Optimizations

1. **Backend Initialization**: Increased Sails.js hook timeout to 120000ms (2 minutes)
2. **Docker Services**: Optimized PostgreSQL and Redis containers for local development

## Troubleshooting Notes

1. **Backend Initialization**: The backend takes several minutes to initialize ("Lifting..." to "Aloft")
2. **Frontend Connection**: The frontend needs the backend to be fully initialized before API calls succeed
3. **API Connection**: Ensure API_HOST and SOCKET_HOST include the protocol (http://)
4. **Database Migrations**: Some migrations may fail if they've been run previously
5. **CORS Issues**: If experiencing cross-origin problems, verify CORS settings in `config/cors.js`
6. **Cookie Issues**: Check browser developer tools to ensure cookies are being set correctly

## Next Steps

1. Implement GitHub OAuth integration (Sprint 1 per PRD)
2. Develop repository connection feature
3. Create agent plugin system
4. Restructure holonic groups for software categories
3. Develop AI builder plugin skeleton
