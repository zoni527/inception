#!/bin/sh

# Environment variable controlling the port that is used for
# connecting to mariadb
export MYSQL_TCP_PORT=$MARIADB_PORT_INTERNAL

user=mysql
root_password=rootpwd # $(cat $MARIADB_ROOT_PASSWORD_FILE)
datadir=/var/lib/mysql
logdir=/var/log/mysql
log_error=$logdir/mariadb.err

# If tables are already present it means that the script has already been run
if [ -d $datadir/data ]; then
	mariadb-safe;
	exit 1; # Safety exit if above command exits unexpectedly
fi

if [ ! "$root_password" ]; then
	echo "Empty mariadb root password, exiting"
	exit 1;
fi

# If user doesn't exist create it and add it to the mysql group
if [ ! "$(grep $user /etc/passwd)" ]; then
	adduser -H $user && adduser -G $user mysql
fi;
echo "Creating directories"
mkdir -p $datadir $logdir && chown $user $datadir $logdir

# Run install for initialization
mariadb-install-db \
	--user=$user \
	--basedir=/usr \
	--datadir=$datadir \
	--log-error=$log_error \
	--skip-test-db

# Start daemon temporarily for setup
echo "Setup start"
mariadbd \
	--user=$user \
	--datadir=$datadir \
	--log-error=$log_error \
	--port=$MYSQL_TCP_PORT \
 	--bootstrap <<- EOF
 	-- Disable root login without password and set password
 	GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'rootpwd' WITH GRANT OPTION;
 	FLUSH PRIVILEGES;
EOF

echo "Running mariadb"
exec mariadbd-safe --user=$user --datadir=$datadir --log-error=$log_error --port=$MYSQL_TCP_PORT
