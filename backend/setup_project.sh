#!/bin/bash

# Exit on error
set -e

# Variables
GITHUB_REPO_URL="https://github.com/your-username/your-repo-name.git"
PROJECT_DIR="project"
JWT_SECRET_FILE="jwt_secret_key.txt"
CRYPTO_KEY_FILE="crypto_key.txt"
DOCKER_SERVICE="tbsky-docker-tbsky-booking-1"

# Functions
generate_keys() {
  echo "Generating keys..."
  
  # Generate JWT secret key
  if [ ! -f "$JWT_SECRET_FILE" ]; then
    python3 -c "import secrets; print(secrets.token_hex(32))" > "$JWT_SECRET_FILE"
    echo "JWT secret key generated in $JWT_SECRET_FILE"
  else
    echo "JWT secret key already exists in $JWT_SECRET_FILE"
  fi

  # Generate Fernet crypto key
  if [ ! -f "$CRYPTO_KEY_FILE" ]; then
    python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())" > "$CRYPTO_KEY_FILE"
    echo "Crypto key generated in $CRYPTO_KEY_FILE"
  else
    echo "Crypto key already exists in $CRYPTO_KEY_FILE"
  fi
}


initialize_docker() {
  echo "Initializing Docker Compose..."
  
  # Navigate to the project directory
  cd "$PROJECT_DIR"
  
  # Start Docker Compose
  docker-compose up -d
  
  echo "Docker Compose initialized."
}

run_setup_commands() {
  echo "Running setup commands in the Docker container..."
  
  # Execute setup commands inside the container
  docker exec -it "$DOCKER_SERVICE" bash -c "
    poetry run start core initialize-database &&
    poetry run start flights fill-repositories
  "
  
  echo "Setup commands completed."
}

# Main script execution
echo "Starting setup process..."
git clone https://github.com/Lim0H/tbsky_session.git tbsky-session
git clone https://github.com/Lim0H/tbsky_booking.git tbsky-booking
git clone https://github.com/sashasupron/ticket-search.git tbsky-frontend
generate_keys
initialize_docker
run_setup_commands

echo "Setup process completed successfully!"