# Go Multitenancy Prototype

## Schema Migrations

### Setting Up

Schema migrations are handled by the [`golang-migrate`](https://github.com/golang-migrate/migrate) CLI tool (not to be confused with the Go library).
To set up the `golang-migrate` CLI tool, follow the [following instructions](https://github.com/golang-migrate/migrate/tree/master/cmd/migrate#installation).

### Creating a Schema Migration

In order to create a schema migration, run

```sh
./generate-migration.sh -n <migration name>
```

Two files will be created in the `migrations` directory, representing a single logical migration.
One of the files is used to migrate "up" to the specified version of the schema from the previous version, while the other is used to migrate "down" to the previous version.
The ordering and direction of the migration files is determined by their file names, which are of the following format:

```sh
{timestamp}_{title}.up.sql
{timestamp}_{title}.down.sql
```

You can then proceed to write the SQL necessary for the migration.

### Migrating the Database

Once the migration has been written, the database can be migrated to the latest version of the schema by running

```sh
./migrate-db.sh up
```

Note that the script is equivalent to running the `migrate` command, except it automatically sets the path of the migration files to the `migrations` directory, and also generates the PostgreSQL connection URI from the environment variables set.

To view available commands, run `./migrate-db -help`.
