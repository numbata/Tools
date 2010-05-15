#!/bin/sh

#
# @author Andrei Subbota <subbota@gmail.com>
# @todo пароль и имя пользователя принимать как параметры

# Параметры соединения с БД
MYSQL_USER="root"
MYSQL_PASS=""

# Если есть аргумент, то считаем его именем базы для бэкапа
if [ -n "$1" ]; then
    MYSQL_DB_FROM="$1"
else
	echo "USAGE: ./mysqlrenamebase.sh basenamefrom basenameto"
	exit
fi

# Если есть аргумент, то считаем его именем базы для бэкапа
if [ -n "$2" ]; then
    MYSQL_DB_TO="$2"
else
    echo "USAGE: ./mysqlrenamebase.sh basenamefrom basenameto"
    exit
fi

mysql -u${MYSQL_USER} -p${MYSQL_PASS} ${MYSQL_DB_FROM} -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_TO};"

# Получаем список таблиц
TABLES=`mysql --database=${MYSQL_DB_FROM} -u${MYSQL_USER} -p${MYSQL_PASS} -B -N -e "SHOW TABLES;"`

for TABLE in ${TABLES}; do
    echo "Move ${MYSQL_DB_FROM}.${TABLE} to ${MYSQL_DB_TO}.${TABLE}"
    mysql -u${MYSQL_USER} -p${MYSQL_PASS} ${MYSQL_DB_FROM} -e "RENAME TABLE ${MYSQL_DB_FROM}.${TABLE} TO ${MYSQL_DB_TO}.${TABLE};"
done

mysql -u${MYSQL_USER} -p${MYSQL_PASS} ${MYSQL_DB_FROM} -e "DROP DATABASE IF EXISTS ${MYSQL_DB_FROM};"

echo "done"
