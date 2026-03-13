#!/bin/ash
yel="\033[1;93m"
gre="\033[1;92m"
red="\033[1;91m"
clr="\033[0m"

user=mysql
root_password=rootpwd # $(cat ${MARIADB_ROOT_PASSWORD_FILE})
wp_db_name=wordpress
wp_db_user=wp_user
wp_db_user_password=userpwd
datadir=/var/lib/mysql
logdir=/var/log/mysql
log_error=${logdir}/mariadb.err

if [ ! "${root_password}" ]; then
	printf "${red}%s${clr}\n" ${red} "Empty mariadb root password, exiting"
	exit 1;
fi

if [ ! -d ${datadir}/data ]; then
	printf "${yel}%s${clr}\n" "Creating directories"
	mkdir -p ${datadir} ${logdir} && chown ${user} ${datadir} ${logdir}

	# Run database install
	printf "${yel}%s${clr}\n" "Installing mariadb"
	mariadb-install-db \
		--user=${user} \
		--basedir=/usr \
		--datadir=${datadir} \
		--log-error=${log_error} \
		--skip-test-db
fi

# Start daemon temporarily for setup using bootstrap
printf "${yel}%s${clr}\n" "Setting up database"
mariadbd --user=${user} --datadir=${datadir} --bootstrap <<- EOF
	FLUSH PRIVILEGES;

	-- Only enable root to login with a password
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${root_password}';

	-- Disable root remote login
	DELETE FROM mysql.user WHERE user='root' AND host != 'localhost';

	-- Create wordpress database with default charset
	CREATE DATABASE IF NOT EXISTS ${wp_db_name};

	-- Create wordpress database user and give privileges
	CREATE USER IF NOT EXISTS '${wp_db_user}'@'%' IDENTIFIED BY '${wp_db_user_password}';
	GRANT ALL PRIVILEGES ON ${wp_db_name}.* TO '${wp_db_user}'@'%';

	FLUSH PRIVILEGES;
EOF
