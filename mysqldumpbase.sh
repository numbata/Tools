#!/bin/sh

# описание используемых ключей
# -c - Use complete INSERT  statements that include column names.
# -d - Do not write any table row information (that is, do not dump table contents)
# -e - Use multiple-row INSERT  syntax that include several VALUES  lists. This results in a smaller dump file and speeds up inserts when the file is reloaded.
# -n - This option suppresses the CREATE DATABASE statements
# -q - This option is useful for dumping large tables. (see --quick)
# -t - Do not write CREATE TABLE  statements that re-create each dumped table.
# -Q - Quote identifiers (such as database, table, and column names) within “`” characters.
 

# Параметры соединения с БД
MYSQL_USER="root"
MYSQL_PASS=""
MYSQL_DB=""

# Директория где будут дампы
BACKUP_DIR="backups/"

# Список таблиц которых бэкапить не надо
EXCLUDE_LIST="api_log crons sphinx_counter"

# Если есть аргумент, то считаем его именем базы для бэкапа
if [ -n "$1" ]; then
    MYSQL_DB="$1"
fi

# TODO: Добавить проверку на сущестование выбранной базы

# Получаем список таблиц
TABLES=`mysql --database=${MYSQL_DB} -u${MYSQL_USER} -p${MYSQL_PASS} -B -N -e "SHOW TABLES"`
TODAY=`date +%Y-%m-%d-%H.%M`
BACKUP_DIR="${BACKUP_DIR}/${MYSQL_DB}_${TODAY}/"

# Создание директории для дампа
mkdir -p ${BACKUP_DIR}

# Имя файла со схемой базы
FILENAME_SCHEMA="${BACKUP_DIR}_database_schema.sql"
echo "/*!40101 SET NAMES utf8 */;" > ${FILENAME_SCHEMA}

for TABLE in ${TABLES}; do

  # Проверка исключений
  SKIP=0
  if [ $(echo " ${EXCLUDE_LIST} " | egrep -m 1 -oie "[[:space:]]${TABLE}[[:space:]]" -) ]; then
    SKIP=1
  fi

  # Если таблица не в исключениях
  if [ ${SKIP} = 0 ]; then
    echo "dumping ${TABLE}"

    # Сохранение структуры таблицы в файл со схемой
    mysqldump -u${MYSQL_USER} -p${MYSQL_PASS} --skip-opt -d -n -q -Q -c --add-drop-table --create-options --skip-tz-utc --skip-comments ${MYSQL_DB} ${TABLE} | grep -v '^\/\*' >> ${FILENAME_SCHEMA}

    # Создаем файл дампа и добавляем truncate таблицы и отключение ключей в начало
    FILENAME_DATA="${BACKUP_DIR}${TABLE}.sql"
    echo "/*!40101 SET NAMES utf8 */;" > ${FILENAME_DATA}
    echo "TRUNCATE ${TABLE};" >> ${FILENAME_DATA}
    echo "ALTER TABLE ${TABLE} disable keys;" >> ${FILENAME_DATA}
    echo "SET autocommit = 0;" >> ${FILENAME_DATA}
    echo "START TRANSACTION;" >> ${FILENAME_DATA}
    mysqldump -u${MYSQL_USER} -p${MYSQL_PASS} --skip-opt -e -n -t -q -Q -c --set-charset --skip-tz-utc --skip-comments ${MYSQL_DB} ${TABLE} | grep -v '^\/\*' >> ${FILENAME_DATA}
    echo "COMMIT;" >> ${FILENAME_DATA}
    echo "SET autocommit = 1;" >> ${FILENAME_DATA}
    echo "ALTER TABLE ${TABLE} enable keys;" >> ${FILENAME_DATA}
  fi
done

echo "done"
