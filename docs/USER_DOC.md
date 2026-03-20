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
## Processes within containers
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
