# User documentation
## Services/Stack
- Database: MariaDB
- Frontend: WordPress
- Server:   nginx
## Running
Define an environment file and set up credentials before the first run,
more information and helpful scripts in `./DEV_DOC.md`.

Make commands run in root of repository.

Start services:
```bash
make up
```
Stop services:
```bash
make down
```
Remove all data:
```bash
make fclean
```
## Credentials
Placed in `secrets` directory, files link to `srcs/.env`. Required secrets:
- mariadb_user.txt
- mariadb_user_password.txt
- mariadb_root_password.txt
- wordpress_admin.txt
- wordpress_admin_email.txt
- wordpress_admin_password.txt
- wordpress_user.txt
- wordpress_user_email.txt
- wordpress_user_password.txt

Set secrets before running, use strong passwords.
## Access website
```
https://<username>.42.fr
```
## Access WordPress admin panel
```
https://<username>.42.fr/wp-admin
```
## MariaDB data
Access container:
```bash
docker exec -it mariadb sh
```
Log in and check databases:
```bash
mariadb -u <mariadb_user/root> -p<password>
```
```SQL
SHOW DATABASES;
SHOW TABLES FROM <database_name>;
```
## Monitoring
### Running containers
```bash
docker compose ps
```
or
```bash
docker ps
```
### Processes within containers
```bash
docker exec <container_name> ps aux
```
### Logs
```bash
docker logs <container_name>
```
or
```bash
docker exec <container_name> cat <path_to_log_file>
```
Logfiles are:
- MariaDB:      `/var/log/mysql/mariadb.err`
- nginx:        `/var/log/nginx/error.log`
- WordPress:    `/var/log/fpm-php/www.log`
