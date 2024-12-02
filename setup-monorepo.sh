#!/bin/bash

# Exit immediately on error
set -e

# Project name
PROJECT_NAME="micromind"

# Create the monorepo root directory
echo "Creating project: $PROJECT_NAME..."
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize root package.json
echo "Initializing root package.json..."
npm init -y > /dev/null

# Manually configure workspaces in package.json
echo "Configuring workspaces..."
cat > package.json <<EOL
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "private": true,
  "workspaces": [
    "server",
    "protocol",
    "client",
    "app/*",
    "electron"
  ]
}
EOL

# Create directories for the specified structure
echo "Creating workspace directories..."
mkdir -p server protocol client electron app/web app/native

# Initialize packages
initialize_package() {
  local dir=$1
  echo "Initializing $dir..."
  mkdir -p $dir
  (
    cd $dir
    npm init -y > /dev/null
  )
}

# Initialize each package
initialize_package "server"
initialize_package "protocol"
initialize_package "client"
initialize_package "electron"
initialize_package "app/web"
initialize_package "app/native"

# Link protocol to server and client as a shared dependency
echo "Linking protocol package to server and client..."
npm install protocol@* --workspace=server > /dev/null
npm install protocol@* --workspace=client > /dev/null

# Install all dependencies
echo "Installing dependencies..."
npm install > /dev/null

# Completion message
echo "Monorepo setup for $PROJECT_NAME complete!"
echo "Structure:"
echo "
$PROJECT_NAME/
├── server/         # Server-side logic
├── protocol/       # Shared protocol library
├── client/         # Client-side logic
├── app/
│   ├── web/        # Web application
│   ├── native/     # Native application
├── electron/       # Electron desktop application
"

