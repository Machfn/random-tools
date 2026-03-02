#include <stdio.h>
#include <sqlite3.h>
// ***WORK IN PROGRESS***
// A program to store commonly used commands with arguements for future use
int main() {
	sqlite3 *db;

	if (sqlite3_open("/home/benon/dbs/commands.db", &db) != SQLITE_OK) {
		fprintf(stderr, "Cannot open database\n");
		return 1;
	}

	// execute sql
	char *sql = "CREATE TABLE IF NOT EXISTS COMMANDS(name varchar(30) PRIMARY KEY, Payload TEXT);";

	if (sqlite3_exec(db, sql, 0, 0, 0) != SQLITE_OK) {
		fprintf(stderr, "SQL Error\n");
	}

	sqlite3_close(db);
	return 0;
}
