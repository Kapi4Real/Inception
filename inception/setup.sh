#!/bin/bash
# Setup script for Inception project
# This script creates the necessary directories and configures the environment

set -e

echo "=========================================="
echo "Inception Project Setup"
echo "=========================================="

# Get the current username
USERNAME=$(whoami)
HOME_DIR=$(eval echo ~$USERNAME)
DATA_DIR="$HOME_DIR/data"

echo "Username: $USERNAME"
echo "Home directory: $HOME_DIR"
echo "Data directory: $DATA_DIR"
echo ""

# Create data directories
echo "Creating data directories..."
mkdir -p "$DATA_DIR/mariadb"
mkdir -p "$DATA_DIR/wordpress"
chmod 755 "$DATA_DIR/mariadb"
chmod 755 "$DATA_DIR/wordpress"
echo "✓ Data directories created"

# Create .env from .env.example if it doesn't exist
if [ ! -f .env ]; then
    echo ""
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo "✓ .env created. Please edit it with your desired configuration."
fi

# Update docker-compose.yml with the current user's data directory
echo ""
echo "Updating docker-compose.yml with data directory: $DATA_DIR"
sed -i.bak "s|/home/[^/]*/data|$DATA_DIR|g" docker-compose.yml
rm -f docker-compose.yml.bak
echo "✓ docker-compose.yml updated"

echo ""
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit .env if you need custom configuration"
echo "2. Run: docker-compose build"
echo "3. Run: docker-compose up -d"
echo ""
