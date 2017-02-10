# Migrator

Applies Ecto migrations to a deployed application.

## Deploying

Build with `MIX_ENV=prod mix release --env=prod`. Upload to your server.

## Usage

You'll need a directory with migrations (usually it's `/priv/repo/migrations` within your application)
and the database credentials (DB name, username, password).

Run the app as follows:

```
DIRECTORY=/path/to/migrations ACTION=migrate|rollback DB_NAME=name DB_USER=user DB_PASSWORD=password REPLACE_OS_VARS=true bin/migrator foreground
```

For simple syntax, use the shell scripts located in the release's main directory:

```
migrate.sh /path/to/migrations dbname dbuser dbpassword
rollback.sh /path/to/migrations dbname dbuser dbpassword
```
