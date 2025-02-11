Here’s a `README.md` file for your project:

# Project Setup and Usage

This guide will walk you through generating required keys, initializing the Docker Compose environment, and running necessary commands to prepare the application.

---

## Prerequisites

1. Ensure you have the following tools installed:
   - [Docker](https://docs.docker.com/get-docker/)
   - [Docker Compose](https://docs.docker.com/compose/install/)
   - Python 3.12+ (for generating keys)
   - [Poetry](https://python-poetry.org/docs/#installation) (already included in the project)

---

## 1. Generate Secret Keys

Before starting the application, generate the required secret keys.

### Generate JWT Secret Key
Run the following command to generate a JWT secret key and save it to `jwt_secret_key.txt`:

```bash
python -c "import secrets; print(secrets.token_hex(32))" > jwt_secret_key.txt
```

### Generate Crypto Key (Fernet)
Run the following command to generate a Fernet encryption key and save it to `crypto_key.txt`:

```bash
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())" > crypto_key.txt
```

---

## 2. Initialize Docker Compose

Start the Docker Compose environment by running:

```bash
docker-compose up -d
```

This will:
- Start the application services, including the `booking` service.
- Initialize networking between services.

---

## 3. Execute Setup Commands in the Booking Service

After starting the Docker environment, execute the following commands inside the `tbsky-docker-tbsky-booking-1` container to initialize the application.

### Enter the Booking Service Container
Run:

```bash
docker exec -it tbsky-docker-tbsky-booking-1 bash
```

This will open a bash shell inside the container.

### Initialize the Database
Run the following command inside the container to initialize the database:

```bash
poetry run start core initialize-database
```

### Populate Flight Repositories
Run the following command inside the container to fill repositories with initial flight data:

```bash
poetry run start flights fill-repositories
```
