# mysql-backup
Simple Docker image for backing up a MySQL/MariaDB Database

## Usage
```
$ docker run --rm \
  -e DB_HOST='yourdbhostname' \
  -e DB_USER='yourdbusername' \
  -e DB_PASS='yourcomplexpassword' \
  -v $pwd/backups:/mysqldump \
  ikaruswill/mysql-backup
```

## Parameters
| Parameter        | Description                                                                  |
|------------------|------------------------------------------------------------------------------|
| DB_HOST          | Hostname of database instance                                                |
| DB_USER          | Username to connect to the database as                                       |
| DB_PASS          | Password to connect to the database with                                     |
| DB_NAME          | (Optional) Name of database to backup                                        |
| ALL_DATABASES    | Set 'true' to backup all databases, overrides `DB_NAME` (defaults to `true`) |
| BACKUP_RETENTION | Number of backups to retain on rotation (defaults to `7`)                    |
| BACKUP_PATH      | Path to backup to (defaults to `/mysqldump`)                                 |

