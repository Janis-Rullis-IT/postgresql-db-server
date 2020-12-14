# postgresql-db-server

## FIRST TIME? HOW TO SET THIS UP?

#### [1. Install docker](https://github.com/Janis-Rullis-IT/dev/tree/master/Tools/Docker#install)

Docker is a virtual environment with all the required software included. See [all other benefits](https://github.com/Janis-Rullis-IT/flexi-tic-tac-toe/blob/523698d731e5de6aae2a168565d99a621c3e382d/Why-use-docker.md).

#### 2. Provide Your environment values

- Copy the `.env.example` to `.env` and fill `FILL_THIS` values in it.

#### 3. Execute

It will download, install and prepare all the required software.

```shell
./setup-db-server.sh
```

#### 4. Add these to Your `hosts` file

This transletes the machines address to the domain-name.

```
172.72.4.1  db1.pg.local
```

#### Connect to DB

* Make sure that this server is running first (`./start-db-server.sh`).
* Open Your PostgreSQL Admin.
* IP: 172.72.4.1
* Port: 5432
* Password You choosed.

## ALREADY SET-UP?

* `./start-db-server.sh` - Start containers once the setup has been done.
* `./connect-to-db-server.sh` - Connect to the container/VM.
* `./backup-db.sh` - Will backup the current DB to `db-import-export/` folder.
* `./htop-show-server-processes.sh` - Show containers running processes using the `htop` command in it.
* `./import-db.sh` - Rename the file `import-me.gz` and put it into  `db-import-export/` folder.
* `./open-postgresql-command-line.sh` - Opens the `postgresql` command line inside the container.
* `./restart-postgresql-service.sh` - Restart the Postgres service.
* `./status-postgresql-service.sh` - See if the Postgres service is running.
* `./restart-db-server.sh` - Restart the container (not the Postgres service).