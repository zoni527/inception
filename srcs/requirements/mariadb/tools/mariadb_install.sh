#!/bin/ash
yel="\033[1;93m"
gre="\033[1;92m"
red="\033[1;91m"
clr="\033[0m"

user=${user:-mysql}
root_password="$(cat /run/secrets/mariadb_root_password)"
wp_db_name=${MARIADB_DATABASE_NAME:-wordpress}
wp_db_user="$(cat /run/secrets/mariadb_user)"
wp_db_user_password="$(cat /run/secrets/mariadb_user_password)"
datadir=${datadir:-/var/lib/mysql}
logdir=${logdir:-/var/log/mysql}
log_error=${log_error:-${logdir}/mariadb.err}

# First time database tables install
if [ ! -d ${datadir}/mysql ]; then
	printf "${yel}%s${clr}\n" "Creating directories"
	mkdir -p ${datadir} ${logdir} && chown ${user} ${datadir} ${logdir}

	printf "${yel}%s${clr}\n" "Installing mariadb"
	mariadb-install-db \
		--user=${user} \
		--basedir=/usr \
		--datadir=${datadir} \
		--log-error=${log_error} \
		--skip-test-db
fi

# Start daemon temporarily for database management using bootstrap
printf "${yel}%s${clr}\n" "Setting up database"
cat << EOF > /tmp/setup.sql
FLUSH PRIVILEGES;

-- Only enable root to login with a password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${root_password}';

-- Disable root remote login
DELETE FROM mysql.user WHERE user='root' AND host != 'localhost';

-- Create wordpress database with default charset
CREATE DATABASE IF NOT EXISTS \`${wp_db_name}\`;

-- Create wordpress database user and give privileges
CREATE USER IF NOT EXISTS \`${wp_db_user}\`@'%' IDENTIFIED BY '${wp_db_user_password}';
GRANT ALL PRIVILEGES ON \`${wp_db_name}\`.* TO \`${wp_db_user}\`@'%';

FLUSH PRIVILEGES;
EOF

mariadbd --user=${user} --datadir=${datadir} --bootstrap < /tmp/setup.sql
rm /tmp/setup.sql

exec mariadbd-safe \
	--user=${user} \
	--datadir=${datadir} \
	--log_error=${log_error} \
	--port=${MYSQL_TCP_PORT} \
	--bind-address=0.0.0.0 \
	--skip-networking=false
