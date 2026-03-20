# Set up environment from scratch
## Prerequisites
- Linux Kernel (through OS, VM, WSL...)
- Git
- GNU Make
- Docker
- Docker Compose
## Steps
1. Install prerequisites
2. Clone repository and `cd` into it
3. Setup credentials
4. Setup environment file `srcs/.env`
5. Run `make up`
## Credential files
Script for creating credential files:
```bash
mkdir -p ./secrets
touch ./secrets/mariadb_user.txt
touch ./secrets/mariadb_user_password.txt
touch ./secrets/mariadb_root_password.txt
touch ./secrets/wordpress_admin.txt
touch ./secrets/wordpress_admin_email.txt
touch ./secrets/wordpress_admin_password.txt
touch ./secrets/wordpress_user.txt
touch ./secrets/wordpress_user_email.txt
touch ./secrets/wordpress_user_password.txt
```
Need to be filled in, use strong credentials.
## Environment file
Example default environment file creation script, place in `srcs/`:
```bash
cat << EOF > .env
DATABASE_HOSTNAME=mariadb
FRONTEND_HOSTNAME=wordpress
SERVER_HOSTNAME=nginx

DOMAIN_NAME=${USER}.42.fr

NGINX_PORT_HOST=443
NGINX_PORT_INTERNAL=443

MARIADB_DATABASE_NAME=wordpress
MARIADB_USER_FILE=../secrets/mariadb_user.txt
MARIADB_USER_PASSWORD_FILE=../secrets/mariadb_user_password.txt
MARIADB_ROOT_PASSWORD_FILE=../secrets/mariadb_root_password.txt
MARIADB_PORT_INTERNAL=3306

WORDPRESS_SITE_TITLE="Inception"
WORDPRESS_PORT_INTERNAL=9000
WORDPRESS_USER_FILE=../secrets/wordpress_user.txt
WORDPRESS_USER_EMAIL_FILE=../secrets/wordpress_user_email.txt
WORDPRESS_USER_PASSWORD_FILE=../secrets/wordpress_user_password.txt
WORDPRESS_USER_ROLE=author
WORDPRESS_ADMIN_FILE=../secrets/wordpress_admin.txt
WORDPRESS_ADMIN_EMAIL_FILE=../secrets/wordpress_admin_email.txt
WORDPRESS_ADMIN_PASSWORD_FILE=../secrets/wordpress_admin_password.txt
EOF
```
# Managing containers
## Building
### Using Make
```bash
make build
```
To force a complete rebuild use
```bash
make rebuild
```
### Using Docker Compose
Run in `srcs/`
```bash
docker compose --env-file .env build
```
To force a complete rebuild use
```bash
docker compose --env-file .env build --no-cache
```
## Launching
## Data storage
