#!/bin/bash

DB_USER=${DB_USER:-${MYSQL_ENV_DB_USER}}
DB_PASS=${DB_PASS:-${MYSQL_ENV_DB_PASS}}
DB_NAME=${DB_NAME:-${MYSQL_ENV_DB_NAME}}
DB_HOST=${DB_HOST:-${MYSQL_ENV_DB_HOST}}
ALL_DATABASES=${ALL_DATABASES}
IGNORE_DATABASE=${IGNORE_DATABASE}
BACKUP_RETENTION=${BACKUP_RETENTION:-1}
BACKUP_PATH=${BACKUP_PATH:/mysqldump}

function rotate_dumps {
	pattern=$1
	ls -t | grep $pattern | sed -e 1,${BACKUP_RETENTION}d | xargs -d '\n' rm -r > /dev/null 2>&1
}

if [[ ${DB_USER} == "" ]]; then
	echo "Missing DB_USER env variable"
	exit 1
fi
if [[ ${DB_PASS} == "" ]]; then
	echo "Missing DB_PASS env variable"
	exit 1
fi
if [[ ${DB_HOST} == "" ]]; then
	echo "Missing DB_HOST env variable"
	exit 1
fi

cd $BACKUP_PATH

if [[ ${ALL_DATABASES} == "" ]]; then
	if [[ ${DB_NAME} == "" ]]; then
		echo "Missing DB_NAME env variable"
		exit 1
	fi
	mysqldump --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" "$@" "${DB_NAME}" | gzip > "${DB_NAME}-`date +%Y-%m-%d`".sql.gz
	rotate_dumps $DB_NAME
else
	databases=`mysql --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] && [[ "$db" != "$IGNORE_DATABASE" ]]; then
        echo "Dumping database: $db"
        mysqldump --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" --databases $db | gzip > "$db-`date +%Y-%m-%d`".sql.gz
		rotate_dumps $db
    fi
done
fi
