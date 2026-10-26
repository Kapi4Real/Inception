#!/bin/bash
set -euo pipefail

INIT_MARKER="/var/lib/mysql/.inception_initialized"
DATADIR="/var/lib/mysql"

mkdir -p "$DATADIR" /var/run/mysqld
chown -R mysql:mysql "$DATADIR" /var/run/mysqld || true

if [ -f "$INIT_MARKER" ]; then
  echo "Initialization marker present, starting mariadb in foreground"
  exec /usr/sbin/mariadbd --basedir=/usr --datadir="$DATADIR" --plugin-dir=/usr/lib/mysql/plugin --user=mysql --console
fi

# Initialize database structure if missing
if [ ! -d "$DATADIR/mysql" ]; then
  echo "Initializing database files"
  mariadb-install-db --user=mysql --datadir="$DATADIR" --auth-root-authentication-method=normal >/dev/null
fi

echo "Starting temporary mysqld for initial configuration"
# Create init SQL file
INIT_SQL_FILE="/tmp/mysql-init.sql"
cat > "$INIT_SQL_FILE" <<-SQL
ALTER USER IF EXISTS 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL

# Use --init-file without restrictive flags so SQL can be executed at startup
# This is the canonical way MariaDB initializes on first run
/usr/sbin/mariadbd --basedir=/usr --datadir="$DATADIR" --plugin-dir=/usr/lib/mysql/plugin --user=mysql --init-file="$INIT_SQL_FILE" &
MYSQLD_PID=$!

# Wait for server to complete initialization and be ready
retries=60
until mysqladmin --protocol=socket -u root -p"${MYSQL_ROOT_PASSWORD}" ping --silent >/dev/null 2>&1; do
  retries=$((retries-1))
  if [ "$retries" -le 0 ]; then
    echo "MariaDB server did not start successfully in time" >&2
    kill "$MYSQLD_PID" 2>/dev/null || true
    wait "$MYSQLD_PID" 2>/dev/null || true
    exit 1
  fi
  sleep 1
done

echo "MariaDB initialized successfully"
touch "$INIT_MARKER"

# Stop the background server
kill "$MYSQLD_PID" || true
wait "$MYSQLD_PID" 2>/dev/null || true

# Sleep for graceful shutdown
sleep 2

echo "Launching mariadb in foreground"
exec /usr/sbin/mariadbd --basedir=/usr --datadir="$DATADIR" --plugin-dir=/usr/lib/mysql/plugin --user=mysql --console