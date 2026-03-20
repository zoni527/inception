# Services/Stack
- Database: MariaDB
- Frontend: WordPress
- Server:   nginx
# Credentials
Placed in `./secrets` directory, files link to `./srcs/.env`. Required secrets:
- mariadb_user.txt
- mariadb_user_password.txt
- mariadb_root_password.txt
- wordpress_admin.txt
- wordpress_admin_email.txt
- wordpress_admin_password.txt
- wordpress_user.txt
- wordpress_user_email.txt
- wordpress_user_password.txt
Use strong passwords.

Script for creating password files, run in repo root folder (fill in passwords yourself):
```bash
make -p ./secrets
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
Example `.env` file creation script:
```bash
cat << EOF > ./.env
DATABASE_HOSTNAME=mariadb
FRONTEND_HOSTNAME=wordpress
SERVER_HOSTNAME=nginx

DOMAIN_NAME=${USER}.42.fr

NGINX_PORT_HOST=4321
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
# Access website
```
https://<domain_name>[:nginx_host_port]
```
# Access WordPress admin panel
```
https://<domain_name>[:nginx_host_port]/wp-admin
```
# Monitoring
## Running containers
```bash
docker compose ps
```
or
```bash
docker ps
```
## Processes withing containers
```bash
docker exec <container_name> ps aux
```
## Logs
```bash
docker logs <container_name>
```
or
```bash
docker exec <container_name> cat <path_to_log_file>
```
