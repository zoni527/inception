#!/bin/sh

yel="\033[1;93m"
gre="\033[1;92m"
red="\033[1;91m"
clr="\033[0m"

user=mysql
root_password="rootpasswd" # $(cat ${MARIADB_ROOT_PASSWORD_FILE})
datadir=/var/lib/mysql
logdir=/var/log/mysql
log_error=${logdir}/mariadb.err

# If tables are present it means that the rest of the script has already been run before
# NOTE: Assume that the user hasn't corrupted the folder/user structure between runs
if [ -d ${datadir}/data ]; then
	printf "${yel}%s${clr}\n" ${yel} "Data directory already exists"
	exit 0;
fi

if [ ! "${root_password}" ]; then
	printf "${red}%s${clr}\n" ${red} "Empty mariadb root password, exiting"
	exit 1;
fi

# If user doesn't exist create it and add it to the mysql group
if [ ! "$(grep ${user} /etc/passwd)" ]; then
	printf "${yel}%s${clr}\n" ${yel} "Adding user ${user}"
	adduser -H ${user} && adduser -G ${user} mysql
fi;

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

# Start daemon temporarily for setup
printf "${yel}%s${clr}\n" "Setting up root login"
mariadbd --user=${user} --datadir=${datadir} --bootstrap <<- EOF
	FLUSH PRIVILEGES;

	-- Only enable root to login with a password
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${root_password}';

	-- Disable root remote login
	DELETE FROM mysql.user WHERE user='root' AND host != 'localhost';

	FLUSH PRIVILEGES;
EOF
